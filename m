Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaFQPEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:04:31 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50367 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbaFQPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:04:29 -0400
Date: Tue, 17 Jun 2014 16:04:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, broonie@kernel.org, sameo@linux.intel.com,
        mika.westerberg@linux.intel.com, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com
Subject: Re: [PATCH v5 1/3] mfd: intel_soc_pmic: Core driver
Message-ID: <20140617150422.GI29841@lee--X1>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401773164-30326-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401773164-30326-2-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch provides the common I2C driver code for Intel SoC PMICs.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
> v2:
> - Use regmap instead of creating our own I2C read/write callbacks.
> - Add one missing EXPORT_SYMBOL.
> - Remove duplicate code and put them into pmic_regmap_load_from_hw.
> v3:
> - Use regmap-irq. Remove our own pmic_regmap_* and IRQ handling code.
> - Remove intel_soc_pmic_dev() and intel_soc_pmic_set_pdata().
> - Use EXPORT_SYMBOL_GPL for exposed APIs.
> - Use gpiod interface instead of gpio numbers.
> - Remove redundant I2C IDs.
> - Use managed allocations.
> v4:
> - Remove all exported APIs which are wrappers of regmap API, export
>   the regmap in data structure instead.
> - Combine I2C and core .c files.
> - Clean up include files.
> - Use intel_soc_pmic_ prefix to replace pmic_ and intel_pmic_.
> - Fix various coding style issues.
> v5:
> - Add comment to describe what is done in _find_gpio_irq().
> - Remove i2c id. Only keep ACPI id and match it in _probe().
> - Further fix of coding style issues.
> ---
>  drivers/mfd/intel_soc_pmic_core.c  | 168 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  32 +++++++
>  include/linux/mfd/intel_soc_pmic.h |  30 +++++++
>  3 files changed, 230 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h

Applied, thanks.

> diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
> new file mode 100644
> index 0000000..7638b34
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_core.c
> @@ -0,0 +1,168 @@
> +/*
> + * intel_soc_pmic_core.c - Intel SoC PMIC MFD Driver
> + *
> + * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Author: Yang, Bin <bin.yang@intel.com>
> + * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mfd/core.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/acpi.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include "intel_soc_pmic_core.h"
> +
> +/*
> + * On some boards the PMIC interrupt may come from a GPIO line.
> + * Try to lookup the ACPI table and see if such connection exists. If not,
> + * return -ENOENT and use the IRQ provided by I2C.
> + */
> +static int intel_soc_pmic_find_gpio_irq(struct device *dev)
> +{
> +	struct gpio_desc *desc;
> +	int irq;
> +
> +	desc = devm_gpiod_get_index(dev, "intel_soc_pmic", 0);
> +	if (IS_ERR(desc))
> +		return -ENOENT;
> +
> +	irq = gpiod_to_irq(desc);
> +	if (irq < 0)
> +		dev_warn(dev, "Can't get irq: %d\n", irq);
> +
> +	return irq;
> +}
> +
> +static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
> +				    const struct i2c_device_id *i2c_id)
> +{
> +	struct device *dev = &i2c->dev;
> +	const struct acpi_device_id *id;
> +	struct intel_soc_pmic_config *config;
> +	struct intel_soc_pmic *pmic;
> +	int ret;
> +	int irq;
> +
> +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +	if (!id || !id->driver_data)
> +		return -ENODEV;
> +
> +	config = (struct intel_soc_pmic_config *)id->driver_data;
> +
> +	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
> +	dev_set_drvdata(dev, pmic);
> +
> +	pmic->regmap = devm_regmap_init_i2c(i2c, config->regmap_config);
> +
> +	irq = intel_soc_pmic_find_gpio_irq(dev);
> +	pmic->irq = (irq < 0) ? i2c->irq : irq;
> +
> +	ret = regmap_add_irq_chip(pmic->regmap, pmic->irq,
> +				  config->irq_flags | IRQF_ONESHOT,
> +				  0, config->irq_chip,
> +				  &pmic->irq_chip_data);
> +	if (ret)
> +		return ret;
> +
> +	ret = enable_irq_wake(pmic->irq);
> +	if (ret)
> +		dev_warn(dev, "Can't enable IRQ as wake source: %d\n", ret);
> +
> +	ret = mfd_add_devices(dev, -1, config->cell_dev,
> +			      config->n_cell_devs, NULL, 0,
> +			      regmap_irq_get_domain(pmic->irq_chip_data));
> +	if (ret)
> +		goto err_del_irq_chip;
> +
> +	return 0;
> +
> +err_del_irq_chip:
> +	regmap_del_irq_chip(pmic->irq, pmic->irq_chip_data);
> +	return ret;
> +}
> +
> +static int intel_soc_pmic_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct intel_soc_pmic *pmic = dev_get_drvdata(&i2c->dev);
> +
> +	regmap_del_irq_chip(pmic->irq, pmic->irq_chip_data);
> +
> +	mfd_remove_devices(&i2c->dev);
> +
> +	return 0;
> +}
> +
> +static void intel_soc_pmic_shutdown(struct i2c_client *i2c)
> +{
> +	struct intel_soc_pmic *pmic = dev_get_drvdata(&i2c->dev);
> +
> +	disable_irq(pmic->irq);
> +
> +	return;
> +}
> +
> +static int intel_soc_pmic_suspend(struct device *dev)
> +{
> +	struct intel_soc_pmic *pmic = dev_get_drvdata(dev);
> +
> +	disable_irq(pmic->irq);
> +
> +	return 0;
> +}
> +
> +static int intel_soc_pmic_resume(struct device *dev)
> +{
> +	struct intel_soc_pmic *pmic = dev_get_drvdata(dev);
> +
> +	enable_irq(pmic->irq);
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(intel_soc_pmic_pm_ops, intel_soc_pmic_suspend,
> +			 intel_soc_pmic_resume);
> +
> +static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
> +
> +static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
> +	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);
> +
> +static struct i2c_driver intel_soc_pmic_i2c_driver = {
> +	.driver = {
> +		.name = "intel_soc_pmic_i2c",
> +		.owner = THIS_MODULE,
> +		.pm = &intel_soc_pmic_pm_ops,
> +		.acpi_match_table = ACPI_PTR(intel_soc_pmic_acpi_match),
> +	},
> +	.probe = intel_soc_pmic_i2c_probe,
> +	.remove = intel_soc_pmic_i2c_remove,
> +	.id_table = intel_soc_pmic_i2c_id,
> +	.shutdown = intel_soc_pmic_shutdown,
> +};
> +
> +module_i2c_driver(intel_soc_pmic_i2c_driver);
> +
> +MODULE_DESCRIPTION("I2C driver for Intel SoC PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
> +MODULE_AUTHOR("Zhu, Lejun <lejun.zhu@linux.intel.com>");
> diff --git a/drivers/mfd/intel_soc_pmic_core.h b/drivers/mfd/intel_soc_pmic_core.h
> new file mode 100644
> index 0000000..33aacd9
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_core.h
> @@ -0,0 +1,32 @@
> +/*
> + * intel_soc_pmic_core.h - Intel SoC PMIC MFD Driver
> + *
> + * Copyright (C) 2012-2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Author: Yang, Bin <bin.yang@intel.com>
> + * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
> + */
> +
> +#ifndef __INTEL_SOC_PMIC_CORE_H__
> +#define __INTEL_SOC_PMIC_CORE_H__
> +
> +struct intel_soc_pmic_config {
> +	unsigned long irq_flags;
> +	struct mfd_cell *cell_dev;
> +	int n_cell_devs;
> +	struct regmap_config *regmap_config;
> +	struct regmap_irq_chip *irq_chip;
> +};
> +
> +extern struct intel_soc_pmic_config intel_soc_pmic_config_crc;
> +
> +#endif	/* __INTEL_SOC_PMIC_CORE_H__ */
> diff --git a/include/linux/mfd/intel_soc_pmic.h b/include/linux/mfd/intel_soc_pmic.h
> new file mode 100644
> index 0000000..abcbfcf
> --- /dev/null
> +++ b/include/linux/mfd/intel_soc_pmic.h
> @@ -0,0 +1,30 @@
> +/*
> + * intel_soc_pmic.h - Intel SoC PMIC Driver
> + *
> + * Copyright (C) 2012-2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Author: Yang, Bin <bin.yang@intel.com>
> + * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
> + */
> +
> +#ifndef __INTEL_SOC_PMIC_H__
> +#define __INTEL_SOC_PMIC_H__
> +
> +#include <linux/regmap.h>
> +
> +struct intel_soc_pmic {
> +	int irq;
> +	struct regmap *regmap;
> +	struct regmap_irq_chip_data *irq_chip_data;
> +};
> +
> +#endif	/* __INTEL_SOC_PMIC_H__ */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
