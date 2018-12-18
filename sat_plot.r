# Generate the plot with R CMD BATCG sat_plot.r
library(ggplot2)
library(reshape2)
library(tikzDevice)
dat <- read.table("dat_N200.txt", sep="\t", header=T)
dat$time <- dat$time/max(dat$time)
dat$Successful <- dat$Successful/max(dat$Successful)
colnames(dat) <- c("M", "Satisfiable fraction",
                   "Time [a.u.]")
dat.molten <- melt(dat, id.vars="M")

CRIT <- 4.267
WIDTH.CRIT <- 0.15
g <- ggplot(dat.molten, aes(x=M/200, y=value)) +
    geom_point(size=1.1, alpha=0.2) + geom_line() +
    facet_grid(variable~., scales="free_y") +
    xlab("clauses-to-variables ratio $\\alpha$") + ylab("") +
    annotate("rect", xmin=CRIT-WIDTH.CRIT , xmax=CRIT-WIDTH.CRIT,
             ymin=-Inf, ymax=Inf, alpha=0.2, fill="blue")

print(g)

CM.PER.INCH <- 2.54
WIDTH <- 12.5
HEIGHT <- 7

ggsave("plot_sat.pdf", g, , width=WIDTH, height=HEIGHT, units="cm")

tikz("material_2/plot_sat.tex",
     width=WIDTH/CM.PER.INCH, height=HEIGHT/CM.PER.INCH)
print(g)
dev.off()
