Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaKMJFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:05:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:28100 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbaKMJFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:05:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,375,1413270000"; 
   d="scan'208";a="631269690"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ACPI / pmic_opregion: support PMIC operation region for XPower AXP288
Date: Thu, 13 Nov 2014 17:04:35 +0800
Message-Id: <1415869476-24329-3-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415869476-24329-1-git-send-email-aaron.lu@intel.com>
References: <1415869476-24329-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Baytrail-T-CR platform firmware has defined two customized operation
regions for PMIC chip Dollar Cove XPower - one is for power resource
handling and one is for thermal just like the CrystalCove one. This patch
adds support for them on top of the common PMIC opregion region code.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Lee Jones <lee.jones@linaro.org> for the MFD part
---
 drivers/acpi/Kconfig                  |   6 +
 drivers/acpi/Makefile                 |   1 +
 drivers/acpi/pmic/intel_pmic_xpower.c | 277 ++++++++++++++++++++++++++++++++++
 drivers/mfd/axp20x.c                  |   3 +
 4 files changed, 287 insertions(+)
 create mode 100644 drivers/acpi/pmic/intel_pmic_xpower.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index df816456dc06..1b7b753cadcc 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -409,6 +409,12 @@ config CRC_PMIC_OPREGION
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
index 000000000000..c24bf1a6e48a
--- /dev/null
+++ b/drivers/acpi/pmic/intel_pmic_xpower.c
@@ -0,0 +1,277 @@
+/*
+ * intel_pmic_xpower.c - XPower AXP288 PMIC operation region Driver
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
+static struct pmic_pwr_table pwr_table[] = {
+	{
+		.address = 0x00,
+		.pwr_reg = {
+			.reg = 0x13,
+			.bit = 0x05,
+		}
+	}, /* ALD1, 0x13, bit5 */
+	{
+		.address = 0x04,
+		.pwr_reg = {
+			.reg = 0x13,
+			.bit = 0x06,
+		}
+	}, /* ALD2, 0x13, bit6 */
+	{
+		.address = 0x08,
+		.pwr_reg = {
+			.reg = 0x13,
+			.bit = 0x07,
+		}
+	}, /* ALD3, 0x13, bit7 */
+	{
+		.address = 0x0c,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x03,
+		}
+	}, /* DLD1, 0x12, bit3 */
+	{
+		.address = 0x10,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x04,
+		}
+	}, /* DLD2, 0x12, bit4 */
+	{
+		.address = 0x14,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x05,
+		}
+	}, /* DLD3, 0x12, bit5 */
+	{
+		.address = 0x18,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x06,
+		}
+	}, /* DLD4, 0x12, bit6 */
+	{
+		.address = 0x1c,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x00,
+		}
+	}, /* ELD1, 0x12, bit0 */
+	{
+		.address = 0x20,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x01,
+		}
+	}, /* ELD2, 0x12, bit1 */
+	{
+		.address = 0x24,
+		.pwr_reg = {
+			.reg = 0x12,
+			.bit = 0x02,
+		}
+	}, /* ELD3, 0x12, bit2 */
+	{
+		.address = 0x28,
+		.pwr_reg = {
+			.reg = 0x13,
+			.bit = 0x02,
+		}
+	}, /* FLD1, 0x13, bit2 */
+	{
+		.address = 0x2c,
+		.pwr_reg = {
+			.reg = 0x13,
+			.bit = 0x03,
+		}
+	}, /* FLD2, 0x13, bit3 */
+	{
+		.address = 0x30,
+		.pwr_reg = {
+			.reg = 0x13,
+			.bit = 0x04,
+		}
+	}, /* FLD3, 0x13, bit4 */
+	{
+		.address = 0x38,
+		.pwr_reg = {
+			.reg = 0x10,
+			.bit = 0x03,
+		}
+	}, /* BUC1, 0x10, bit3 */
+	{
+		.address = 0x3c,
+		.pwr_reg = {
+			.reg = 0x10,
+			.bit = 0x06,
+		}
+	}, /* BUC2, 0x10, bit6 */
+	{
+		.address = 0x40,
+		.pwr_reg = {
+			.reg = 0x10,
+			.bit = 0x05,
+		}
+	}, /* BUC3, 0x10, bit5 */
+	{
+		.address = 0x44,
+		.pwr_reg = {
+			.reg = 0x10,
+			.bit = 0x04,
+		}
+	}, /* BUC4, 0x10, bit4 */
+	{
+		.address = 0x48,
+		.pwr_reg = {
+			.reg = 0x10,
+			.bit = 0x01,
+		}
+	}, /* BUC5, 0x10, bit1 */
+	{
+		.address = 0x4c,
+		.pwr_reg = {
+			.reg = 0x10,
+			.bit = 0x00
+		}
+	}, /* BUC6, 0x10, bit0 */
+};
+
+/* TMP0 - TMP5 are the same, all from GPADC */
+static struct pmic_dptf_table dptf_table[] = {
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
+static int intel_xpower_pmic_get_power(struct regmap *regmap,
+				       struct pmic_pwr_reg *preg, u64 *value)
+{
+	int data;
+
+	if (regmap_read(regmap, preg->reg, &data))
+		return -EIO;
+
+	*value = (data & BIT(preg->bit)) ? 1 : 0;
+	return 0;
+}
+
+static int intel_xpower_pmic_update_power(struct regmap *regmap,
+					  struct pmic_pwr_reg *preg, bool on)
+{
+	int data;
+
+	if (regmap_read(regmap, preg->reg, &data))
+		return -EIO;
+
+	if (on)
+		data |= BIT(preg->bit);
+	else
+		data &= ~BIT(preg->bit);
+
+	if (regmap_write(regmap, preg->reg, data))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * We could get the sensor value by manipulating the HW regs here, but since
+ * the axp288 IIO driver may also access the same regs at the same time, the
+ * APIs provided by IIO subsystem are used here instead to avoid problems. As
+ * a result, the two passed in params are of no actual use.
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
+static struct intel_soc_pmic_opregion_data intel_xpower_pmic_opregion_data = {
+	.get_power = intel_xpower_pmic_get_power,
+	.update_power = intel_xpower_pmic_update_power,
+	.get_raw_temp = intel_xpower_pmic_get_raw_temp,
+	.pwr_table = pwr_table,
+	.pwr_table_count = ARRAY_SIZE(pwr_table),
+	.dptf_table = dptf_table,
+	.dptf_table_count = ARRAY_SIZE(dptf_table),
+};
+
+
+static int intel_xpower_pmic_opregion_probe(struct platform_device *pdev)
+{
+	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
+	return intel_soc_pmic_install_opregion_handler(&pdev->dev,
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

