Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3BDMOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:14:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40711 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3BDL4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:15 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 14/73] regulator: ab8500: Add support of low voltage battery
Date: Mon,  4 Feb 2013 11:53:29 +0000
Message-Id: <1359978868-28736-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Low voltage batteries have a wider voltage range with
lower operating voltages. Some consumers in the platform
may not work with the lower voltages and therefore need
an extra regulator to boost the voltage in this case.

This driver adds support for checking the consumers that
need higher voltage (Vaux1, 2 and 3 regulators, 3 V SIM)
and control the external buck/boost regulator
accordingly.

Note that to utilize the low voltage battery support,
the battery voltage thresholds must be changed. This
applies for the low battery voltage threshold of the
battery manager and the OTP setting for the AB8500
BattOk levels.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   30 +++
 drivers/regulator/Kconfig                     |    8 +
 drivers/regulator/Makefile                    |    1 +
 drivers/regulator/ab8500-ext.c                |  293 +++++++++++++++++++++++++
 drivers/regulator/ab8500.c                    |   12 +-
 include/linux/regulator/ab8500.h              |   24 ++
 6 files changed, 367 insertions(+), 1 deletion(-)
 create mode 100644 drivers/regulator/ab8500-ext.c

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 967e4ac..76f5f4c 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -332,6 +332,7 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
 	[AB8500_LDO_AUX1] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-DISPLAY",
 			.min_uV = 2500000,
@@ -352,6 +353,7 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 	/* supplies to the on-board eMMC */
 	[AB8500_LDO_AUX2] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-eMMC1",
 			.min_uV = 1100000,
@@ -364,6 +366,7 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 	/* supply for VAUX3, supplies to SDcard slots */
 	[AB8500_LDO_AUX3] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-MMC-SD",
 			.min_uV = 1100000,
@@ -439,9 +442,36 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 };
 
+/* supply for VextSupply3 */
+static struct regulator_consumer_supply ab8500_ext_supply3_consumers[] = {
+	/* SIM supply for 3 V SIM cards */
+	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
+};
+
+/*
+ * AB8500 external regulators
+ */
+static struct regulator_init_data ab8500_ext_regulators[] = {
+	/* fixed Vbat supplies VSMPS3_EXT_3V4 and VSMPS4_EXT_3V4 */
+	[AB8500_EXT_SUPPLY3] = {
+		.constraints = {
+			.name = "ab8500-ext-supply3",
+			.min_uV = 3400000,
+			.max_uV = 3400000,
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+			.boot_on = 1,
+		},
+		.num_consumer_supplies =
+			ARRAY_SIZE(ab8500_ext_supply3_consumers),
+		.consumer_supplies = ab8500_ext_supply3_consumers,
+	},
+};
+
 struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.reg_init               = ab8500_reg_init,
 	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
 	.regulator              = ab8500_regulators,
 	.num_regulator          = ARRAY_SIZE(ab8500_regulators),
+	.ext_regulator          = ab8500_ext_regulators,
+	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 551a22b..fdbc0f0 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -332,6 +332,14 @@ config REGULATOR_AB8500
 	  This driver supports the regulators found on the ST-Ericsson mixed
 	  signal AB8500 PMIC
 
+config REGULATOR_AB8500_EXT
+	bool "ST-Ericsson AB8500 External Regulators"
+	depends on REGULATOR_AB8500
+	default y if REGULATOR_AB8500
+	help
+	  This driver supports the external regulator controls found on the
+	  ST-Ericsson mixed signal AB8500 PMIC
+
 config REGULATOR_DBX500_PRCMU
 	bool
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index b802b0c..be541cf 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_AB8500_EXT) += ab8500-ext.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
new file mode 100644
index 0000000..ffcb96e
--- /dev/null
+++ b/drivers/regulator/ab8500-ext.c
@@ -0,0 +1,293 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Authors: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
+ *
+ * This file is based on drivers/regulator/ab8500.c
+ *
+ * AB8500 external regulators
+ *
+ * ab8500-ext supports the following regulators:
+ * - VextSupply3
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/regulator/ab8500.h>
+
+/**
+ * struct ab8500_ext_regulator_info - ab8500 regulator information
+ * @dev: device pointer
+ * @desc: regulator description
+ * @regulator_dev: regulator device
+ * @is_enabled: status of regulator (on/off)
+ * @fixed_uV: typical voltage (for fixed voltage supplies)
+ * @update_bank: bank to control on/off
+ * @update_reg: register to control on/off
+ * @update_mask: mask to enable/disable and set mode of regulator
+ * @update_val: bits holding the regulator current mode
+ * @update_val_en: bits to set EN pin active (LPn pin deactive)
+ *                 normally this means high power mode
+ * @update_val_en_lp: bits to set EN pin active and LPn pin active
+ *                    normally this means low power mode
+ * @delay: startup delay in ms
+ */
+struct ab8500_ext_regulator_info {
+	struct device *dev;
+	struct regulator_desc desc;
+	struct regulator_dev *regulator;
+	bool is_enabled;
+	int fixed_uV;
+	u8 update_bank;
+	u8 update_reg;
+	u8 update_mask;
+	u8 update_val;
+	u8 update_val_en;
+	u8 update_val_en_lp;
+};
+
+static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg,
+		info->update_mask, info->update_val);
+	if (ret < 0)
+		dev_err(rdev_get_dev(rdev),
+			"couldn't set enable bits for regulator\n");
+
+	info->is_enabled = true;
+
+	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, info->update_val);
+
+	return ret;
+}
+
+static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
+	if (ret < 0)
+		dev_err(rdev_get_dev(rdev),
+			"couldn't set disable bits for regulator\n");
+
+	info->is_enabled = false;
+
+	dev_dbg(rdev_get_dev(rdev), "%s-disable (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
+
+	return ret;
+}
+
+static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_get_register_interruptible(info->dev,
+		info->update_bank, info->update_reg, &regval);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't read 0x%x register\n", info->update_reg);
+		return ret;
+	}
+
+	dev_dbg(rdev_get_dev(rdev), "%s-is_enabled (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, regval);
+
+	if (regval & info->update_mask)
+		info->is_enabled = true;
+	else
+		info->is_enabled = false;
+
+	return info->is_enabled;
+}
+
+static int ab8500_ext_fixed_get_voltage(struct regulator_dev *rdev)
+{
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	return info->fixed_uV;
+}
+
+static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
+				   unsigned selector)
+{
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	/* return the uV for the fixed regulators */
+	if (info->fixed_uV)
+		return info->fixed_uV;
+
+	return -EINVAL;
+}
+
+static struct regulator_ops ab8500_ext_regulator_ops = {
+	.enable			= ab8500_ext_regulator_enable,
+	.disable		= ab8500_ext_regulator_disable,
+	.is_enabled		= ab8500_ext_regulator_is_enabled,
+	.get_voltage		= ab8500_ext_fixed_get_voltage,
+	.list_voltage		= ab8500_ext_list_voltage,
+};
+
+
+static struct ab8500_ext_regulator_info
+		ab8500_ext_regulator_info[AB8500_NUM_EXT_REGULATORS] = {
+	[AB8500_EXT_SUPPLY3] = {
+		.desc = {
+			.name		= "VEXTSUPPLY3",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 3400000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x30,
+		.update_val		= 0x10,
+		.update_val_en		= 0x10,
+		.update_val_en_lp	= 0x30,
+	},
+};
+
+int ab8500_ext_regulator_init(struct platform_device *pdev)
+{
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *ppdata;
+	struct ab8500_regulator_platform_data *pdata;
+	int i, err;
+
+	if (!ab8500) {
+		dev_err(&pdev->dev, "null mfd parent\n");
+		return -EINVAL;
+	}
+	ppdata = dev_get_platdata(ab8500->dev);
+	if (!ppdata) {
+		dev_err(&pdev->dev, "null parent pdata\n");
+		return -EINVAL;
+	}
+
+	pdata = ppdata->regulator;
+	if (!pdata) {
+		dev_err(&pdev->dev, "null pdata\n");
+		return -EINVAL;
+	}
+
+	/* make sure the platform data has the correct size */
+	if (pdata->num_ext_regulator != ARRAY_SIZE(ab8500_ext_regulator_info)) {
+		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
+		return -EINVAL;
+	}
+
+	/* check for AB8500 2.x */
+	if (abx500_get_chip_id(&pdev->dev) < 0x30) {
+		struct ab8500_ext_regulator_info *info;
+
+		/* VextSupply3LPn is inverted on AB8500 2.x */
+		info = &ab8500_ext_regulator_info[AB8500_EXT_SUPPLY3];
+		info->update_val = 0x30;
+		info->update_val_en = 0x30;
+		info->update_val_en_lp = 0x10;
+	}
+
+	/* register all regulators */
+	for (i = 0; i < ARRAY_SIZE(ab8500_ext_regulator_info); i++) {
+		struct ab8500_ext_regulator_info *info = NULL;
+
+		/* assign per-regulator data */
+		info = &ab8500_ext_regulator_info[i];
+		info->dev = &pdev->dev;
+
+		/* register regulator with framework */
+		info->regulator = regulator_register(&info->desc, &pdev->dev,
+				&pdata->ext_regulator[i], info, NULL);
+		if (IS_ERR(info->regulator)) {
+			err = PTR_ERR(info->regulator);
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+					info->desc.name);
+			/* when we fail, un-register all earlier regulators */
+			while (--i >= 0) {
+				info = &ab8500_ext_regulator_info[i];
+				regulator_unregister(info->regulator);
+			}
+			return err;
+		}
+
+		dev_dbg(rdev_get_dev(info->regulator),
+			"%s-probed\n", info->desc.name);
+	}
+
+	return 0;
+}
+
+int ab8500_ext_regulator_exit(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab8500_ext_regulator_info); i++) {
+		struct ab8500_ext_regulator_info *info = NULL;
+		info = &ab8500_ext_regulator_info[i];
+
+		dev_vdbg(rdev_get_dev(info->regulator),
+			"%s-remove\n", info->desc.name);
+
+		regulator_unregister(info->regulator);
+	}
+
+	return 0;
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Bengt Jonsson <bengt.g.jonsson@stericsson.com>");
+MODULE_DESCRIPTION("AB8500 external regulator driver");
+MODULE_ALIAS("platform:ab8500-ext-regulator");
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3ccb9eb..f36a407 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1034,6 +1034,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			return err;
 	}
 
+	/* register external regulators (before Vaux1, 2 and 3) */
+	err = ab8500_ext_regulator_init(pdev);
+	if (err)
+		return err;
+
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		err = ab8500_regulator_register(pdev, &pdata->regulator[i], i, NULL);
@@ -1046,7 +1051,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
-	int i;
+	int i, err;
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		struct ab8500_regulator_info *info = NULL;
@@ -1058,6 +1063,11 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 		regulator_unregister(info->regulator);
 	}
 
+	/* remove external regulators (after Vaux1, 2 and 3) */
+	err = ab8500_ext_regulator_exit(pdev);
+	if (err)
+		return err;
+
 	return 0;
 }
 
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 3a8e026..63d2c4e 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -10,6 +10,8 @@
 #ifndef __LINUX_MFD_AB8500_REGULATOR_H
 #define __LINUX_MFD_AB8500_REGULATOR_H
 
+#include <linux/platform_device.h>
+
 /* AB8500 regulators */
 enum ab8500_regulator_id {
 	AB8500_LDO_AUX1,
@@ -152,11 +154,33 @@ enum ab9540_regulator_reg {
 	AB9540_NUM_REGULATOR_REGISTERS,
 };
 
+/* AB8500 external regulators */
+enum ab8500_ext_regulator_id {
+	AB8500_EXT_SUPPLY3,
+	AB8500_NUM_EXT_REGULATORS,
+};
+
 struct ab8500_regulator_platform_data {
 	int num_reg_init;
 	struct ab8500_regulator_reg_init *reg_init;
 	int num_regulator;
 	struct regulator_init_data *regulator;
+	int num_ext_regulator;
+	struct regulator_init_data *ext_regulator;
 };
 
+#ifdef CONFIG_REGULATOR_AB8500_EXT
+int ab8500_ext_regulator_init(struct platform_device *pdev);
+int ab8500_ext_regulator_exit(struct platform_device *pdev);
+#else
+inline int ab8500_ext_regulator_init(struct platform_device *pdev)
+{
+	return 0;
+}
+inline int ab8500_ext_regulator_exit(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 #endif
-- 
1.7.9.5

