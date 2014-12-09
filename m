Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaLIJGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:06:40 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38954 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaLIJGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:06:35 -0500
Date: Tue, 9 Dec 2014 09:06:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com, lee.jone@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH v7 1/4] mfd: rt5033: Add Richtek RT5033 driver core.
Message-ID: <20141209090626.GU3951@x1>
References: <1417527591-20450-1-git-send-email-beomho.seo@samsung.com>
 <1417527591-20450-2-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417527591-20450-2-git-send-email-beomho.seo@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2014, Beomho Seo wrote:

> This patch adds a new driver for Richtek RT5033 driver.
> RT5033 is a Multifunction device which includes battery charger, fuel gauge,
> flash LED current source, LDO and synchronous Buck converter. It is interfaced
> to host controller using I2C interface.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jone@linaro.org>
> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Changes in v7
> - Use small description.
> - Change some names for a variable.
> - Revise of_device_id struct style.
> 
> Changes in v6
> - Fix white space issue in mfd cell struct.
> 
> Changes in v5
> - Change possible built as a module.
> - Revise rt5033_dev mfd cell entry.
> - Fix incorrect typo.
> - Add module alias.
> 
> Changes in v4
> - none.
> 
> Changes in v3
> - Correct sentence errors.
> - Add author information the top of each drivers.
> - Remove unnecessary pre-initialise, struct member(rt5033->i2c) and blink.
> - Change some return check.
> - Use bool and of_match_ptr().
> 
> Changes in v2
> - Remove volatile_reg callback. Because this driver not in use regmap cache.
> - Revmoe unnecessary subnode of_compatible.
> - Add define for set_high impedance mode of charger.
> ---
>  drivers/mfd/Kconfig                |   12 ++
>  drivers/mfd/Makefile               |    1 +
>  drivers/mfd/rt5033.c               |  141 +++++++++++++++++++
>  include/linux/mfd/rt5033-private.h |  260 ++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rt5033.h         |   62 +++++++++
>  5 files changed, 476 insertions(+)
>  create mode 100644 drivers/mfd/rt5033.c
>  create mode 100644 include/linux/mfd/rt5033-private.h
>  create mode 100644 include/linux/mfd/rt5033.h

[...]

> diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
> new file mode 100644
> index 0000000..2d2bfbe
> --- /dev/null
> +++ b/drivers/mfd/rt5033.c
> @@ -0,0 +1,141 @@
> +/*
> + * RT5033 core driver.

I asked you to write a small description of the h/w here.

Instead you've made it _less_ descriptive?

> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
> + * Author: Beomho Seo <beomho.seo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published bythe Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/rt5033.h>
> +#include <linux/mfd/rt5033-private.h>
> +
> +static const struct regmap_irq rt5033_irqs[] = {
> +	{ .mask = RT5033_PMIC_IRQ_BUCKOCP, },
> +	{ .mask = RT5033_PMIC_IRQ_BUCKLV, },
> +	{ .mask = RT5033_PMIC_IRQ_SAFELDOLV, },
> +	{ .mask = RT5033_PMIC_IRQ_LDOLV, },
> +	{ .mask = RT5033_PMIC_IRQ_OT, },
> +	{ .mask = RT5033_PMIC_IRQ_VDDA_UV, },
> +};
> +
> +static const struct regmap_irq_chip rt5033_irq_chip = {
> +	.name		= "rt5033",
> +	.status_base	= RT5033_REG_PMIC_IRQ_STAT,
> +	.mask_base	= RT5033_REG_PMIC_IRQ_CTRL,
> +	.mask_invert	= true,
> +	.num_regs	= 1,
> +	.irqs		= rt5033_irqs,
> +	.num_irqs	= ARRAY_SIZE(rt5033_irqs),
> +};
> +
> +static const struct mfd_cell rt5033_devs[] = {
> +	{ .name = "rt5033-regulator", },
> +	{
> +		.name = "rt5033-charger",
> +		.of_compatible = "richtek,rt5033-charger",
> +	}, {
> +		.name = "rt5033-battery",
> +		.of_compatible = "richtek,rt5033-battery",
> +	},
> +};
> +
> +static const struct of_device_id rt5033_dt_match[] = {
> +	{
> +		.compatible = "richtek,rt5033",
> +	},
> +	{ }
> +};

This was better as a single line entry.

I also asked you to move it down to where it's first used, instead of
way up here.  Please convert it back to one line and move the whole
structure down just above the line:

"static struct i2c_driver rt5033_driver = {"

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
