Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaLHIqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:46:40 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:47733 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaLHIqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:46:37 -0500
Date: Mon, 8 Dec 2014 08:46:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>
Subject: Re: [PATCH v3 2/8] mfd: MT6397: Add support for PMIC MT6397 MFD
Message-ID: <20141208084629.GB3951@x1>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
 <1417752479-4749-3-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417752479-4749-3-git-send-email-flora.fu@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2014, Flora Fu wrote:

> Add core files for MT6397 MFD driver.
> 
> Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> ---
>  drivers/mfd/Kconfig                  |  10 +
>  drivers/mfd/Makefile                 |   1 +
>  drivers/mfd/mt6397-core.c            |  87 +++++++++
>  include/linux/mfd/mt6397/core.h      |  23 +++
>  include/linux/mfd/mt6397/registers.h | 362 +++++++++++++++++++++++++++++++++++
>  5 files changed, 483 insertions(+)
>  create mode 100644 drivers/mfd/mt6397-core.c
>  create mode 100644 include/linux/mfd/mt6397/core.h
>  create mode 100644 include/linux/mfd/mt6397/registers.h

[...]

> +++ b/drivers/mfd/mt6397-core.c
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Flora Fu <flora.fu@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/mt6397/core.h>
> +#include <linux/soc/mediatek/mtk-pmic-wrap.h>
> +
> +static const struct mfd_cell mt6397_devs[] = {
> +	{ .name = "mt6397-rtc" },
> +	{
> +		.name = "mt6397-regulator",
> +		.of_compatible = "mediatek,mt6397-regulator",
> +	},
> +	{
> +		.name = "mt6397-codec",
> +		.of_compatible = "mediatek,mt6397-codec",
> +	},
> +};
> +
> +static int mt6397_probe(struct platform_device *pdev)
> +{
> +	u32 ret;
> +	struct mt6397_chip *mt6397;
> +	struct pmic_wrapper *wrp;
> +
> +	/* mt6397 MFD is child device of soc pmic wrapper. */
> +	if (!pdev->dev.parent)
> +		return -ENODEV;
> +
> +	wrp = dev_get_drvdata(pdev->dev.parent);

You're _still_ not checking the return value prior to dereferencing.

> +	mt6397 = devm_kzalloc(&pdev->dev, sizeof(*mt6397), GFP_KERNEL);
> +	if (!mt6397)
> +		return -ENOMEM;
> +
> +	mt6397->dev = &pdev->dev;
> +	mt6397->regmap = wrp->regmap;

> +	platform_set_drvdata(pdev, mt6397);
> +
> +	ret = mfd_add_devices(&pdev->dev, -1, &mt6397_devs[0],

Just mt6397_devs here.

> +			ARRAY_SIZE(mt6397_devs), NULL, 0, NULL);
> +	if (ret)
> +		dev_err(&pdev->dev, "failed to add child devices: %d\n", ret);

There is no point in printing ret.  The kernel will do that for you.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
