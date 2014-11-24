Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaKXJYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:24:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:42630 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaKXJYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:24:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,447,1413270000"; 
   d="scan'208";a="642456994"
Message-ID: <5472F95F.7080605@intel.com>
Date: Mon, 24 Nov 2014 17:24:47 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 updated 2/3] ACPI / PMIC: support PMIC operation region
 for XPower AXP288
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com> <1416553911-22990-3-git-send-email-aaron.lu@intel.com> <4442976.gicsivIv0q@vostro.rjw.lan>
In-Reply-To: <4442976.gicsivIv0q@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 09:04 AM, Rafael J. Wysocki wrote:
> On Friday, November 21, 2014 03:11:50 PM Aaron Lu wrote:
>> +static struct pmic_pwr_table pwr_table[] = {
>> +	{
>> +		.address = 0x00,
>> +		.pwr_reg = {
>> +			.reg = 0x13,
>> +			.bit = 0x05,
>> +		}
>> +	}, /* ALD1, 0x13, bit5 */
> 
> It is not necessary to repeat the reg numbers and bits in the comments.

I've removed them all, it's only useful when developing the code.
Here is the updated version:

From: Aaron Lu <aaron.lu@intel.com>
Date: Mon, 20 Oct 2014 17:00:59 +0800
Subject: [PATCH 2/3] ACPI / PMIC: support PMIC operation region for XPower
 AXP288

The Baytrail-T-CR platform firmware has defined two customized operation
regions for PMIC chip Dollar Cove XPower - one is for power resource
handling and one is for thermal just like the CrystalCove one. This patch
adds support for them on top of the common PMIC opregion region code.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Lee Jones <lee.jones@linaro.org> for the MFD part
---
 drivers/acpi/Kconfig                  |   6 +
 drivers/acpi/Makefile                 |   1 +
 drivers/acpi/pmic/intel_pmic_xpower.c | 246 ++++++++++++++++++++++++++++++++++
 drivers/mfd/axp20x.c                  |   3 +
 4 files changed, 256 insertions(+)
 create mode 100644 drivers/acpi/pmic/intel_pmic_xpower.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 3e5f2056f946..227f0692cbff 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -408,6 +408,12 @@ config CRC_PMIC_OPREGION
 	help
 	  This config adds ACPI operation region support for CrystalCove PMIC.
 
+config XPOWER_PMIC_OPREGION
+	bool "ACPI operation region support for XPower AXP288 PMIC"
+	depends on AXP288_ADC
+	help
+	  This config adds ACPI operation region support for XPower AXP288 PMIC.
+
 endif
 
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index f5938399ac14..f74317cc1ca9 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -91,3 +91,4 @@ obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
 
 obj-$(CONFIG_PMIC_OPREGION)	+= pmic/intel_pmic.o
 obj-$(CONFIG_CRC_PMIC_OPREGION) += pmic/intel_pmic_crc.o
+obj-$(CONFIG_XPOWER_PMIC_OPREGION) += pmic/intel_pmic_xpower.o
diff --git a/drivers/acpi/pmic/intel_pmic_xpower.c b/drivers/acpi/pmic/intel_pmic_xpower.c
new file mode 100644
index 000000000000..795ca073db08
--- /dev/null
+++ b/drivers/acpi/pmic/intel_pmic_xpower.c
@@ -0,0 +1,246 @@
+/*
+ * intel_pmic_xpower.c - XPower AXP288 PMIC operation region driver
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
+#include <linux/mfd/axp20x.h>
+#include <linux/regmap.h>
+#include <linux/platform_device.h>
+#include <linux/iio/consumer.h>
+#include "intel_pmic.h"
+
+#define XPOWER_GPADC_LOW	0x5b
+
+static struct pmic_table power_table[] = {
+	{
+		.address = 0x00,
+		.reg = 0x13,
+		.bit = 0x05,
+	},
+	{
+		.address = 0x04,
+		.reg = 0x13,
+		.bit = 0x06,
+	},
+	{
+		.address = 0x08,
+		.reg = 0x13,
+		.bit = 0x07,
+	},
+	{
+		.address = 0x0c,
+		.reg = 0x12,
+		.bit = 0x03,
+	},
+	{
+		.address = 0x10,
+		.reg = 0x12,
+		.bit = 0x04,
+	},
+	{
+		.address = 0x14,
+		.reg = 0x12,
+		.bit = 0x05,
+	},
+	{
+		.address = 0x18,
+		.reg = 0x12,
+		.bit = 0x06,
+	},
+	{
+		.address = 0x1c,
+		.reg = 0x12,
+		.bit = 0x00,
+	},
+	{
+		.address = 0x20,
+		.reg = 0x12,
+		.bit = 0x01,
+	},
+	{
+		.address = 0x24,
+		.reg = 0x12,
+		.bit = 0x02,
+	},
+	{
+		.address = 0x28,
+		.reg = 0x13,
+		.bit = 0x02,
+	},
+	{
+		.address = 0x2c,
+		.reg = 0x13,
+		.bit = 0x03,
+	},
+	{
+		.address = 0x30,
+		.reg = 0x13,
+		.bit = 0x04,
+	},
+	{
+		.address = 0x38,
+		.reg = 0x10,
+		.bit = 0x03,
+	},
+	{
+		.address = 0x3c,
+		.reg = 0x10,
+		.bit = 0x06,
+	},
+	{
+		.address = 0x40,
+		.reg = 0x10,
+		.bit = 0x05,
+	},
+	{
+		.address = 0x44,
+		.reg = 0x10,
+		.bit = 0x04,
+	},
+	{
+		.address = 0x48,
+		.reg = 0x10,
+		.bit = 0x01,
+	},
+	{
+		.address = 0x4c,
+		.reg = 0x10,
+		.bit = 0x00
+	},
+};
+
+/* TMP0 - TMP5 are the same, all from GPADC */
+static struct pmic_table thermal_table[] = {
+	{
+		.address = 0x00,
+		.reg = XPOWER_GPADC_LOW
+	},
+	{
+		.address = 0x0c,
+		.reg = XPOWER_GPADC_LOW
+	},
+	{
+		.address = 0x18,
+		.reg = XPOWER_GPADC_LOW
+	},
+	{
+		.address = 0x24,
+		.reg = XPOWER_GPADC_LOW
+	},
+	{
+		.address = 0x30,
+		.reg = XPOWER_GPADC_LOW
+	},
+	{
+		.address = 0x3c,
+		.reg = XPOWER_GPADC_LOW
+	},
+};
+
+static int intel_xpower_pmic_get_power(struct regmap *regmap, int reg,
+				       int bit, u64 *value)
+{
+	int data;
+
+	if (regmap_read(regmap, reg, &data))
+		return -EIO;
+
+	*value = (data & BIT(bit)) ? 1 : 0;
+	return 0;
+}
+
+static int intel_xpower_pmic_update_power(struct regmap *regmap, int reg,
+					  int bit, bool on)
+{
+	int data;
+
+	if (regmap_read(regmap, reg, &data))
+		return -EIO;
+
+	if (on)
+		data |= BIT(bit);
+	else
+		data &= ~BIT(bit);
+
+	if (regmap_write(regmap, reg, data))
+		return -EIO;
+
+	return 0;
+}
+
+/**
+ * intel_xpower_pmic_get_raw_temp(): Get raw temperature reading from the PMIC
+ *
+ * @regmap: regmap of the PMIC device
+ * @reg: register to get the reading
+ *
+ * We could get the sensor value by manipulating the HW regs here, but since
+ * the axp288 IIO driver may also access the same regs at the same time, the
+ * APIs provided by IIO subsystem are used here instead to avoid problems. As
+ * a result, the two passed in params are of no actual use.
+ *
+ * Return a positive value on success, errno on failure.
+ */
+static int intel_xpower_pmic_get_raw_temp(struct regmap *regmap, int reg)
+{
+	struct iio_channel *gpadc_chan;
+	int ret, val;
+
+	gpadc_chan = iio_channel_get(NULL, "axp288-system-temp");
+	if (IS_ERR_OR_NULL(gpadc_chan))
+		return -EACCES;
+
+	ret = iio_read_channel_raw(gpadc_chan, &val);
+	if (ret < 0)
+		val = ret;
+
+	iio_channel_release(gpadc_chan);
+	return val;
+}
+
+static struct intel_pmic_opregion_data intel_xpower_pmic_opregion_data = {
+	.get_power = intel_xpower_pmic_get_power,
+	.update_power = intel_xpower_pmic_update_power,
+	.get_raw_temp = intel_xpower_pmic_get_raw_temp,
+	.power_table = power_table,
+	.power_table_count = ARRAY_SIZE(power_table),
+	.thermal_table = thermal_table,
+	.thermal_table_count = ARRAY_SIZE(thermal_table),
+};
+
+
+static int intel_xpower_pmic_opregion_probe(struct platform_device *pdev)
+{
+	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
+	return intel_pmic_install_opregion_handler(&pdev->dev,
+			ACPI_HANDLE(pdev->dev.parent), axp20x->regmap,
+			&intel_xpower_pmic_opregion_data);
+}
+
+static struct platform_driver intel_xpower_pmic_opregion_driver = {
+	.probe = intel_xpower_pmic_opregion_probe,
+	.driver = {
+		.name = "axp288_opregion",
+	},
+};
+
+static int __init intel_xpower_pmic_opregion_driver_init(void)
+{
+	return platform_driver_register(&intel_xpower_pmic_opregion_driver);
+}
+module_init(intel_xpower_pmic_opregion_driver_init);
+
+MODULE_DESCRIPTION("XPower AXP288 ACPI operation region driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index acbb4c3bf98c..daf3c8d33b4d 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -354,6 +354,9 @@ static struct mfd_cell axp288_cells[] = {
 		.num_resources = ARRAY_SIZE(axp288_battery_resources),
 		.resources = axp288_battery_resources,
 	},
+	{
+		.name = "axp288_opregion",
+	},
 };
 
 static struct axp20x_dev *axp20x_pm_power_off;
-- 
1.9.3

