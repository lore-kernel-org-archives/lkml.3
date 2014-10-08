Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaJHIFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:05:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58445 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaJHIFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:05:23 -0400
Date: Wed, 8 Oct 2014 09:05:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-gpio@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 2/2] PMIC / opregion: support PMIC customized operation
 region for CrystalCove
Message-ID: <20141008080515.GC20647@lee--X1>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
 <1410229968-11638-3-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410229968-11638-3-git-send-email-aaron.lu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To all those CC'ed,

> The Baytrail-T platform firmware has defined two customized operation
> regions for PMIC chip Crystal Cove - one is for power resource handling
> and one is for thermal: sensor temperature reporting, trip point setting,
> etc. This patch adds support for them on top of the existing Crystal Cove
> PMIC driver.
> 
> The reason to split code into a separate file intel_soc_pmic_opregion.c
> is that there are more PMIC driver with ACPI operation region support
> coming and we can re-use those code. The intel_soc_pmic_opregion_data
> structure is created also for this purpose: when we need to support a
> new PMIC's operation region, we just need to fill those callbacks and
> the two register mapping tables.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  drivers/mfd/Kconfig                       |  11 +
>  drivers/mfd/Makefile                      |   1 +
>  drivers/mfd/intel_soc_pmic_crc.c          |   3 +
>  drivers/mfd/intel_soc_pmic_crc_opregion.c | 229 +++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_opregion.c     | 350 ++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_opregion.h     |  35 +++

With the influx of new same-chip devices, I think the MFD subsystem is
fast becoming overloaded.  I think all of the PMIC handling should in
fact either live in Regulators or have its own subsystem.

Let's open this up to the floor by Cc'ing some probable interested
parties.

[Leaving the driver code in, but my comments stop here]

>  6 files changed, 629 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc_opregion.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_opregion.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_opregion.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf244746..77a7229058a6 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -266,6 +266,17 @@ config INTEL_SOC_PMIC
>  	  thermal, charger and related power management functions
>  	  on these systems.
>  
> +config CRC_PMIC_OPREGION
> +	tristate "ACPI operation region support for CrystalCove PMIC"
> +	depends on ACPI
> +	depends on INTEL_SOC_PMIC
> +	help
> +	  Select this option to enable support for ACPI operation
> +	  region of the PMIC chip. The operation region can be used
> +	  to control power rails and sensor reading/writing on the
> +	  PMIC chip. This config addes ACPI operation region support
> +	  for CrystalCove PMIC.
> +
>  config MFD_INTEL_MSIC
>  	bool "Intel MSIC"
>  	depends on INTEL_SCU_IPC
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f00148782d9b..e02f0573e293 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -172,3 +172,4 @@ obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
>  
>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> +obj-$(CONFIG_CRC_PMIC_OPREGION) += intel_soc_pmic_crc_opregion.o intel_soc_pmic_opregion.o
> diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
> index 7107cab832e6..48845d636bba 100644
> --- a/drivers/mfd/intel_soc_pmic_crc.c
> +++ b/drivers/mfd/intel_soc_pmic_crc.c
> @@ -106,6 +106,9 @@ static struct mfd_cell crystal_cove_dev[] = {
>  		.num_resources = ARRAY_SIZE(gpio_resources),
>  		.resources = gpio_resources,
>  	},
> +	{
> +		.name = "crystal_cove_region",
> +	},
>  };
>  
>  static struct regmap_config crystal_cove_regmap_config = {
> diff --git a/drivers/mfd/intel_soc_pmic_crc_opregion.c b/drivers/mfd/intel_soc_pmic_crc_opregion.c
> new file mode 100644
> index 000000000000..27b67dc3fa8d
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_crc_opregion.c
> @@ -0,0 +1,229 @@
> +/*
> + * intel_soc_pmic_crc_opregion.c - Intel SoC PMIC operation region Driver
> + *
> + * Copyright (C) 2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/acpi.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include <linux/regmap.h>
> +#include <linux/platform_device.h>
> +#include "intel_soc_pmic_opregion.h"
> +
> +#define PWR_SOURCE_SELECT	BIT(1)
> +
> +#define PMIC_A0LOCK_REG		0xc5
> +
> +static struct pmic_pwr_table pwr_table[] = {
> +	{
> +		.address = 0x24,
> +		.pwr_reg = {
> +			.reg = 0x66,
> +			.bit = 0x00,
> +		},
> +	},	/* X285 -> V2P85SX, camara */
> +	{
> +		.address = 0x48,
> +		.pwr_reg = {
> +			.reg = 0x5d,
> +			.bit = 0x00,
> +		},
> +	},	/* V18X -> V1P8SX, eMMC/camara/audio */
> +};
> +
> +static struct pmic_dptf_table dptf_table[] = {
> +	{
> +		.address = 0x00,
> +		.reg = 0x75
> +	},	/* TMP0 -> SYS0_THRM_RSLT_L */
> +	{
> +		.address = 0x04,
> +		.reg = 0x95
> +	},	/* AX00 -> SYS0_THRMALRT0_L */
> +	{
> +		.address = 0x08,
> +		.reg = 0x97
> +	},	/* AX01 -> SYS0_THRMALRT1_L */
> +	{
> +		.address = 0x0c,
> +		.reg = 0x77
> +	},	/* TMP1 -> SYS1_THRM_RSLT_L */
> +	{
> +		.address = 0x10,
> +		.reg = 0x9a
> +	},	/* AX10 -> SYS1_THRMALRT0_L */
> +	{
> +		.address = 0x14,
> +		.reg = 0x9c
> +	},	/* AX11 -> SYS1_THRMALRT1_L */
> +	{
> +		.address = 0x18,
> +		.reg = 0x79
> +	},	/* TMP2 -> SYS2_THRM_RSLT_L */
> +	{
> +		.address = 0x1c,
> +		.reg = 0x9f
> +	},	/* AX20 -> SYS2_THRMALRT0_L */
> +	{
> +		.address = 0x20,
> +		.reg = 0xa1
> +	},	/* AX21 -> SYS2_THRMALRT1_L */
> +	{
> +		.address = 0x48,
> +		.reg = 0x94
> +	},	/* PEN0 -> SYS0_THRMALRT0_H */
> +	{
> +		.address = 0x4c,
> +		.reg = 0x99
> +	},	/* PEN1 -> SYS1_THRMALRT1_H */
> +	{
> +		.address = 0x50,
> +		.reg = 0x9e
> +	},	/* PEN2 -> SYS2_THRMALRT2_H */
> +};
> +
> +static int intel_crc_pmic_get_power(struct regmap *regmap,
> +				    struct pmic_pwr_reg *preg, u64 *value)
> +{
> +	int data;
> +
> +	if (regmap_read(regmap, preg->reg, &data))
> +		return -EIO;
> +
> +	*value = (data & PWR_SOURCE_SELECT) && (data & BIT(preg->bit)) ? 1 : 0;
> +	return 0;
> +}
> +
> +static int intel_crc_pmic_update_power(struct regmap *regmap,
> +				       struct pmic_pwr_reg *preg, bool on)
> +{
> +	int data;
> +
> +	if (regmap_read(regmap, preg->reg, &data))
> +		return -EIO;
> +
> +	if (on) {
> +		data |= PWR_SOURCE_SELECT | BIT(preg->bit);
> +	} else {
> +		data &= ~BIT(preg->bit);
> +		data |= PWR_SOURCE_SELECT;
> +	}
> +
> +	if (regmap_write(regmap, preg->reg, data))
> +		return -EIO;
> +	return 0;
> +}
> +
> +/* Raw temperature value is 10bits: 8bits in reg and 2bits in reg-1 bit0,1 */
> +static int intel_crc_pmic_get_raw_temp(struct regmap *regmap, int reg)
> +{
> +	int temp_l, temp_h;
> +
> +	if (regmap_read(regmap, reg, &temp_l) ||
> +	    regmap_read(regmap, reg - 1, &temp_h))
> +		return -EIO;
> +
> +	return (temp_l | ((temp_h & 0x3) << 8));
> +}
> +
> +static int
> +intel_crc_pmic_update_aux(struct regmap *regmap, int reg, int raw)
> +{
> +	if (regmap_write(regmap, reg, raw) ||
> +	    regmap_update_bits(regmap, reg - 1, 0x3, raw >> 8))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int
> +intel_crc_pmic_get_policy(struct regmap *regmap, int reg, u64 *value)
> +{
> +	int pen;
> +
> +	if (regmap_read(regmap, reg, &pen))
> +		return -EIO;
> +	*value = pen >> 7;
> +	return 0;
> +}
> +
> +static int intel_crc_pmic_update_policy(struct regmap *regmap,
> +					int reg, int enable)
> +{
> +	int alert0;
> +
> +	/* Update to policy enable bit requires unlocking a0lock */
> +	if (regmap_read(regmap, PMIC_A0LOCK_REG, &alert0))
> +		return -EIO;
> +	if (regmap_update_bits(regmap, PMIC_A0LOCK_REG, 0x01, 0))
> +		return -EIO;
> +
> +	if (regmap_update_bits(regmap, reg, 0x80, enable << 7))
> +		return -EIO;
> +
> +	/* restore alert0 */
> +	if (regmap_write(regmap, PMIC_A0LOCK_REG, alert0))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static struct intel_soc_pmic_opregion_data intel_crc_pmic_opregion_data = {
> +	.get_power	= intel_crc_pmic_get_power,
> +	.update_power	= intel_crc_pmic_update_power,
> +	.get_raw_temp	= intel_crc_pmic_get_raw_temp,
> +	.update_aux	= intel_crc_pmic_update_aux,
> +	.get_policy	= intel_crc_pmic_get_policy,
> +	.update_policy	= intel_crc_pmic_update_policy,
> +	.pwr_table	= pwr_table,
> +	.pwr_table_count= ARRAY_SIZE(pwr_table),
> +	.dptf_table	= dptf_table,
> +	.dptf_table_count = ARRAY_SIZE(dptf_table),
> +};
> +
> +static int intel_crc_pmic_opregion_probe(struct platform_device *pdev)
> +{
> +	struct intel_soc_pmic *pmic = dev_get_drvdata(pdev->dev.parent);
> +	return intel_soc_pmic_install_opregion_handler(&pdev->dev,
> +			ACPI_HANDLE(pdev->dev.parent), pmic->regmap,
> +			&intel_crc_pmic_opregion_data);
> +}
> +
> +static int intel_crc_pmic_opregion_remove(struct platform_device *pdev)
> +{
> +	intel_soc_pmic_remove_opregion_handler(ACPI_HANDLE(pdev->dev.parent));
> +	return 0;
> +}
> +
> +#define DRV_NAME "crystal_cove_region"
> +
> +static struct platform_device_id crystal_cove_opregion_id_table[] = {
> +	{ .name = DRV_NAME },
> +	{},
> +};
> +
> +static struct platform_driver intel_crc_pmic_opregion_driver = {
> +	.probe = intel_crc_pmic_opregion_probe,
> +	.remove = intel_crc_pmic_opregion_remove,
> +	.id_table = crystal_cove_opregion_id_table,
> +	.driver = {
> +		.name = DRV_NAME,
> +	},
> +};
> +
> +MODULE_DEVICE_TABLE(platform, crystal_cove_opregion_id_table);
> +
> +module_platform_driver(intel_crc_pmic_opregion_driver);
> +
> +MODULE_DESCRIPTION("CrystalCove ACPI opregion driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/intel_soc_pmic_opregion.c b/drivers/mfd/intel_soc_pmic_opregion.c
> new file mode 100644
> index 000000000000..62824a35ce97
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_opregion.c
> @@ -0,0 +1,350 @@
> +/*
> + * intel_soc_pmic_opregion.c - Intel SoC PMIC operation region Driver
> + *
> + * Copyright (C) 2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/acpi.h>
> +#include <linux/regmap.h>
> +#include "intel_soc_pmic_opregion.h"
> +
> +#define PMIC_PMOP_OPREGION_ID	0x8d
> +#define PMIC_DPTF_OPREGION_ID	0x8c
> +
> +struct acpi_lpat {
> +	int temp;
> +	int raw;
> +};
> +
> +struct intel_soc_pmic_opregion {
> +	struct mutex lock;
> +	struct acpi_lpat *lpat;
> +	int lpat_count;
> +	struct regmap *regmap;
> +	struct intel_soc_pmic_opregion_data *data;
> +};
> +
> +static struct pmic_pwr_reg *
> +pmic_get_pwr_reg(int address, struct pmic_pwr_table *table, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		if (table[i].address == address)
> +			return &table[i].pwr_reg;
> +	}
> +	return NULL;
> +}
> +
> +static int
> +pmic_get_dptf_reg(int address, struct pmic_dptf_table *table, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		if (table[i].address == address)
> +			return table[i].reg;
> +	}
> +	return -ENOENT;
> +}
> +
> +/* Return temperature from raw value through LPAT table */
> +static int raw_to_temp(struct acpi_lpat *lpat, int count, int raw)
> +{
> +	int i, delta_temp, delta_raw, temp;
> +
> +	for (i = 0; i < count - 1; i++) {
> +		if ((raw >= lpat[i].raw && raw <= lpat[i+1].raw) ||
> +		    (raw <= lpat[i].raw && raw >= lpat[i+1].raw))
> +			break;
> +	}
> +
> +	if (i == count - 1)
> +		return -ENOENT;
> +
> +	delta_temp = lpat[i+1].temp - lpat[i].temp;
> +	delta_raw = lpat[i+1].raw - lpat[i].raw;
> +	temp = lpat[i].temp + (raw - lpat[i].raw) * delta_temp / delta_raw;
> +
> +	return temp;
> +}
> +
> +/* Return raw value from temperature through LPAT table */
> +static int temp_to_raw(struct acpi_lpat *lpat, int count, int temp)
> +{
> +	int i, delta_temp, delta_raw, raw;
> +
> +	for (i = 0; i < count - 1; i++) {
> +		if (temp >= lpat[i].temp && temp <= lpat[i+1].temp)
> +			break;
> +	}
> +
> +	if (i == count - 1)
> +		return -ENOENT;
> +
> +	delta_temp = lpat[i+1].temp - lpat[i].temp;
> +	delta_raw = lpat[i+1].raw - lpat[i].raw;
> +	raw = lpat[i].raw + (temp - lpat[i].temp) * delta_raw / delta_temp;
> +
> +	return raw;
> +}
> +
> +static void
> +pmic_dptf_lpat(struct intel_soc_pmic_opregion *opregion, acpi_handle handle,
> +	       struct device *dev)
> +{
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *obj_p, *obj_e;
> +	int *lpat, i;
> +	acpi_status status;
> +
> +	status = acpi_evaluate_object(handle, "LPAT", NULL, &buffer);
> +	if (ACPI_FAILURE(status))
> +		return;
> +
> +	obj_p = (union acpi_object *)buffer.pointer;
> +	if (!obj_p || (obj_p->type != ACPI_TYPE_PACKAGE) ||
> +	    (obj_p->package.count % 2) || (obj_p->package.count < 4))
> +		goto out;
> +
> +	lpat = devm_kmalloc(dev, sizeof(*lpat) * obj_p->package.count,
> +			    GFP_KERNEL);
> +	if (!lpat)
> +		goto out;
> +
> +	for (i = 0; i < obj_p->package.count; i++) {
> +		obj_e = &obj_p->package.elements[i];
> +		if (obj_e->type != ACPI_TYPE_INTEGER)
> +			goto out;
> +		lpat[i] = obj_e->integer.value;
> +	}
> +
> +	opregion->lpat = (struct acpi_lpat *)lpat;
> +	opregion->lpat_count = obj_p->package.count / 2;
> +
> +out:
> +	kfree(buffer.pointer);
> +}
> +
> +static acpi_status
> +intel_soc_pmic_pmop_handler(u32 function, acpi_physical_address address,
> +			    u32 bits, u64 *value64,
> +			    void *handler_context, void *region_context)
> +{
> +	struct intel_soc_pmic_opregion *opregion = region_context;
> +	struct regmap *regmap = opregion->regmap;
> +	struct intel_soc_pmic_opregion_data *d = opregion->data;
> +	struct pmic_pwr_reg *preg;
> +	int result;
> +
> +	if (bits != 32 || !value64)
> +		return AE_BAD_PARAMETER;
> +
> +	if (function == ACPI_WRITE && !(*value64 == 0 || *value64 == 1))
> +		return AE_BAD_PARAMETER;
> +
> +	preg = pmic_get_pwr_reg(address, d->pwr_table, d->pwr_table_count);
> +	if (!preg)
> +		return AE_BAD_PARAMETER;
> +
> +	mutex_lock(&opregion->lock);
> +
> +	if (function == ACPI_READ)
> +		result = d->get_power(regmap, preg, value64);
> +	else
> +		result = d->update_power(regmap, preg, *value64 == 1);
> +
> +	mutex_unlock(&opregion->lock);
> +
> +	return result ? AE_ERROR : AE_OK;
> +}
> +
> +static acpi_status pmic_read_temp(struct intel_soc_pmic_opregion *opregion,
> +				  int reg, u64 *value)
> +{
> +	int raw_temp, temp;
> +
> +	if (!opregion->data->get_raw_temp)
> +		return AE_BAD_PARAMETER;
> +
> +	raw_temp = opregion->data->get_raw_temp(opregion->regmap, reg);
> +	if (raw_temp < 0)
> +		return AE_ERROR;
> +
> +	if (!opregion->lpat) {
> +		*value = raw_temp;
> +		return AE_OK;
> +	}
> +
> +	temp = raw_to_temp(opregion->lpat, opregion->lpat_count, raw_temp);
> +	if (temp < 0)
> +		return AE_ERROR;
> +
> +	*value = temp;
> +	return AE_OK;
> +}
> +
> +static acpi_status pmic_dptf_temp(struct intel_soc_pmic_opregion *opregion,
> +				  int reg, u32 function, u64 *value)
> +{
> +	if (function != ACPI_READ)
> +		return AE_BAD_PARAMETER;
> +
> +	return pmic_read_temp(opregion, reg, value);
> +}
> +
> +static acpi_status pmic_dptf_aux(struct intel_soc_pmic_opregion *opregion,
> +				 int reg, u32 function, u64 *value)
> +{
> +	int raw_temp;
> +
> +	if (function == ACPI_READ)
> +		return pmic_read_temp(opregion, reg, value);
> +
> +	if (!opregion->data->update_aux)
> +		return AE_BAD_PARAMETER;
> +
> +	if (opregion->lpat) {
> +		raw_temp = temp_to_raw(opregion->lpat, opregion->lpat_count,
> +					 *value);
> +		if (raw_temp < 0)
> +			return AE_ERROR;
> +	} else {
> +		raw_temp = *value;
> +	}
> +
> +	return opregion->data->update_aux(opregion->regmap, reg, raw_temp) ?
> +		AE_ERROR : AE_OK;
> +}
> +
> +static acpi_status pmic_dptf_pen(struct intel_soc_pmic_opregion *opregion,
> +				 int reg, u32 function, u64 *value)
> +{
> +	struct intel_soc_pmic_opregion_data *d = opregion->data;
> +	struct regmap *regmap = opregion->regmap;
> +
> +	if (!d->get_policy || !d->update_policy)
> +		return AE_BAD_PARAMETER;
> +
> +	if (function == ACPI_READ)
> +		return d->get_policy(regmap, reg, value) ? AE_ERROR : AE_OK;
> +
> +	if (*value != 0 || *value != 1)
> +		return AE_BAD_PARAMETER;
> +
> +	return d->update_policy(regmap, reg, *value) ? AE_ERROR : AE_OK;
> +}
> +
> +static bool pmic_dptf_is_temp(int address)
> +{
> +	return (address <= 0x3c) && !(address % 12);
> +}
> +
> +static bool pmic_dptf_is_aux(int address)
> +{
> +	return (address >= 4 && address <= 0x40 && !((address - 4) % 12)) ||
> +	       (address >= 8 && address <= 0x44 && !((address - 8) % 12));
> +}
> +
> +static bool pmic_dptf_is_pen(int address)
> +{
> +	return address >= 0x48 && address <= 0x5c;
> +}
> +
> +static acpi_status
> +intel_soc_pmic_dptf_handler(u32 function, acpi_physical_address address,
> +			    u32 bits, u64 *value64,
> +			    void *handler_context, void *region_context)
> +{
> +	struct intel_soc_pmic_opregion *opregion = region_context;
> +	int reg;
> +	int result;
> +
> +	if (bits != 32 || !value64)
> +		return AE_BAD_PARAMETER;
> +
> +	reg = pmic_get_dptf_reg(address, opregion->data->dptf_table,
> +				opregion->data->dptf_table_count);
> +	if (!reg)
> +		return AE_BAD_PARAMETER;
> +
> +	mutex_lock(&opregion->lock);
> +
> +	result = AE_BAD_PARAMETER;
> +	if (pmic_dptf_is_temp(address))
> +		result = pmic_dptf_temp(opregion, reg, function, value64);
> +	else if (pmic_dptf_is_aux(address))
> +		result = pmic_dptf_aux(opregion, reg, function, value64);
> +	else if (pmic_dptf_is_pen(address))
> +		result = pmic_dptf_pen(opregion, reg, function, value64);
> +
> +	mutex_unlock(&opregion->lock);
> +
> +	return result;
> +}
> +
> +int
> +intel_soc_pmic_install_opregion_handler(struct device *dev,
> +					acpi_handle handle,
> +					struct regmap *regmap,
> +					struct intel_soc_pmic_opregion_data *d)
> +{
> +	acpi_status status;
> +	struct intel_soc_pmic_opregion *opregion;
> +
> +	if (!dev || !regmap || !d)
> +		return -EINVAL;
> +
> +	if (!handle)
> +		return -ENODEV;
> +
> +	opregion = devm_kzalloc(dev, sizeof(*opregion), GFP_KERNEL);
> +	if (!opregion)
> +		return -ENOMEM;
> +
> +	mutex_init(&opregion->lock);
> +	opregion->regmap = regmap;
> +	pmic_dptf_lpat(opregion, handle, dev);
> +
> +	status = acpi_install_address_space_handler(handle,
> +						    PMIC_PMOP_OPREGION_ID,
> +						    intel_soc_pmic_pmop_handler,
> +						    NULL, opregion);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	status = acpi_install_address_space_handler(handle,
> +						    PMIC_DPTF_OPREGION_ID,
> +						    intel_soc_pmic_dptf_handler,
> +						    NULL, opregion);
> +	if (ACPI_FAILURE(status)) {
> +		acpi_remove_address_space_handler(handle, PMIC_PMOP_OPREGION_ID,
> +						  intel_soc_pmic_pmop_handler);
> +		return -ENODEV;
> +	}
> +
> +	opregion->data = d;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_install_opregion_handler);
> +
> +void intel_soc_pmic_remove_opregion_handler(acpi_handle handle)
> +{
> +	acpi_remove_address_space_handler(handle, PMIC_PMOP_OPREGION_ID,
> +					  intel_soc_pmic_pmop_handler);
> +	acpi_remove_address_space_handler(handle, PMIC_DPTF_OPREGION_ID,
> +					  intel_soc_pmic_dptf_handler);
> +}
> +EXPORT_SYMBOL_GPL(intel_soc_pmic_remove_opregion_handler);
> +
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/intel_soc_pmic_opregion.h b/drivers/mfd/intel_soc_pmic_opregion.h
> new file mode 100644
> index 000000000000..752ec3d2bcbb
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_opregion.h
> @@ -0,0 +1,35 @@
> +#ifndef __INTEL_SOC_PMIC_OPREGION_H
> +#define __INTEL_SOC_PMIC_OPREGION_H
> +
> +struct pmic_pwr_reg {
> +	int reg;	/* corresponding PMIC register */
> +	int bit;	/* control bit for power */
> +};
> +
> +struct pmic_pwr_table {
> +	int address;	/* operation region address */
> +	struct pmic_pwr_reg pwr_reg;
> +};
> +
> +struct pmic_dptf_table {
> +	int address;	/* operation region address */
> +	int reg;	/* corresponding thermal register */
> +};
> +
> +struct intel_soc_pmic_opregion_data {
> +	int (*get_power)(struct regmap *r, struct pmic_pwr_reg *preg, u64 *value);
> +	int (*update_power)(struct regmap *r, struct pmic_pwr_reg *preg, bool on);
> +	int (*get_raw_temp)(struct regmap *r, int reg);
> +	int (*update_aux)(struct regmap *r, int reg, int raw_temp);
> +	int (*get_policy)(struct regmap *r, int reg, u64 *value);
> +	int (*update_policy)(struct regmap *r, int reg, int enable);
> +	struct pmic_pwr_table *pwr_table;
> +	int pwr_table_count;
> +	struct pmic_dptf_table *dptf_table;
> +	int dptf_table_count;
> +};
> +
> +int intel_soc_pmic_install_opregion_handler(struct device *dev, acpi_handle handle, struct regmap *regmap, struct intel_soc_pmic_opregion_data *d);
> +void intel_soc_pmic_remove_opregion_handler(acpi_handle handle);
> +
> +#endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
