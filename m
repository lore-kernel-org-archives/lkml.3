Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3EPOFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:05:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:34431 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3EPOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:04:59 -0400
Date: Thu, 16 May 2013 16:04:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jingchang Lu <b35083@freescale.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        john.stultz@linaro.org, shawn.guo@linaro.org, s.hauer@pengutronix.de
Subject: Re: [PATCH v3] clocksource: add MVF600 pit timer support
In-Reply-To: <1368684924-1560-1-git-send-email-b35083@freescale.com>
Message-ID: <alpine.LFD.2.02.1305161214570.1388@ionos>
References: <1368684924-1560-1-git-send-email-b35083@freescale.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013, Jingchang Lu wrote:
> +/*
> + * 8 timers: pit0 - pit7,
> + * Each takes 0x10 Bytes register sapce
> + */
> +#define PITMCR		0x00
> +#define PIT0_OFFSET	0x100
> +#define PITn_OFFSET(n)	(PIT0_OFFSET + 0x10 * (n))
> +#define PITLDVAL	0x00
> +#define PITCVAL		0x04
> +#define PITTCTRL	0x08
> +#define PITTFLG		0x0c
> +
> +#define PITTCTRL_TEN		(0x1 << 0)
> +#define PITTCTRL_TIE		(0x1 << 1)
> +#define	PITCTRL_CHN		(0x1 << 2)
> +
> +#define PITTFLG_TIF		0x1
> +
> +static struct clock_event_device clockevent_pit;
> +static enum clock_event_mode clockevent_mode = CLOCK_EVT_MODE_UNUSED;

What the heck is this? The clock event device itself tracks the
mode. So why do you need a separate status variable?

> +
> +static void __iomem *clksrc_base;
> +static void __iomem *clkevt_base;
> +static void __iomem *sched_clock_reg;
> +static unsigned long pit_cycle_per_jiffy;
> +
> +static inline void pit_timer_enable(void)
> +{
> +	__raw_writel(PITTCTRL_TEN | PITTCTRL_TIE, clkevt_base + PITTCTRL);
> +}
> +
> +static inline void pit_timer_disable(void)
> +{
> +	__raw_writel(0, clkevt_base + PITTCTRL);
> +}
> +
> +static inline void pit_irq_disable(void)

Unused function

> +{
> +	unsigned long val;
> +
> +	val = __raw_readl(clkevt_base + PITTCTRL);
> +	val &= ~PITTCTRL_TIE;
> +	__raw_writel(val, clkevt_base + PITTCTRL);
> +}
> +
> +static inline void pit_irq_enable(void)

Ditto

> +{
> +	unsigned long val;
> +
> +	val = __raw_readl(clkevt_base + PITTCTRL);
> +	val |= PITTCTRL_TIE;
> +	__raw_writel(val, clkevt_base + PITTCTRL);
> +}
> +
> +static void pit_irq_acknowledge(void)

inline

> +{
> +	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
> +}
> +
> +static unsigned int pit_read_sched_clock(void)
> +{
> +	return __raw_readl(sched_clock_reg);
> +}
> +
> +
> +static int __init pit_clocksource_init(struct clk *pit_clk)
> +{
> +	unsigned int c = clk_get_rate(pit_clk);
> +
> +	sched_clock_reg = clksrc_base + PITCVAL;
> +
> +	setup_sched_clock(pit_read_sched_clock, 32, c);
> +	return clocksource_mmio_init(clksrc_base + PITCVAL, "mvf600-pit", c,
> +			300, 32, clocksource_mmio_readl_down);
> +}
> +
> +/* set clock event */

This is the most useless comment ever.

> +static int pit_set_next_event(unsigned long delta,
> +				struct clock_event_device *unused)
> +{
> +	pit_timer_disable();
> +	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
> +	pit_irq_acknowledge();
> +	pit_timer_enable();

It would be much more interesting to comment, why you need to
acknowlegde the timer here.

> +	return 0;
> +}
> +
> +static void pit_set_mode(enum clock_event_mode mode,
> +				struct clock_event_device *evt)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);

All clockevent functions are called with interrupts disabled.

> +	pit_timer_disable();
> +	pit_irq_acknowledge();
> +
> +	/* Remember timer mode */
> +	clockevent_mode = mode;

Groan.

> +	local_irq_restore(flags);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +
> +		__raw_writel(pit_cycle_per_jiffy - 1, clkevt_base + PITLDVAL);
> +		pit_timer_enable();
> +
> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:

Whats so special that this needs a separate break?

> +		break;
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_RESUME:
> +
> +		break;
> +	default:
> +		WARN(1, "%s: unhandled event mode %d\n", __func__, mode);

What the heck? Either you have a default catching everything you do
not handle or you remove the default and let the compiler warn you
when the CLOCK_EVT_MODE enum got a new value added.

> +		break;
> +	}
> +}
> +
> +static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = &clockevent_pit;
> +
> +	pit_irq_acknowledge();
> +
> +	if (clockevent_mode == CLOCK_EVT_MODE_ONESHOT)
> +		pit_timer_disable();

So in oneshot mode you do:

     pit_irq_ack()
     pit_timer_disable()
     ....
	set_next_event()
  	  pit_timer_disable()
	  write_new_value()
	  pit_irq_ack()
	  pit_timer_enable()

Not really the most efficient way in the interrupt fast path, right?

> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction pit_timer_irq = {
> +	.name		= "MVF600 pit timer",
> +	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,

Please look up what IRQF_DISABLED does and why you shouldn't use it.

> +	.handler	= pit_timer_interrupt,
> +};
> +
> +static struct clock_event_device clockevent_pit = {
> +	.name		= "MVF600 pit timer",
> +	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode	= pit_set_mode,
> +	.set_next_event	= pit_set_next_event,
> +	.rating		= 300,
> +};
> +
> +static int __init pit_clockevent_init(struct clk *pit_clk)
> +{
> +	unsigned int c = clk_get_rate(pit_clk);
> +
> +	clockevent_pit.cpumask = cpumask_of(0);
> +	clockevents_config_and_register(&clockevent_pit, c, 0x100, 0xffffff00);

0x100 and 0xffffff00 ?? Random numbers pulled out of what?

> +	return 0;
> +}
> +
> +static void __init pit_timer_init(struct device_node *np)
> +{
> +	struct clk *pit_clk;
> +	void __iomem *timer_base;
> +	int irq;
> +
> +	if (!np) {

So how gets that called without a valid node pointer?

> +		pr_err("Failed to find MVF600 pit DT node\n");
> +		BUG();
> +	}
> +
> +	timer_base = of_iomap(np, 0);
> +	WARN_ON(!timer_base);

Great, timer_base is NULL and you just emit a warning and then
proceed? So instead of either bailing out or crashing the machine
right away you let it randomly die with the first access.

> +
> +	/* choose PIT2 as clocksource, PIT3 as clockevent dev */
> +	clksrc_base = timer_base + PITn_OFFSET(2);
> +	clkevt_base = timer_base + PITn_OFFSET(3);
> +
> +	irq = irq_of_parse_and_map(np, 0);
> +
> +	pit_clk = of_clk_get(np, 0);
> +	if (IS_ERR(pit_clk)) {
> +		pr_err("Vybrid MVF600 pit timer: unable to get clk\n");

Can you please make your pr_*() format consistent?

> +		pr_err("Failed to find MVF600 pit DT node\n");
> +		pr_err("Vybrid MVF600 pit timer: unable to get clk\n");

> +		return;
> +	}
> +
> +	clk_prepare_enable(pit_clk);

And while you're worried about the core code sending you random crap,
you assume that this call always succeeds.

> +	pit_cycle_per_jiffy = clk_get_rate(pit_clk)/(HZ);
> +
> +	__raw_writel(0x0, timer_base + PITMCR);
> +
> +	__raw_writel(0, clkevt_base + PITTCTRL);
> +	__raw_writel(0xffffffff, clkevt_base + PITLDVAL);

What's the point of this? 

> +	__raw_writel(0, clksrc_base + PITTCTRL);
> +	__raw_writel(0xffffffff, clksrc_base + PITLDVAL);

And of this? Why isn't the setup done in the relevant init functions?

> +	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
> +
> +	pit_clocksource_init(pit_clk);
> +
> +	setup_irq(irq, &pit_timer_irq);
> +
> +	pit_clockevent_init(pit_clk);
> +}

Thanks,

	tglx
