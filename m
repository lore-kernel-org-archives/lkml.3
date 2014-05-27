Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaE0Pfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:35:52 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35331 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaE0Pfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:35:48 -0400
Date: Tue, 27 May 2014 16:35:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v3 1/4] mfd: intel_soc_pmic: Core driver
Message-ID: <20140527153541.GB4227@lee--X1>
References: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401163576-14872-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401163576-14872-2-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch provides the common code for the intel_soc_pmic MFD driver, such as read/write register and set up IRQ.
> 
> v2:
> - Use regmap instead of our own callbacks for read/write.
> - Add one missing EXPORT_SYMBOL.
> - Remove some duplicate code and put them into pmic_regmap_load_from_hw.
> v3:
> - Use regmap-irq. Remove our own pmic_regmap_* and IRQ handling code.
> - Remove intel_soc_pmic_dev() because gpio driver no longer uses it.
> - Remove intel_soc_pmic_set_pdata() because currently it's not used.
> - Use EXPORT_SYMBOL_GPL for exposed APIs.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
>  drivers/mfd/intel_soc_pmic_core.c  | 212 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  44 ++++++++
>  include/linux/mfd/intel_soc_pmic.h |  27 +++++
>  3 files changed, 283 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h
> 
> diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
> new file mode 100644
> index 0000000..4f95a4a
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_core.c
> @@ -0,0 +1,212 @@
> +/*
> + * intel_soc_pmic_core.c - Intel SoC PMIC Core Functions
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
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/mfd/core.h>
> +#include <linux/err.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/workqueue.h>
> +#include <linux/acpi.h>
> +#include <linux/version.h>
> +#include <linux/gpio.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include "intel_soc_pmic_core.h"
> +
> +static DEFINE_MUTEX(pmic_lock);	/* protect pmic */
> +static struct intel_soc_pmic *pmic;
> +
> +/*
> + * Read from a PMIC register
> + */
> +int intel_soc_pmic_readb(int reg)
> +{
> +	int ret;
> +	unsigned int val;
> +
> +	mutex_lock(&pmic_lock);
> +
> +	if (!pmic) {
> +		ret = -EIO;
> +	} else {
> +		ret = regmap_read(pmic->regmap, reg, &val);
> +		if (!ret)
> +			ret = val;
> +	}
> +
> +	mutex_unlock(&pmic_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_readb);
> +
> +/*
> + * Write to a PMIC register
> + */
> +int intel_soc_pmic_writeb(int reg, u8 val)
> +{
> +	int ret;
> +
> +	mutex_lock(&pmic_lock);
> +
> +	if (!pmic)
> +		ret = -EIO;
> +	else
> +		ret = regmap_write(pmic->regmap, reg, val);
> +
> +	mutex_unlock(&pmic_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_writeb);
> +
> +/*
> + * Set 1 bit in a PMIC register
> + */
> +int intel_soc_pmic_setb(int reg, u8 mask)
> +{
> +	int ret;
> +
> +	mutex_lock(&pmic_lock);
> +
> +	if (!pmic)
> +		ret = -EIO;
> +	else
> +		ret = regmap_update_bits(pmic->regmap, reg, mask, mask);
> +
> +	mutex_unlock(&pmic_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_setb);
> +
> +/*
> + * Clear 1 bit in a PMIC register
> + */
> +int intel_soc_pmic_clearb(int reg, u8 mask)
> +{
> +	int ret;
> +
> +	mutex_lock(&pmic_lock);
> +
> +	if (!pmic)
> +		ret = -EIO;
> +	else
> +		ret = regmap_update_bits(pmic->regmap, reg, mask, 0);
> +
> +	mutex_unlock(&pmic_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_clearb);
> +
> +/*
> +* Set and clear multiple bits of a PMIC register
> +*/
> +int intel_soc_pmic_update(int reg, u8 val, u8 mask)
> +{
> +	int ret;
> +	
> +	mutex_lock(&pmic_lock);
> +	
> +	if (!pmic)
> +		ret = -EIO;
> +	else
> +		ret = regmap_update_bits(pmic->regmap, reg, mask, val);
> +	
> +	mutex_unlock(&pmic_lock);
> +	
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_update);

I'm really not a fan of all these pointless agregation call-backs.  I
see them as unesersary overhead.  Just use the regmap API directly.

> +int intel_pmic_add(struct intel_soc_pmic *chip)
> +{
> +	int ret;
> +	struct intel_soc_pmic_config *cfg = chip->config;
> +
> +	mutex_lock(&pmic_lock);
> +
> +	if (pmic != NULL) {

if (pmic)

> +		mutex_unlock(&pmic_lock);
> +		return -EBUSY;
> +	}
> +
> +	pmic = chip;
> +
> +	mutex_unlock(&pmic_lock);
> +
> +	if (cfg->init) {
> +		ret = cfg->init();

All this does is invokes a dev_info() message.  Until this does
something useful, please remove it.

> +		if (ret != 0)

if (ret)

Same with all "!= 0" checks.

> +			goto err;
> +	}
> +
> +	ret = regmap_add_irq_chip(chip->regmap, chip->irq,
> +				  cfg->irq_flags | IRQF_ONESHOT,
> +				  0, cfg->irq_chip,
> +				  &chip->irq_chip_data);
> +	if (ret != 0)
> +		goto err;
> +
> +	ret = enable_irq_wake(chip->irq);
> +	if (ret != 0)
> +		dev_warn(chip->dev, "Can't enable IRQ as wake source: %d\n",
> +			 ret);
> +
> +	ret = mfd_add_devices(chip->dev, -1, cfg->cell_dev,
> +			       cfg->n_cell_devs, NULL, 0,
> +			       regmap_irq_get_domain(chip->irq_chip_data));
> +

Remove this line.

> +	if (ret)
> +		goto err_del_irq_chip;
> +
> +	return 0;
> +
> +err_del_irq_chip:
> +	regmap_del_irq_chip(chip->irq, chip->irq_chip_data);
> +err:
> +	mutex_lock(&pmic_lock);
> +	if (pmic == chip)
> +		pmic = NULL;
> +	mutex_unlock(&pmic_lock);

I don't think this locking is required here, and won't pmic == chip
always be true?

> +	return ret;
> +}
> +
> +int intel_pmic_remove(struct intel_soc_pmic *chip)
> +{
> +	mutex_lock(&pmic_lock);
> +
> +	if (pmic != chip) {
> +		mutex_unlock(&pmic_lock);
> +		return -ENODEV;
> +	}
> +
> +	pmic = NULL;
> +
> +	mutex_unlock(&pmic_lock);

I'm not sure the locks are required here either.

> +	regmap_del_irq_chip(chip->irq, chip->irq_chip_data);
> +
> +	mfd_remove_devices(chip->dev);
> +
> +	return 0;
> +}

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
