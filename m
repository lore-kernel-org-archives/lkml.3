Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbbAOQsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:48:30 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55636 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAOQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:48:29 -0500
Message-ID: <54B7ED85.2090700@linaro.org>
Date: Thu, 15 Jan 2015 17:40:37 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 7/8] clocksource: atmel-st: use syscon/regmap
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com> <1421077023-30954-8-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421077023-30954-8-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 04:37 PM, Alexandre Belloni wrote:
> The register range from the system timer is also used by the watchdog driver.
> Use a regmap to handle concurrent accesses.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>   drivers/clocksource/timer-atmel-st.c | 103 +++++++++++++----------------------
>   1 file changed, 39 insertions(+), 64 deletions(-)
>
> diff --git a/drivers/clocksource/timer-atmel-st.c b/drivers/clocksource/timer-atmel-st.c
> index ed0267f1c892..557389306be5 100644
> --- a/drivers/clocksource/timer-atmel-st.c
> +++ b/drivers/clocksource/timer-atmel-st.c
> @@ -24,20 +24,20 @@
>   #include <linux/irq.h>
>   #include <linux/clockchips.h>
>   #include <linux/export.h>
> -#include <linux/of.h>
> -#include <linux/of_address.h>
> +#include <linux/mfd/atmel-st.h>
> +#include <linux/mfd/syscon.h>
>   #include <linux/of_irq.h>
> +#include <linux/regmap.h>
>
>   #include <asm/mach/time.h>
>   #include <asm/system_misc.h>
>
> -#include <mach/at91_st.h>
> -#include <mach/hardware.h>
> -
>   static unsigned long last_crtr;
>   static u32 irqmask;
>   static struct clock_event_device clkevt;
> +static struct regmap *regmap_st;
>
> +#define AT91_SLOW_CLOCK		32768 /* DT compatibility */
>   #define RM9200_TIMER_LATCH	((AT91_SLOW_CLOCK + HZ/2) / HZ)
>
>   /*
> @@ -47,11 +47,11 @@ static struct clock_event_device clkevt;
>    */
>   static inline unsigned long read_CRTR(void)
>   {
> -	unsigned long x1, x2;
> +	unsigned int x1, x2;
>
> -	x1 = at91_st_read(AT91_ST_CRTR);
> +	regmap_read(regmap_st, AT91_ST_CRTR, &x1);
>   	do {
> -		x2 = at91_st_read(AT91_ST_CRTR);
> +		regmap_read(regmap_st, AT91_ST_CRTR, &x2);
>   		if (x1 == x2)
>   			break;
>   		x1 = x2;
> @@ -64,7 +64,10 @@ static inline unsigned long read_CRTR(void)
>    */
>   static irqreturn_t at91rm9200_timer_interrupt(int irq, void *dev_id)
>   {
> -	u32	sr = at91_st_read(AT91_ST_SR) & irqmask;
> +	u32 sr;
> +
> +	regmap_read(regmap_st, AT91_ST_SR, &sr);
> +	sr &= irqmask;
>
>   	/*
>   	 * irqs should be disabled here, but as the irq is shared they are only
> @@ -97,7 +100,7 @@ static struct irqaction at91rm9200_timer_irq = {
>   	.name		= "at91_tick",
>   	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
>   	.handler	= at91rm9200_timer_interrupt,
> -	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
> +	.irq		= 0,
>   };
>
>   static cycle_t read_clk32k(struct clocksource *cs)
> @@ -116,23 +119,25 @@ static struct clocksource clk32k = {
>   static void
>   clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
>   {
> +	unsigned int val;
> +
>   	/* Disable and flush pending timer interrupts */
> -	at91_st_write(AT91_ST_IDR, AT91_ST_PITS | AT91_ST_ALMS);
> -	at91_st_read(AT91_ST_SR);
> +	regmap_write(regmap_st, AT91_ST_IDR, AT91_ST_PITS | AT91_ST_ALMS);
> +	regmap_read(regmap_st, AT91_ST_SR, &val);
>
>   	last_crtr = read_CRTR();
>   	switch (mode) {
>   	case CLOCK_EVT_MODE_PERIODIC:
>   		/* PIT for periodic irqs; fixed rate of 1/HZ */
>   		irqmask = AT91_ST_PITS;
> -		at91_st_write(AT91_ST_PIMR, RM9200_TIMER_LATCH);
> +		regmap_write(regmap_st, AT91_ST_PIMR, RM9200_TIMER_LATCH);
>   		break;
>   	case CLOCK_EVT_MODE_ONESHOT:
>   		/* ALM for oneshot irqs, set by next_event()
>   		 * before 32 seconds have passed
>   		 */
>   		irqmask = AT91_ST_ALMS;
> -		at91_st_write(AT91_ST_RTAR, last_crtr);
> +		regmap_write(regmap_st, AT91_ST_RTAR, last_crtr);
>   		break;
>   	case CLOCK_EVT_MODE_SHUTDOWN:
>   	case CLOCK_EVT_MODE_UNUSED:
> @@ -140,7 +145,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
>   		irqmask = 0;
>   		break;
>   	}
> -	at91_st_write(AT91_ST_IER, irqmask);
> +	regmap_write(regmap_st, AT91_ST_IER, irqmask);
>   }
>
>   static int
> @@ -148,6 +153,7 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
>   {
>   	u32		alm;
>   	int		status = 0;
> +	unsigned int	val;
>
>   	BUG_ON(delta < 2);
>
> @@ -163,12 +169,12 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
>   	alm = read_CRTR();
>
>   	/* Cancel any pending alarm; flush any pending IRQ */
> -	at91_st_write(AT91_ST_RTAR, alm);
> -	at91_st_read(AT91_ST_SR);
> +	regmap_write(regmap_st, AT91_ST_RTAR, alm);
> +	regmap_read(regmap_st, AT91_ST_SR, &val);
>
>   	/* Schedule alarm by writing RTAR. */
>   	alm += delta;
> -	at91_st_write(AT91_ST_RTAR, alm);
> +	regmap_write(regmap_st, AT91_ST_RTAR, alm);
>
>   	return status;
>   }
> @@ -186,47 +192,8 @@ static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
>   	/*
>   	 * Perform a hardware reset with the use of the Watchdog timer.
>   	 */
> -	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
> -	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
> -}
> -
> -void __iomem *at91_st_base;
> -EXPORT_SYMBOL_GPL(at91_st_base);
> -
> -static struct of_device_id at91rm9200_st_timer_ids[] = {
> -	{ .compatible = "atmel,at91rm9200-st" },
> -	{ /* sentinel */ }
> -};
> -
> -static int __init of_at91rm9200_st_init(void)
> -{
> -	struct device_node *np;
> -	int ret;
> -
> -	np = of_find_matching_node(NULL, at91rm9200_st_timer_ids);
> -	if (!np)
> -		goto err;
> -
> -	at91_st_base = of_iomap(np, 0);
> -	if (!at91_st_base)
> -		goto node_err;
> -
> -	/* Get the interrupts property */
> -	ret = irq_of_parse_and_map(np, 0);
> -	if (!ret)
> -		goto ioremap_err;
> -	at91rm9200_timer_irq.irq = ret;
> -
> -	of_node_put(np);
> -
> -	return 0;
> -
> -ioremap_err:
> -	iounmap(at91_st_base);
> -node_err:
> -	of_node_put(np);
> -err:
> -	return -EINVAL;
> +	regmap_write(regmap_st, AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
> +	regmap_write(regmap_st, AT91_ST_CR, AT91_ST_WDRST);
>   }
>
>   /*
> @@ -234,13 +201,21 @@ err:
>    */
>   static void __init atmel_st_timer_init(struct device_node *node)
>   {
> -	/* For device tree enabled device: initialize here */
> -	of_at91rm9200_st_init();
> +	unsigned int val;
> +
> +	regmap_st = syscon_node_to_regmap(node);
> +	if (IS_ERR(regmap_st))
> +		panic(pr_fmt("Unable to get regmap\n"));

Is it possible to get ride of those panics ? IIRC, we discussed to not 
panic when a timer was not initialized in case there is a definition for 
another one.

>
>   	/* Disable all timer interrupts, and clear any pending ones */
> -	at91_st_write(AT91_ST_IDR,
> +	regmap_write(regmap_st, AT91_ST_IDR,
>   		AT91_ST_PITS | AT91_ST_WDOVF | AT91_ST_RTTINC | AT91_ST_ALMS);
> -	at91_st_read(AT91_ST_SR);
> +	regmap_read(regmap_st, AT91_ST_SR, &val);
> +
> +	/* Get the interrupts property */
> +	at91rm9200_timer_irq.irq  = irq_of_parse_and_map(node, 0);
> +	if (!at91rm9200_timer_irq.irq)
> +		panic(pr_fmt("Unable to get IRQ from DT\n"));
>
>   	/* Make IRQs happen for the system timer */
>   	setup_irq(at91rm9200_timer_irq.irq, &at91rm9200_timer_irq);
> @@ -249,7 +224,7 @@ static void __init atmel_st_timer_init(struct device_node *node)
>   	 * directly for the clocksource and all clockevents, after adjusting
>   	 * its prescaler from the 1 Hz default.
>   	 */
> -	at91_st_write(AT91_ST_RTMR, 1);
> +	regmap_write(regmap_st, AT91_ST_RTMR, 1);
>
>   	/* Setup timer clockevent, with minimum of two ticks (important!!) */
>   	clkevt.cpumask = cpumask_of(0);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

