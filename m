Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3BFLG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:57 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37659 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab3BFKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/49] regulator: ab8500: Add support of low voltage battery
Date: Wed,  6 Feb 2013 10:53:30 +0000
Message-Id: <1360148051-7560-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
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

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  125 +++++++-
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 +
 drivers/regulator/Kconfig                     |    8 +
 drivers/regulator/Makefile                    |    1 +
 drivers/regulator/ab8500-ext.c                |  391 +++++++++++++++++++++++++
 drivers/regulator/ab8500.c                    |   12 +-
 include/linux/regulator/ab8500.h              |   26 ++
 7 files changed, 560 insertions(+), 5 deletions(-)
 create mode 100644 drivers/regulator/ab8500-ext.c

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 0fd84d4..7cb52e6 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
+#include <mach/id.h> /* to identify older boards for fixes */
 #include "board-mop500-regulators.h"
 
 static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
@@ -258,13 +259,13 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VREFDDR,                0x03, 0x00),
 	/*
-	 * VextSupply1Regu          = HW control
-	 * VextSupply2Regu          = HW control
-	 * VextSupply3Regu          = HW control
+	 * VextSupply1Regu          = force LP
+	 * VextSupply2Regu          = force OFF
+	 * VextSupply3Regu          = force HP (-> STBB2=LP and TPS=LP)
 	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
 	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x1a),
+	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x13),
 	/*
 	 * Vaux1Regu                = force HP
 	 * Vaux2Regu                = force off
@@ -316,6 +317,7 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
 	[AB8500_LDO_AUX1] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-DISPLAY",
 			.min_uV = 2500000,
@@ -336,6 +338,7 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 	/* supplies to the on-board eMMC */
 	[AB8500_LDO_AUX2] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-eMMC1",
 			.min_uV = 1100000,
@@ -348,6 +351,7 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 	/* supply for VAUX3, supplies to SDcard slots */
 	[AB8500_LDO_AUX3] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-MMC-SD",
 			.min_uV = 1100000,
@@ -423,9 +427,122 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 };
 
+/* supply for VextSupply3 */
+static struct regulator_consumer_supply ab8500_ext_supply3_consumers[] = {
+	/* SIM supply for 3 V SIM cards */
+	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
+};
+
+/* extended configuration for VextSupply2, only used for HREFP_V20 boards */
+static struct ab8500_ext_regulator_cfg ab8500_ext_supply2 = {
+	.hwreq = true,
+};
+
+/*
+ * AB8500 external regulators
+ */
+static struct regulator_init_data ab8500_ext_regulators[] = {
+	/* fixed Vbat supplies VSMPS1_EXT_1V8 */
+	[AB8500_EXT_SUPPLY1] = {
+		.constraints = {
+			.name = "ab8500-ext-supply1",
+			.min_uV = 1800000,
+			.max_uV = 1800000,
+			.initial_mode = REGULATOR_MODE_IDLE,
+			.boot_on = 1,
+			.always_on = 1,
+		},
+	},
+	/* fixed Vbat supplies VSMPS2_EXT_1V36 and VSMPS5_EXT_1V15 */
+	[AB8500_EXT_SUPPLY2] = {
+		.constraints = {
+			.name = "ab8500-ext-supply2",
+			.min_uV = 1360000,
+			.max_uV = 1360000,
+		},
+	},
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
+
+static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
+		if (ab8500_reg_init[i].id == id) {
+			u8 initval = ab8500_reg_init[i].value;
+			initval = (initval & ~mask) | (value & mask);
+			ab8500_reg_init[i].value = initval;
+
+			BUG_ON(mask & ~ab8500_reg_init[i].mask);
+			return;
+		}
+	}
+
+	BUG_ON(1);
+}
+
+void mop500_regulator_init(void)
+{
+	struct regulator_init_data *regulator;
+
+	/*
+	 * Handle VextSupply1 on older boards than HREFP_V22_V1x
+	 * (turn off in suspend)
+	 */
+	if (cpu_is_u8500v20() || cpu_is_u8500v21()) {
+		/* disable VextSupply1 in suspend */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY1];
+		regulator->constraints.state_mem.disabled = 1;
+		regulator->constraints.state_standby.disabled = 1;
+	}
+
+	/*
+	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
+	 * all HREFP_V20 boards)
+	 */
+	if (cpu_is_u8500v20()) {
+		/* VextSupply2RequestCtrl =  HP/OFF depending on VxRequest */
+		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
+
+		/* VextSupply2SysClkReq1HPValid = SysClkReq1 controlled */
+		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
+			0x20, 0x20);
+
+		/* VextSupply2 = force HP at initialization */
+		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
+
+		/* enable VextSupply2 during platform active */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
+		regulator->constraints.always_on = 1;
+
+		/* disable VextSupply2 in suspend */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
+		regulator->constraints.state_mem.disabled = 1;
+		regulator->constraints.state_standby.disabled = 1;
+
+		/* enable VextSupply2 HW control (used in suspend) */
+		regulator->driver_data = (void *)&ab8500_ext_supply2;
+	}
+}
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9ca4869..3d4c412 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -18,4 +18,6 @@ extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
+void mop500_regulator_init(void);
+
 #endif
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
index 0000000..5f6ac8a
--- /dev/null
+++ b/drivers/regulator/ab8500-ext.c
@@ -0,0 +1,391 @@
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
+static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
+					 unsigned int mode)
+{
+	int ret = 0;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		info->update_val = info->update_val_hp;
+		break;
+	case REGULATOR_MODE_IDLE:
+		info->update_val = info->update_val_lp;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (info->is_enabled) {
+		u8 regval;
+
+		ret = enable(info, &regval);
+		if (ret < 0)
+			dev_err(rdev_get_dev(rdev),
+				"Could not set regulator mode.\n");
+
+		dev_dbg(rdev_get_dev(rdev),
+			"%s-set_mode (bank, reg, mask, value): "
+			"0x%x, 0x%x, 0x%x, 0x%x\n",
+			info->desc.name, info->update_bank, info->update_reg,
+			info->update_mask, regval);
+	}
+
+	return ret;
+}
+
+static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
+{
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (info->update_val == info->update_val_hp)
+		ret = REGULATOR_MODE_NORMAL;
+	else if (info->update_val == info->update_val_lp)
+		ret = REGULATOR_MODE_IDLE;
+	else
+		ret = -EINVAL;
+
+	return ret;
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
+	.set_mode		= ab8500_ext_regulator_set_mode,
+	.get_mode		= ab8500_ext_regulator_get_mode,
+	.get_voltage		= ab8500_ext_fixed_get_voltage,
+	.list_voltage		= ab8500_ext_list_voltage,
+};
+
+
+static struct ab8500_ext_regulator_info
+		ab8500_ext_regulator_info[AB8500_NUM_EXT_REGULATORS] = {
+	[AB8500_EXT_SUPPLY1] = {
+		.desc = {
+			.name		= "VEXTSUPPLY1",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1800000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_hp		= 0x01,
+		.update_val_lp		= 0x03,
+		.update_val_hw		= 0x02,
+	},
+	[AB8500_EXT_SUPPLY2] = {
+		.desc = {
+			.name		= "VEXTSUPPLY2",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1360000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_hp		= 0x04,
+		.update_val_lp		= 0x0c,
+		.update_val_hw		= 0x08,
+	},
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
index a7ec26f..1d73067 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -998,6 +998,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
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
@@ -1010,7 +1015,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
-	int i;
+	int i, err;
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		struct ab8500_regulator_info *info = NULL;
@@ -1022,6 +1027,11 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
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
index 3a8e026..6de36b5 100644
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
@@ -152,11 +154,35 @@ enum ab9540_regulator_reg {
 	AB9540_NUM_REGULATOR_REGISTERS,
 };
 
+/* AB8500 external regulators */
+enum ab8500_ext_regulator_id {
+	AB8500_EXT_SUPPLY1,
+	AB8500_EXT_SUPPLY2,
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

