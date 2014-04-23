Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaDWKvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:51:05 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:43944 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaDWKvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:51:01 -0400
Date: Wed, 23 Apr 2014 11:50:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140423105055.GI21613@lee--X1>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Josh Cartwright <joshc@codeaurora.org>
> 
> The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> 800 series SoC family.  This driver exists largely as a glue mfd component,
> it exists to be an owner of an SPMI regmap for children devices
> described in device tree.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> ---
>  drivers/mfd/Kconfig  | 13 +++++++++++
>  drivers/mfd/Makefile |  1 +
>  drivers/mfd/pm8x41.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 77 insertions(+)
>  create mode 100644 drivers/mfd/pm8x41.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3383412..f5ff799 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -502,6 +502,19 @@ config MFD_PM8921_CORE
>  	  Say M here if you want to include support for PM8921 chip as a module.
>  	  This will build a module called "pm8921-core".
>  
> +config MFD_PM8X41
> +	bool "Qualcomm PM8x41 PMIC"
> +	depends on ARCH_QCOM

depends on OF?

> +	select REGMAP_SPMI
> +	help
> +	  This enables basic support for the Qualcomm 8941 and 8841 PMICs.
> +	  These PMICs are currently used with the Snapdragon 800 series of
> +	  SoCs.  Note, that this will only be useful paired with descriptions
> +	  of the independent functions as children nodes in the device tree.
> +
> +	  Say M here if you want to include support for the PM8x41 series as a
> +	  module.  The module will be called "pm8x41".
> +
>  config MFD_RDC321X
>  	tristate "RDC R-321x southbridge"
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 2851275..f0df41d 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -151,6 +151,7 @@ obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
>  obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
>  obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
>  obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
> +obj-$(CONFIG_MFD_PM8X41)	+= pm8x41.o
>  obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
>  obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
>  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
> diff --git a/drivers/mfd/pm8x41.c b/drivers/mfd/pm8x41.c
> new file mode 100644
> index 0000000..c85e0d6
> --- /dev/null
> +++ b/drivers/mfd/pm8x41.c
> @@ -0,0 +1,63 @@
> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spmi.h>
> +#include <linux/regmap.h>
> +#include <linux/of_platform.h>
> +
> +static const struct regmap_config pm8x41_regmap_config = {
> +	.reg_bits	= 16,
> +	.val_bits	= 8,
> +	.max_register	= 0xFFFF,

I've never seen this many registers registered before.

Are you sure you want to regmap the entire bank?

> +};
> +
> +static int pm8x41_remove_child(struct device *dev, void *unused)
> +{
> +	platform_device_unregister(to_platform_device(dev));
> +	return 0;
> +}
> +
> +static void pm8x41_remove(struct spmi_device *sdev)
> +{
> +	device_for_each_child(&sdev->dev, NULL, pm8x41_remove_child);
> +}

Nit: It's strange to see the .remove above the .probe.

> +static int pm8x41_probe(struct spmi_device *sdev)
> +{
> +	struct regmap *regmap;
> +
> +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_dbg(&sdev->dev, "regmap creation failed.\n");

This is not debug, it's an error.

> +		return PTR_ERR(regmap);
> +	}
> +
> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> +}
> +
> +static const struct of_device_id pm8x41_id_table[] = {
> +	{ .compatible = "qcom,pm8841", },
> +	{ .compatible = "qcom,pm8941", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pm8x41_id_table);
> +
> +static struct spmi_driver pm8x41_driver = {
> +	.probe	= pm8x41_probe,
> +	.remove	= pm8x41_remove,
> +	.driver	= {
> +		.name		= "pm8x41",
> +		.of_match_table	= pm8x41_id_table,

of_match_ptr()

> +	},
> +};
> +module_spmi_driver(pm8x41_driver);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
