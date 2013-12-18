Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3LRKgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:36:51 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45673 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3LRKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:36:46 -0500
Date: Wed, 18 Dec 2013 10:36:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: sameo@linux.intel.com, balbi@ti.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: omap-usb-tll: Don't hold lock during
 pm_runtime_get/put_sync()
Message-ID: <20131218103641.GD14274@lee--X1>
References: <1387360909-10624-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387360909-10624-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> pm_runtime_get/put_sync() can sleep so don't hold spinlock while
> calling them.
> 
> This patch prevents a BUG() when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
> Bug is present in Kernel versions v3.9 onwards.
> 
> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: <stable@vger.kernel.org> # 3.9+
> ---
>  drivers/mfd/omap-usb-tll.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
> index 0d946ae1..248004c 100644
> --- a/drivers/mfd/omap-usb-tll.c
> +++ b/drivers/mfd/omap-usb-tll.c
> @@ -346,7 +346,9 @@ int omap_tll_init(struct usbhs_omap_platform_data *pdata)
>  	for (i = 0; i < tll->nch; i++)
>  		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
>  
> +	spin_unlock(&tll_lock);
>  	pm_runtime_get_sync(tll_dev);
> +	spin_lock(&tll_lock);

This is pretty ugly. Can't you move it above the spin_lock() instead?

<snip>

>  	tll = dev_get_drvdata(tll_dev);
>  
> +	spin_unlock(&tll_lock);
>  	pm_runtime_get_sync(tll_dev);
> +	spin_lock(&tll_lock);

Same here?

>  	for (i = 0; i < tll->nch; i++) {
>  		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
> @@ -438,7 +441,6 @@ int omap_tll_enable(struct usbhs_omap_platform_data *pdata)
>  	}
>  
>  	spin_unlock(&tll_lock);
> -

This doesn't belong in this patch and is now inconsistent with the
other functions in the driver.

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(omap_tll_enable);
> @@ -464,9 +466,8 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
>  		}
>  	}
>  
> -	pm_runtime_put_sync(tll_dev);
> -
>  	spin_unlock(&tll_lock);
> +	pm_runtime_put_sync(tll_dev);
>  
>  	return 0;
>  }

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
