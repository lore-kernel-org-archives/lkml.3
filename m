Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaIZJ4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:56:52 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40573 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbaIZJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:56:49 -0400
Date: Fri, 26 Sep 2014 10:56:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, dbaryshkov@gmail.com,
        Christophe Kerello <christophe.kerello@st.com>
Subject: Re: [PATCH 1/5] power: reset: Add restart functionality for STiH41x
 platforms
Message-ID: <20140926095628.GE4097@lee--X1>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
 <1406040752-25229-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406040752-25229-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

This patch-set has been on the list for some time (2 months) now.

How would you like me to proceed?

> This driver adds the restart functionality for STiH415 and STiH416
> platforms from STMicroelectronics.  This driver registers an
> arm_pm_restart function to reset the platform.
> 
> Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/power/reset/Kconfig       |   6 ++
>  drivers/power/reset/Makefile      |   1 +
>  drivers/power/reset/st-poweroff.c | 151 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 158 insertions(+)
>  create mode 100644 drivers/power/reset/st-poweroff.c
> 
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index 003e4d4..445b330 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -58,6 +58,12 @@ config POWER_RESET_SUN6I
>  	help
>  	  Reboot support for the Allwinner A31 SoCs.
>  
> +config POWER_RESET_ST
> +	bool "ST restart power-off driver"
> +	depends on POWER_RESET && ARCH_STI
> +	help
> +	  Power off and reset support for STMicroelectronics boards.
> +
>  config POWER_RESET_VEXPRESS
>  	bool "ARM Versatile Express power-off and reset driver"
>  	depends on ARM || ARM64
> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> index dde2e8b..aaae990 100644
> --- a/drivers/power/reset/Makefile
> +++ b/drivers/power/reset/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
>  obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
>  obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
>  obj-$(CONFIG_POWER_RESET_SUN6I) += sun6i-reboot.o
> +obj-$(CONFIG_POWER_RESET_ST) += st-poweroff.o
>  obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
>  obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
>  obj-$(CONFIG_POWER_RESET_KEYSTONE) += keystone-reset.o
> diff --git a/drivers/power/reset/st-poweroff.c b/drivers/power/reset/st-poweroff.c
> new file mode 100644
> index 0000000..a0acf25
> --- /dev/null
> +++ b/drivers/power/reset/st-poweroff.c
> @@ -0,0 +1,151 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics
> + *
> + * Power off Restart driver, used in STMicroelectronics devices.
> + *
> + * Author: Christophe Kerello <christophe.kerello@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +
> +#include <asm/system_misc.h>
> +
> +struct reset_syscfg {
> +	struct regmap *regmap;
> +	/* syscfg used for reset */
> +	unsigned int offset_rst;
> +	unsigned int mask_rst;
> +	/* syscfg used for unmask the reset */
> +	unsigned int offset_rst_msk;
> +	unsigned int mask_rst_msk;
> +};
> +
> +/* STiH415 */
> +#define STIH415_SYSCFG_11	0x2c
> +#define STIH415_SYSCFG_15	0x3c
> +
> +static struct reset_syscfg stih415_reset = {
> +	.offset_rst = STIH415_SYSCFG_11,
> +	.mask_rst = BIT(0),
> +	.offset_rst_msk = STIH415_SYSCFG_15,
> +	.mask_rst_msk = BIT(0)
> +};
> +
> +/* STiH416 */
> +#define STIH416_SYSCFG_500	0x7d0
> +#define STIH416_SYSCFG_504	0x7e0
> +
> +static struct reset_syscfg stih416_reset = {
> +	.offset_rst = STIH416_SYSCFG_500,
> +	.mask_rst = BIT(0),
> +	.offset_rst_msk = STIH416_SYSCFG_504,
> +	.mask_rst_msk = BIT(0)
> +};
> +
> +/* STiH407 */
> +#define STIH407_SYSCFG_4000	0x0
> +#define STIH407_SYSCFG_4008	0x20
> +
> +static struct reset_syscfg stih407_reset = {
> +	.offset_rst = STIH407_SYSCFG_4000,
> +	.mask_rst = BIT(0),
> +	.offset_rst_msk = STIH407_SYSCFG_4008,
> +	.mask_rst_msk = BIT(0)
> +};
> +
> +/* STiD127 */
> +#define STID127_SYSCFG_700	0x0
> +#define STID127_SYSCFG_773	0x124
> +
> +static struct reset_syscfg stid127_reset = {
> +	.offset_rst = STID127_SYSCFG_773,
> +	.mask_rst = BIT(0),
> +	.offset_rst_msk = STID127_SYSCFG_700,
> +	.mask_rst_msk = BIT(8)
> +};
> +
> +static struct reset_syscfg *st_restart_syscfg;
> +
> +static void st_restart(enum reboot_mode reboot_mode, const char *cmd)
> +{
> +	/* reset syscfg updated */
> +	regmap_update_bits(st_restart_syscfg->regmap,
> +			   st_restart_syscfg->offset_rst,
> +			   st_restart_syscfg->mask_rst,
> +			   0);
> +
> +	/* unmask the reset */
> +	regmap_update_bits(st_restart_syscfg->regmap,
> +			   st_restart_syscfg->offset_rst_msk,
> +			   st_restart_syscfg->mask_rst_msk,
> +			   0);
> +}
> +
> +static struct of_device_id st_reset_of_match[] = {
> +	{
> +		.compatible = "st,stih415-restart",
> +		.data = (void *)&stih415_reset,
> +	}, {
> +		.compatible = "st,stih416-restart",
> +		.data = (void *)&stih416_reset,
> +	}, {
> +		.compatible = "st,stih407-restart",
> +		.data = (void *)&stih407_reset,
> +	}, {
> +		.compatible = "st,stid127-restart",
> +		.data = (void *)&stid127_reset,
> +	},
> +	{}
> +};
> +
> +static int st_reset_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	const struct of_device_id *match;
> +	struct device *dev = &pdev->dev;
> +
> +	match = of_match_device(st_reset_of_match, dev);
> +	if (!match)
> +		return -ENODEV;
> +
> +	st_restart_syscfg = (struct reset_syscfg *)match->data;
> +
> +	st_restart_syscfg->regmap =
> +		syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> +	if (IS_ERR(st_restart_syscfg->regmap)) {
> +		dev_err(dev, "No syscfg phandle specified\n");
> +		return PTR_ERR(st_restart_syscfg->regmap);
> +	}
> +
> +	arm_pm_restart = st_restart;
> +
> +	return 0;
> +}
> +
> +static struct platform_driver st_reset_driver = {
> +	.probe = st_reset_probe,
> +	.driver = {
> +		.name = "st_reset",
> +		.of_match_table = st_reset_of_match,
> +	},
> +};
> +
> +static int __init st_reset_init(void)
> +{
> +	return platform_driver_register(&st_reset_driver);
> +}
> +
> +device_initcall(st_reset_init);
> +
> +MODULE_AUTHOR("Christophe Kerello <christophe.kerello@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics Power off Restart driver");
> +MODULE_LICENSE("GPL v2");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
