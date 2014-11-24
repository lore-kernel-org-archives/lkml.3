Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaKXJWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:22:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:62074 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaKXJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:22:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,447,1413270000"; 
   d="scan'208";a="642455974"
Message-ID: <5472F8B2.6070608@intel.com>
Date: Mon, 24 Nov 2014 17:21:54 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3 updated] ACPI / PMIC: support PMIC operation region
 for CrystalCove
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com> <1416553911-22990-2-git-send-email-aaron.lu@intel.com> <1648486.v4se7VimfK@vostro.rjw.lan>
In-Reply-To: <1648486.v4se7VimfK@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:59 AM, Rafael J. Wysocki wrote:
> On Friday, November 21, 2014 03:11:49 PM Aaron Lu wrote:
>> The Baytrail-T platform firmware has defined two customized operation
>> regions for PMIC chip Crystal Cove - one is for power resource handling
>> and one is for thermal: sensor temperature reporting, trip point setting,
>> etc. This patch adds support for them on top of the existing Crystal Cove
>> PMIC driver.
>>
>> The reason to split code into a separate file intel_pmic.c is that there
>> are more PMIC drivers with ACPI operation region support coming and we can
>> re-use those code. The intel_pmic_opregion_data structure is created also
>> for this purpose: when we need to support a new PMIC's operation region,
>> we just need to fill those callbacks and the two register mapping tables.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> Acked-by: Lee Jones <lee.jones@linaro.org> for the MFD part
> 
> Thanks for resending, looks better to me.
> 
> Some nitpicking below.

Updated patch here:

From: Aaron Lu <aaron.lu@intel.com>
Date: Mon, 20 Oct 2014 16:38:37 +0800
Subject: [PATCH 1/3] ACPI / PMIC: support PMIC operation region for
 CrystalCove

The Baytrail-T platform firmware has defined two customized operation
regions for PMIC chip Crystal Cove - one is for power resource handling
and one is for thermal: sensor temperature reporting, trip point setting,
etc. This patch adds support for them on top of the existing Crystal Cove
PMIC driver.

The reason to split code into a separate file intel_pmic.c is that there
are more PMIC drivers with ACPI operation region support coming and we can
re-use those code. The intel_pmic_opregion_data structure is created also
for this purpose: when we need to support a new PMIC's operation region,
we just need to fill those callbacks and the two register mapping tables.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Lee Jones <lee.jones@linaro.org> for the MFD part
---
 drivers/acpi/Kconfig               |  17 ++
 drivers/acpi/Makefile              |   3 +
 drivers/acpi/pmic/intel_pmic.c     | 354 +++++++++++++++++++++++++++++++++++++
 drivers/acpi/pmic/intel_pmic.h     |  25 +++
 drivers/acpi/pmic/intel_pmic_crc.c | 211 ++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_crc.c   |   3 +
 6 files changed, 613 insertions(+)
 create mode 100644 drivers/acpi/pmic/intel_pmic.c
 create mode 100644 drivers/acpi/pmic/intel_pmic.h
 create mode 100644 drivers/acpi/pmic/intel_pmic_crc.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 79078b8f5697..3e5f2056f946 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -393,4 +393,21 @@ config ACPI_EXTLOG
 	  driver adds support for that functionality with corresponding
 	  tracepoint which carries that information to userspace.
 
+menuconfig PMIC_OPREGION
+	bool "PMIC (Power Management Integrated Circuit) operation region support"
+	help
+	  Select this option to enable support for ACPI operation
+	  region of the PMIC chip. The operation region can be used
+	  to control power rails and sensor reading/writing on the
+	  PMIC chip.
+
+if PMIC_OPREGION
+config CRC_PMIC_OPREGION
+	bool "ACPI operation region support for CrystalCove PMIC"
+	depends on INTEL_SOC_PMIC
+	help
+	  This config adds ACPI operation region support for CrystalCove PMIC.
+
+endif
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 6d11522f0e48..f5938399ac14 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -88,3 +88,6 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 obj-$(CONFIG_ACPI_APEI)		+= apei/
 
 obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
+
+obj-$(CONFIG_PMIC_OPREGION)	+= pmic/intel_pmic.o
+obj-$(CONFIG_CRC_PMIC_OPREGION) += pmic/intel_pmic_crc.o
diff --git a/drivers/acpi/pmic/intel_pmic.c b/drivers/acpi/pmic/intel_pmic.c
new file mode 100644
index 000000000000..8da794664c7f
--- /dev/null
+++ b/drivers/acpi/pmic/intel_pmic.c
@@ -0,0 +1,354 @@
+/*
+ * intel_pmic.c - Intel PMIC operation region driver
+ *
+ * Copyright (C) 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/regmap.h>
+#include "intel_pmic.h"
+
+#define PMIC_POWER_OPREGION_ID		0x8d
+#define PMIC_THERMAL_OPREGION_ID	0x8c
+
+struct acpi_lpat {
+	int temp;
+	int raw;
+};
+
+struct intel_pmic_opregion {
+	struct mutex lock;
+	struct acpi_lpat *lpat;
+	int lpat_count;
+	struct regmap *regmap;
+	struct intel_pmic_opregion_data *data;
+};
+
+static int pmic_get_reg_bit(int address, struct pmic_table *table,
+			    int count, int *reg, int *bit)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (table[i].address == address) {
+			*reg = table[i].reg;
+			if (bit)
+				*bit = table[i].bit;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+/**
+ * raw_to_temp(): Return temperature from raw value through LPAT table
+ *
+ * @lpat: the temperature_raw mapping table
+ * @count: the count of the above mapping table
+ * @raw: the raw value, used as a key to get the temerature from the
+ *       above mapping table
+ *
+ * A positive value will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+static int raw_to_temp(struct acpi_lpat *lpat, int count, int raw)
+{
+	int i, delta_temp, delta_raw, temp;
+
+	for (i = 0; i < count - 1; i++) {
+		if ((raw >= lpat[i].raw && raw <= lpat[i+1].raw) ||
+		    (raw <= lpat[i].raw && raw >= lpat[i+1].raw))
+			break;
+	}
+
+	if (i == count - 1)
+		return -ENOENT;
+
+	delta_temp = lpat[i+1].temp - lpat[i].temp;
+	delta_raw = lpat[i+1].raw - lpat[i].raw;
+	temp = lpat[i].temp + (raw - lpat[i].raw) * delta_temp / delta_raw;
+
+	return temp;
+}
+
+/**
+ * temp_to_raw(): Return raw value from temperature through LPAT table
+ *
+ * @lpat: the temperature_raw mapping table
+ * @count: the count of the above mapping table
+ * @temp: the temperature, used as a key to get the raw value from the
+ *        above mapping table
+ *
+ * A positive value will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+static int temp_to_raw(struct acpi_lpat *lpat, int count, int temp)
+{
+	int i, delta_temp, delta_raw, raw;
+
+	for (i = 0; i < count - 1; i++) {
+		if (temp >= lpat[i].temp && temp <= lpat[i+1].temp)
+			break;
+	}
+
+	if (i == count - 1)
+		return -ENOENT;
+
+	delta_temp = lpat[i+1].temp - lpat[i].temp;
+	delta_raw = lpat[i+1].raw - lpat[i].raw;
+	raw = lpat[i].raw + (temp - lpat[i].temp) * delta_raw / delta_temp;
+
+	return raw;
+}
+
+static void pmic_thermal_lpat(struct intel_pmic_opregion *opregion,
+			      acpi_handle handle, struct device *dev)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj_p, *obj_e;
+	int *lpat, i;
+	acpi_status status;
+
+	status = acpi_evaluate_object(handle, "LPAT", NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return;
+
+	obj_p = (union acpi_object *)buffer.pointer;
+	if (!obj_p || (obj_p->type != ACPI_TYPE_PACKAGE) ||
+	    (obj_p->package.count % 2) || (obj_p->package.count < 4))
+		goto out;
+
+	lpat = devm_kmalloc(dev, sizeof(int) * obj_p->package.count,
+			    GFP_KERNEL);
+	if (!lpat)
+		goto out;
+
+	for (i = 0; i < obj_p->package.count; i++) {
+		obj_e = &obj_p->package.elements[i];
+		if (obj_e->type != ACPI_TYPE_INTEGER) {
+			devm_kfree(dev, lpat);
+			goto out;
+		}
+		lpat[i] = (s64)obj_e->integer.value;
+	}
+
+	opregion->lpat = (struct acpi_lpat *)lpat;
+	opregion->lpat_count = obj_p->package.count / 2;
+
+out:
+	kfree(buffer.pointer);
+}
+
+static acpi_status intel_pmic_power_handler(u32 function,
+		acpi_physical_address address, u32 bits, u64 *value64,
+		void *handler_context, void *region_context)
+{
+	struct intel_pmic_opregion *opregion = region_context;
+	struct regmap *regmap = opregion->regmap;
+	struct intel_pmic_opregion_data *d = opregion->data;
+	int reg, bit, result;
+
+	if (bits != 32 || !value64)
+		return AE_BAD_PARAMETER;
+
+	if (function == ACPI_WRITE && !(*value64 == 0 || *value64 == 1))
+		return AE_BAD_PARAMETER;
+
+	result = pmic_get_reg_bit(address, d->power_table,
+				  d->power_table_count, &reg, &bit);
+	if (result == -ENOENT)
+		return AE_BAD_PARAMETER;
+
+	mutex_lock(&opregion->lock);
+
+	result = function == ACPI_READ ?
+		d->get_power(regmap, reg, bit, value64) :
+		d->update_power(regmap, reg, bit, *value64 == 1);
+
+	mutex_unlock(&opregion->lock);
+
+	return result ? AE_ERROR : AE_OK;
+}
+
+static int pmic_read_temp(struct intel_pmic_opregion *opregion,
+			  int reg, u64 *value)
+{
+	int raw_temp, temp;
+
+	if (!opregion->data->get_raw_temp)
+		return -ENXIO;
+
+	raw_temp = opregion->data->get_raw_temp(opregion->regmap, reg);
+	if (raw_temp < 0)
+		return raw_temp;
+
+	if (!opregion->lpat) {
+		*value = raw_temp;
+		return 0;
+	}
+
+	temp = raw_to_temp(opregion->lpat, opregion->lpat_count, raw_temp);
+	if (temp < 0)
+		return temp;
+
+	*value = temp;
+	return 0;
+}
+
+static int pmic_thermal_temp(struct intel_pmic_opregion *opregion, int reg,
+			     u32 function, u64 *value)
+{
+	return function == ACPI_READ ?
+		pmic_read_temp(opregion, reg, value) : -EINVAL;
+}
+
+static int pmic_thermal_aux(struct intel_pmic_opregion *opregion, int reg,
+			    u32 function, u64 *value)
+{
+	int raw_temp;
+
+	if (function == ACPI_READ)
+		return pmic_read_temp(opregion, reg, value);
+
+	if (!opregion->data->update_aux)
+		return -ENXIO;
+
+	if (opregion->lpat) {
+		raw_temp = temp_to_raw(opregion->lpat, opregion->lpat_count,
+				       *value);
+		if (raw_temp < 0)
+			return raw_temp;
+	} else {
+		raw_temp = *value;
+	}
+
+	return opregion->data->update_aux(opregion->regmap, reg, raw_temp);
+}
+
+static int pmic_thermal_pen(struct intel_pmic_opregion *opregion, int reg,
+			    u32 function, u64 *value)
+{
+	struct intel_pmic_opregion_data *d = opregion->data;
+	struct regmap *regmap = opregion->regmap;
+
+	if (!d->get_policy || !d->update_policy)
+		return -ENXIO;
+
+	if (function == ACPI_READ)
+		return d->get_policy(regmap, reg, value);
+
+	if (*value != 0 || *value != 1)
+		return -EINVAL;
+
+	return d->update_policy(regmap, reg, *value);
+}
+
+static bool pmic_thermal_is_temp(int address)
+{
+	return (address <= 0x3c) && !(address % 12);
+}
+
+static bool pmic_thermal_is_aux(int address)
+{
+	return (address >= 4 && address <= 0x40 && !((address - 4) % 12)) ||
+	       (address >= 8 && address <= 0x44 && !((address - 8) % 12));
+}
+
+static bool pmic_thermal_is_pen(int address)
+{
+	return address >= 0x48 && address <= 0x5c;
+}
+
+static acpi_status intel_pmic_thermal_handler(u32 function,
+		acpi_physical_address address, u32 bits, u64 *value64,
+		void *handler_context, void *region_context)
+{
+	struct intel_pmic_opregion *opregion = region_context;
+	struct intel_pmic_opregion_data *d = opregion->data;
+	int reg, result;
+
+	if (bits != 32 || !value64)
+		return AE_BAD_PARAMETER;
+
+	result = pmic_get_reg_bit(address, d->thermal_table,
+				  d->thermal_table_count, &reg, NULL);
+	if (result == -ENOENT)
+		return AE_BAD_PARAMETER;
+
+	mutex_lock(&opregion->lock);
+
+	if (pmic_thermal_is_temp(address))
+		result = pmic_thermal_temp(opregion, reg, function, value64);
+	else if (pmic_thermal_is_aux(address))
+		result = pmic_thermal_aux(opregion, reg, function, value64);
+	else if (pmic_thermal_is_pen(address))
+		result = pmic_thermal_pen(opregion, reg, function, value64);
+	else
+		result = -EINVAL;
+
+	mutex_unlock(&opregion->lock);
+
+	if (result < 0) {
+		if (result == -EINVAL)
+			return AE_BAD_PARAMETER;
+		else
+			return AE_ERROR;
+	}
+
+	return AE_OK;
+}
+
+int intel_pmic_install_opregion_handler(struct device *dev, acpi_handle handle,
+					struct regmap *regmap,
+					struct intel_pmic_opregion_data *d)
+{
+	acpi_status status;
+	struct intel_pmic_opregion *opregion;
+
+	if (!dev || !regmap || !d)
+		return -EINVAL;
+
+	if (!handle)
+		return -ENODEV;
+
+	opregion = devm_kzalloc(dev, sizeof(*opregion), GFP_KERNEL);
+	if (!opregion)
+		return -ENOMEM;
+
+	mutex_init(&opregion->lock);
+	opregion->regmap = regmap;
+	pmic_thermal_lpat(opregion, handle, dev);
+
+	status = acpi_install_address_space_handler(handle,
+						    PMIC_POWER_OPREGION_ID,
+						    intel_pmic_power_handler,
+						    NULL, opregion);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	status = acpi_install_address_space_handler(handle,
+						    PMIC_THERMAL_OPREGION_ID,
+						    intel_pmic_thermal_handler,
+						    NULL, opregion);
+	if (ACPI_FAILURE(status)) {
+		acpi_remove_address_space_handler(handle, PMIC_POWER_OPREGION_ID,
+						  intel_pmic_power_handler);
+		return -ENODEV;
+	}
+
+	opregion->data = d;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(intel_pmic_install_opregion_handler);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/acpi/pmic/intel_pmic.h b/drivers/acpi/pmic/intel_pmic.h
new file mode 100644
index 000000000000..d4e90af8f0dd
--- /dev/null
+++ b/drivers/acpi/pmic/intel_pmic.h
@@ -0,0 +1,25 @@
+#ifndef __INTEL_PMIC_H
+#define __INTEL_PMIC_H
+
+struct pmic_table {
+	int address;	/* operation region address */
+	int reg;	/* corresponding thermal register */
+	int bit;	/* control bit for power */
+};
+
+struct intel_pmic_opregion_data {
+	int (*get_power)(struct regmap *r, int reg, int bit, u64 *value);
+	int (*update_power)(struct regmap *r, int reg, int bit, bool on);
+	int (*get_raw_temp)(struct regmap *r, int reg);
+	int (*update_aux)(struct regmap *r, int reg, int raw_temp);
+	int (*get_policy)(struct regmap *r, int reg, u64 *value);
+	int (*update_policy)(struct regmap *r, int reg, int enable);
+	struct pmic_table *power_table;
+	int power_table_count;
+	struct pmic_table *thermal_table;
+	int thermal_table_count;
+};
+
+int intel_pmic_install_opregion_handler(struct device *dev, acpi_handle handle, struct regmap *regmap, struct intel_pmic_opregion_data *d);
+
+#endif
diff --git a/drivers/acpi/pmic/intel_pmic_crc.c b/drivers/acpi/pmic/intel_pmic_crc.c
new file mode 100644
index 000000000000..8955e5b41195
--- /dev/null
+++ b/drivers/acpi/pmic/intel_pmic_crc.c
@@ -0,0 +1,211 @@
+/*
+ * intel_pmic_crc.c - Intel CrystalCove PMIC operation region driver
+ *
+ * Copyright (C) 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/mfd/intel_soc_pmic.h>
+#include <linux/regmap.h>
+#include <linux/platform_device.h>
+#include "intel_pmic.h"
+
+#define PWR_SOURCE_SELECT	BIT(1)
+
+#define PMIC_A0LOCK_REG		0xc5
+
+static struct pmic_table power_table[] = {
+	{
+		.address = 0x24,
+		.reg = 0x66,
+		.bit = 0x00,
+	},
+	{
+		.address = 0x48,
+		.reg = 0x5d,
+		.bit = 0x00,
+	},
+};
+
+static struct pmic_table thermal_table[] = {
+	{
+		.address = 0x00,
+		.reg = 0x75
+	},
+	{
+		.address = 0x04,
+		.reg = 0x95
+	},
+	{
+		.address = 0x08,
+		.reg = 0x97
+	},
+	{
+		.address = 0x0c,
+		.reg = 0x77
+	},
+	{
+		.address = 0x10,
+		.reg = 0x9a
+	},
+	{
+		.address = 0x14,
+		.reg = 0x9c
+	},
+	{
+		.address = 0x18,
+		.reg = 0x79
+	},
+	{
+		.address = 0x1c,
+		.reg = 0x9f
+	},
+	{
+		.address = 0x20,
+		.reg = 0xa1
+	},
+	{
+		.address = 0x48,
+		.reg = 0x94
+	},
+	{
+		.address = 0x4c,
+		.reg = 0x99
+	},
+	{
+		.address = 0x50,
+		.reg = 0x9e
+	},
+};
+
+static int intel_crc_pmic_get_power(struct regmap *regmap, int reg,
+				    int bit, u64 *value)
+{
+	int data;
+
+	if (regmap_read(regmap, reg, &data))
+		return -EIO;
+
+	*value = (data & PWR_SOURCE_SELECT) && (data & BIT(bit)) ? 1 : 0;
+	return 0;
+}
+
+static int intel_crc_pmic_update_power(struct regmap *regmap, int reg,
+				       int bit, bool on)
+{
+	int data;
+
+	if (regmap_read(regmap, reg, &data))
+		return -EIO;
+
+	if (on) {
+		data |= PWR_SOURCE_SELECT | BIT(bit);
+	} else {
+		data &= ~BIT(bit);
+		data |= PWR_SOURCE_SELECT;
+	}
+
+	if (regmap_write(regmap, reg, data))
+		return -EIO;
+	return 0;
+}
+
+static int intel_crc_pmic_get_raw_temp(struct regmap *regmap, int reg)
+{
+	int temp_l, temp_h;
+
+	/*
+	 * Raw temperature value is 10bits: 8bits in reg
+	 * and 2bits in reg-1: bit0,1
+	 */
+	if (regmap_read(regmap, reg, &temp_l) ||
+	    regmap_read(regmap, reg - 1, &temp_h))
+		return -EIO;
+
+	return temp_l | (temp_h & 0x3) << 8;
+}
+
+static int intel_crc_pmic_update_aux(struct regmap *regmap, int reg, int raw)
+{
+	return regmap_write(regmap, reg, raw) ||
+		regmap_update_bits(regmap, reg - 1, 0x3, raw >> 8) ? -EIO : 0;
+}
+
+static int intel_crc_pmic_get_policy(struct regmap *regmap, int reg, u64 *value)
+{
+	int pen;
+
+	if (regmap_read(regmap, reg, &pen))
+		return -EIO;
+	*value = pen >> 7;
+	return 0;
+}
+
+static int intel_crc_pmic_update_policy(struct regmap *regmap,
+					int reg, int enable)
+{
+	int alert0;
+
+	/* Update to policy enable bit requires unlocking a0lock */
+	if (regmap_read(regmap, PMIC_A0LOCK_REG, &alert0))
+		return -EIO;
+
+	if (regmap_update_bits(regmap, PMIC_A0LOCK_REG, 0x01, 0))
+		return -EIO;
+
+	if (regmap_update_bits(regmap, reg, 0x80, enable << 7))
+		return -EIO;
+
+	/* restore alert0 */
+	if (regmap_write(regmap, PMIC_A0LOCK_REG, alert0))
+		return -EIO;
+
+	return 0;
+}
+
+static struct intel_pmic_opregion_data intel_crc_pmic_opregion_data = {
+	.get_power	= intel_crc_pmic_get_power,
+	.update_power	= intel_crc_pmic_update_power,
+	.get_raw_temp	= intel_crc_pmic_get_raw_temp,
+	.update_aux	= intel_crc_pmic_update_aux,
+	.get_policy	= intel_crc_pmic_get_policy,
+	.update_policy	= intel_crc_pmic_update_policy,
+	.power_table	= power_table,
+	.power_table_count= ARRAY_SIZE(power_table),
+	.thermal_table	= thermal_table,
+	.thermal_table_count = ARRAY_SIZE(thermal_table),
+};
+
+static int intel_crc_pmic_opregion_probe(struct platform_device *pdev)
+{
+	struct intel_soc_pmic *pmic = dev_get_drvdata(pdev->dev.parent);
+	return intel_pmic_install_opregion_handler(&pdev->dev,
+			ACPI_HANDLE(pdev->dev.parent), pmic->regmap,
+			&intel_crc_pmic_opregion_data);
+}
+
+static struct platform_driver intel_crc_pmic_opregion_driver = {
+	.probe = intel_crc_pmic_opregion_probe,
+	.driver = {
+		.name = "crystal_cove_region",
+	},
+};
+
+static int __init intel_crc_pmic_opregion_driver_init(void)
+{
+	return platform_driver_register(&intel_crc_pmic_opregion_driver);
+}
+module_init(intel_crc_pmic_opregion_driver_init);
+
+MODULE_DESCRIPTION("CrystalCove ACPI opration region driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
index 7107cab832e6..48845d636bba 100644
--- a/drivers/mfd/intel_soc_pmic_crc.c
+++ b/drivers/mfd/intel_soc_pmic_crc.c
@@ -106,6 +106,9 @@ static struct mfd_cell crystal_cove_dev[] = {
 		.num_resources = ARRAY_SIZE(gpio_resources),
 		.resources = gpio_resources,
 	},
+	{
+		.name = "crystal_cove_region",
+	},
 };
 
 static struct regmap_config crystal_cove_regmap_config = {
-- 
1.9.3

