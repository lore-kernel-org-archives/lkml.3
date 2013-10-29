Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3J2PpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:45:23 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40986 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3J2PpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:45:21 -0400
Date: Tue, 29 Oct 2013 08:45:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: at91sam9_wdt: various fixes
Message-ID: <20131029154519.GB9266@roeck-us.net>
References: <20131029075028.GF19704@spo001.leaseweb.com>
 <1383043053-3520-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383043053-3520-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:37:33AM +0100, Boris BREZILLON wrote:
> Fix the secs_to_ticks macro in case 0 is passed as an argument.
> 
> Rework the heartbeat calculation to increase the security margin of the
> watchdog reset timer.
> 
> Use the min_heartbeat value instead of the calculated heartbeat value for
> the first watchdog reset.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Hi Boris,

can you possibly split the three changes into separate patches ?

The first is a no-brainer. Gives my opinion of my code review capabilities
a slight damper ;-).

For the other two problems, it might make sense to describe
the problems you are trying to solve.

Couple of comments inline.

Thanks,
Guenter


> ---
>  drivers/watchdog/at91sam9_wdt.c |   35 ++++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index 9bd089e..f1b59f1 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -51,7 +51,7 @@
>  #define ticks_to_hz_rounddown(t)	((((t) + 1) * HZ) >> 8)
>  #define ticks_to_hz_roundup(t)		(((((t) + 1) * HZ) + 255) >> 8)
>  #define ticks_to_secs(t)		(((t) + 1) >> 8)
> -#define secs_to_ticks(s)		(((s) << 8) - 1)
> +#define secs_to_ticks(s)		(s ? (((s) << 8) - 1) : 0)
>  
	(s)

>  #define WDT_MR_RESET	0x3FFF2FFF
>  
> @@ -61,6 +61,11 @@
>  /* Watchdog max delta/value in secs */
>  #define WDT_COUNTER_MAX_SECS	ticks_to_secs(WDT_COUNTER_MAX_TICKS)
>  
> +/* Watchdog heartbeat shift used for security margin:
> + * we'll try to rshift the heartbeat value with this value to secure
> + * the watchdog reset. */
> +#define WDT_HEARTBEAT_SHIFT	2
> +
>  /* Hardware timeout in seconds */
>  #define WDT_HW_TIMEOUT 2
>  
> @@ -158,7 +163,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
>  	int err;
>  	u32 mask = wdt->mr_mask;
>  	unsigned long min_heartbeat = 1;
> +	unsigned long max_heartbeat;
>  	struct device *dev = &pdev->dev;
> +	int shift;
>  
>  	tmp = wdt_read(wdt, AT91_WDT_MR);
>  	if ((tmp & mask) != (wdt->mr & mask)) {
> @@ -181,23 +188,27 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
>  	if (delta < value)
>  		min_heartbeat = ticks_to_hz_roundup(value - delta);
>  
> -	wdt->heartbeat = ticks_to_hz_rounddown(value);
> -	if (!wdt->heartbeat) {
> +	max_heartbeat = ticks_to_hz_rounddown(value);
> +	if (!max_heartbeat) {
>  		dev_err(dev,
>  			"heartbeat is too small for the system to handle it correctly\n");
>  		return -EINVAL;
>  	}
>  
> -	if (wdt->heartbeat < min_heartbeat + 4) {
> +	for (shift = WDT_HEARTBEAT_SHIFT; shift > 0; shift--) {
> +		if ((max_heartbeat >> shift) < min_heartbeat)
> +			continue;
> +
> +		wdt->heartbeat = max_heartbeat >> shift;
> +		break;
> +	}
> +
> +	if (!shift)
>  		wdt->heartbeat = min_heartbeat;

Correct me if I am wrong, but it seems to me that

	if ((max_heartbeat >> 2) >= min_heartbeat)
		 wdt->heartbeat = max_heartbeat >> 2;
	else if ((max_heartbeat >> 1) >= min_heartbeat)
		wdt->heartbeat = max_heartbeat >> 1;
	else
		wdt->heartbeat = min_heartbeat;

would accomplish the same and be easier to understand.

However, given that, I wonder if it is really necessary to bail out above if
max_heartbeat is 0. After all, you set heartbeat to min_heartbeat anyway
in this case.

> +
> +	if (max_heartbeat < min_heartbeat + 4)
>  		dev_warn(dev,
>  			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
> -		if (wdt->heartbeat < 4)
> -			dev_warn(dev,
> -				 "heartbeat might be too small for the system to handle it correctly\n");
> -	} else {
> -		wdt->heartbeat -= 4;
> -	}
>  
>  	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
>  		err = request_irq(wdt->irq, wdt_interrupt,
> @@ -213,7 +224,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
>  			 tmp & wdt->mr_mask, wdt->mr & wdt->mr_mask);
>  
>  	setup_timer(&wdt->timer, at91_ping, (unsigned long)wdt);
> -	mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
> +	/* Use min_heartbeat the first time because the watchdog timer might
> +	 * be running for a long time when we reach this init function. */

	/*
	 * Multi-line comment style
	 *
	 * Not really sure I understand what this accomplishes. What problem
	 * are you trying to solve here ?
	 */

> +	mod_timer(&wdt->timer, jiffies + min_heartbeat);
>  
>  	/* Try to set timeout from device tree first */
>  	if (watchdog_init_timeout(&wdt->wdd, 0, dev))
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
