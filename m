Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaCLPfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:35:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:32856 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaCLPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:35:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pm@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for platform-bus
Date: Wed, 12 Mar 2014 16:37:19 +0100
Message-ID: <2775124.TXohNNxBKa@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1391191965-31102-1-git-send-email-balbi@ti.com>
References: <1391191965-31102-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

(CC'ing Geert Uytterhoeven as we happen to discuss runtime PM and clock 
handling for the Renesas SoCs at the moment)

Thank you for the patch. This is a bit of a late reply, but that's better than 
no reply I suppose. Please see below for a small comment.

On Friday 31 January 2014 12:12:45 Felipe Balbi wrote:
> Still TODO a commit log. Not for merging!!!!!
> 
> NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> This patch is an idea I've had recently in order to combine several
> different PM implementations into the platform-bus.
> 
> This patch is bare minimum for platforms which need to handle functional and
> interface clocks but the whole thing is made optional.
> 
> Note that this patch makes sure that by the time a platform_driver's probe
> is called, we already have clocks enabled and pm_runtime_set_active() has
> been called, thus making sure that a device driver's pm_runtime_get_sync()
> will solely increase the pm usage counter.
> 
> I have *NOT* tested this anywhere *YET*, but I suppose it shouldn't cause
> any issues since the clock API has ref counting too.
> 
> Would really like to get some review from several folks involved with ARM
> SoC PM so that's the reason for the wide audience. If I have missed
> anybody, please add them to Cc.
> 
> As mentioned above, this is *NOT* meant for merging, but serves as a
> starting point for discussing some convergence of several PM domain
> implementations on different arch/arm/mach-* directories.
> 
> For OMAP, this has the added benefit of removing clock handling from
> omap_device/omap_hwmod and, thus, dropping the need for so many DT_CLK()
> tables under drivers/clk/ti/
> 
>  drivers/base/platform.c         | 169 +++++++++++++++++++++++++++++++++++--
>  include/linux/platform_device.h |   9 +++
>  2 files changed, 173 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 3a94b79..86aeb5b 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -484,6 +484,21 @@ static int platform_drv_probe(struct device *_dev)
>  	if (ACPI_HANDLE(_dev))
>  		acpi_dev_pm_attach(_dev, true);
> 
> +	dev->fck = devm_clk_get(_dev, "fck");
> +	dev->ick = devm_clk_get(_dev, "ick");

My concern with this that some devices might want to handle their functional 
and interface clocks manually if they have exotic requirements. They would 
thus need a way to signal that the platform bus core should not try to perform 
clock management on its own.

One possible way would be to name the clocks differently for those devices, 
but we might then have a backward compatibility issue with DT.

Another concern is how to handle the DT backward compatibility for devices 
that would benefit from core management of their functional and interface 
clocks, but that currently don't name those clocks "fck" and "ick". Renaming 
those clocks in DT wouldn't be a problem for the future, but backward 
compatibility needs to be handled. Maybe platforms could provide aliases in 
that case.

> +	if (!IS_ERR(dev->fck))
> +		clk_prepare_enable(dev->fck);
> +	else
> +		dev->fck = NULL;
> +
> +	if (!IS_ERR(dev->ick))
> +		clk_prepare_enable(dev->ick);
> +	else
> +		dev->ick = NULL;
> +
> +	pm_runtime_set_active(_dev);
> +
>  	ret = drv->probe(dev);
>  	if (ret && ACPI_HANDLE(_dev))
>  		acpi_dev_pm_detach(_dev, true);
> @@ -507,6 +522,14 @@ static int platform_drv_remove(struct device *_dev)
>  	struct platform_device *dev = to_platform_device(_dev);
>  	int ret;
> 
> +	if (!IS_ERR(dev->ick))
> +		clk_disable_unprepare(dev->ick);
> +
> +	if (!IS_ERR(dev->fck))
> +		clk_disable_unprepare(dev->fck);
> +
> +	pm_runtime_set_suspended(_dev);
> +
>  	ret = drv->remove(dev);
>  	if (ACPI_HANDLE(_dev))
>  		acpi_dev_pm_detach(_dev, true);
> @@ -780,6 +803,59 @@ static int platform_legacy_resume(struct device *dev)
> 
>  #endif /* CONFIG_PM_SLEEP */
> 
> +#ifdef CONFIG_PM_RUNTIME
> +int platform_pm_runtime_suspend(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	struct platform_driver *pdrv = to_platform_driver(drv);
> +	struct platform_device *pdev = to_platform_device(dev);
> +	int ret;
> +
> +	ret = pm_generic_runtime_suspend(dev);
> +	if (ret)
> +		return ret;
> +
> +	if (!test_bit(PLATFORM_PM_RUNTIME_KEEP_ICK, &pdrv->flags))
> +		clk_disable(pdev->ick);
> +
> +	if (!test_bit(PLATFORM_PM_RUNTIME_KEEP_FCK, &pdrv->flags))
> +		clk_disable(pdev->fck);
> +
> +	return ret;
> +}
> +
> +int platform_pm_runtime_resume(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	struct platform_driver *pdrv = to_platform_driver(drv);
> +	struct platform_device *pdev = to_platform_device(dev);
> +	int ret;
> +
> +	if (!test_bit(PLATFORM_PM_RUNTIME_KEEP_ICK, &pdrv->flags)) {
> +		ret = clk_enable(pdev->ick);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (!test_bit(PLATFORM_PM_RUNTIME_KEEP_FCK, &pdrv->flags)) {
> +		ret = clk_enable(pdev->fck);
> +		if (ret) {
> +			clk_disable(pdev->ick);
> +			return ret;
> +		}
> +	}
> +
> +	ret = pm_generic_runtime_suspend(dev);
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		clk_disable(pdev->fck);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +#endif
> +
>  #ifdef CONFIG_SUSPEND
> 
>  int platform_pm_suspend(struct device *dev)
> @@ -790,6 +866,9 @@ int platform_pm_suspend(struct device *dev)
>  	if (!drv)
>  		return 0;
> 
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +
>  	if (drv->pm) {
>  		if (drv->pm->suspend)
>  			ret = drv->pm->suspend(dev);
> @@ -802,12 +881,27 @@ int platform_pm_suspend(struct device *dev)
> 
>  int platform_pm_resume(struct device *dev)
>  {
> +	struct platform_device *pdev = to_platform_device(dev);
>  	struct device_driver *drv = dev->driver;
>  	int ret = 0;
> 
>  	if (!drv)
>  		return 0;
> 
> +	ret = clk_enable(pdev->ick);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_enable(pdev->fck);
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		return ret;
> +	}
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +
>  	if (drv->pm) {
>  		if (drv->pm->resume)
>  			ret = drv->pm->resume(dev);
> @@ -815,7 +909,17 @@ int platform_pm_resume(struct device *dev)
>  		ret = platform_legacy_resume(dev);
>  	}
> 
> -	return ret;
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		clk_disable(pdev->fck);
> +		pm_runtime_disable(dev);
> +		pm_runtime_set_suspended(dev);
> +		pm_runtime_enable(dev);
> +
> +		return ret;
> +	}
> +
> +	return 0;
>  }
> 
>  #endif /* CONFIG_SUSPEND */
> @@ -830,6 +934,9 @@ int platform_pm_freeze(struct device *dev)
>  	if (!drv)
>  		return 0;
> 
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +
>  	if (drv->pm) {
>  		if (drv->pm->freeze)
>  			ret = drv->pm->freeze(dev);
> @@ -848,6 +955,20 @@ int platform_pm_thaw(struct device *dev)
>  	if (!drv)
>  		return 0;
> 
> +	ret = clk_enable(pdev->ick);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_enable(pdev->fck);
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		return ret;
> +	}
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +
>  	if (drv->pm) {
>  		if (drv->pm->thaw)
>  			ret = drv->pm->thaw(dev);
> @@ -855,7 +976,17 @@ int platform_pm_thaw(struct device *dev)
>  		ret = platform_legacy_resume(dev);
>  	}
> 
> -	return ret;
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		clk_disable(pdev->fck);
> +		pm_runtime_disable(dev);
> +		pm_runtime_set_suspended(dev);
> +		pm_runtime_enable(dev);
> +
> +		return ret;
> +	}
> +
> +	return 0;
>  }
> 
>  int platform_pm_poweroff(struct device *dev)
> @@ -866,6 +997,9 @@ int platform_pm_poweroff(struct device *dev)
>  	if (!drv)
>  		return 0;
> 
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +
>  	if (drv->pm) {
>  		if (drv->pm->poweroff)
>  			ret = drv->pm->poweroff(dev);
> @@ -884,6 +1018,20 @@ int platform_pm_restore(struct device *dev)
>  	if (!drv)
>  		return 0;
> 
> +	ret = clk_enable(pdev->ick);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_enable(pdev->fck);
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		return ret;
> +	}
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +
>  	if (drv->pm) {
>  		if (drv->pm->restore)
>  			ret = drv->pm->restore(dev);
> @@ -891,14 +1039,25 @@ int platform_pm_restore(struct device *dev)
>  		ret = platform_legacy_resume(dev);
>  	}
> 
> -	return ret;
> +	if (ret) {
> +		clk_disable(pdev->ick);
> +		clk_disable(pdev->fck);
> +		pm_runtime_disable(dev);
> +		pm_runtime_set_suspended(dev);
> +		pm_runtime_enable(dev);
> +
> +		return ret;
> +	}
> +
> +	return 0;
>  }
> 
>  #endif /* CONFIG_HIBERNATE_CALLBACKS */
> 
>  static const struct dev_pm_ops platform_dev_pm_ops = {
> -	.runtime_suspend = pm_generic_runtime_suspend,
> -	.runtime_resume = pm_generic_runtime_resume,
> +	SET_RUNTIME_PM_OPS(platform_pm_runtime_suspend,
> +			platform_pm_runtime_resume,
> +			NULL)
>  	USE_PLATFORM_PM_SLEEP_OPS
>  };
> 
> diff --git a/include/linux/platform_device.h
> b/include/linux/platform_device.h index 16f6654..91133f5 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -12,6 +12,7 @@
>  #define _PLATFORM_DEVICE_H_
> 
>  #include <linux/device.h>
> +#include <linux/clk.h>
>  #include <linux/mod_devicetable.h>
> 
>  #define PLATFORM_DEVID_NONE	(-1)
> @@ -21,6 +22,10 @@ struct mfd_cell;
> 
>  struct platform_device {
>  	const char	*name;
> +
> +	struct clk	*fck;
> +	struct clk	*ick;
> +
>  	int		id;
>  	bool		id_auto;
>  	struct device	dev;
> @@ -179,8 +184,12 @@ struct platform_driver {
>  	struct device_driver driver;
>  	const struct platform_device_id *id_table;
>  	bool prevent_deferred_probe;
> +	unsigned long flags;
>  };
> 
> +#define PLATFORM_PM_RUNTIME_KEEP_ICK	BIT(0)
> +#define PLATFORM_PM_RUNTIME_KEEP_FCK	BIT(1)
> +
>  #define to_platform_driver(drv)	(container_of((drv), struct
> platform_driver, \ driver))

-- 
Regards,

Laurent Pinchart

