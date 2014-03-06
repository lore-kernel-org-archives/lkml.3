Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaCFKkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:40:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34840 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaCFKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:40:10 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-94-5318508844cb
Message-id: <1394102406.25853.4.camel@AMDC1943>
Subject: Re: [PATCH v3 Resend 2/3] regulator: Add support for S2MPA01 regulator
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org
Date: Thu, 06 Mar 2014 11:40:06 +0100
In-reply-to: <1394100057-32677-2-git-send-email-sachin.kamat@linaro.org>
References: <1394100057-32677-1-git-send-email-sachin.kamat@linaro.org>
 <1394100057-32677-2-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xq7odARLBBv37uSzufz3KaHF51xw2
	i5N/ehkdmD3uXNvD5vF5k1wAUxSXTUpqTmZZapG+XQJXxomWH6wFjVIVS6+uZGxgvCHaxcjB
	ISFgInHwenwXIyeQKSZx4d56ti5GLg4hgaWMEju+P2CEcD4zSly40MwE0sAroC/x4nwyiCks
	4C/RuK8QpJdNwFhi8/IlbCC2iICWxMvu5UwgNrOAmcT75gYWkHIWAVWJlp5akDCngIfEnjsv
	WCCmtzJKNM/7zghRry4xad4iZoh7lCR2t3eyQ8TlJTaveQsW5xUQlPgx+R7LBEaBWUhaZiEp
	m4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkND8uoNx6TGrQ4wCHIxKPLwb/MSD
	hVgTy4orcw8xSnAwK4nwbjGUCBbiTUmsrEotyo8vKs1JLT7EyMTBKdXAWL5J+Haa8/cLVbMd
	7c49Ol71Q43z+um1k4Sm3ugw3KwbrXxCjeXsbhGbvVMLuwVlw+NniRb8MVz27rtOxrGFcx97
	VXecFtC6ue/R05dXU3zTF6ULW6yedl3w1uHTv8oUQyW2RLup2tV4aiaWc2yoXWaSMbtz+dct
	SjHFpVMUfb2OP3XMuKgersRSnJFoqMVcVJwIAMBFvMUrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 15:30 +0530, Sachin Kamat wrote:
> Add support for S2MPA01 voltage and current regulator.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/Kconfig   |    7 +
>  drivers/regulator/Makefile  |    1 +
>  drivers/regulator/s2mpa01.c |  483 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 491 insertions(+)
>  create mode 100644 drivers/regulator/s2mpa01.c
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 4ddfb6c065c7..5b08ea927870 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -425,6 +425,13 @@ config REGULATOR_RC5T583
>  	  through regulator interface. The device supports multiple DCDC/LDO
>  	  outputs which can be controlled by i2c communication.
>  
> +config REGULATOR_S2MPA01
> +	tristate "Samsung S2MPA01 voltage regulator"
> +	depends on MFD_SEC_CORE
> +	help
> +	 This driver controls Samsung S2MPA01 voltage output regulator
> +	 via I2C bus. S2MPA01 has 10 Bucks and 26 LDO outputs.
> +
>  config REGULATOR_S2MPS11
>  	tristate "Samsung S2MPS11 voltage regulator"
>  	depends on MFD_SEC_CORE
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index c624dbcdcc76..2d14f7580304 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -58,6 +58,7 @@ obj-$(CONFIG_REGULATOR_PBIAS) += pbias-regulator.o
>  obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
>  obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
>  obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
> +obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
>  obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
>  obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
>  obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
> diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> new file mode 100644
> index 000000000000..6ac6e8205a05
> --- /dev/null
> +++ b/drivers/regulator/s2mpa01.c
> @@ -0,0 +1,483 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
> + *		http://www.samsung.com
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/regmap.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +#include <linux/regulator/of_regulator.h>
> +#include <linux/mfd/samsung/core.h>
> +#include <linux/mfd/samsung/s2mpa01.h>
> +
> +#define S2MPA01_REGULATOR_CNT ARRAY_SIZE(regulators)
> +
> +struct s2mpa01_info {
> +	struct regulator_dev *rdev[S2MPA01_REGULATOR_MAX];

Hi,

It seems that s2mpa01_info->rdev is not used anywhere, except as return
value of devm_regulator_register. I think you can remove it completely.

Beside that, can this driver be merged into existing s2mps11 regulator
driver?

Best regards,
Krzysztof



