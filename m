Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3JCRbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:31:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63002 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3JCRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:31:12 -0400
Date: Thu, 3 Oct 2013 10:31:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/4] watchdog: at91sam9_wdt: better watchdog support
Message-ID: <20131003173105.GC31605@roeck-us.net>
References: <1380802761-32279-1-git-send-email-b.brezillon@overkiz.com>
 <1380802761-32279-2-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380802761-32279-2-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:19:18PM +0200, Boris BREZILLON wrote:
> The at91sam9 watchdog timer can only be configured once, and the current
> implementation tries to configure it in a static way:
> - 2 seconds timeout
> - wdt restart every 500ms
> 
> If the timer has already been configured with different values, it returns an
> error and do not create any watchdog device.
> 
> This is not critical if the watchdog is disabled, but if it has been enabled with
> different timeout values it will lead to a SoC reset.
> 
> This patch series tries to address this issue by adapting the heartbeat value
> according the WDT timer config:
> - it first tries to configure the timer as requested.
> - if it fails it fallbacks to the current config, adapting its heartbeat timer
> to the needs
> 
> This patch series also move to a dynamically allocated at91wdt device instead
> of the static instance.
> 
> It adds a new at91 wdt type: software. This new type make use of the at91 wdt
> interrupt to trigger a software reboot.
> 
> Finally it adds several properties to the device tree bindings.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Hi Boris,

deeper dive this time ...

> ---
>  drivers/watchdog/at91sam9_wdt.c |  300 ++++++++++++++++++++++++++++-----------
>  1 file changed, 217 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index be37dde..8f44528 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -19,11 +19,13 @@
>  
>  #include <linux/errno.h>
>  #include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>  #include <linux/types.h>
>  #include <linux/watchdog.h>
>  #include <linux/jiffies.h>
> @@ -31,22 +33,33 @@
>  #include <linux/bitops.h>
>  #include <linux/uaccess.h>
>  #include <linux/of.h>
> +#include <linux/of_irq.h>
>  
>  #include "at91sam9_wdt.h"
>  
>  #define DRV_NAME "AT91SAM9 Watchdog"
>  
> -#define wdt_read(field) \
> -	__raw_readl(at91wdt_private.base + field)
> -#define wdt_write(field, val) \
> -	__raw_writel((val), at91wdt_private.base + field)
> +#define wdt_read(wdt, field) \
> +	__raw_readl((wdt)->base + (field))
> +#define wdt_write(wtd, field, val) \
> +	__raw_writel((val), (wdt)->base + (field))
>  
>  /* AT91SAM9 watchdog runs a 12bit counter @ 256Hz,
>   * use this to convert a watchdog
>   * value from/to milliseconds.
>   */
> -#define ms_to_ticks(t)	(((t << 8) / 1000) - 1)
> -#define ticks_to_ms(t)	(((t + 1) * 1000) >> 8)
> +#define ticks_to_hz_rounddown(t)	((((t) + 1) * HZ) >> 8)
> +#define ticks_to_hz_roundup(t)		(((((t) + 1) * HZ) + 255) >> 8)
> +#define ticks_to_secs(t)		(((t) + 1) >> 8)
> +#define secs_to_ticks(s)		(((s) << 8) - 1)
> +
> +#define WDT_MR_RESET	0x3FFF2FFF
> +
> +/* Watchdog max counter value in ticks */
> +#define WDT_COUNTER_MAX_TICKS	0xFFF
> +
> +/* Watchdog max delta/value in secs */
> +#define WDT_COUNTER_MAX_SECS	ticks_to_secs(WDT_COUNTER_MAX_TICKS)
>  
>  /* Hardware timeout in seconds */
>  #define WDT_HW_TIMEOUT 2
> @@ -66,23 +79,40 @@ module_param(nowayout, bool, 0);
>  MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
>  	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
>  
> -static struct watchdog_device at91_wdt_dev;
> -static void at91_ping(unsigned long data);
> -
> -static struct {
> +#define to_wdt(wdd) container_of(wdd, struct at91wdt, wdd)
> +struct at91wdt {
> +	struct watchdog_device wdd;
>  	void __iomem *base;
>  	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
>  	struct timer_list timer;	/* The timer that pings the watchdog */
> -} at91wdt_private;
> +	u32 mr;
> +	u32 mr_mask;
> +	unsigned long heartbeat;	/* WDT heartbeat in jiffies */
> +	bool nowayout;
> +	unsigned int irq;
> +};
>  
>  /* ......................................................................... */
>  
> +static irqreturn_t wdt_interrupt(int irq, void *dev_id)
> +{
> +	struct at91wdt *wdt = (struct at91wdt *)dev_id;
> +
> +	if (wdt_read(wdt, AT91_WDT_SR)) {
> +		pr_crit("at91sam9 WDT software reset\n");
> +		emergency_restart();
> +		pr_crit("Reboot didn't ?????\n");
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
>  /*
>   * Reload the watchdog timer.  (ie, pat the watchdog)
>   */
> -static inline void at91_wdt_reset(void)
> +static inline void at91_wdt_reset(struct at91wdt *wdt)
>  {
> -	wdt_write(AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
> +	wdt_write(wdt, AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
>  }
>  
>  /*
> @@ -90,26 +120,20 @@ static inline void at91_wdt_reset(void)
>   */
>  static void at91_ping(unsigned long data)
>  {
> -	if (time_before(jiffies, at91wdt_private.next_heartbeat) ||
> -	    (!watchdog_active(&at91_wdt_dev))) {
> -		at91_wdt_reset();
> -		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
> +	struct at91wdt *wdt = (struct at91wdt *)data;
> +	if (time_before(jiffies, wdt->next_heartbeat) ||
> +	    !watchdog_active(&wdt->wdd)) {
> +		at91_wdt_reset(wdt);
> +		mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
>  	} else
>  		pr_crit("I will reset your machine !\n");
>  }
>  
>  static int at91_wdt_ping(struct watchdog_device *wdd)
>  {
> +	struct at91wdt *wdt = to_wdt(wdd);
>  	/* calculate when the next userspace timeout will be */
> -	at91wdt_private.next_heartbeat = jiffies + wdd->timeout * HZ;
> -	return 0;
> -}
> -
> -static int at91_wdt_start(struct watchdog_device *wdd)
> -{
> -	/* calculate the next userspace timeout and modify the timer */
> -	at91_wdt_ping(wdd);
> -	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
> +	wdt->next_heartbeat = jiffies + wdd->timeout * HZ;
>  	return 0;
>  }
>  
> @@ -125,36 +149,84 @@ static int at91_wdt_set_timeout(struct watchdog_device *wdd, unsigned int new_ti

at91_wdt_set_timeout only sets the new timeout but does not update
next_heartbeat. That is ok if the timeout decreases, but if it is
increased (say, from 1 second to 1 minute) it might result in a missed
ping as userspace will subsequently believe that the new (larger)
timeout was accepted by the driver. So I think you should also call
at91_wdt_ping here or set wdt->next_heartbeat directly.

>  	return 0;
>  }
>  
> -/*
> - * Set the watchdog time interval in 1/256Hz (write-once)
> - * Counter is 12 bit.
> - */
> -static int at91_wdt_settimeout(unsigned int timeout)
> +static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
>  {
> -	unsigned int reg;
> -	unsigned int mr;
> -
> -	/* Check if disabled */
> -	mr = wdt_read(AT91_WDT_MR);
> -	if (mr & AT91_WDT_WDDIS) {
> -		pr_err("sorry, watchdog is disabled\n");
> -		return -EIO;
> +	u32 tmp;
> +	u32 delta;
> +	u32 value;
> +	int err;
> +	u32 mask = wdt->mr_mask;
> +	unsigned long min_heartbeat = 1;
> +
> +	tmp = wdt_read(wdt, AT91_WDT_MR);
> +	if ((tmp & mask) != (wdt->mr & mask)) {
> +		if (tmp == WDT_MR_RESET) {
> +			wdt_write(wdt, AT91_WDT_MR, wdt->mr);
> +			tmp = wdt_read(wdt, AT91_WDT_MR);
> +		}
>  	}
>  
> -	/*
> -	 * All counting occurs at SLOW_CLOCK / 128 = 256 Hz
> -	 *
> -	 * Since WDV is a 12-bit counter, the maximum period is
> -	 * 4096 / 256 = 16 seconds.
> -	 */
> -	reg = AT91_WDT_WDRSTEN	/* causes watchdog reset */
> -		/* | AT91_WDT_WDRPROC	causes processor reset only */
> -		| AT91_WDT_WDDBGHLT	/* disabled in debug mode */
> -		| AT91_WDT_WDD		/* restart at any time */
> -		| (timeout & AT91_WDT_WDV);  /* timer value */
> -	wdt_write(AT91_WDT_MR, reg);
> +	if (tmp & AT91_WDT_WDDIS) {
> +		if (wdt->mr & AT91_WDT_WDDIS)
> +			return 0;
> +		dev_err(wdt->wdd.parent, "watchdog is disabled\n");

Took me a while to get why you use "wdt->wdd.parent" :).
I would just have passed the 'dev' argument. Your call, though.

> +		return -EINVAL;
> +	}
> +
> +	value = tmp & AT91_WDT_WDV;
> +	delta = (tmp & AT91_WDT_WDD) >> 16;
> +
> +	if (delta < value)
> +		min_heartbeat = ticks_to_hz_roundup(value - delta);
> +
> +	wdt->heartbeat = ticks_to_hz_rounddown(value);
> +	if (!wdt->heartbeat) {
> +		dev_err(wdt->wdd.parent,
> +			"heartbeat is too small for the system to handle it correctly\n");
> +		return -EINVAL;
> +	}
> +
> +	if (wdt->heartbeat < min_heartbeat + 3) {
> +		wdt->heartbeat = min_heartbeat;
> +		dev_warn(wdt->wdd.parent,
> +			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
> +		if (wdt->heartbeat < 4)
> +			dev_warn(wdt->wdd.parent,
> +				 "heartbeat might be too small for the system to handle it correctly\n");
> +	} else
> +		wdt->heartbeat -= 4;

That means heartbeat can be 0, correct (if min_heartbeat == 1) ?
Will that work ?

> +
> +	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
> +		err = request_irq(wdt->irq, wdt_interrupt,
> +				  IRQF_SHARED | IRQF_IRQPOLL,
> +				  pdev->name, wdt);
> +		if (err)
> +			return err;
> +	}
> +
> +	if ((tmp & wdt->mr_mask) != (wdt->mr & wdt->mr_mask))
> +		dev_warn(wdt->wdd.parent,
> +			 "watchdog already configured differently (mr = %x expecting %x)\n",
> +			 tmp & wdt->mr_mask, wdt->mr & wdt->mr_mask);
> +
> +	setup_timer(&wdt->timer, at91_ping, (unsigned long)wdt);
> +	mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
> +
> +	/* Try to set timeout from device tree first */
> +	if (watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev))
> +		watchdog_init_timeout(&wdt->wdd, heartbeat, &pdev->dev);
> +	watchdog_set_nowayout(&wdt->wdd, wdt->nowayout);
> +	err = watchdog_register_device(&wdt->wdd);
> +	if (err)
> +		goto out_stop_timer;
> +
> +	wdt->next_heartbeat = jiffies + wdt->wdd.timeout * HZ;
>  
>  	return 0;
> +
> +out_stop_timer:
> +	del_timer(&wdt->timer);
> +	return err;
>  }
>  
>  /* ......................................................................... */
> @@ -167,63 +239,125 @@ static const struct watchdog_info at91_wdt_info = {
>  
>  static const struct watchdog_ops at91_wdt_ops = {
>  	.owner =	THIS_MODULE,
> -	.start =	at91_wdt_start,
> +	.start =	at91_wdt_ping,
>  	.stop =		at91_wdt_stop,
>  	.ping =		at91_wdt_ping,

Notpick, but you don't need both start and ping. If both are the same, providing
start is sufficient. Given this, it might be cleaner to name the function
at91_wdt_start and not provide ping.

>  	.set_timeout =	at91_wdt_set_timeout,
>  };
>  
> -static struct watchdog_device at91_wdt_dev = {
> -	.info =		&at91_wdt_info,
> -	.ops =		&at91_wdt_ops,
> -	.timeout =	WDT_HEARTBEAT,
> -	.min_timeout =	1,
> -	.max_timeout =	0xFFFF,
> -};
> +#if defined(CONFIG_OF)
> +static int of_at91wdt_init(struct device_node *np, struct at91wdt *wdt)
> +{
> +	u32 min = 0;
> +	u32 max = WDT_COUNTER_MAX_SECS;
> +	const char *tmp;
> +
> +	/* Get the interrupts property */
> +	wdt->irq = irq_of_parse_and_map(np, 0);
> +	if (!wdt->irq)
> +		dev_warn(wdt->wdd.parent, "failed to get IRQ from DT\n");
> +
> +	if (!of_property_read_u32_index(np, "atmel,max-heartbeat-sec", 0,
> +					&max)) {
> +		if (!max || max > WDT_COUNTER_MAX_SECS)
> +			max = WDT_COUNTER_MAX_SECS;
> +
> +		if (!of_property_read_u32_index(np, "atmel,min-heartbeat-sec",
> +						0, &min)) {
> +			if (min >= max)
> +				min = max - 1;
> +		}
> +	}
> +
> +	min = secs_to_ticks(min);
> +	max = secs_to_ticks(max);
> +
> +	wdt->mr_mask = 0x3FFFFFFF;
> +	wdt->mr = 0;
> +	if (!of_property_read_string(np, "atmel,watchdog-type", &tmp) &&
> +	    !strcmp(tmp, "software")) {
> +		wdt->mr |= AT91_WDT_WDFIEN;
> +		wdt->mr_mask &= ~AT91_WDT_WDRPROC;
> +	} else
> +		wdt->mr |= AT91_WDT_WDRSTEN;
> +
> +	if (!of_property_read_string(np, "atmel,reset-type", &tmp) &&
> +	    !strcmp(tmp, "proc"))
> +		wdt->mr |= AT91_WDT_WDRPROC;
> +
> +	if (of_property_read_bool(np, "atmel,disable")) {
> +		wdt->mr |= AT91_WDT_WDDIS;
> +		wdt->mr_mask &= AT91_WDT_WDDIS;
> +	}
> +
> +	if (of_property_read_bool(np, "atmel,idle-halt"))
> +		wdt->mr |= AT91_WDT_WDIDLEHLT;
> +
> +	if (of_property_read_bool(np, "atmel,dbg-halt"))
> +		wdt->mr |= AT91_WDT_WDDBGHLT;
> +
> +	wdt->mr |= max | ((max - min) << 16);
> +
> +	return 0;
> +}
> +#else
> +static inline int of_at91wdt_init(struct device_node *np, struct at91wdt *wdt)
> +{
> +	return 0;
> +}
> +#endif
>  
>  static int __init at91wdt_probe(struct platform_device *pdev)
>  {
>  	struct resource	*r;
> -	int res;
> +	int err;
> +	struct at91wdt *wdt;
>  
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!r)
> -		return -ENODEV;
> -	at91wdt_private.base = ioremap(r->start, resource_size(r));
> -	if (!at91wdt_private.base) {
> -		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> +	if (!wdt)
>  		return -ENOMEM;
> -	}
>  
> -	at91_wdt_dev.parent = &pdev->dev;
> -	watchdog_init_timeout(&at91_wdt_dev, heartbeat, &pdev->dev);
> -	watchdog_set_nowayout(&at91_wdt_dev, nowayout);
> +	wdt->mr = (WDT_HW_TIMEOUT * 256) | AT91_WDT_WDRSTEN | AT91_WDT_WDD |
> +		  AT91_WDT_WDDBGHLT | AT91_WDT_WDIDLEHLT;
> +	wdt->mr_mask = 0x3FFFFFFF;
> +	wdt->nowayout = nowayout;
> +	wdt->wdd.parent = &pdev->dev;
> +	wdt->wdd.info = &at91_wdt_info;
> +	wdt->wdd.ops = &at91_wdt_ops;
> +	wdt->wdd.timeout = WDT_HEARTBEAT;
> +	wdt->wdd.min_timeout = 1;
> +	wdt->wdd.max_timeout = 0xFFFF;
>  
> -	/* Set watchdog */
> -	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
> -	if (res)
> -		return res;
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	wdt->base = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(wdt->base))
> +		return PTR_ERR(wdt->base);
> +
> +	if (pdev->dev.of_node) {
> +		err = of_at91wdt_init(pdev->dev.of_node, wdt);
> +		if (err)
> +			return err;
> +	}
>  
> -	res = watchdog_register_device(&at91_wdt_dev);
> -	if (res)
> -		return res;
> +	err = at91_wdt_init(pdev, wdt);
> +	if (err)
> +		return err;
>  
> -	at91wdt_private.next_heartbeat = jiffies + at91_wdt_dev.timeout * HZ;
> -	setup_timer(&at91wdt_private.timer, at91_ping, 0);
> -	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
> +	platform_set_drvdata(pdev, wdt);
>  
>  	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
> -		at91_wdt_dev.timeout, nowayout);
> +		wdt->wdd.timeout, wdt->nowayout);
>  
>  	return 0;
>  }
>  
>  static int __exit at91wdt_remove(struct platform_device *pdev)
>  {
> -	watchdog_unregister_device(&at91_wdt_dev);
> +	struct at91wdt *wdt = platform_get_drvdata(pdev);
> +	watchdog_unregister_device(&wdt->wdd);
>  
>  	pr_warn("I quit now, hardware will probably reboot!\n");
> -	del_timer(&at91wdt_private.timer);
> +	del_timer(&wdt->timer);
>  
>  	return 0;
>  }
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
