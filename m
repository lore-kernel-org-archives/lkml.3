Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3IYPcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:32:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55516 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3IYPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:32:12 -0400
Date: Wed, 25 Sep 2013 17:32:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
Message-ID: <20130925153207.GG16106@pengutronix.de>
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <5242F434.7060702@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5242F434.7060702@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Wed, Sep 25, 2013 at 04:33:24PM +0200, Daniel Lezcano wrote:
> On 09/16/2013 11:44 AM, Uwe Kleine-König wrote:
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > I'm not sure that the way I implemented if a given timer is used as
> > clock_source or clock_event_device is robust. Does it need locking?
> > The reason to create a timer device for each timer instead of a single
> > device of all of them is that it makes it cleaner to specify irqs and
> > clks which each timer has one of each respectively. I didn't find an
> > example, but while looking I wondered if in zevio-timer.c a single timer
> > can really support both clock_event and clocksource.
> > 
> > I guess for inclusion I need to write a document describing the
> > of-binding. I will include that in the next iteration.
> 
> Right and a nice description of the timer would be valuable.
in the binding document or the commit log?
 
> The first letter of the description should be in capital "Provide".
> 
> > checkpatch wails that the description of CLKSRC_EFM32 is too short. I
> > think it's OK though.
> > 
> > Best regards
> > Uwe
> > 
> >  drivers/clocksource/Kconfig      |   8 ++
> >  drivers/clocksource/Makefile     |   1 +
> >  drivers/clocksource/time-efm32.c | 274 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 283 insertions(+)
> >  create mode 100644 drivers/clocksource/time-efm32.c
> > 
> > diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> > index 41c6946..410b152 100644
> > --- a/drivers/clocksource/Kconfig
> > +++ b/drivers/clocksource/Kconfig
> > @@ -70,6 +70,14 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
> >  	help
> >  	  Use the always on PRCMU Timer as sched_clock
> >  
> > +config CLKSRC_EFM32
> > +	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
> > +	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
> > +	default ARCH_EFM32
> > +	help
> > +	  Support to use the timers of EFM32 SoCs as clock source and clock
> > +	  event device.
> > +
> 
> No option for the timer. It must be selected by the platform.
It is. If ARCH_EFM32=y there is no prompt and the "default ARCH_EFM32"
makes it true.

> >  config ARM_ARCH_TIMER
> >  	bool
> >  	select CLKSRC_OF if OF
> > diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> > index 704d6d3..33621ef 100644
> > --- a/drivers/clocksource/Makefile
> > +++ b/drivers/clocksource/Makefile
> > @@ -27,6 +27,7 @@ obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
> >  obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
> >  obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
> >  obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
> > +obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
> >  obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
> >  obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
> >  obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
> > diff --git a/drivers/clocksource/time-efm32.c b/drivers/clocksource/time-efm32.c
> > new file mode 100644
> > index 0000000..6ead8d7
> > --- /dev/null
> > +++ b/drivers/clocksource/time-efm32.c
> > @@ -0,0 +1,274 @@
> > +/*
> > + * Copyright (C) 2013 Pengutronix
> > + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it under
> > + * the terms of the GNU General Public License version 2 as published by the
> > + * Free Software Foundation.
> > + */
> > +
> > +#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/clocksource.h>
> > +#include <linux/clockchips.h>
> > +#include <linux/irq.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/clk.h>
> > +
> > +#define TIMERn_CTRL			0x00
> > +#define TIMERn_CTRL_PRESC(val)			(((val) & 0xf) << 24)
> 
> You can replace all binary shift with the BIT macro.
The BIT macro only can define values that have a single bit set. So it
doesn't help for the definition of the TIMERn_CTRL_PRESC macro and most
others. And then I prefer to have a common way to define the register
descriptions.
 
> > +#define TIMERn_CTRL_PRESC_1024			TIMERn_CTRL_PRESC(10)
> > +#define TIMERn_CTRL_CLKSEL(val)			(((val) & 0x3) << 16)
> > +#define TIMERn_CTRL_CLKSEL_PRESCHFPERCLK	TIMERn_CTRL_CLKSEL(0)
> > +#define TIMERn_CTRL_OSMEN			0x00000010
> > +#define TIMERn_CTRL_MODE(val)			(((val) & 0x3) <<  0)
> > +#define TIMERn_CTRL_MODE_UP			TIMERn_CTRL_MODE(0)
> > +#define TIMERn_CTRL_MODE_DOWN			TIMERn_CTRL_MODE(1)
> > +
> > +#define TIMERn_CMD			0x04
> > +#define TIMERn_CMD_START			0x1
> > +#define TIMERn_CMD_STOP				0x2
> > +
> > +#define TIMERn_IEN			0x0c
> > +#define TIMERn_IF			0x10
> > +#define TIMERn_IFS			0x14
> > +#define TIMERn_IFC			0x18
> > +#define TIMERn_IRQ_UF				0x2
> > +#define TIMERn_IRQ_OF				0x1
> 
> I see a wrong alignment with the values. May be it is due to my mailer.
Maybe that's because the patch has one char more (the +) before the
tabs, that make things look wrong sometimes. In the file it looks ok.

> > +
> > +#define TIMERn_TOP			0x1c
> > +#define TIMERn_CNT			0x24
> > +
> > +#define TIMER_CLOCKSOURCE	0
> > +#define TIMER_CLOCKEVENT	1
> 
> I don't see these macro used anywhere.
Right, pre-dt cruft.

> > +struct efm32_clock_event_ddata {
> 
> The structure name looks a bit long to me.
> 
> > +	struct clock_event_device evtdev;
> > +	void __iomem *base;
> > +	unsigned periodic_top;
> > +};
> > +static void efm32_clock_event_set_mode(enum clock_event_mode mode,
> > +				       struct clock_event_device *evtdev)
> > +{
> > +	struct efm32_clock_event_ddata *ddata =
> > +		container_of(evtdev, struct efm32_clock_event_ddata, evtdev);
> 
> Wouldn't be worth to check the previous mode of the timer before
> switching to a mode where it is already ?
This isn't a hot path, is it? IIRC this function is called exactly
twice. And I think it still needs stopping at least in some cases. Then
it's more complicated and so not worth the effort.
 
> > +	switch (mode) {
> > +	case CLOCK_EVT_MODE_PERIODIC:
> > +		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
> > +		writel_relaxed(ddata->periodic_top, ddata->base + TIMERn_TOP);
> > +		writel_relaxed(TIMERn_CTRL_PRESC_1024 |
> > +			       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
> > +			       TIMERn_CTRL_MODE_DOWN,
> > +			       ddata->base + TIMERn_CTRL);
> > +		writel_relaxed(TIMERn_CMD_START, ddata->base + TIMERn_CMD);
> > +		break;
> > +
> > +	case CLOCK_EVT_MODE_ONESHOT:
> > +		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
> > +		writel_relaxed(TIMERn_CTRL_PRESC_1024 |
> > +			       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
> > +			       TIMERn_CTRL_OSMEN |
> > +			       TIMERn_CTRL_MODE_DOWN,
> > +			       ddata->base + TIMERn_CTRL);
> > +		break;
> 
> IMO, these two routines are similar enough to factor them out in a
> single function.
I don't know what you want here? A #define for the common bits? I like
being explicit here to not have to jump around to verify the settings
with the hardware reference manual.
 
> > +	case CLOCK_EVT_MODE_UNUSED:
> > +	case CLOCK_EVT_MODE_SHUTDOWN:
> > +		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
> > +		break;
> > +
> > +	case CLOCK_EVT_MODE_RESUME:
> > +		break;
> > +	}
> > +}
> > +
> > +static int efm32_clock_event_set_next_event(unsigned long evt,
> > +					    struct clock_event_device *evtdev)
> > +{
> > +	struct efm32_clock_event_ddata *ddata =
> > +		container_of(evtdev, struct efm32_clock_event_ddata, evtdev);
> > +
> > +	writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
> > +	writel_relaxed(evt, ddata->base + TIMERn_CNT);
> > +	writel_relaxed(TIMERn_CMD_START, ddata->base + TIMERn_CMD);
> > +
> > +	return 0;
> > +}
> > +
> > +static irqreturn_t efm32_clock_event_handler(int irq, void *dev_id)
> > +{
> > +	struct efm32_clock_event_ddata *ddata = dev_id;
> > +
> > +	writel_relaxed(TIMERn_IRQ_UF, ddata->base + TIMERn_IFC);
> > +
> > +	ddata->evtdev.event_handler(&ddata->evtdev);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static struct efm32_clock_event_ddata clock_event_ddata = {
> > +	.evtdev = {
> > +		.name = "efm32 clockevent",
> > +		.features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_MODE_PERIODIC,
> > +		.set_mode = efm32_clock_event_set_mode,
> > +		.set_next_event = efm32_clock_event_set_next_event,
> > +		.rating = 200,
> > +	},
> > +};
> > +
> > +static struct irqaction efm32_clock_event_irq = {
> > +	.name = "efm32 clockevent",
> > +	.flags = IRQF_TIMER,
> > +	.handler = efm32_clock_event_handler,
> > +	.dev_id = &clock_event_ddata,
> > +};
> 
> Function name looks a bit long.
Which function? I prefer having a unique prefix for the driver + an
accurate description. All lines affected by "efm32_clock_event_handler"
don't even need to be broken, so IMO it's OK like that.
 
> > +static int efm32_clocksource_init(struct device_node *np)
> > +{
> > +	struct clk *clk;
> > +	void __iomem *base;
> > +	unsigned long rate;
> > +	int ret;
> > +
> > +	clk = of_clk_get(np, 0);
> > +	if (IS_ERR(clk)) {
> > +		ret = PTR_ERR(clk);
> > +		pr_err("failed to get clock for clocksource (%d)\n", ret);
> > +		goto err_clk_get;
> > +	}
> > +
> > +	ret = clk_prepare_enable(clk);
> > +	if (ret) {
> > +		pr_err("failed to enable timer clock for clocksource (%d)\n",
> > +		       ret);
> > +		goto err_clk_enable;
> > +	}
> > +	rate = clk_get_rate(clk);
> > +
> > +	base = of_iomap(np, 0);
> > +	if (!base) {
> > +		ret = -EADDRNOTAVAIL;
> > +		pr_err("failed to map registers for clocksource\n");
> > +		goto err_iomap;
> > +	}
> > +
> > +	writel_relaxed(TIMERn_CTRL_PRESC_1024 |
> > +		       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
> > +		       TIMERn_CTRL_MODE_UP, base + TIMERn_CTRL);
> > +	writel_relaxed(TIMERn_CMD_START, base + TIMERn_CMD);
> > +
> > +	ret = clocksource_mmio_init(base + TIMERn_CNT, "efm32 timer",
> > +				    DIV_ROUND_CLOSEST(rate, 1024), 200, 16,
> > +				    clocksource_mmio_readl_up);
> > +	if (ret) {
> > +		pr_err("failed to init clocksource (%d)\n", ret);
> > +		goto err_clocksource_init;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_clocksource_init:
> > +
> > +	iounmap(base);
> > +err_iomap:
> > +
> > +	clk_disable_unprepare(clk);
> > +err_clk_enable:
> > +
> > +	clk_put(clk);
> > +err_clk_get:
> > +
> > +	return ret;
> > +}
> > +
> > +static int __init efm32_clockevent_init(struct device_node *np)
> > +{
> > +	struct clk *clk;
> > +	void __iomem *base;
> > +	unsigned long rate;
> > +	int irq;
> > +	int ret;
> > +
> > +	clk = of_clk_get(np, 0);
> > +	if (IS_ERR(clk)) {
> > +		ret = PTR_ERR(clk);
> > +		pr_err("failed to get clock for clockevent (%d)\n", ret);
> > +		goto err_clk_get;
> > +	}
> > +
> > +	ret = clk_prepare_enable(clk);
> > +	if (ret) {
> > +		pr_err("failed to enable timer clock for clockevent (%d)\n",
> > +		       ret);
> > +		goto err_clk_enable;
> > +	}
> > +	rate = clk_get_rate(clk);
> > +
> > +	base = of_iomap(np, 0);
> > +	if (!base) {
> > +		ret = -EADDRNOTAVAIL;
> > +		pr_err("failed to map registers for clockevent\n");
> > +		goto err_iomap;
> > +	}
> > +
> > +	irq = irq_of_parse_and_map(np, 0);
> > +	if (!irq) {
> > +		ret = -ENOENT;
> > +		pr_err("failed to get irq for clockevent\n");
> > +		goto err_get_irq;
> > +	}
> > +
> > +	writel_relaxed(TIMERn_IRQ_UF, base + TIMERn_IEN);
> > +
> > +	clock_event_ddata.base = base;
> > +	clock_event_ddata.periodic_top = DIV_ROUND_CLOSEST(rate, 1024 * HZ);
> > +
> > +	setup_irq(irq, &efm32_clock_event_irq);
> > +
> > +	clockevents_config_and_register(&clock_event_ddata.evtdev,
> > +			DIV_ROUND_CLOSEST(rate, 1024), 0xf, 0xffff);
oh, here is an indention problem. Will fixup for the next version.
> > +
> > +	return 0;
> > +
> > +err_get_irq:
> > +
> > +	iounmap(base);
> > +err_iomap:
> > +
> > +	clk_disable_unprepare(clk);
> > +err_clk_enable:
> > +
> > +	clk_put(clk);
> > +err_clk_get:
> > +
> > +	return ret;
> > +}
> > +
> > +static void __init efm32_timer_init(struct device_node *np)
> > +{
> > +	static int has_clocksource, has_clockevent;
> > +	int ret;
> > +
> > +	if (!has_clocksource) {
> > +		ret = efm32_clocksource_init(np);
> > +		if (!ret) {
> > +			has_clocksource = 1;
> > +			return;
> > +		}
> > +	}
> > +
> > +	if (!has_clockevent) {
> > +		ret = efm32_clockevent_init(np);
> > +		if (!ret) {
> > +			has_clockevent = 1;
> > +			return;
> > +		}
> > +	}
> > +}
> 
> I don't get the purpose of this initialization, can you explain ?
An efm32 SoC has four timer blocks. A single block can only be used for
one of clocksource or clockevent device and having more than one
clocksource or clockevent device doesn't make sense. So this routine
asserts that the first timer is used as clocksource and the second as
clockevent device. The others are unused.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
