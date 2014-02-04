Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaBDLl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:41:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45702 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaBDLl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:41:57 -0500
Message-ID: <52F0D1D2.4030603@ti.com>
Date: Tue, 4 Feb 2014 13:41:06 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <santosh.shilimkar@ti.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <daniel.lezcano@linaro.org>,
        <tglx@linutronix.de>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: Re: [PATCH v4 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com> <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Santosh shilimkar <santosh.shilimkar@ti.com>

On 02/04/2014 01:30 PM, Ivan Khoronzhuk wrote:
> Add broadcast clock-event device for the Keystone arch.
>
> The timer can be configured as a general-purpose 64-bit timer,
> dual general-purpose 32-bit timers. When configured as dual 32-bit
> timers, each half can operate in conjunction (chain mode) or
> independently (unchained mode) of each other.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>   drivers/clocksource/Makefile         |   1 +
>   drivers/clocksource/timer-keystone.c | 233 +++++++++++++++++++++++++++++++++++
>   2 files changed, 234 insertions(+)
>   create mode 100644 drivers/clocksource/timer-keystone.c
>
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index c7ca50a..4abe5aa 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -37,3 +37,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
>   obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
>   obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
>   obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
> +obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
> diff --git a/drivers/clocksource/timer-keystone.c b/drivers/clocksource/timer-keystone.c
> new file mode 100644
> index 0000000..cbac8d0
> --- /dev/null
> +++ b/drivers/clocksource/timer-keystone.c
> @@ -0,0 +1,233 @@
> +/*
> + * Keystone broadcast clock-event
> + *
> + * Copyright 2013 Texas Instruments, Inc.
> + *
> + * Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/clocksource.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +
> +#define TIMER_NAME			"timer-keystone"
> +
> +/* Timer register offsets */
> +#define TIM12				0x10
> +#define TIM34				0x14
> +#define PRD12				0x18
> +#define PRD34				0x1c
> +#define TCR				0x20
> +#define TGCR				0x24
> +#define INTCTLSTAT			0x44
> +
> +/* Timer register bitfields */
> +#define TCR_ENAMODE_MASK		0xC0
> +#define TCR_ENAMODE_ONESHOT_MASK	0x40
> +#define TCR_ENAMODE_PERIODIC_MASK	0x80
> +
> +#define TGCR_TIM_UNRESET_MASK		0x03
> +#define INTCTLSTAT_ENINT_MASK		0x01
> +
> +/**
> + * struct keystone_timer: holds timer's data
> + * @base: timer memory base address
> + * @hz_period: cycles per HZ period
> + * @event_dev: event device based on timer
> + */
> +static struct keystone_timer {
> +	void __iomem *base;
> +	unsigned long hz_period;
> +	struct clock_event_device event_dev;
> +} timer;
> +
> +static inline u32 keystone_timer_readl(unsigned long rg)
> +{
> +	return readl_relaxed(timer.base + rg);
> +}
> +
> +static inline void keystone_timer_writel(u32 val, unsigned long rg)
> +{
> +	writel_relaxed(val, timer.base + rg);
> +}
> +
> +/**
> + * keystone_timer_config: configures timer to work in oneshot/periodic modes.
> + * @ mode: mode to configure
> + * @ period: cycles number to configure for
> + */
> +static int keystone_timer_config(u64 period, enum clock_event_mode mode)
> +{
> +	u32 tcr;
> +	u32 off;
> +
> +	tcr = keystone_timer_readl(TCR);
> +	off = tcr & ~(TCR_ENAMODE_MASK);
> +
> +	/* set enable mode */
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		tcr |= TCR_ENAMODE_ONESHOT_MASK;
> +		break;
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		tcr |= TCR_ENAMODE_PERIODIC_MASK;
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	/* disable timer */
> +	keystone_timer_writel(off, TCR);
> +	/* here we have to be sure the timer has been disabled */
> +	wmb();
> +
> +	/* reset counter to zero, set new period */
> +	keystone_timer_writel(0, TIM12);
> +	keystone_timer_writel(0, TIM34);
> +	keystone_timer_writel(period & 0xffffffff, PRD12);
> +	keystone_timer_writel(period >> 32, PRD34);
> +
> +	/*
> +	 * enable timer
> +	 * here we have to be sure that CNTLO, CNTHI, PRDLO, PRDHI registers
> +	 * have been written.
> +	 */
> +	wmb();
> +	keystone_timer_writel(tcr, TCR);
> +	return 0;
> +}
> +
> +static void keystone_timer_disable(void)
> +{
> +	u32 tcr;
> +
> +	tcr = keystone_timer_readl(TCR);
> +
> +	/* disable timer */
> +	tcr &= ~(TCR_ENAMODE_MASK);
> +	keystone_timer_writel(tcr, TCR);
> +}
> +
> +static irqreturn_t keystone_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = dev_id;
> +
> +	evt->event_handler(evt);
> +	return IRQ_HANDLED;
> +}
> +
> +static int keystone_set_next_event(unsigned long cycles,
> +				  struct clock_event_device *evt)
> +{
> +	return keystone_timer_config(cycles, evt->mode);
> +}
> +
> +static void keystone_set_mode(enum clock_event_mode mode,
> +			     struct clock_event_device *evt)
> +{
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		keystone_timer_config(timer.hz_period, CLOCK_EVT_MODE_PERIODIC);
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		keystone_timer_disable();
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static void __init keystone_timer_init(struct device_node *np)
> +{
> +	struct clock_event_device *event_dev = &timer.event_dev;
> +	unsigned long rate;
> +	struct clk *clk;
> +	int irq, error;
> +	u32 tgcr;
> +
> +	irq  = irq_of_parse_and_map(np, 0);
> +	if (irq == NO_IRQ) {
> +		pr_err("%s: failed to map interrupts\n", __func__);
> +		return;
> +	}
> +
> +	timer.base = of_iomap(np, 0);
> +	if (!timer.base) {
> +		pr_err("%s: failed to map registers\n", __func__);
> +		return;
> +	}
> +
> +	clk = of_clk_get(np, 0);
> +	if (!clk) {
> +		pr_err("%s: failed to get clock\n", __func__);
> +		iounmap(timer.base);
> +		return;
> +	}
> +
> +	error = clk_prepare_enable(clk);
> +	if (error) {
> +		pr_err("%s: failed to enable clock\n", __func__);
> +		goto err;
> +	}
> +
> +	rate = clk_get_rate(clk);
> +
> +	/* disable, use internal clock source */
> +	keystone_timer_writel(0, TCR);
> +	/* here we have to be sure the timer has been disabled */
> +	wmb();
> +
> +	/* reset timer as 64-bit, no pre-scaler, plus features are disabled */
> +	tgcr = 0;
> +	keystone_timer_writel(0, TGCR);
> +
> +	/* unreset timer */
> +	tgcr |= TGCR_TIM_UNRESET_MASK;
> +	keystone_timer_writel(tgcr, TGCR);
> +
> +	/* init counter to zero */
> +	keystone_timer_writel(0, TIM12);
> +	keystone_timer_writel(0, TIM34);
> +
> +	timer.hz_period = DIV_ROUND_UP(rate, HZ);
> +
> +	/* enable timer interrupts */
> +	keystone_timer_writel(INTCTLSTAT_ENINT_MASK, INTCTLSTAT);
> +
> +	error = request_irq(irq, keystone_timer_interrupt, IRQF_TIMER,
> +			    TIMER_NAME, event_dev);
> +	if (error) {
> +		pr_err("%s: failed to setup irq\n", __func__);
> +		goto err;
> +	}
> +
> +	/* setup clockevent */
> +	event_dev->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> +	event_dev->set_next_event = keystone_set_next_event;
> +	event_dev->set_mode = keystone_set_mode;
> +	event_dev->cpumask = cpu_all_mask;
> +	event_dev->owner = THIS_MODULE;
> +	event_dev->name = TIMER_NAME;
> +	event_dev->irq = irq;
> +
> +	clockevents_config_and_register(event_dev, rate, 1, ULONG_MAX);
> +
> +	pr_info("keystone timer clock @%lu Hz\n", rate);
> +	return;
> +err:
> +	clk_put(clk);
> +	iounmap(timer.base);
> +}
> +
> +CLOCKSOURCE_OF_DECLARE(keystone_timer, "ti,keystone-timer",
> +					keystone_timer_init);

-- 
Regards,
Ivan Khoronzhuk

