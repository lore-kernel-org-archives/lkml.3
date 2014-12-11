Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbaLKRbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:31:14 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58461 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943AbaLKRbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:31:11 -0500
MIME-Version: 1.0
In-Reply-To: <1418285264-21763-2-git-send-email-pankaj.dubey@samsung.com>
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com> <1418285264-21763-2-git-send-email-pankaj.dubey@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 11 Dec 2014 11:30:49 -0600
Message-ID: <CAL_JsqKaf+w_D-xLCUizuTmxwT7uUHExA=qMpawQ+00G7uMcBg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] soc: samsung: add exynos chipid driver support
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 2:07 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Exynos SoCs have Chipid, for identification of product IDs
> and SoC revisions. This patch intendes to provide initialization
> code for all these functionalites.
>
> This driver usese existing binding for exnos-chipid.

s/usese/uses/
s/exnos/exynos/

>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  drivers/soc/Kconfig                    |   1 +
>  drivers/soc/Makefile                   |   1 +
>  drivers/soc/samsung/Kconfig            |  14 +++
>  drivers/soc/samsung/Makefile           |   1 +
>  drivers/soc/samsung/exynos-chipid.c    | 168 +++++++++++++++++++++++++++++++++
>  include/linux/soc/samsung/exynos-soc.h |  51 ++++++++++
>  6 files changed, 236 insertions(+)
>  create mode 100644 drivers/soc/samsung/Kconfig
>  create mode 100644 drivers/soc/samsung/Makefile
>  create mode 100644 drivers/soc/samsung/exynos-chipid.c
>  create mode 100644 include/linux/soc/samsung/exynos-soc.h
>
> diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
> index 76d6bd4..c3abfbe 100644
> --- a/drivers/soc/Kconfig
> +++ b/drivers/soc/Kconfig
> @@ -1,6 +1,7 @@
>  menu "SOC (System On Chip) specific Drivers"
>
>  source "drivers/soc/qcom/Kconfig"
> +source "drivers/soc/samsung/Kconfig"
>  source "drivers/soc/ti/Kconfig"
>  source "drivers/soc/versatile/Kconfig"
>
> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
> index 063113d..620366f 100644
> --- a/drivers/soc/Makefile
> +++ b/drivers/soc/Makefile
> @@ -3,6 +3,7 @@
>  #
>
>  obj-$(CONFIG_ARCH_QCOM)                += qcom/
> +obj-$(CONFIG_SOC_SAMSUNG)      += samsung/
>  obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>  obj-$(CONFIG_SOC_TI)           += ti/
>  obj-$(CONFIG_PLAT_VERSATILE)   += versatile/
> diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
> new file mode 100644
> index 0000000..2d83652
> --- /dev/null
> +++ b/drivers/soc/samsung/Kconfig
> @@ -0,0 +1,14 @@
> +#
> +# SAMSUNG SoC drivers
> +#
> +menu "Samsung SOC driver support"
> +
> +config SOC_SAMSUNG
> +       bool
> +
> +config EXYNOS_CHIPID
> +       bool
> +       depends on ARCH_EXYNOS
> +       select SOC_BUS

This is going to show an empty menu when ARCH_EXYNOS is not enabled.
The whole menu should probably have "if ARCH_EXYNOS" instead.

> +
> +endmenu
> diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
> new file mode 100644
> index 0000000..855ca05
> --- /dev/null
> +++ b/drivers/soc/samsung/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_EXYNOS_CHIPID)    += exynos-chipid.o
> diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
> new file mode 100644
> index 0000000..8968f83
> --- /dev/null
> +++ b/drivers/soc/samsung/exynos-chipid.c
> @@ -0,0 +1,168 @@
> +/*
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *           http://www.samsung.com/
> + *
> + * EXYNOS - CHIP ID support
> + * Author: Pankaj Dubey <pankaj.dubey@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/sys_soc.h>
> +#include <linux/soc/samsung/exynos-soc.h>
> +
> +#define EXYNOS_SUBREV_MASK     (0xF << 4)
> +#define EXYNOS_MAINREV_MASK    (0xF << 0)
> +#define EXYNOS_REV_MASK                (EXYNOS_SUBREV_MASK | EXYNOS_MAINREV_MASK)
> +
> +static void __iomem *exynos_chipid_base;
> +
> +struct exynos_chipid_info exynos_soc_info;
> +EXPORT_SYMBOL(exynos_soc_info);

The soc_device already has similar data. Why is this needed? Is it
temporary for compatibility? For early use? If for early use, then it
should not be exported.


> +
> +static const char * __init product_id_to_name(unsigned int product_id)
> +{
> +       const char *soc_name;
> +       unsigned int soc_id = product_id & EXYNOS_SOC_MASK;
> +
> +       switch (soc_id) {
> +       case EXYNOS3250_SOC_ID:
> +               soc_name = "EXYNOS3250";
> +               break;
> +       case EXYNOS4210_SOC_ID:
> +               soc_name = "EXYNOS4210";
> +               break;
> +       case EXYNOS4212_SOC_ID:
> +               soc_name = "EXYNOS4212";
> +               break;
> +       case EXYNOS4412_SOC_ID:
> +               soc_name = "EXYNOS4412";
> +               break;
> +       case EXYNOS4415_SOC_ID:
> +               soc_name = "EXYNOS4415";
> +               break;
> +       case EXYNOS5250_SOC_ID:
> +               soc_name = "EXYNOS5250";
> +               break;
> +       case EXYNOS5260_SOC_ID:
> +               soc_name = "EXYNOS5260";
> +               break;
> +       case EXYNOS5420_SOC_ID:
> +               soc_name = "EXYNOS5420";
> +               break;
> +       case EXYNOS5440_SOC_ID:
> +               soc_name = "EXYNOS5440";
> +               break;
> +       case EXYNOS5800_SOC_ID:
> +               soc_name = "EXYNOS5800";
> +               break;
> +       default:
> +               soc_name = "UNKNOWN";
> +       }
> +       return soc_name;
> +}
> +
> +static const struct of_device_id of_exynos_chipid_ids[] __initconst = {
> +       {
> +               .compatible     = "samsung,exynos4210-chipid",
> +       },
> +       {},
> +};
> +
> +/**
> + *  exynos_chipid_early_init: Early chipid initialization
> + *  @dev: pointer to chipid device
> + */
> +void __init exynos_chipid_early_init(struct device *dev)
> +{
> +       struct device_node *np;
> +       const struct of_device_id *match;
> +
> +       if (exynos_chipid_base)
> +               return;
> +
> +       if (!dev)
> +               np = of_find_matching_node_and_match(NULL,
> +                       of_exynos_chipid_ids, &match);
> +       else
> +               np = dev->of_node;
> +
> +       if (!np)
> +               panic("%s, failed to find chipid node\n", __func__);

Do you really want to halt booting here? Your console may not be up to
see the panic anyway.

> +
> +       exynos_chipid_base = of_iomap(np, 0);

Once you read the rev and product_id, do you need to keep the mapping?

> +
> +       if (!exynos_chipid_base)
> +               panic("%s: failed to map registers\n", __func__);
> +
> +       exynos_soc_info.product_id  = __raw_readl(exynos_chipid_base);
> +       exynos_soc_info.revision = exynos_soc_info.product_id & EXYNOS_REV_MASK;
> +}
> +
> +static int __init exynos_chipid_probe(struct platform_device *pdev)
> +{
> +       struct soc_device_attribute *soc_dev_attr;
> +       struct soc_device *soc_dev;
> +       struct device_node *root;
> +       int ret;
> +
> +       exynos_chipid_early_init(&pdev->dev);
> +
> +       soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
> +       if (!soc_dev_attr)
> +               return -ENODEV;
> +
> +       soc_dev_attr->family = "Samsung Exynos";
> +
> +       root = of_find_node_by_path("/");
> +       ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
> +       of_node_put(root);
> +       if (ret)
> +               goto free_soc;

Should a lack of model really be a reason to not load the soc_device?

> +
> +       soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d",
> +                                       exynos_soc_info.revision);
> +       if (!soc_dev_attr->revision)
> +               goto free_soc;
> +
> +       soc_dev_attr->soc_id = product_id_to_name(exynos_soc_info.product_id);
> +
> +       soc_dev = soc_device_register(soc_dev_attr);
> +       if (IS_ERR(soc_dev))
> +               goto free_rev;
> +
> +       soc_device_to_device(soc_dev);
> +
> +       dev_info(&pdev->dev, "Exynos: CPU[%s] CPU_REV[0x%x] Detected\n",
> +                       product_id_to_name(exynos_soc_info.product_id),
> +                       exynos_soc_info.revision);
> +       return 0;
> +free_rev:
> +       kfree(soc_dev_attr->revision);
> +free_soc:
> +       kfree(soc_dev_attr);
> +       return -EINVAL;
> +}
> +
> +static struct platform_driver exynos_chipid_driver __initdata = {
> +       .driver = {
> +               .name = "exynos-chipid",
> +               .of_match_table = of_exynos_chipid_ids,
> +       },
> +       .probe = exynos_chipid_probe,
> +};
> +
> +static int __init exynos_chipid_init(void)
> +{
> +       return platform_driver_register(&exynos_chipid_driver);
> +}
> +core_initcall(exynos_chipid_init);
> +
> diff --git a/include/linux/soc/samsung/exynos-soc.h b/include/linux/soc/samsung/exynos-soc.h
> new file mode 100644
> index 0000000..d2d9f05
> --- /dev/null
> +++ b/include/linux/soc/samsung/exynos-soc.h
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * Header for EXYNOS SoC Chipid support
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __EXYNOS_SOC_H
> +#define __EXYNOS_SOC_H
> +
> +#define EXYNOS3250_SOC_ID      0xE3472000
> +#define EXYNOS4210_SOC_ID      0x43210000
> +#define EXYNOS4212_SOC_ID      0x43220000
> +#define EXYNOS4412_SOC_ID      0xE4412000
> +#define EXYNOS4415_SOC_ID      0xE4415000
> +#define EXYNOS5250_SOC_ID      0x43520000
> +#define EXYNOS5260_SOC_ID      0xE5260000
> +#define EXYNOS5410_SOC_ID      0xE5410000
> +#define EXYNOS5420_SOC_ID      0xE5420000
> +#define EXYNOS5440_SOC_ID      0xE5440000
> +#define EXYNOS5800_SOC_ID      0xE5422000
> +
> +#define EXYNOS_SOC_MASK                0xFFFFF000
> +
> +#define EXYNOS4210_REV_0       0x0
> +#define EXYNOS4210_REV_1_0     0x10
> +#define EXYNOS4210_REV_1_1     0x11
> +
> +/**
> + * Struct exynos_chipid_info
> + * @soc_product_id: product id allocated to exynos SoC
> + * @soc_revision: revision of exynos SoC
> + */
> +
> +struct exynos_chipid_info {
> +       u32 product_id;
> +       u32 revision;
> +};

Exposing this struct kernel wide in an SOC specific way concerns me. I
would not like to see this done on every SOC family. That would become
a mess.

Rob
