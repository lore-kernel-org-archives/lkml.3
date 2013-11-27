Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3K0MTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:19:17 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:43954 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3K0MTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:19:14 -0500
Date: Wed, 27 Nov 2013 12:19:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl-core: Clean up module by removing twl603x pdata
 handling
Message-ID: <20131127121908.GE3296@lee--X1>
References: <1385036008-1727-1-git-send-email-ruslan.ruslichenko@globallogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385036008-1727-1-git-send-email-ruslan.ruslichenko@globallogic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Ruslan Ruslichenko wrote:

> Since currently nobody uses TWL603x platform data and all new

Hmm... when you say nobody, how did you come to this conclusion?

Without digging into it and probably not that relevant, it
appears there is some references to it in platform data still:

$ git grep twl603 -- arch/ | grep -v dts
arch/arm/mach-omap2/common.h:extern int omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers);
arch/arm/mach-omap2/omap4-common.c:static int omap4_twl6030_hsmmc_late_init(struct device *dev)
arch/arm/mach-omap2/omap4-common.c:		irq = twl6030_mmc_card_detect_config();
arch/arm/mach-omap2/omap4-common.c:		pdata->slots[0].card_detect = twl6030_mmc_card_detect;
arch/arm/mach-omap2/omap4-common.c:static __init void omap4_twl6030_hsmmc_set_late_init(struct device *dev)
arch/arm/mach-omap2/omap4-common.c:	pdata->init =	omap4_twl6030_hsmmc_late_init;
arch/arm/mach-omap2/omap4-common.c:int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
arch/arm/mach-omap2/omap4-common.c:		omap4_twl6030_hsmmc_set_late_init(&c->pdev->dev);
arch/arm/mach-omap2/omap4-common.c:int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
arch/arm/mach-omap2/omap_twl.c:static unsigned long twl6030_vsel_to_uv(const u8 vsel)
arch/arm/mach-omap2/omap_twl.c:static u8 twl6030_uv_to_vsel(unsigned long uv)
arch/arm/mach-omap2/omap_twl.c:	if (uv > twl6030_vsel_to_uv(0x39)) {
arch/arm/mach-omap2/omap_twl.c:			__func__, uv, twl6030_vsel_to_uv(0x39));
arch/arm/mach-omap2/omap_twl.c:	.vsel_to_uv		= twl6030_vsel_to_uv,
arch/arm/mach-omap2/omap_twl.c:	.uv_to_vsel		= twl6030_uv_to_vsel,
arch/arm/mach-omap2/omap_twl.c:	.vsel_to_uv		= twl6030_vsel_to_uv,
arch/arm/mach-omap2/omap_twl.c:	.uv_to_vsel		= twl6030_uv_to_vsel,
arch/arm/mach-omap2/omap_twl.c:	.vsel_to_uv		= twl6030_vsel_to_uv,
arch/arm/mach-omap2/omap_twl.c:	.uv_to_vsel		= twl6030_uv_to_vsel,

> users will supply it through device tree, handling of these
> data within twl-core will never be used, so remove it.
> 
> Signed-off-by: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>
> ---
> 
> Tested on TI SDP/Tablet OMAP4460 board
> Based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> commit 5e01dc7 Linux 3.12
> 
>  drivers/mfd/twl-core.c | 198 -------------------------------------------------
>  1 file changed, 198 deletions(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 29473c2..c3c28b9 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -701,62 +701,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
>  			usb3v1[0].dev_name = dev_name(child);
>  		}
>  	}
> -	if (IS_ENABLED(CONFIG_TWL6030_USB) && pdata->usb &&
> -	    twl_class_is_6030()) {
> -
> -		static struct regulator_consumer_supply usb3v3;
> -		int regulator;
> -
> -		if (IS_ENABLED(CONFIG_REGULATOR_TWL4030)) {
> -			/* this is a template that gets copied */
> -			struct regulator_init_data usb_fixed = {
> -				.constraints.valid_modes_mask =
> -					REGULATOR_MODE_NORMAL
> -					| REGULATOR_MODE_STANDBY,
> -				.constraints.valid_ops_mask =
> -					REGULATOR_CHANGE_MODE
> -					| REGULATOR_CHANGE_STATUS,
> -			};
> -
> -			if (features & TWL6032_SUBCLASS) {
> -				usb3v3.supply =	"ldousb";
> -				regulator = TWL6032_REG_LDOUSB;
> -			} else {
> -				usb3v3.supply = "vusb";
> -				regulator = TWL6030_REG_VUSB;
> -			}
> -			child = add_regulator_linked(regulator, &usb_fixed,
> -							&usb3v3, 1,
> -							features);
> -			if (IS_ERR(child))
> -				return PTR_ERR(child);
> -		}
> -
> -		pdata->usb->features = features;
> -
> -		child = add_child(TWL_MODULE_USB, "twl6030_usb",
> -			pdata->usb, sizeof(*pdata->usb), true,
> -			/* irq1 = VBUS_PRES, irq0 = USB ID */
> -			irq_base + USBOTG_INTR_OFFSET,
> -			irq_base + USB_PRES_INTR_OFFSET);
> -
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -		/* we need to connect regulators to this transceiver */
> -		if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && child)
> -			usb3v3.dev_name = dev_name(child);
> -	} else if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) &&
> -		   twl_class_is_6030()) {
> -		if (features & TWL6032_SUBCLASS)
> -			child = add_regulator(TWL6032_REG_LDOUSB,
> -						pdata->ldousb, features);
> -		else
> -			child = add_regulator(TWL6030_REG_VUSB,
> -						pdata->vusb, features);
> -
> -			if (IS_ERR(child))
> -					return PTR_ERR(child);
> -	}
>  
>  	if (IS_ENABLED(CONFIG_TWL4030_WATCHDOG) && twl_class_is_4030()) {
>  		child = add_child(TWL_MODULE_PM_RECEIVER, "twl4030_wdt", NULL,
> @@ -870,148 +814,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
>  			return PTR_ERR(child);
>  	}
>  
> -	/* twl6030 regulators */
> -	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_6030() &&
> -			!(features & TWL6032_SUBCLASS)) {
> -		child = add_regulator(TWL6030_REG_VDD1, pdata->vdd1,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VDD2, pdata->vdd2,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VDD3, pdata->vdd3,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_V1V8, pdata->v1v8,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_V2V1, pdata->v2v1,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VMMC, pdata->vmmc,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VPP, pdata->vpp,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VUSIM, pdata->vusim,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VCXIO, pdata->vcxio,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VDAC, pdata->vdac,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VAUX1_6030, pdata->vaux1,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VAUX2_6030, pdata->vaux2,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_VAUX3_6030, pdata->vaux3,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6030_REG_CLK32KG, pdata->clk32kg,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -	}
> -
> -	/* 6030 and 6025 share this regulator */
> -	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_6030()) {
> -		child = add_regulator(TWL6030_REG_VANA, pdata->vana,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -	}
> -
> -	/* twl6032 regulators */
> -	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_6030() &&
> -			(features & TWL6032_SUBCLASS)) {
> -		child = add_regulator(TWL6032_REG_LDO5, pdata->ldo5,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDO1, pdata->ldo1,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDO7, pdata->ldo7,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDO6, pdata->ldo6,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDOLN, pdata->ldoln,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDO2, pdata->ldo2,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDO4, pdata->ldo4,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_LDO3, pdata->ldo3,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_SMPS3, pdata->smps3,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_SMPS4, pdata->smps4,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -		child = add_regulator(TWL6032_REG_VIO, pdata->vio6025,
> -					features);
> -		if (IS_ERR(child))
> -			return PTR_ERR(child);
> -
> -	}
> -
>  	if (IS_ENABLED(CONFIG_CHARGER_TWL4030) && pdata->bci &&
>  			!(features & (TPS_SUBSET | TWL5031))) {
>  		child = add_child(TWL_MODULE_MAIN_CHARGE, "twl4030_bci",

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
