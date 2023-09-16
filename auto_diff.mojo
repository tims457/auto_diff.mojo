struct Dual:
    var value: SIMD[DType.float64, 1]
    var dual: SIMD[DType.float64, 1]

    fn __init__(inout self, value: SIMD[DType.float64, 1], dual: SIMD[DType.float64, 1])->None:
        self.value= value
        self.dual= dual


    fn __add__(self, g: Dual)->Dual:
        return Dual(self.value + g.value, self.dual + g.dual)

    fn __add__(self, g: Float64)->Dual:
        return Dual(self.value + g, self.dual)

    fn __sub__(self, g: Dual)->Dual:
        return Dual(self.value - g.value, self.dual - g.dual)

    fn __sub__(self, g: Float64)->Dual:
        return Dual(self.value - g.value, self.dual)

    fn __mul__(self, g: Dual)->Dual:
        return Dual(self.value * g.value, self.value * g.dual + self.dual * g.value)
    
    fn __mul__(self, g: Float64)->Dual:
        return Dual(self.value * g, self.dual * g)


    fn __truediv__(self, g: Dual)->Dual:
        return Dual(self.value / g.value, (self.dual * g.value - self.value * g.dual) / (g.value * g.value))

    fn __truediv__(self, g: Float64)->Dual:
        return Dual(self.value / g, self.dual / g)


    fn __pow__(self, g: Int)->Dual:
        return Dual(self.value ** g, g * self.value ** (g - 1) * self.dual)
       


fn print_dual(d: Dual)->None:
    print('(',d.value,',', d.dual,')')
    
fn derivative(f: fn(Dual)->Dual, x: Float64)->SIMD[DType.float64, 1]:
    return f(Dual(x, 1.0)).dual

fn f(x: Dual)->Dual:
    return x ** 2 + x + 1.0




def main():
    print_dual(Dual(1, 2) + Dual(3, 4))
    print_dual(Dual(1, 2) + 3)

    print("f(x) = x^2 + x + 1")
    print("df/dx at x = 2")
    print(derivative(f, 2.0))