Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3FZQKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:10:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43805 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3FZQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:10:07 -0400
Date: Wed, 26 Jun 2013 18:10:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Subject: Re: [PATCH v2] ARM: clocksource: add support for MOXA ART SoCs
Message-ID: <20130626161004.GC27010@pengutronix.de>
References: <1371549604-7201-1-git-send-email-jonas.jensen@gmail.com>
 <1372258383-24524-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372258383-24524-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 26, 2013 at 04:53:03PM +0200, Jonas Jensen wrote:
> This patch adds an clocksource driver for the main timer(s)
> found on MOXA ART SoCs.
> 
> Changes since v2:
> 
> 1. use clocksource/clockevents infrastructures
> 2. clock frequency read from system clock
> 
> Applies to next-20130619
Put the changes since vX after the tripple dash please. This way they
don't make it into the git history.

> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>  drivers/clocksource/Makefile       |    1 +
>  drivers/clocksource/moxart_timer.c |  184 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 185 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clocksource/moxart_timer.c
> 
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 8d979c7..c93e1a8 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
>  
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
>  obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
> +obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
> diff --git a/drivers/clocksource/moxart_timer.c b/drivers/clocksource/moxart_timer.c
> new file mode 100644
> index 0000000..376df31
> --- /dev/null
> +++ b/drivers/clocksource/moxart_timer.c
> @@ -0,0 +1,184 @@
> +/*
> + * MOXA ART SoCs timer handling.
> + *
> + * Copyright (C) 2013 Jonas Jensen
> + *
> + * Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/irqreturn.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/io.h>
> +#include <linux/clocksource.h>
> +
> +#define MAX_TIMER			2
> +#define USED_TIMER			1
This define is unused. ..ooOO(UNUSED_TIMER)
> +#define APB_CLK				48000000
> +
> +/* note: timer count is writable */
> +
> +#define TIMER1_COUNT        0x0
> +#define TIMER1_LOAD         0x4
> +#define TIMER1_MATCH1       0x8
> +#define TIMER1_MATCH2       0xC
> +
> +#define TIMER2_COUNT        0x10
> +#define TIMER2_LOAD         0x14
> +#define TIMER2_MATCH1       0x18
> +#define TIMER2_MATCH2       0x1C
> +
> +#define TIMER3_COUNT        0x20
> +#define TIMER3_LOAD         0x24
> +#define TIMER3_MATCH1       0x28
> +#define TIMER3_MATCH2       0x2C
Maybe make this:

	TIMER1_BASE	0x00
	TIMER2_BASE	0x10
	TIMER3_BASE	0x20

	REG_COUNT	0x0
	REG_LOAD	0x4
	REG_MATCH1	0x8
	REG_MATCH2	0xc

?

> +
> +#define TIMER_CR			0x30
> +#define TIMER_INTR_STATE    0x34
> +#define TIMER_INTR_MASK     0x38
All lines above starting with TIMER1_COUNT use spaces to indent, only
TIMER_CR uses tabs.

> +
> +/* TIMER_CR flags:
> +   TIMEREG_CR_1_CLOCK  0: PCLK, 1: EXT1CLK
> +   TIMEREG_CR_1_INT    over flow interrupt enable bit */
> +
> +#define TIMEREG_CR_1_ENABLE         (1 << 0)
> +#define TIMEREG_CR_1_CLOCK          (1 << 1)
> +#define TIMEREG_CR_1_INT            (1 << 2)
> +#define TIMEREG_CR_2_ENABLE         (1 << 3)
> +#define TIMEREG_CR_2_CLOCK          (1 << 4)
> +#define TIMEREG_CR_2_INT            (1 << 5)
> +#define TIMEREG_CR_3_ENABLE         (1 << 6)
> +#define TIMEREG_CR_3_CLOCK			(1 << 7)
> +#define TIMEREG_CR_3_INT			(1 << 8)
> +#define TIMEREG_CR_COUNT_UP			(1 << 9)
> +#define TIMEREG_CR_COUNT_DOWN		(0 << 9)
Same problem here.

> +
> +static void __iomem *timer_base;
> +static unsigned int clock_frequency;
> +
> +static void moxart_clkevt_mode(enum clock_event_mode mode,
> +	struct clock_event_device *clk)
> +{
> +	u32 u = readl(timer_base + TIMER_CR);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_RESUME:
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		u |= TIMEREG_CR_1_ENABLE;
> +		writel(u, timer_base + TIMER_CR);
> +		writel(~0, timer_base + TIMER1_LOAD);
> +		pr_debug("%s: CLOCK_EVT_MODE_ONESHOT\n", __func__);
This does already start the timer, right? I think the intention is that
after set_mode(ONESHOT) the timer only starts running after a call to
next_event.

> +		break;
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		u |= TIMEREG_CR_1_ENABLE;
> +		writel(u, timer_base + TIMER_CR);
> +		writel(clock_frequency / HZ, timer_base + TIMER1_LOAD);
better precalculate this value to save the division here.

> +		pr_debug("%s: CLOCK_EVT_MODE_PERIODIC\n", __func__);
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	default:
> +		u &= ~TIMEREG_CR_1_ENABLE;
> +		writel(u, timer_base + TIMER_CR);
> +		break;
> +	}
> +}
> +
> +static int moxart_clkevt_next_event(unsigned long cycles,
> +	struct clock_event_device *unused)
> +{
> +	u32 alarm = readl(timer_base + TIMER1_COUNT) - cycles;
> +	writel(alarm, timer_base + TIMER1_MATCH1);
> +	return 0;
> +}
> +
> +static struct clock_event_device moxart_clockevent = {
> +	.name = "moxart_timer",
> +	.rating = 300,
> +	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode = moxart_clkevt_mode,
> +	.set_next_event = moxart_clkevt_next_event,
> +};
> +
> +static irqreturn_t moxart_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
This cast is not necessary.

> +	evt->event_handler(evt);
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction moxart_timer_irq = {
> +	.name = "moxart-timer",
> +	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.handler = moxart_timer_interrupt,
> +	.dev_id = &moxart_clockevent,
> +};
> +
> +static void __init moxart_timer_init(struct device_node *node)
> +{
> +	int ret, irq;
> +	struct clk *clk;
> +
> +	timer_base = of_iomap(node, 0);
> +	if (!timer_base)
> +		panic("%s: failed to map base\n", node->full_name);
> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (irq <= 0)
> +		panic("%s: can't parse IRQ\n", node->full_name);
> +
> +	ret = setup_irq(irq, &moxart_timer_irq);
> +	if (ret) {
> +		pr_err("%s: failed to setup IRQ %d\n", node->full_name, irq);
> +		return;
> +	}
> +
> +	clock_frequency = APB_CLK;
> +	/* it might be a good idea to have a default other than 0 for
> +	   clock_frequency, should any attempt at getting a valid
> +	   frequency fail, not that i see how it could, it probably could..
> +	   having it APB_CLK can certainly be wrong on some hardware,
> +	   why it is set again with the DT specific property: */
Multi-line comments look as follows in the Kernel:

	/*
	 * ...
	 * ...
	 */

IIUC the comment describes the assignment to clock_frequency. In this
case the comment has to be above the assignment.
> +
> +	ret = of_property_read_u32(node, "clock-frequency", &clock_frequency);
> +	if (ret)
> +		pr_err("%s: can't read clock-frequency DT property\n",
> +			node->full_name);
> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk))
Maybe move the default assignment of clock_frequency to here?

> +		pr_err("%s: of_clk_get failed\n", __func__);
> +	else {
> +		clock_frequency = clk_get_rate(clk);
> +		pr_debug("%s: clk_get_rate=%u success\n", __func__,
> +			clock_frequency);
> +	}
> +
> +	writel(~0, timer_base + TIMER2_LOAD);
> +
> +	writel(TIMEREG_CR_1_ENABLE | TIMEREG_CR_2_ENABLE |
> +		TIMEREG_CR_COUNT_DOWN, timer_base + TIMER_CR);
> +
> +	if (clocksource_mmio_init(timer_base + TIMER2_COUNT, "moxart_timer",
> +		clock_frequency, 200, 32, clocksource_mmio_readl_down))
> +		pr_err("%s: clocksource_mmio_init failed\n", __func__);
> +
> +	moxart_clockevent.cpumask = cpumask_of(0);
> +
> +	clockevents_config_and_register(&moxart_clockevent, clock_frequency,
> +		0x4, 0xf0000000);
tglx recently told me he prefers to align continuation lines to the
matching opening brace.

Best regards
Uwe

> +
> +	pr_info("%s: %s finished clock_frequency=%d HZ=%d IRQ=%d\n",
> +		node->full_name, __func__, clock_frequency, HZ, irq);
> +}
> +CLOCKSOURCE_OF_DECLARE(moxart, "moxa,moxart-timer", moxart_timer_init);
> +
> -- 
> 1.7.2.5
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
