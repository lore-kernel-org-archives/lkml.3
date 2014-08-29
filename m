Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080AbaH2Xit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 19:38:49 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17452 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbaH2Xir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 19:38:47 -0400
Date: Fri, 29 Aug 2014 16:41:29 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Subject: Re: [PATCH v2] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
Message-ID: <20140829234128.GB25668@sonymobile.com>
References: <1409354063-20289-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409354063-20289-1-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 01:14:23AM +0200, Bjorn Andersson wrote:
> From: Kumar Gala <galak@codeaurora.org>
> 
> Add driver for Qualcomm MSM Hardware Mutex block that exists on
> newer Qualcomm SoCs.
> 
> Cc: Jeffrey Hugo <jhugo@codeaurora.org>
> Cc: Eric Holmberg <eholmber@codeaurora.org>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> [bjorn: added pm_runtime calls, from Courtney,
> 	added sfpb-mutex compatible,
> 	updated DT binding documentation formatting]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
[...]
> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> index 3612cb5..2cd39e2 100644
> --- a/drivers/hwspinlock/Kconfig
> +++ b/drivers/hwspinlock/Kconfig
> @@ -8,6 +8,17 @@ config HWSPINLOCK
>  
>  menu "Hardware Spinlock drivers"
>  
> +config HWSPINLOCK_MSM
> +	tristate "MSM Hardware Spinlock device"
> +	depends on ARCH_QCOM

This should also depend on OF, as it won't compile or work without it.

> +	select HWSPINLOCK
> +	help
> +	  Say y here to support the MSM Hardware Mutex functionality, which
> +	  provides a synchronisation mechanism for the various processors on
> +	  the SoC.
> +
> +	  If unsure, say N.
> +
>  config HWSPINLOCK_OMAP
>  	tristate "OMAP Hardware Spinlock device"
>  	depends on ARCH_OMAP4 || SOC_OMAP5 || SOC_DRA7XX || SOC_AM33XX || SOC_AM43XX
[...]
> +static const struct of_device_id msm_hwspinlock_of_match[] = {
> +	{ .compatible = "qcom,sfpb-mutex", .data = (void *)0x4 },
> +	{ .compatible = "qcom,tcsr-mutex", .data = (void *)0x80 },
> +	{ },
> +};

MODULE_DEVICE_TABLE(of, msm_hwspinlock_of_match); ?

[...]
> +static struct platform_driver msm_hwspinlock_driver = {
> +	.probe		= msm_hwspinlock_probe,
> +	.remove		= msm_hwspinlock_remove,
> +	.driver		= {
> +		.name	= "msm_hwspinlock",
> +		.owner	= THIS_MODULE,

No need, as:

#define platform_driver_register(drv) \
	__platform_driver_register(drv, THIS_MODULE)
extern int __platform_driver_register(struct platform_driver *,
					struct module *);

> +		.of_match_table = msm_hwspinlock_of_match,
> +	},
> +};

Otherwise, looks fine.

-Courtney
