Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbaIKQJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:09:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57370 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbaIKQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:09:32 -0400
Date: Thu, 11 Sep 2014 09:09:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH] watchdog: omap_wdt: Add 'early_disable' module parameter
Message-ID: <20140911160927.GC13052@roeck-us.net>
References: <1410268057-8851-1-git-send-email-lisovy@merica.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410268057-8851-1-git-send-email-lisovy@merica.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 03:07:37PM +0200, Rostislav Lisovy wrote:
> This parameter makes it possible to control if the watchdog
> is being disabled during initialization or will stay enabled
> in case it was previously initialized in the bootloader.
> 
> To maintain the existing behavior, the default value is 'true',
> thus the watchdog is disabled during initialization.
> 
> This new feature is highly inspired by the w83627hf_wdt.c
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> ---
>  drivers/watchdog/omap_wdt.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 3691b15..8f4cabe 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -53,6 +53,10 @@ static unsigned timer_margin;
>  module_param(timer_margin, uint, 0);
>  MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
>  
> +static bool early_disable = true;
> +module_param(early_disable, bool, 0);
> +MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=1)");
> +


>  struct omap_wdt_dev {
>  	void __iomem    *base;          /* physical */
>  	struct device   *dev;
> @@ -255,7 +259,15 @@ static int omap_wdt_probe(struct platform_device *pdev)
>  	omap_wdt->bootstatus = (rs & (1 << OMAP_MPU_WD_RST_SRC_ID_SHIFT)) ?
>  				WDIOF_CARDRESET : 0;
>  
> -	omap_wdt_disable(wdev);
> +	if (early_disable) {
> +		pr_warn("Stopping previously enabled watchdog until userland kicks in\n");

This is an unconditional message which will be displayed even if the watchdog
was not running at all. Since there was previously no message, why add a
confusing one now ?

> +		omap_wdt_disable(wdev);
> +	} else {
> +		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
> +			omap_wdt->timeout);
> +		omap_wdt_set_timeout(omap_wdt, omap_wdt->timeout);
> +		omap_wdt_ping(omap_wdt);
> +	}
>  
>  	ret = watchdog_register_device(omap_wdt);
>  	if (ret) {
> @@ -267,7 +279,8 @@ static int omap_wdt_probe(struct platform_device *pdev)
>  		readl_relaxed(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
>  		omap_wdt->timeout);
>  
> -	pm_runtime_put_sync(wdev->dev);
> +	if (early_disable)
> +		pm_runtime_put_sync(wdev->dev);

Doesn't that mean that you are now leaking the device usage counter
if early_disable is 0 ?

Guenter
>  
>  	return 0;
>  }
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
