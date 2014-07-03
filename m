Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaGCMFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:05:35 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51747 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaGCMFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:05:34 -0400
Message-ID: <53B5470D.4070009@linaro.org>
Date: Thu, 03 Jul 2014 14:05:33 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] clocksource: add device-tree support for PXA timer
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr> <1403388588-11956-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1403388588-11956-2-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 12:09 AM, Robert Jarzmik wrote:
> Add device-tree support to PXA platforms.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>   drivers/clocksource/pxa_timer.c | 131 ++++++++++++++++++++++++++++++----------
>   1 file changed, 98 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/clocksource/pxa_timer.c b/drivers/clocksource/pxa_timer.c
> index fca174e..67da3f5 100644
> --- a/drivers/clocksource/pxa_timer.c
> +++ b/drivers/clocksource/pxa_timer.c
> @@ -15,14 +15,41 @@
>   #include <linux/kernel.h>
>   #include <linux/init.h>
>   #include <linux/interrupt.h>
> +#include <linux/clk.h>
>   #include <linux/clockchips.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
>   #include <linux/sched_clock.h>
>
>   #include <asm/div64.h>
>   #include <asm/mach/irq.h>
>   #include <asm/mach/time.h>
> -#include <mach/regs-ost.h>
>   #include <mach/irqs.h>
> +#include <mach/hardware.h>

Now as the driver is in 'drivers', do not reference the headers files in 
mach. Moving the driver to the drivers directory implies some cleanup 
with the headers dependencies.

> +#define OSMR0		0x00	/* */
> +#define OSMR1		0x04	/* */
> +#define OSMR2		0x08	/* */
> +#define OSMR3		0x0C	/* */
> +#define OSMR4		0x80	/* */

Can you please remove those unused empty comment or fill them with 
something appropriate.

> +#define OSCR		0x10	/* OS Timer Counter Register */
> +#define OSCR4		0x40	/* OS Timer Counter Register */
> +#define OMCR4		0xC0	/* */
> +#define OSSR		0x14	/* OS Timer Status Register */
> +#define OWER		0x18	/* OS Timer Watchdog Enable Register */
> +#define OIER		0x1C	/* OS Timer Interrupt Enable Register */
> +
> +#define OSSR_M3		(1 << 3)	/* Match status channel 3 */
> +#define OSSR_M2		(1 << 2)	/* Match status channel 2 */
> +#define OSSR_M1		(1 << 1)	/* Match status channel 1 */
> +#define OSSR_M0		(1 << 0)	/* Match status channel 0 */
> +
> +#define OWER_WME	(1 << 0)	/* Watchdog Match Enable */
> +
> +#define OIER_E3		(1 << 3)	/* Interrupt enable channel 3 */
> +#define OIER_E2		(1 << 2)	/* Interrupt enable channel 2 */
> +#define OIER_E1		(1 << 1)	/* Interrupt enable channel 1 */
> +#define OIER_E0		(1 << 0)	/* Interrupt enable channel 0 */

Is it possible to do some cleanups around regs-ost.h and here in order 
to remove the unused macros. Also, it seems some define will be 
duplicate as they are shared with the watchdog. Any plan to fix that ?

>   /*
>    * This is PXA's sched_clock implementation. This has a resolution
> @@ -33,9 +60,14 @@
>    * calls to sched_clock() which should always be the case in practice.
>    */
>
> +#define timer_readl(reg) readl_relaxed(timer_base + (reg))
> +#define timer_writel(val, reg) writel_relaxed((val), timer_base + (reg))
> +
> +static void __iomem *timer_base;
> +
>   static u64 notrace pxa_read_sched_clock(void)
>   {
> -	return readl_relaxed(OSCR);

So here there is a change which is not explained in the changelog 
(timer_base offset).

Even it is obvious for me because I am used to see this kind of code, 
that would deserve a better description in the changelog.

> +	return timer_readl(OSCR);
>   }
>

[ ... ]

> +static void __init pxa_timer_dt_init(struct device_node *np)
> +{
> +	struct clk *clk;
> +	int irq;
> +
> +	/* timer registers are shared with watchdog timer */
> +	timer_base = of_iomap(np, 0);
> +	if (!timer_base)
> +		panic("%s: unable to map resource\n", np->name);
> +
> +	clk = of_clk_get(np, 0);
> +	if (IS_ERR(clk))
> +		panic("%s: unable to get clk\n", np->name);
> +	clk_prepare_enable(clk);
> +
> +	/* we are only interested in OS-timer0 irq */
> +	irq = irq_of_parse_and_map(np, 0);
> +	if (irq <= 0)
> +		panic("%s: unable to parse OS-timer0 irq\n", np->name);

Is the 'panic' desirable ? The clksrc-of is written in a way to use 
different clocks, no ?

> +
> +	pxa_timer_common_init(irq, clk_get_rate(clk));
> +}
> +CLOCKSOURCE_OF_DECLARE(pxa_timer, "marvell,pxa-timer", pxa_timer_dt_init);
> +
> +/*
> + * Legacy timer init for non device-tree boards.
> + */
> +void __init pxa_timer_init(void)
> +{
> +	unsigned long clock_tick_rate = get_clock_tick_rate();
> +
> +	timer_base = io_p2v(0x40a00000);
> +	pxa_timer_common_init(IRQ_OST0, clock_tick_rate);
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

