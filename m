Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaIPPt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:49:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48621 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaIPPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:49:26 -0400
Date: Tue, 16 Sep 2014 08:49:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v2] watchdog: omap_wdt: Add 'early_disable' module
 parameter
Message-ID: <20140916154921.GA14725@roeck-us.net>
References: <1410877228-20925-1-git-send-email-lisovy@merica.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410877228-20925-1-git-send-email-lisovy@merica.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 04:20:28PM +0200, Rostislav Lisovy wrote:
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
> Changes since v1:
>  * Fix Runtime PM device usage counter leaking (Guenter Roeck)
>  * Remove the unnecessary message informing about "stopping the watchdog"
>    (Guenter Roeck)
>  * Fix proper setting of "omap_wdt_users"
> 
>  drivers/watchdog/omap_wdt.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 3691b15..abf3b62 100644
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
> @@ -128,9 +132,11 @@ static int omap_wdt_start(struct watchdog_device *wdog)
>  
>  	mutex_lock(&wdev->lock);
>  
> -	wdev->omap_wdt_users = true;
> -
> -	pm_runtime_get_sync(wdev->dev);
> +	/* The watchdog was disabled in probe function */
> +	if (early_disable) {

I think this should be
	if (!wdev->omap_wdt_users) {

> +		wdev->omap_wdt_users = true;
> +		pm_runtime_get_sync(wdev->dev);
> +	}
>  
>  	/* initialize prescaler */
>  	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x01)
> @@ -218,7 +224,7 @@ static int omap_wdt_probe(struct platform_device *pdev)
>  	if (!wdev)
>  		return -ENOMEM;
>  
> -	wdev->omap_wdt_users	= false;
> +	wdev->omap_wdt_users	= (early_disable) ? false : true;

I don't immediately see what early_disable (a boot flag) has to do with 
omap_wdt_users which is supposed to show if the watchdog is running or not.
Also see below.

>  	wdev->dev		= &pdev->dev;
>  	wdev->wdt_trgr_pattern	= 0x1234;
>  	mutex_init(&wdev->lock);
> @@ -255,7 +261,14 @@ static int omap_wdt_probe(struct platform_device *pdev)
>  	omap_wdt->bootstatus = (rs & (1 << OMAP_MPU_WD_RST_SRC_ID_SHIFT)) ?
>  				WDIOF_CARDRESET : 0;
>  
> -	omap_wdt_disable(wdev);
> +	if (early_disable) {
> +		omap_wdt_disable(wdev);
> +	} else {
> +		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
> +			omap_wdt->timeout);

How do you know that the watchdog was already running ?
Seems to me you are just making an assumption that it is running
without really knowing for sure.

> +		omap_wdt_set_timeout(omap_wdt, omap_wdt->timeout);
> +		omap_wdt_ping(omap_wdt);
> +	}
>  
>  	ret = watchdog_register_device(omap_wdt);
>  	if (ret) {
> @@ -267,7 +280,8 @@ static int omap_wdt_probe(struct platform_device *pdev)
>  		readl_relaxed(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
>  		omap_wdt->timeout);
>  
> -	pm_runtime_put_sync(wdev->dev);
> +	if (early_disable)
> +		pm_runtime_put_sync(wdev->dev);

Again, I think this should be
	if (!wdev->omap_wdt_users)

and you should actually detect if the watchdog is running or not.

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
