Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3EVMLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:11:54 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:40383 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751Ab3EVMLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:11:52 -0400
From: <yizhang.mrvl@gmail.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <jett.zhou@marvell.com>,
        <linux-kernel@vger.kernel.org>, Yi Zhang <yizhang@marvell.com>
Subject: [PATCH] regulator: 88pm800: add regulator driver
Date: Wed, 22 May 2013 20:10:53 +0800
Message-ID: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

Signed-off-by: Yi Zhang <yizhang@marvell.com>
---
 drivers/regulator/88pm800.c |  531 +++++++++++++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig   |   10 +
 drivers/regulator/Makefile  |    1 +
 3 files changed, 542 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/88pm800.c

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
new file mode 100644
index 0000000..be08895
--- /dev/null
+++ b/drivers/regulator/88pm800.c
@@ -0,0 +1,531 @@
+/*
+ * Regulators driver for Marvell 88PM800
+ *
+ * Copyright (C) 2012 Marvell International Ltd.
+ * Joseph(Yossi) Hanin <yhanin@marvell.com>
+ * Yi Zhang <yizhang@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/88pm80x.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
+
+/* LDO1 with DVC[0..3] */
+#define PM800_LDO1_VOUT		(0x08) /* VOUT1 */
+#define PM800_LDO1_VOUT_2	(0x09)
+#define PM800_LDO1_VOUT_3	(0x0A)
+#define PM800_LDO2_VOUT		(0x0B)
+#define PM800_LDO3_VOUT		(0x0C)
+#define PM800_LDO4_VOUT		(0x0D)
+#define PM800_LDO5_VOUT		(0x0E)
+#define PM800_LDO6_VOUT		(0x0F)
+#define PM800_LDO7_VOUT		(0x10)
+#define PM800_LDO8_VOUT		(0x11)
+#define PM800_LDO9_VOUT		(0x12)
+#define PM800_LDO10_VOUT	(0x13)
+#define PM800_LDO11_VOUT	(0x14)
+#define PM800_LDO12_VOUT	(0x15)
+#define PM800_LDO13_VOUT	(0x16)
+#define PM800_LDO14_VOUT	(0x17)
+#define PM800_LDO15_VOUT	(0x18)
+#define PM800_LDO16_VOUT	(0x19)
+#define PM800_LDO17_VOUT	(0x1A)
+#define PM800_LDO18_VOUT	(0x1B)
+#define PM800_LDO19_VOUT	(0x1C)
+
+/* BUCK1 with DVC[0..3] */
+#define PM800_BUCK1		(0x3C)
+#define PM800_BUCK1_1		(0x3D)
+#define PM800_BUCK1_2		(0x3E)
+#define PM800_BUCK1_3		(0x3F)
+#define PM800_BUCK2		(0x40)
+#define PM800_BUCK3		(0x41)
+
+#define PM800_BUCK_ENA		(0x50)
+#define PM800_LDO_ENA1_1	(0x51)
+#define PM800_LDO_ENA1_2	(0x52)
+#define PM800_LDO_ENA1_3	(0x53)
+
+#define PM800_LDO_ENA2_1	(0x56)
+#define PM800_LDO_ENA2_2	(0x57)
+#define PM800_LDO_ENA2_3	(0x58)
+
+#define PM800_BUCK1_MISC1	(0x78)
+#define PM800_BUCK3_MISC1	(0x7E)
+#define PM800_BUCK4_MISC1	(0x81)
+#define PM800_BUCK5_MISC1	(0x84)
+
+struct pm800_regulator_info {
+	struct regulator_desc desc;
+	struct pm80x_chip *chip;
+	struct regmap *map;
+	struct regulator_dev *regulator;
+
+	unsigned int *vol_table;
+	unsigned int *vol_suspend;
+	int max_ua;
+};
+
+static const unsigned int BUCK1_table[] = {
+	/* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
+	600000, 612500, 625000, 637500, 650000, 662500, 675000, 687500,
+	700000, 712500, 725000, 737500, 750000, 762500, 775000, 787500,
+	800000, 812500, 825000, 837500, 850000, 862500, 875000, 887500,
+	900000, 912500, 925000, 937500, 950000, 962500, 975000, 987500,
+	1000000, 1012500, 1025000, 1037500, 1050000, 1062500, 1075000, 1087500,
+	1100000, 1112500, 1125000, 1137500, 1150000, 1162500, 1175000, 1187500,
+	1200000, 1212500, 1225000, 1237500, 1250000, 1262500, 1275000, 1287500,
+	1300000, 1312500, 1325000, 1337500, 1350000, 1362500, 1375000, 1387500,
+	1400000, 1412500, 1425000, 1437500, 1450000, 1462500, 1475000, 1487500,
+	1500000, 1512500, 1525000, 1537500, 1550000, 1562500, 1575000, 1587500,
+	/* 0x50-0x7F: from 1.6 to 1.8V with step 0.05V */
+	1600000, 1650000, 1700000, 1750000, 1800000,
+};
+
+static const unsigned int BUCK2_table[] = {
+	/* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
+	600000, 612500, 625000, 637500, 650000, 662500, 675000, 687500,
+	700000, 712500, 725000, 737500, 750000, 762500, 775000, 787500,
+	800000, 812500, 825000, 837500, 850000, 862500, 875000, 887500,
+	900000, 912500, 925000, 937500, 950000, 962500, 975000, 987500,
+	1000000, 1012500, 1025000, 1037500, 1050000, 1062500, 1075000, 1087500,
+	1100000, 1112500, 1125000, 1137500, 1150000, 1162500, 1175000, 1187500,
+	1200000, 1212500, 1225000, 1237500, 1250000, 1262500, 1275000, 1287500,
+	1300000, 1312500, 1325000, 1337500, 1350000, 1362500, 1375000, 1387500,
+	1400000, 1412500, 1425000, 1437500, 1450000, 1462500, 1475000, 1487500,
+	1500000, 1512500, 1525000, 1537500, 1550000, 1562500, 1575000, 1587500,
+	/* 0x50-0x7F: from 1.6 to 3.3V with step 0.05V */
+	1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000, 1950000,
+	2000000, 2050000, 2100000, 2150000, 2200000, 2250000, 2300000, 2350000,
+	2400000, 2450000, 2500000, 2550000, 2600000, 2650000, 2700000, 2750000,
+	2800000, 2850000, 2900000, 2950000, 3000000, 3050000, 3100000, 3150000,
+	3200000, 3250000, 3300000,
+};
+
+static const unsigned int BUCK3_table[] = {
+	/* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
+	600000, 612500, 625000, 637500, 650000, 662500, 675000, 687500,
+	700000, 712500, 725000, 737500, 750000, 762500, 775000, 787500,
+	800000, 812500, 825000, 837500, 850000, 862500, 875000, 887500,
+	900000, 912500, 925000, 937500, 950000, 962500, 975000, 987500,
+	1000000, 1012500, 1025000, 1037500, 1050000, 1062500, 1075000, 1087500,
+	1100000, 1112500, 1125000, 1137500, 1150000, 1162500, 1175000, 1187500,
+	1200000, 1212500, 1225000, 1237500, 1250000, 1262500, 1275000, 1287500,
+	1300000, 1312500, 1325000, 1337500, 1350000, 1362500, 1375000, 1387500,
+	1400000, 1412500, 1425000, 1437500, 1450000, 1462500, 1475000, 1487500,
+	1500000, 1512500, 1525000, 1537500, 1550000, 1562500, 1575000, 1587500,
+	/* 0x50-0x7F: from 1.6 to 3.3V with step 0.05V */
+	1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000, 1950000,
+	2000000, 2050000, 2100000, 2150000, 2200000, 2250000, 2300000, 2350000,
+	2400000, 2450000, 2500000, 2550000, 2600000, 2650000, 2700000, 2750000,
+	2800000, 2850000, 2900000, 2950000, 3000000, 3050000, 3100000, 3150000,
+	3200000, 3250000, 3300000,
+};
+
+static const unsigned int BUCK4_table[] = {
+	/* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
+	600000, 612500, 625000, 637500, 650000, 662500, 675000, 687500,
+	700000, 712500, 725000, 737500, 750000, 762500, 775000, 787500,
+	800000, 812500, 825000, 837500, 850000, 862500, 875000, 887500,
+	900000, 912500, 925000, 937500, 950000, 962500, 975000, 987500,
+	1000000, 1012500, 1025000, 1037500, 1050000, 1062500, 1075000, 1087500,
+	1100000, 1112500, 1125000, 1137500, 1150000, 1162500, 1175000, 1187500,
+	1200000, 1212500, 1225000, 1237500, 1250000, 1262500, 1275000, 1287500,
+	1300000, 1312500, 1325000, 1337500, 1350000, 1362500, 1375000, 1387500,
+	1400000, 1412500, 1425000, 1437500, 1450000, 1462500, 1475000, 1487500,
+	1500000, 1512500, 1525000, 1537500, 1550000, 1562500, 1575000, 1587500,
+	/* 0x50-0x7F: from 1.6 to 3.3V with step 0.05V */
+	1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000, 1950000,
+	2000000, 2050000, 2100000, 2150000, 2200000, 2250000, 2300000, 2350000,
+	2400000, 2450000, 2500000, 2550000, 2600000, 2650000, 2700000, 2750000,
+	2800000, 2850000, 2900000, 2950000, 3000000, 3050000, 3100000, 3150000,
+	3200000, 3250000, 3300000,
+};
+
+static const unsigned int BUCK5_table[] = {
+	/* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
+	600000, 612500, 625000, 637500, 650000, 662500, 675000, 687500,
+	700000, 712500, 725000, 737500, 750000, 762500, 775000, 787500,
+	800000, 812500, 825000, 837500, 850000, 862500, 875000, 887500,
+	900000, 912500, 925000, 937500, 950000, 962500, 975000, 987500,
+	1000000, 1012500, 1025000, 1037500, 1050000, 1062500, 1075000, 1087500,
+	1100000, 1112500, 1125000, 1137500, 1150000, 1162500, 1175000, 1187500,
+	1200000, 1212500, 1225000, 1237500, 1250000, 1262500, 1275000, 1287500,
+	1300000, 1312500, 1325000, 1337500, 1350000, 1362500, 1375000, 1387500,
+	1400000, 1412500, 1425000, 1437500, 1450000, 1462500, 1475000, 1487500,
+	1500000, 1512500, 1525000, 1537500, 1550000, 1562500, 1575000, 1587500,
+	/* 0x50-0x7F: from 1.6 to 3.3V with step 0.05V */
+	1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000, 1950000,
+	2000000, 2050000, 2100000, 2150000, 2200000, 2250000, 2300000, 2350000,
+	2400000, 2450000, 2500000, 2550000, 2600000, 2650000, 2700000, 2750000,
+	2800000, 2850000, 2900000, 2950000, 3000000, 3050000, 3100000, 3150000,
+	3200000, 3250000, 3300000,
+};
+
+static const unsigned int LDO1_table[] = {
+	600000,  650000,  700000,  750000,  800000,  850000,  900000,  950000,
+	1000000, 1050000, 1100000, 1150000, 1200000, 1300000, 1400000, 1500000,
+};
+
+static const unsigned int LDO2_table[] = {
+	1700000, 1800000, 1900000, 2000000, 2100000, 2500000, 2700000, 2800000,
+};
+
+static const unsigned int LDO3_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO4_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO5_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO6_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO7_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO8_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO9_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO10_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO11_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO12_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO13_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO14_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO15_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO16_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO17_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+static const unsigned int LDO18_table[] = {
+	1700000, 1800000, 1900000, 2500000, 2800000, 2900000, 3100000, 3300000,
+};
+
+static const unsigned int LDO19_table[] = {
+	1700000, 1800000, 1900000, 2500000, 2800000, 2900000, 3100000, 3300000,
+};
+
+static const unsigned int BUCK_DVC_SET[] = {
+	195, 390, 780, 1560, 3120, 6250, 12500, 25000,
+};
+
+static int pm800_list_voltage(struct regulator_dev *rdev, unsigned index)
+{
+	struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret = -EINVAL;
+
+	if (info->vol_table && (index < rdev->desc->n_voltages))
+		ret = info->vol_table[index];
+
+	return ret;
+}
+
+static int choose_voltage(struct regulator_dev *rdev, int min_uv, int max_uv)
+{
+	struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
+	int i, ret = -ENOENT;
+
+	if (info->vol_table) {
+		for (i = 0; i < rdev->desc->n_voltages; i++) {
+			if (!info->vol_table[i])
+				break;
+			if ((min_uv <= info->vol_table[i])
+			    && (max_uv >= info->vol_table[i])) {
+				ret = info->vol_table[i];
+				break;
+			}
+		}
+	}
+	if (ret < 0)
+		dev_err(&rdev->dev, "invalid voltage (%d %d)uV\n",
+			min_uv, max_uv);
+
+	return ret;
+}
+
+static int pm800_set_voltage(struct regulator_dev *rdev,
+			     int min_uv, int max_uv, unsigned *sel)
+{
+	*sel = choose_voltage(rdev, min_uv, max_uv);
+	if (*sel < 0)
+		return -EINVAL;
+	return regulator_set_voltage_sel_regmap(rdev, *sel);
+}
+
+static int pm800_get_current_limit(struct regulator_dev *rdev)
+{
+	struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
+	return info->max_ua;
+}
+
+static struct regulator_ops pm800_regulator_ops = {
+	.set_voltage = pm800_set_voltage,
+	.get_voltage = regulator_get_voltage_sel_regmap,
+	.list_voltage = pm800_list_voltage,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.get_current_limit = pm800_get_current_limit,
+};
+
+/*
+ * vreg - the buck regs string.
+ * ureg - the string for the register that is control by PI2c for sleep,
+ * ereg - the string for the enable register.
+ * ebit - the bit number in the enable register.
+ * amax - the current
+ */
+#define PM800_DVC(vreg, ureg, ubit, ereg, ebit, amax)			\
+{									\
+	.desc	= {							\
+		.name	= #vreg,					\
+		.ops	= &pm800_regulator_ops,				\
+		.type	= REGULATOR_VOLTAGE,				\
+		.id	= PM800_ID_##vreg,				\
+		.owner	= THIS_MODULE,					\
+		.n_voltages = ARRAY_SIZE(vreg##_table),			\
+		.vsel_reg	= PM800_##vreg,				\
+		.vsel_mask =	0x7f,					\
+		.enable_reg	= PM800_##ereg,				\
+		.enable_mask	= 1 << (ebit),				\
+	},								\
+	.max_ua		= (amax),					\
+	.vol_table	= (unsigned int *)&vreg##_table,		\
+	.vol_suspend	= (unsigned int *)&vreg##_table,		\
+}
+
+/*
+ * _id - the LDO number.
+ * vreg - the LDO regs string
+ * ereg -  the string for the enable register.
+ * ebit - the bit number in the enable register.
+ * amax - the current
+ */
+#define PM800_LDO(_id, vreg, ereg, ebit, amax)	\
+{									\
+	.desc	= {							\
+		.name	= "LDO" #_id,					\
+		.ops	= &pm800_regulator_ops,				\
+		.type	= REGULATOR_VOLTAGE,				\
+		.id	= PM800_ID_LDO##_id,				\
+		.owner	= THIS_MODULE,					\
+		.n_voltages = ARRAY_SIZE(LDO##_id##_table),		\
+		.vsel_reg	= PM800_##vreg##_VOUT,			\
+		.vsel_mask = 0x1f,					\
+		.enable_reg	= PM800_##ereg,				\
+		.enable_mask	= 1 << (ebit),				\
+	},								\
+	.max_ua		= (amax),					\
+	.vol_table	= (unsigned int *)&LDO##_id##_table,		\
+	.vol_suspend	= (unsigned int *)&LDO##_id##_table,		\
+}
+/*
+ * the GO register in the PM800_DVC table need to be consider
+ * it might be we need to remove this filed from the MACRO
+ */
+static struct pm800_regulator_info pm800_regulator_info[] = {
+	PM800_DVC(BUCK1, BUCK_ENA, 0, BUCK_ENA, 0, 3000000),
+	PM800_DVC(BUCK2, BUCK_ENA, 1, BUCK_ENA, 1, 1200000),
+	PM800_DVC(BUCK3, BUCK_ENA, 2, BUCK_ENA, 2, 1200000),
+	PM800_DVC(BUCK4, BUCK_ENA, 3, BUCK_ENA, 3, 1200000),
+	PM800_DVC(BUCK5, BUCK_ENA, 4, BUCK_ENA, 4, 1200000),
+
+	PM800_LDO(1,	LDO1,	LDO_ENA1_1, 0, 200000),
+	PM800_LDO(2,	LDO2,	LDO_ENA1_1, 1, 10000),
+	PM800_LDO(3,	LDO3,	LDO_ENA1_1, 2, 300000),
+	PM800_LDO(4,	LDO4,	LDO_ENA1_1, 3, 300000),
+	PM800_LDO(5,	LDO5,	LDO_ENA1_1, 4, 300000),
+	PM800_LDO(6,	LDO6,	LDO_ENA1_1, 5, 300000),
+	PM800_LDO(7,	LDO7,	LDO_ENA1_1, 6, 300000),
+	PM800_LDO(8,	LDO8,	LDO_ENA1_1, 7, 300000),
+	PM800_LDO(9,	LDO9,	LDO_ENA1_2, 0, 300000),
+	PM800_LDO(10,	LDO10,	LDO_ENA1_2, 1, 300000),
+	PM800_LDO(11,	LDO11,	LDO_ENA1_2, 2, 300000),
+	PM800_LDO(12,	LDO12,	LDO_ENA1_2, 3, 300000),
+	PM800_LDO(13,	LDO13,	LDO_ENA1_2, 4, 300000),
+	PM800_LDO(14,	LDO14,	LDO_ENA1_2, 5, 300000),
+	PM800_LDO(15,	LDO15,	LDO_ENA1_2, 6, 300000),
+	PM800_LDO(16,	LDO16,	LDO_ENA1_2, 7, 300000),
+	PM800_LDO(17,	LDO17,	LDO_ENA1_3, 0, 300000),
+	PM800_LDO(18,	LDO18,	LDO_ENA1_3, 1, 200000),
+	PM800_LDO(19,	LDO19,	LDO_ENA1_3, 2, 200000),
+};
+
+#ifdef CONFIG_OF
+static int pm800_regulator_dt_init(struct platform_device *pdev,
+				    struct pm800_regulator_info *info,
+				    struct regulator_config *config)
+{
+	struct device_node *nproot, *np;
+	nproot = pdev->dev.parent->of_node;
+	if (!nproot)
+		return -ENODEV;
+	nproot = of_find_node_by_name(nproot, "regulators");
+	if (!nproot) {
+		dev_err(&pdev->dev, "failed to find regulators node\n");
+		return -ENODEV;
+	}
+	for_each_child_of_node(nproot, np) {
+		if (!of_node_cmp(np->name, info->desc.name)) {
+			config->init_data =
+				of_get_regulator_init_data(&pdev->dev, np);
+			config->of_node = np;
+			break;
+		}
+	}
+	return 0;
+}
+#else
+static int pm800_regulator_dt_init(struct platform_device *pdev,
+				    struct pm800_regulator_info *info,
+				    struct regulator_config *config)
+{
+	return -ENOSYS;
+}
+#endif
+
+static int pm800_regulator_probe(struct platform_device *pdev)
+{
+	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_init_data *pdata = pdev->dev.platform_data;
+	struct pm800_regulator_info *info = NULL;
+	struct regulator_config config = { };
+
+	struct resource *res;
+	int i;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource!\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pm800_regulator_info); i++) {
+		info = &pm800_regulator_info[i];
+		if (info->desc.id == res->start)
+			break;
+	}
+
+	if ((i < 0) || (i > PM800_ID_RG_MAX)) {
+		dev_err(&pdev->dev,
+			"failed to find regulator %d\n", res->start);
+		return -EINVAL;
+	}
+
+	info->map = chip->subchip->regmap_power;
+	info->chip = chip;
+
+	config.dev = &pdev->dev;
+	config.driver_data = info;
+
+	if (pm800_regulator_dt_init(pdev, info, &config))
+		if (pdata)
+			config.init_data = pdata;
+	config.regmap = chip->subchip->regmap_power;
+
+
+	info->regulator = regulator_register(&info->desc, &config);
+	if (IS_ERR(info->regulator)) {
+		dev_err(&pdev->dev, "failed to register regulator %s\n",
+			info->desc.name);
+		return PTR_ERR(info->regulator);
+	}
+
+	platform_set_drvdata(pdev, info);
+	return 0;
+}
+
+static int pm800_regulator_remove(struct platform_device *pdev)
+{
+	struct pm800_regulator_info *info = platform_get_drvdata(pdev);
+	platform_set_drvdata(pdev, NULL);
+	regulator_unregister(info->regulator);
+	return 0;
+}
+
+static struct platform_driver pm800_regulator_driver = {
+	.driver		= {
+		.name	= "88pm80x-regulator",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= pm800_regulator_probe,
+	.remove		= __devexit_p(pm800_regulator_remove),
+};
+
+static int __init pm800_regulator_init(void)
+{
+	return platform_driver_register(&pm800_regulator_driver);
+}
+subsys_initcall(pm800_regulator_init);
+
+static void __exit pm800_regulator_exit(void)
+{
+	platform_driver_unregister(&pm800_regulator_driver);
+}
+module_exit(pm800_regulator_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joseph(Yossi) Hanin <yhanin@marvell.com>");
+MODULE_DESCRIPTION("Regulator Driver for Marvell 88PM800 PMIC");
+MODULE_ALIAS("platform:88pm800-regulator");
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8bb2644..cd8ebff 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -170,6 +170,16 @@ config REGULATOR_88PM8607
 	help
 	  This driver supports 88PM8607 voltage regulator chips.
 
+config REGULATOR_88PM800
+	bool "Marvell 88PM800 Power regulators"
+	depends on MFD_88PM800=y
+	help
+	  This driver supports Marvell 88PM800 voltage regulator chips.
+	  It delivers digitally programmable output,
+	  the voltage is programmed via I2C interface.
+	  It's suitable to support PXA988 chips to control VCC_MAIN and
+	  various voltages.
+
 config REGULATOR_MAX1586
 	tristate "Maxim 1586/1587 voltage regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 47a34ff..1f21a7d 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
+obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o ab8500-ext.o
-- 
1.7.0.4

