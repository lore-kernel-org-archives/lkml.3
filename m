Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133AbaDIVJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:09:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35301 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933885AbaDIVJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:09:03 -0400
Message-ID: <5345B6E6.4090209@free-electrons.com>
Date: Wed, 09 Apr 2014 21:08:54 +0000
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org
CC: mark.rutland@arm.com, andrew@lunn.ch, linux-doc@vger.kernel.org,
        thierry.reding@gmail.com, heiko.stuebner@bq.com,
        linux@arm.linux.org.uk, daniel.lezcano@linaro.org,
        florian.vaussard@epfl.ch, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, rdunlap@infradead.org,
        silvio.fricke@gmail.com, galak@codeaurora.org, olof@lixom.net,
        jic23@kernel.org
Subject: Re: [PATCH 1/4] clocksource: Add support for the Mediatek SoCs
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com> <1397072736-10793-2-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1397072736-10793-2-git-send-email-matthias.bgg@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On 09/04/2014 19:45, Matthias Brugger wrote:
> This patch adds a clock source and clock event for the timer found
> on the Mediatek SoCs.
> 
> The Mediatek General Porpose Timer block provides five 32 bit timers and
> one 64 bit timer.
> 
> Two 32 bit timers are used:
> TIMER1: clock events supporting periodic and oneshot events
> TIMER2: clock source configured as a free running counter
> 
> The General Porpose Timer block can be run with two clocks. A 13 MHz system
> clock and the RTC clock running at 32 KHz. This implementation uses the system
> clock.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/clocksource/Kconfig     |    4 +
>  drivers/clocksource/Makefile    |    1 +
>  drivers/clocksource/mtk_timer.c |  248 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 253 insertions(+)
>  create mode 100644 drivers/clocksource/mtk_timer.c
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 96918e1..bb29321 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -144,6 +144,10 @@ config VF_PIT_TIMER
>  config SYS_SUPPORTS_SH_CMT
>          bool
>  
> +config MTK_TIMER
> +	bool
> +
> +
>  config SYS_SUPPORTS_SH_MTU2
>          bool
>  
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 98cb6c5..619d302 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
>  obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
>  obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
>  obj-$(CONFIG_CLKSRC_QCOM)	+= qcom-timer.o
> +obj-$(CONFIG_MTK_TIMER)		+= mtk_timer.o
>  
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
>  obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
> diff --git a/drivers/clocksource/mtk_timer.c b/drivers/clocksource/mtk_timer.c
> new file mode 100644
> index 0000000..bf901e3
> --- /dev/null
> +++ b/drivers/clocksource/mtk_timer.c
> @@ -0,0 +1,248 @@
> +/*
> + * Mediatek SoCs General-Purpose Timer handling.
> + *
> + * Copyright (C) 2014 Matthias Brugger
> + *
> + * Matthias Brugger <matthias.bgg@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/irqreturn.h>
> +#include <linux/sched_clock.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +
> +#define GPT_IRQ_EN_REG		0x00
> +#define GPT_IRQ_ENABLE(val)	BIT(val-1)
> +#define GPT_IRQ_ST_REG		0x04
> +#define GPT_IRQ_ACK_REG		0x08
> +#define GPT_IRQ_ACK(val)	BIT(val-1)
> +
> +#define TIMER_CTRL_REG(val)	(0x10 * val)
> +#define TIMER_CTRL_OP(val)	(((val) & 0x3) << 4)
> +#define TIMER_CTRL_OP_ONESHOT	(0)
> +#define TIMER_CTRL_OP_REPEAT	(1)
> +#define TIMER_CTRL_OP_KEEPGO	(2)
> +#define TIMER_CTRL_OP_FREERUN	(3)
> +#define TIMER_CTRL_CLEAR	(2)
> +#define TIMER_CTRL_ENABLE	(1)
> +#define TIMER_CTRL_DISABLE	(0)
> +
> +#define TIMER_CLK_REG(val)	(0x04 + (0x10 * val))
> +#define TIMER_CLK_SRC(val)	(((val) & 0x1) << 4)
> +#define TIMER_CLK_SRC_SYS13M	(0)
> +#define TIMER_CLK_SRC_RTC32K	(1)
> +#define TIMER_CLK_DIV1		(0x0)
> +#define TIMER_CLK_DIV2		(0x1)
> +#define TIMER_CLK_DIV3		(0x2)
> +#define TIMER_CLK_DIV4		(0x3)
> +#define TIMER_CLK_DIV5		(0x4)
> +#define TIMER_CLK_DIV6		(0x5)
> +#define TIMER_CLK_DIV7		(0x6)
> +#define TIMER_CLK_DIV8		(0x7)
> +#define TIMER_CLK_DIV9		(0x8)
> +#define TIMER_CLK_DIV10		(0x9)
> +#define TIMER_CLK_DIV11		(0xA)
> +#define TIMER_CLK_DIV12		(0xB)
> +#define TIMER_CLK_DIV13		(0xC)
> +#define TIMER_CLK_DIV16		(0xD)
> +#define TIMER_CLK_DIV32		(0xE)
> +#define TIMER_CLK_DIV64		(0xF)
> +
> +#define TIMER_CNT_REG(val)	(0x08 + (0x10 * val))
> +#define TIMER_CMP_REG(val)	(0x0C + (0x10 * val))
> +
> +#define GPT_CLK_EVT	1
> +#define GPT_CLK_SRC	2
> +
> +static void __iomem *gpt_base;
> +static u32 ticks_per_jiffy;
> +
> +static void mtk_clkevt_time_stop(u8 timer)
> +{
> +	u32 val = readl(gpt_base + TIMER_CTRL_REG(timer));
> +	writel(val & ~TIMER_CTRL_ENABLE, gpt_base + TIMER_CTRL_REG(timer));
> +}
> +
> +static void mtk_clkevt_time_setup(unsigned long delay, u8 timer)
> +{
> +	writel(delay, gpt_base + TIMER_CMP_REG(timer));
> +}
> +
> +static void mtk_clkevt_time_start(bool periodic, u8 timer)
> +{
> +	u32 val;
> +
> +	/* Acknowledge interrupt */
> +	writel(GPT_IRQ_ACK(timer), gpt_base + GPT_IRQ_ACK_REG);
> +
> +	val = readl(gpt_base + TIMER_CTRL_REG(timer));
> +
> +	/* Clear 2 bit timer operation mode field */
> +	val &= ~TIMER_CTRL_OP(0x3);
> +
> +	if (periodic)
> +		val |= TIMER_CTRL_OP(TIMER_CTRL_OP_REPEAT);
> +	else
> +		val |= TIMER_CTRL_OP(TIMER_CTRL_OP_ONESHOT);
> +
> +	writel(val | TIMER_CTRL_ENABLE | TIMER_CTRL_CLEAR,
> +	       gpt_base + TIMER_CTRL_REG(timer));
> +}
> +
> +static void mtk_clkevt_mode(enum clock_event_mode mode,
> +			      struct clock_event_device *clk)
> +{
> +	mtk_clkevt_time_stop(GPT_CLK_EVT);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		mtk_clkevt_time_setup(ticks_per_jiffy, GPT_CLK_EVT);
> +		mtk_clkevt_time_start(true, GPT_CLK_EVT);
> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		mtk_clkevt_time_start(false, GPT_CLK_EVT);
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	default:
> +		/* No more interrupts will occur as source is disabled */
> +		break;
> +	}
> +}
> +
> +static int mtk_clkevt_next_event(unsigned long evt,
> +				   struct clock_event_device *unused)
> +{
> +	mtk_clkevt_time_stop(GPT_CLK_EVT);
> +	mtk_clkevt_time_setup(evt, GPT_CLK_EVT);
> +	mtk_clkevt_time_start(false, GPT_CLK_EVT);
> +
> +	return 0;
> +}
> +
> +static struct clock_event_device mtk_clockevent = {
> +	.name = "mtk_tick",
> +	.rating = 300,
> +	.shift = 32,
> +	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode = mtk_clkevt_mode,
> +	.set_next_event = mtk_clkevt_next_event,
> +};
> +
> +
> +static irqreturn_t mtk_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
> +
> +	/* Acknowledge timer0 irq */
> +	writel(GPT_IRQ_ACK(GPT_CLK_EVT), gpt_base + GPT_IRQ_ACK_REG);
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void mtk_timer_global_reset(void)
> +{
> +	/* Disable all interrupts */
> +	writel(0x0, gpt_base + GPT_IRQ_EN_REG);
> +	/* Acknowledge all interrupts */
> +	writel(0x3f, gpt_base + GPT_IRQ_ACK_REG);
> +}
> +
> +static void mtk_timer_reset(u8 timer)
> +{
> +	writel(TIMER_CTRL_CLEAR | TIMER_CTRL_DISABLE,
> +		gpt_base + TIMER_CTRL_REG(timer));
> +	writel(0x0, gpt_base + TIMER_CMP_REG(timer));
> +}
> +
> +static struct irqaction mtk_timer_irq = {
> +	.name = "mtk_timer0",
> +	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.handler = mtk_timer_interrupt,
> +	.dev_id = &mtk_clockevent,
> +};
> +
> +static u32 mtk_timer_sched_read(void)
> +{
> +	return readl(gpt_base + TIMER_CNT_REG(GPT_CLK_SRC));
> +}
> +
> +static void __init mtk_timer_init(struct device_node *node)
> +{
> +	unsigned long rate = 0;
> +	struct clk *clk;
> +	int ret, irq;
> +	u32 val;
> +
> +	gpt_base = of_iomap(node, 0);

What about using of_address_to_resource()? Then you will be
able to use request_mem_region() before calling ioremap().

> +	if (!gpt_base)
> +		panic("Can't map registers");
> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (irq <= 0)
> +		panic("Can't parse IRQ");
> +
> +	clk = of_clk_get_by_name(node, "sys_clk");

We try to avoid to used named clock. You should use
of_clk_get(np, 0) here.


Thanks,

Gregory


> +	if (IS_ERR(clk))
> +		panic("Can't get timer clock");
> +	clk_prepare_enable(clk);
> +
> +	rate = clk_get_rate(clk);
> +
> +	mtk_timer_global_reset();
> +
> +	/* Configure clock source */
> +	mtk_timer_reset(GPT_CLK_SRC);
> +
> +	writel(TIMER_CLK_SRC(TIMER_CLK_SRC_SYS13M) | TIMER_CLK_DIV1,
> +			gpt_base + TIMER_CLK_REG(GPT_CLK_SRC));
> +
> +	writel(TIMER_CTRL_OP(TIMER_CTRL_OP_FREERUN) | TIMER_CTRL_ENABLE,
> +				gpt_base + TIMER_CTRL_REG(GPT_CLK_SRC));
> +
> +	clocksource_mmio_init(gpt_base + TIMER_CNT_REG(GPT_CLK_SRC), node->name,
> +			      rate, 300, 32, clocksource_mmio_readl_up);
> +
> +	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
> +
> +	/* Configure clock event */
> +	mtk_timer_reset(GPT_CLK_EVT);
> +
> +	writel(TIMER_CLK_SRC(TIMER_CLK_SRC_SYS13M) | TIMER_CLK_DIV1,
> +			gpt_base + TIMER_CLK_REG(GPT_CLK_EVT));
> +	writel(0, gpt_base + TIMER_CMP_REG(GPT_CLK_EVT));
> +
> +	writel(TIMER_CTRL_OP(TIMER_CTRL_OP_REPEAT) | TIMER_CTRL_ENABLE,
> +			gpt_base + TIMER_CTRL_REG(GPT_CLK_EVT));
> +
> +	ret = setup_irq(irq, &mtk_timer_irq);
> +	if (ret)
> +		pr_warn("failed to setup irq %d\n", irq);
> +
> +	/* Enable timer0 interrupt */
> +	val = readl(gpt_base + GPT_IRQ_EN_REG);
> +	writel(val | GPT_IRQ_ENABLE(GPT_CLK_EVT), gpt_base + GPT_IRQ_EN_REG);
> +
> +	mtk_clockevent.cpumask = cpumask_of(0);
> +
> +	clockevents_config_and_register(&mtk_clockevent, rate, 0x3,
> +					0xffffffff);
> +}
> +CLOCKSOURCE_OF_DECLARE(mtk_mt6589, "mediatek,mtk6589-timer", mtk_timer_init);
> +
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
