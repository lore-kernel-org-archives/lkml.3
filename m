Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3E3Ob3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:31:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:33651 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab3E3ObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:31:22 -0400
Date: Thu, 30 May 2013 16:31:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Tang <dt.tangr@gmail.com>
cc: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add TI-Nspire timer support
In-Reply-To: <5F0F2B5B-F956-4F5A-A105-E60F73678882@gmail.com>
Message-ID: <alpine.LFD.2.02.1305301617520.2905@ionos>
References: <5F0F2B5B-F956-4F5A-A105-E60F73678882@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Daniel Tang wrote:
> +#define IO_MATCH(x)	(IO_MATCH_BEGIN + ((x)<<2))

space before and after "<<" please.
  
> +#define CNTL_STOP_TIMER	(1<<4)

Ditto.

> +struct zevio_timer {
> +	void __iomem *base;
> +	void __iomem *timer1, *timer2;
> +	void __iomem *interrupt_regs;
> +
> +	int irqnr;
> +
> +	struct clk *clk;
> +	struct clock_event_device clkevt;
> +	struct irqaction clkevt_irq;
> +
> +	char clocksource_name[64];
> +	char clockevent_name[64];
> +};
> +
> +static int zevio_timer_set_event(unsigned long delta,
> +		struct clock_event_device *dev)

static int zevio_timer_set_event(unsigned long delta,
			         struct clock_event_device *dev)

Is way more readable.

> +{
> +	unsigned long flags;
> +	struct zevio_timer *timer = container_of(dev,
> +			struct zevio_timer,
> +			clkevt);
> +

        struct zevio_timer *timer = container_of(dev, struct zevio_timer,
	       		   	    		 clekevt);

This random alignment of split lines is really annoying. Please fix
all over the place.

> +	local_irq_save(flags);

Pointless exercise. All the clockevent callbacks are called with
interrupts disabled.

> +	writel(delta, timer->timer1 + IO_CURRENT_VAL);
> +	writel(CNTL_RUN_TIMER | CNTL_DEC | CNTL_MATCH(TIMER_MATCH),
> +			timer->timer1 + IO_CONTROL);
> +
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> +
> +static void zevio_timer_set_mode(enum clock_event_mode mode,
> +		struct clock_event_device *dev)
> +{
> +	unsigned long flags;
> +	struct zevio_timer *timer = container_of(dev,
> +			struct zevio_timer,
> +			clkevt);
> +
> +	local_irq_save(flags);

See above.

> +	switch (mode) {
> +	case CLOCK_EVT_MODE_RESUME:
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		/* Enable timer interrupts */
> +		writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_MSK);
> +		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
> +		dev->mode = mode;

The core code sets the dev->mode. Where did you copy this from?

> +static int __init zevio_timer_add(struct device_node *node)
> +{
> +	struct zevio_timer *timer;
> +	struct resource res;
> +	int ret;
> +
> +	timer = kzalloc(sizeof(*timer), GFP_ATOMIC);

Why do you need an atomic allocation here ?

> +
> +	if (timer->interrupt_regs && timer->irqnr) {
> +		timer->clkevt.name	= timer->clockevent_name;
> +		timer->clkevt.set_next_event = zevio_timer_set_event;
> +		timer->clkevt.set_mode	= zevio_timer_set_mode;

Either you have a consistent alignment of all these assignments or you
have not.

> +		timer->clkevt.rating	= 200;
> +		timer->clkevt.cpumask	= cpu_all_mask;
> +		timer->clkevt.features	=
> +			CLOCK_EVT_FEAT_ONESHOT;

Pointless linebreak.

> +		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
> +		writel(0, timer->timer1 + IO_DIVIDER);
> +
> +		/* Start with timer interrupts disabled */
> +		writel(0, timer->interrupt_regs + IO_INTR_MSK);
> +		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
> +
> +		/* Interrupt to occur when timer value matches 0 */
> +		writel(0, timer->base + IO_MATCH(TIMER_MATCH));
> +
> +		timer->clkevt_irq.name	= timer->clockevent_name;
> +		timer->clkevt_irq.handler = zevio_timer_interrupt;
> +		timer->clkevt_irq.dev_id = timer;
> +		timer->clkevt_irq.flags	=
> +			IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL;

Please lookup what IRQF_DISABLED actually does.

Thanks,

	tglx
