Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3ETC1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:27:38 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:34988
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099Ab3ETC1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:27:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 12
X-BigFish: VS12(zz98dI1432Ic8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh11f642sz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 20 May 2013 10:27:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingchang Lu <b35083@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3] clocksource: add MVF600 pit timer support
Message-ID: <20130520022747.GA25113@S2101-09.ap.freescale.net>
References: <1368684924-1560-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1368684924-1560-1-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 02:15:24PM +0800, Jingchang Lu wrote:
> Add Freescale Vybrid MVF600 period interrupt timer support.
> 
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
> v3:
>   move the pit driver to drivers/clocksource.
> 
>  drivers/clocksource/Kconfig            |   5 +
>  drivers/clocksource/Makefile           |   1 +
>  drivers/clocksource/mvf600_pit_timer.c | 224 +++++++++++++++++++++++++++++++++

This is a driver for PIT, a timer IP block found on mvf family.  Even
though we prefer to use particular SoC name to specify the compatibility
and version of the block, all the versions of the IP block should be
ideally supported by single PIT driver.  This is just like we have
drivers spi-imx and i2c-imx support all SPI and I2C controllers found on
IMX SoCs.

That said, I suggest you use family name "mvf" to name the driver,
Kconfig symbol etc. and use "mvf600" only in compatible string.

>  3 files changed, 230 insertions(+)
>  create mode 100644 drivers/clocksource/mvf600_pit_timer.c
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index f151c6c..2808a76 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -85,3 +85,8 @@ config CLKSRC_SAMSUNG_PWM
>  	  Samsung S3C, S5P and Exynos SoCs, replacing an earlier driver
>  	  for all devicetree enabled platforms. This driver will be
>  	  needed only on systems that do not have the Exynos MCT available.
> +
> +config MVF600_PIT_TIMER
> +	bool
> +	help
> +	  Support for Period Interrupt Timer on Freescale Vybrid MVF600 SoC.
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 8d979c7..f471ca3 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
>  obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
>  obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
>  obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
> +obj-$(CONFIG_MVF600_PIT_TIMER)	+= mvf600_pit_timer.o
>  
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
>  obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
> diff --git a/drivers/clocksource/mvf600_pit_timer.c b/drivers/clocksource/mvf600_pit_timer.c
> new file mode 100644
> index 0000000..74f7963
> --- /dev/null
> +++ b/drivers/clocksource/mvf600_pit_timer.c
> @@ -0,0 +1,224 @@
> +/*
> + *  Copyright 2012-2013 Freescale Semiconductor, Inc.
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
> + * 8 timers: pit0 - pit7,
> + * Each takes 0x10 Bytes register sapce

s/sapce/space

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

Use space than tab between "#define" and macro name.

> +
> +#define PITTFLG_TIF		0x1
> +
> +static struct clock_event_device clockevent_pit;
> +static enum clock_event_mode clockevent_mode = CLOCK_EVT_MODE_UNUSED;
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
> +{
> +	unsigned long val;
> +
> +	val = __raw_readl(clkevt_base + PITTCTRL);
> +	val &= ~PITTCTRL_TIE;
> +	__raw_writel(val, clkevt_base + PITTCTRL);
> +}
> +
> +static inline void pit_irq_enable(void)
> +{
> +	unsigned long val;
> +
> +	val = __raw_readl(clkevt_base + PITTCTRL);
> +	val |= PITTCTRL_TIE;
> +	__raw_writel(val, clkevt_base + PITTCTRL);
> +}
> +
> +static void pit_irq_acknowledge(void)
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
> +static int pit_set_next_event(unsigned long delta,
> +				struct clock_event_device *unused)
> +{
> +	pit_timer_disable();
> +	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
> +	pit_irq_acknowledge();
> +	pit_timer_enable();
> +
> +	return 0;
> +}
> +
> +static void pit_set_mode(enum clock_event_mode mode,
> +				struct clock_event_device *evt)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	pit_timer_disable();
> +	pit_irq_acknowledge();
> +
> +	/* Remember timer mode */
> +	clockevent_mode = mode;
> +	local_irq_restore(flags);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +
Nit: remove this blank line.

> +		__raw_writel(pit_cycle_per_jiffy - 1, clkevt_base + PITLDVAL);
> +		pit_timer_enable();
> +
Ditto

> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +
> +		break;
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_RESUME:
> +
Ditto

> +		break;
> +	default:
> +		WARN(1, "%s: unhandled event mode %d\n", __func__, mode);
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
> +
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction pit_timer_irq = {
> +	.name		= "MVF600 pit timer",
> +	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
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
> +
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
> +		pr_err("Failed to find MVF600 pit DT node\n");
> +		BUG();
> +	}
> +
> +	timer_base = of_iomap(np, 0);
> +	WARN_ON(!timer_base);
> +
> +	/* choose PIT2 as clocksource, PIT3 as clockevent dev */

Reading the comment, I have a natural question - what PIT0 and PIT1 are
used for?

Shawn

> +	clksrc_base = timer_base + PITn_OFFSET(2);
> +	clkevt_base = timer_base + PITn_OFFSET(3);
> +
> +	irq = irq_of_parse_and_map(np, 0);
> +
> +	pit_clk = of_clk_get(np, 0);
> +	if (IS_ERR(pit_clk)) {
> +		pr_err("Vybrid MVF600 pit timer: unable to get clk\n");
> +		return;
> +	}
> +
> +	clk_prepare_enable(pit_clk);
> +
> +	pit_cycle_per_jiffy = clk_get_rate(pit_clk)/(HZ);
> +
> +	__raw_writel(0x0, timer_base + PITMCR);
> +
> +	__raw_writel(0, clkevt_base + PITTCTRL);
> +	__raw_writel(0xffffffff, clkevt_base + PITLDVAL);
> +
> +	__raw_writel(0, clksrc_base + PITTCTRL);
> +	__raw_writel(0xffffffff, clksrc_base + PITLDVAL);
> +	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
> +
> +	pit_clocksource_init(pit_clk);
> +
> +	setup_irq(irq, &pit_timer_irq);
> +
> +	pit_clockevent_init(pit_clk);
> +}
> +
> +CLOCKSOURCE_OF_DECLARE(mvf600, "fsl,mvf600-pit", pit_timer_init);
> -- 
> 1.8.0
> 
> 

