Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaIXJNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:13:05 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57494 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaIXJM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:12:57 -0400
Date: Wed, 24 Sep 2014 10:12:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH v4 1/3] mfd: add support for Qualcomm SPMI PMICs
Message-ID: <20140924091250.GK17801@lee--X1>
References: <1406903450-27283-1-git-send-email-svarbanov@mm-sol.com>
 <1406903450-27283-2-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406903450-27283-2-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2014, Stanimir Varbanov wrote:
> From: Josh Cartwright <joshc@codeaurora.org>
> 
> The Qualcomm SPMI PMIC chips are components used with the
> Snapdragon 800 series SoC family.  This driver exists
> largely as a glue mfd component, it exists to be an owner
> of an SPMI regmap for children devices described in
> device tree.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/Kconfig          |   15 +++++++++
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/qcom-spmi-pmic.c |   67 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 83 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/qcom-spmi-pmic.c

Applied, thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 6cc4b6a..abfe12a 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -524,6 +524,21 @@ config MFD_PM8921_CORE
>  	  Say M here if you want to include support for PM8921 chip as a module.
>  	  This will build a module called "pm8921-core".
>  
> +config MFD_SPMI_PMIC
> +	tristate "Qualcomm SPMI PMICs"
> +	depends on ARCH_QCOM || COMPILE_TEST
> +	depends on OF
> +	depends on SPMI
> +	select REGMAP_SPMI
> +	help
> +	  This enables support for the Qualcomm SPMI PMICs.
> +	  These PMICs are currently used with the Snapdragon 800 series of
> +	  SoCs.  Note, that this will only be useful paired with descriptions
> +	  of the independent functions as children nodes in the device tree.
> +
> +	  Say M here if you want to include support for the SPMI PMIC
> +	  series as a module.  The module will be called "qcom-spmi-pmic".
> +
>  config MFD_RDC321X
>  	tristate "RDC R-321x southbridge"
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8afedba..0e7f32e 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -153,6 +153,7 @@ obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
>  obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
>  obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
>  obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
> +obj-$(CONFIG_MFD_SPMI_PMIC)	+= qcom-spmi-pmic.o
>  obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
>  obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
>  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
> diff --git a/drivers/mfd/qcom-spmi-pmic.c b/drivers/mfd/qcom-spmi-pmic.c
> new file mode 100644
> index 0000000..4b8beb2
> --- /dev/null
> +++ b/drivers/mfd/qcom-spmi-pmic.c
> @@ -0,0 +1,67 @@
> +/*
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
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
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spmi.h>
> +#include <linux/regmap.h>
> +#include <linux/of_platform.h>
> +
> +static const struct regmap_config spmi_regmap_config = {
> +	.reg_bits	= 16,
> +	.val_bits	= 8,
> +	.max_register	= 0xffff,
> +	.fast_io	= true,
> +};
> +
> +static int pmic_spmi_probe(struct spmi_device *sdev)
> +{
> +	struct device_node *root = sdev->dev.of_node;
> +	struct regmap *regmap;
> +
> +	regmap = devm_regmap_init_spmi_ext(sdev, &spmi_regmap_config);
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
> +	return of_platform_populate(root, NULL, NULL, &sdev->dev);
> +}
> +
> +static void pmic_spmi_remove(struct spmi_device *sdev)
> +{
> +	of_platform_depopulate(&sdev->dev);
> +}
> +
> +static const struct of_device_id pmic_spmi_id_table[] = {
> +	{ .compatible = "qcom,spmi-pmic" },
> +	{ .compatible = "qcom,pm8941" },
> +	{ .compatible = "qcom,pm8841" },
> +	{ .compatible = "qcom,pma8084" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pmic_spmi_id_table);
> +
> +static struct spmi_driver pmic_spmi_driver = {
> +	.probe = pmic_spmi_probe,
> +	.remove = pmic_spmi_remove,
> +	.driver = {
> +		.name = "pmic-spmi",
> +		.of_match_table = pmic_spmi_id_table,
> +	},
> +};
> +module_spmi_driver(pmic_spmi_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm SPMI PMIC driver");
> +MODULE_ALIAS("spmi:spmi-pmic");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Josh Cartwright <joshc@codeaurora.org>");
> +MODULE_AUTHOR("Stanimir Varbanov <svarbanov@mm-sol.com>");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
