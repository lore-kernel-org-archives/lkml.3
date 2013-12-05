Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3LETDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:03:48 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26305 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3LETDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:03:47 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hljt2Z3MYIKkK4sJONBj8
Date: Thu, 5 Dec 2013 11:03:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>, Joel F <joelf@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: add fail hook for runtime_pm
 when bad data is detected
Message-ID: <20131205190343.GI26766@atomide.com>
References: <1386121153-32351-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386121153-32351-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [131203 17:40]:
> Due to the cross dependencies between hwmod for automanaged device
> information for OMAP and dts node definitions, we can run into scenarios
> where the dts node is defined, however it's hwmod entry is yet to be
> added. In these cases:
> a) omap_device does not register a pm_domain (since it cannot find
>    hwmod entry).
> b) driver does not know about (a), does a pm_runtime_get_sync which
>    never fails
> c) It then tries to do some operation on the device (such as read the
>   revision register (as part of probe) without clock or adequate OMAP
>   generic PM operation performed for enabling the module.
> 
> This causes a crash such as that reported in:
> https://bugzilla.kernel.org/show_bug.cgi?id=66441
> 
> When 'ti,hwmod' is provided in dt node, it is expected that the device
> will not function without the OMAP's power automanagement. Hence, when
> we hit a fail condition (due to hwmod entries not present or other
> similar scenario), fail at pm_domain level due to lack of data, provide
> enough information for it to be fixed, however, it allows for the driver
> to take appropriate measures to prevent crash.

Kevin, any comments on this one?

Regards,

Tony
 
> Reported-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  arch/arm/mach-omap2/omap_device.c |   24 ++++++++++++++++++++++++
>  arch/arm/mach-omap2/omap_device.h |    1 +
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index 53f0735..e0a398c 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -183,6 +183,10 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
>  odbfd_exit1:
>  	kfree(hwmods);
>  odbfd_exit:
> +	/* if data/we are at fault.. load up a fail handler */
> +	if (ret)
> +		pdev->dev.pm_domain = &omap_device_fail_pm_domain;
> +
>  	return ret;
>  }
>  
> @@ -604,6 +608,19 @@ static int _od_runtime_resume(struct device *dev)
>  
>  	return pm_generic_runtime_resume(dev);
>  }
> +
> +static int _od_fail_runtime_suspend(struct device *dev)
> +{
> +	dev_warn(dev, "%s: FIXME: missing hwmod/omap_dev info\n", __func__);
> +	return -ENODEV;
> +}
> +
> +static int _od_fail_runtime_resume(struct device *dev)
> +{
> +	dev_warn(dev, "%s: FIXME: missing hwmod/omap_dev info\n", __func__);
> +	return -ENODEV;
> +}
> +
>  #endif
>  
>  #ifdef CONFIG_SUSPEND
> @@ -657,6 +674,13 @@ static int _od_resume_noirq(struct device *dev)
>  #define _od_resume_noirq NULL
>  #endif
>  
> +struct dev_pm_domain omap_device_fail_pm_domain = {
> +	.ops = {
> +		SET_RUNTIME_PM_OPS(_od_fail_runtime_suspend,
> +				   _od_fail_runtime_resume, NULL)
> +	}
> +};
> +
>  struct dev_pm_domain omap_device_pm_domain = {
>  	.ops = {
>  		SET_RUNTIME_PM_OPS(_od_runtime_suspend, _od_runtime_resume,
> diff --git a/arch/arm/mach-omap2/omap_device.h b/arch/arm/mach-omap2/omap_device.h
> index 17ca1ae..78c02b3 100644
> --- a/arch/arm/mach-omap2/omap_device.h
> +++ b/arch/arm/mach-omap2/omap_device.h
> @@ -29,6 +29,7 @@
>  #include "omap_hwmod.h"
>  
>  extern struct dev_pm_domain omap_device_pm_domain;
> +extern struct dev_pm_domain omap_device_fail_pm_domain;
>  
>  /* omap_device._state values */
>  #define OMAP_DEVICE_STATE_UNKNOWN	0
> -- 
> 1.7.9.5
> 
