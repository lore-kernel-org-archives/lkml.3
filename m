Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbbAVMyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:54:45 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65011 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAVMym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:54:42 -0500
Message-ID: <54C0F30F.9060607@linaro.org>
Date: Thu, 22 Jan 2015 13:54:39 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
References: <cover.1421821466.git.baruch@tkos.co.il> <762d81b2cf12922ba28fb58b3ea4d5b7072abefb.1421821466.git.baruch@tkos.co.il>
In-Reply-To: <762d81b2cf12922ba28fb58b3ea4d5b7072abefb.1421821466.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 07:36 AM, Baruch Siach wrote:
> Add clocksource driver to the Conexant CX92755 SoC, part of the Digicolor SoCs
> series. Hardware provides 8 timers, A to H. Timer A is dedicated to a future
> watchdog driver so we don't use it here. Use timer B for sched_clock, and timer
> C for clock_event.
>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>   drivers/clocksource/Makefile          |   1 +
>   drivers/clocksource/timer-digicolor.c | 164 ++++++++++++++++++++++++++++++++++
>   2 files changed, 165 insertions(+)
>   create mode 100644 drivers/clocksource/timer-digicolor.c
>
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 94d90b24b56b..a993c108be67 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
>   obj-$(CONFIG_EM_TIMER_STI)	+= em_sti.o
>   obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
>   obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
> +obj-$(CONFIG_ARCH_DIGICOLOR)	+= timer-digicolor.o
>   obj-$(CONFIG_DW_APB_TIMER)	+= dw_apb_timer.o
>   obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
>   obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
> diff --git a/drivers/clocksource/timer-digicolor.c b/drivers/clocksource/timer-digicolor.c
> new file mode 100644
> index 000000000000..014c50675980
> --- /dev/null
> +++ b/drivers/clocksource/timer-digicolor.c
> @@ -0,0 +1,164 @@
> +/*
> + * Conexant Digicolor timer driver
> + *
> + * Author: Baruch Siach <baruch@tkos.co.il>
> + *
> + * Copyright (C) 2014 Paradox Innovation Ltd.
> + *
> + * Based on:
> + *	Allwinner SoCs hstimer driver


If this is based on the Allwinnner driver, may be you can have a look at 
the patchset sent by Maxim to make sure your implementation is complete ?

https://lkml.org/lkml/2015/1/11/52

> + * Copyright (C) 2013 Maxime Ripard
> + *
> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +/*
> + * Conexant Digicolor SoCs have 8 configurable timers, named from "Timer A" to
> + * "Timer H". Timer A is the only one with watchdog support, so it is dedicated
> + * to the watchdog driver. This driver uses Timer B for sched_clock(), and
> + * Timer C for clockevents.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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
> +enum {
> +	TIMER_A,
> +	TIMER_B,
> +	TIMER_C,
> +	TIMER_D,
> +	TIMER_E,
> +	TIMER_F,
> +	TIMER_G,
> +	TIMER_H,
> +};
> +
> +#define CONTROL(t)	((t)*8)
> +#define COUNT(t)	((t)*8 + 4)
> +
> +static void __iomem *timer_base;
> +static u32 ticks_per_jiffy;

Mind to encapsulate those global variables in a structure and use 
container_of to access those fields like:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/clocksource/mtk_timer.c#n56

?

> +static void digicolor_clkevt_mode(enum clock_event_mode mode,
> +				  struct clock_event_device *clk)
> +{
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		writeb(0, timer_base + CONTROL(TIMER_C));

Even if that sounds overkill, please replace '0', '1' with whatever 
macro name (eg. TIMER_DISABLE/ENABLE).

> +		writel(ticks_per_jiffy, timer_base + COUNT(TIMER_C));
> +		writeb(0x21, timer_base + CONTROL(TIMER_C));

Please replace 0x21 occurrences by a macro.

> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		writeb(0, timer_base + CONTROL(TIMER_C));
> +		writeb(0x11, timer_base + CONTROL(TIMER_C));

Please replace 0x11 occurrences by a macro.

> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	default:
> +		writeb(0, timer_base + CONTROL(TIMER_C));
> +		break;
> +	}
> +}
> +
> +static int digicolor_clkevt_next_event(unsigned long evt,
> +				       struct clock_event_device *unused)
> +{
> +	writeb(0, timer_base + CONTROL(TIMER_C));
> +	writel(evt, timer_base + COUNT(TIMER_C));
> +	writeb(0x11, timer_base + CONTROL(TIMER_C));

ditto.

> +	return 0;
> +}
> +
> +static struct clock_event_device digicolor_clockevent = {
> +	.name = "digicolor_tick",
> +	.rating = 340,
> +	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode = digicolor_clkevt_mode,
> +	.set_next_event = digicolor_clkevt_next_event,
> +};
> +
> +
> +static irqreturn_t digicolor_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
> +
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction digicolor_timer_irq = {
> +	.name = "digicolor_timerC",
> +	.flags = IRQF_TIMER | IRQF_IRQPOLL,
> +	.handler = digicolor_timer_interrupt,
> +	.dev_id = &digicolor_clockevent,
> +};

The current trend is to use 'request_irq', so no such structure 
declaration/initialization is needed.

> +static u64 digicolor_timer_sched_read(void)
> +{
> +	return ~readl(timer_base + COUNT(TIMER_B));
> +}
> +
> +static void __init digicolor_timer_init(struct device_node *node)
> +{
> +	unsigned long rate;
> +	struct clk *clk;
> +	int ret, irq;
> +
> +	timer_base = of_iomap(node, 0);
> +	if (!timer_base) {
> +		pr_err("Can't map registers");
> +		return;
> +	}
> +
> +	irq = irq_of_parse_and_map(node, TIMER_C);
> +	if (irq <= 0) {
> +		pr_err("Can't parse IRQ");
> +		return;
> +	}
> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk)) {
> +		pr_err("Can't get timer clock");
> +		return;
> +	}
> +	clk_prepare_enable(clk);
> +	rate = clk_get_rate(clk);
> +
> +	writeb(0, timer_base + CONTROL(TIMER_B));
> +	writel(~0, timer_base + COUNT(TIMER_B));

s/~0/UINT_MAX/ ?

> +	writeb(1, timer_base + CONTROL(TIMER_B));
> +
> +	sched_clock_register(digicolor_timer_sched_read, 32, rate);
> +	clocksource_mmio_init(timer_base + COUNT(TIMER_B), node->name,
> +			      rate, 340, 32, clocksource_mmio_readl_down);
> +
> +	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
> +
> +	ret = setup_irq(irq, &digicolor_timer_irq);
> +	if (ret)
> +		pr_warn("failed to setup timer irq %d (%d)\n", irq, ret);

s/setup_irq/request_irq/

> +
> +	digicolor_clockevent.cpumask = cpu_possible_mask;
> +	digicolor_clockevent.irq = irq;
> +
> +	clockevents_config_and_register(&digicolor_clockevent, rate, 0,
> +					0xffffffff);
> +}
> +CLOCKSOURCE_OF_DECLARE(conexant_digicolor, "cnxt,cx92755-timer",
> +		       digicolor_timer_init);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

