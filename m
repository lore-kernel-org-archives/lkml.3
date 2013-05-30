Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab3E3TBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:01:13 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55292 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab3E3TBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:01:04 -0400
Message-ID: <51A7A1EB.1010109@linaro.org>
Date: Thu, 30 May 2013 21:00:59 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingchang Lu <b35083@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        john.stultz@linaro.org, tglx@linutronix.de, shawn.guo@linaro.org,
        s.hauer@pengutronix.de
Subject: Re: [PATCH v5] clocksource: add Freescale Vybrid pit timer support
References: <1369732899-17142-1-git-send-email-b35083@freescale.com>
In-Reply-To: <1369732899-17142-1-git-send-email-b35083@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 11:21 AM, Jingchang Lu wrote:
> Add Freescale Vybrid Family period interrupt timer support.
> 
> Signed-off-by: Jingchang Lu <b35083@freescale.com>

I queued this patch for 3.11 in my tree [1]

Thanks
  -- Daniel

[1]
https://git.linaro.org/gitweb?p=people/dlezcano/clockevents.git;a=shortlog;h=refs/heads/timers/clockevents

> ---
> v5:
>  Follow internal suggestions to name the SoC family as VF.
>  Add comment for min and max clockevent delta.
>  Add clockevent device irq initialization.
>  Remove IRQF_DISABLED flag.
> v4:
>   Use family name names driver and symbol instead of SoC name.
>   Remove redundant code.
>   Use BUG_ON instead of WARN_ON.
>   Add necessory comment information.
> v3:
>   Move the pit driver adding from arch to drivers/clocksource.
> v2:
>   Use CLOCKSOURCE_OF_DECLARE init pit timer.
>   Add ONESHOT mode support.
> 
>  drivers/clocksource/Kconfig        |   5 +
>  drivers/clocksource/Makefile       |   1 +
>  drivers/clocksource/vf_pit_timer.c | 194 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 200 insertions(+)
>  create mode 100644 drivers/clocksource/vf_pit_timer.c
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index f151c6c..0a04257 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -85,3 +85,8 @@ config CLKSRC_SAMSUNG_PWM
>  	  Samsung S3C, S5P and Exynos SoCs, replacing an earlier driver
>  	  for all devicetree enabled platforms. This driver will be
>  	  needed only on systems that do not have the Exynos MCT available.
> +
> +config VF_PIT_TIMER
> +	bool
> +	help
> +	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 8d979c7..36a9ac1 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
>  obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
>  obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
>  obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
> +obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
>  
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
>  obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
> diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
> new file mode 100644
> index 0000000..598399d
> --- /dev/null
> +++ b/drivers/clocksource/vf_pit_timer.c
> @@ -0,0 +1,194 @@
> +/*
> + * Copyright 2012-2013 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/clockchips.h>
> +#include <linux/clk.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <asm/sched_clock.h>
> +
> +/*
> + * Each pit takes 0x10 Bytes register space
> + */
> +#define PITMCR		0x00
> +#define PIT0_OFFSET	0x100
> +#define PITn_OFFSET(n)	(PIT0_OFFSET + 0x10 * (n))
> +#define PITLDVAL	0x00
> +#define PITCVAL		0x04
> +#define PITTCTRL	0x08
> +#define PITTFLG		0x0c
> +
> +#define PITMCR_MDIS	(0x1 << 1)
> +
> +#define PITTCTRL_TEN	(0x1 << 0)
> +#define PITTCTRL_TIE	(0x1 << 1)
> +#define PITCTRL_CHN	(0x1 << 2)
> +
> +#define PITTFLG_TIF	0x1
> +
> +static void __iomem *clksrc_base;
> +static void __iomem *clkevt_base;
> +static unsigned long cycle_per_jiffy;
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
> +static inline void pit_irq_acknowledge(void)
> +{
> +	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
> +}
> +
> +static unsigned int pit_read_sched_clock(void)
> +{
> +	return __raw_readl(clksrc_base + PITCVAL);
> +}
> +
> +static int __init pit_clocksource_init(unsigned long rate)
> +{
> +	/* set the max load value and start the clock source counter */
> +	__raw_writel(0, clksrc_base + PITTCTRL);
> +	__raw_writel(~0UL, clksrc_base + PITLDVAL);
> +	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
> +
> +	setup_sched_clock(pit_read_sched_clock, 32, rate);
> +	return clocksource_mmio_init(clksrc_base + PITCVAL, "vf-pit", rate,
> +			300, 32, clocksource_mmio_readl_down);
> +}
> +
> +static int pit_set_next_event(unsigned long delta,
> +				struct clock_event_device *unused)
> +{
> +	/*
> +	 * set a new value to PITLDVAL register will not restart the timer,
> +	 * to abort the current cycle and start a timer period with the new
> +	 * value, the timer must be disabled and enabled again.
> +	 * and the PITLAVAL should be set to delta minus one according to pit
> +	 * hardware requirement.
> +	 */
> +	pit_timer_disable();
> +	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
> +	pit_timer_enable();
> +
> +	return 0;
> +}
> +
> +static void pit_set_mode(enum clock_event_mode mode,
> +				struct clock_event_device *evt)
> +{
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		pit_set_next_event(cycle_per_jiffy, evt);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = dev_id;
> +
> +	pit_irq_acknowledge();
> +
> +	/*
> +	 * pit hardware doesn't support oneshot, it will generate an interrupt
> +	 * and reload the counter value from PITLDVAL when PITCVAL reach zero,
> +	 * and start the counter again. So software need to disable the timer
> +	 * to stop the counter loop in ONESHOT mode.
> +	 */
> +	if (likely(evt->mode == CLOCK_EVT_MODE_ONESHOT))
> +		pit_timer_disable();
> +
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct clock_event_device clockevent_pit = {
> +	.name		= "VF pit timer",
> +	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode	= pit_set_mode,
> +	.set_next_event	= pit_set_next_event,
> +	.rating		= 300,
> +};
> +
> +static struct irqaction pit_timer_irq = {
> +	.name		= "VF pit timer",
> +	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
> +	.handler	= pit_timer_interrupt,
> +	.dev_id		= &clockevent_pit,
> +};
> +
> +static int __init pit_clockevent_init(unsigned long rate, int irq)
> +{
> +	__raw_writel(0, clkevt_base + PITTCTRL);
> +	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
> +
> +	BUG_ON(setup_irq(irq, &pit_timer_irq));
> +
> +	clockevent_pit.cpumask = cpumask_of(0);
> +	clockevent_pit.irq = irq;
> +	/*
> +	 * The value for the LDVAL register trigger is calculated as:
> +	 * LDVAL trigger = (period / clock period) - 1
> +	 * The pit is a 32-bit down count timer, when the conter value
> +	 * reaches 0, it will generate an interrupt, thus the minimal
> +	 * LDVAL trigger value is 1. And then the min_delta is
> +	 * minimal LDVAL trigger value + 1, and the max_delta is full 32-bit.
> +	 */
> +	clockevents_config_and_register(&clockevent_pit, rate, 2, 0xffffffff);
> +
> +	return 0;
> +}
> +
> +static void __init pit_timer_init(struct device_node *np)
> +{
> +	struct clk *pit_clk;
> +	void __iomem *timer_base;
> +	unsigned long clk_rate;
> +	int irq;
> +
> +	timer_base = of_iomap(np, 0);
> +	BUG_ON(!timer_base);
> +
> +	/*
> +	 * PIT0 and PIT1 can be chained to build a 64-bit timer,
> +	 * so choose PIT2 as clocksource, PIT3 as clockevent device,
> +	 * and leave PIT0 and PIT1 unused for anyone else who needs them.
> +	 */
> +	clksrc_base = timer_base + PITn_OFFSET(2);
> +	clkevt_base = timer_base + PITn_OFFSET(3);
> +
> +	irq = irq_of_parse_and_map(np, 0);
> +	BUG_ON(irq <= 0);
> +
> +	pit_clk = of_clk_get(np, 0);
> +	BUG_ON(IS_ERR(pit_clk));
> +
> +	BUG_ON(clk_prepare_enable(pit_clk));
> +
> +	clk_rate = clk_get_rate(pit_clk);
> +	cycle_per_jiffy = clk_rate / (HZ);
> +
> +	/* enable the pit module */
> +	__raw_writel(~PITMCR_MDIS, timer_base + PITMCR);
> +
> +	BUG_ON(pit_clocksource_init(clk_rate));
> +
> +	pit_clockevent_init(clk_rate, irq);
> +}
> +CLOCKSOURCE_OF_DECLARE(vf610, "fsl,vf610-pit", pit_timer_init);
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

