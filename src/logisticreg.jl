# Logistic regression

immutable LogisticRegressFunctor <: DifferentiableRegressFunctor end


####
#
#  rf(u, y) = log(1 + exp(-y * u))             ... (1)
#           = -(y * u) + log(1 + exp(y * u))   ... (2)
#
#  For numerical stability, use (1) when y * u > 0, or (2) otherwise
#  

function evaluate_values!(
	rf::LogisticRegressFunctor, 
	u::Vector{Float64}, 
	y::Vector{Float64}, 
	v::Vector{Float64})

	for i in 1 : length(u)
		x = y[i] * u[i]
		v[i] = x > 0 ? log1p(exp(-x)) : -x + log1p(exp(x))
	end
end

function evaluate_derivs!(
	rf::LogisticRegressFunctor, 
	u::Vector{Float64}, 
	y::Vector{Float64}, 
	g::Vector{Float64})

	for i in 1 : length(u)
		yi = y[i]
		x = yi * u[i]
		if x > 0
			t = exp(-x)
			g[i] = - yi * t / (1 + t)
		else
			g[i] = - yi / (1 + exp(x))
		end
	end
end

function evaluate_values_and_derivs!(
	rf::LogisticRegressFunctor, 
	u::Vector{Float64}, 
	y::Vector{Float64}, 
	v::Vector{Float64},
	g::Vector{Float64})

	for i in 1 : length(u)
		yi = y[i]
		x = yi * u[i]
		if x > 0
			t = exp(-x)
			v[i] = log1p(t)
			g[i] = - yi * t / (1 + t)
		else
			t = exp(x)
			v[i] = -x + log1p(t)
			g[i] = - yi / (1 + t)
		end
	end
end


