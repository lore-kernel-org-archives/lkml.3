Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3BFK6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:58:06 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:58409 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3BFKzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 41/49] regulator: ab8500: Add mode operation for v-amic
Date: Wed,  6 Feb 2013 10:54:03 +0000
Message-Id: <1360148051-7560-42-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v-amic1 and v-amic2 regulators have dedicated mode registers
and share the same mode bit. This patch adds special handling
for those regulators.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   10 +-
 drivers/regulator/ab8500.c                    |  178 ++++++++++++++++++++++---
 2 files changed, 167 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 793bdae..b4b284e 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -880,7 +880,10 @@ struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 	[AB8505_LDO_ANAMIC1] = {
 		.constraints = {
 			.name = "V-AMIC1",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic1_consumers),
 		.consumer_supplies = ab8500_vamic1_consumers,
@@ -889,7 +892,10 @@ struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 	[AB8505_LDO_ANAMIC2] = {
 		.constraints = {
 			.name = "V-AMIC2",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
 		.consumer_supplies = ab8500_vamic2_consumers,
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 4cd0d28..653c298 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -30,10 +30,22 @@
 #include <linux/slab.h>
 
 /**
+ * struct ab8500_shared_mode - is used when mode is shared between
+ * two regulators.
+ * @shared_regulator: pointer to the other sharing regulator
+ * @lp_mode_req: low power mode requested by this regulator
+ */
+struct ab8500_shared_mode {
+	struct ab8500_regulator_info *shared_regulator;
+	bool lp_mode_req;
+};
+
+/**
  * struct ab8500_regulator_info - ab8500 regulator information
  * @dev: device pointer
  * @desc: regulator description
  * @regulator_dev: regulator device
+ * @shared_mode: used when mode is shared between two regulators
  * @is_enabled: status of regulator (on/off)
  * @load_lp_uA: maximum load in idle (low power) mode
  * @update_bank: bank to control on/off
@@ -42,6 +54,11 @@
  * @update_val: bits holding the regulator current mode
  * @update_val_idle: bits to enable the regulator in idle (low power) mode
  * @update_val_normal: bits to enable the regulator in normal (high power) mode
+ * @mode_bank: bank with location of mode register
+ * @mode_reg: mode register
+ * @mode_mask: mask for setting mode
+ * @mode_val_idle: mode setting for low power
+ * @mode_val_normal: mode setting for normal power
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
@@ -52,6 +69,7 @@ struct ab8500_regulator_info {
 	struct device		*dev;
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
+	struct ab8500_shared_mode *shared_mode;
 	bool is_enabled;
 	int load_lp_uA;
 	u8 update_bank;
@@ -60,6 +78,11 @@ struct ab8500_regulator_info {
 	u8 update_val;
 	u8 update_val_idle;
 	u8 update_val_normal;
+	u8 mode_bank;
+	u8 mode_reg;
+	u8 mode_mask;
+	u8 mode_val_idle;
+	u8 mode_val_normal;
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
@@ -191,6 +214,10 @@ static const int ldo_vaudio_voltages[] = {
 	2600000,	/* Duplicated in Vaudio and IsoUicc Control register. */
 };
 
+static DEFINE_MUTEX(shared_mode_mutex);
+static struct ab8500_shared_mode ldo_anamic1_shared;
+static struct ab8500_shared_mode ldo_anamic2_shared;
+
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
@@ -270,7 +297,11 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
 	int ret = 0;
-
+	u8 bank;
+	u8 reg;
+	u8 mask;
+	u8 val;
+	bool dmr = false; /* Dedicated mode register */
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL) {
@@ -278,21 +309,72 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	switch (mode) {
-	case REGULATOR_MODE_NORMAL:
-		info->update_val = info->update_val_normal;
-		break;
-	case REGULATOR_MODE_IDLE:
-		info->update_val = info->update_val_idle;
-		break;
-	default:
-		return -EINVAL;
+	if (info->shared_mode) {
+		/*
+		 * Special case where mode is shared between two regulators.
+		 */
+		struct ab8500_shared_mode *sm = info->shared_mode;
+		mutex_lock(&shared_mode_mutex);
+
+		if (mode == REGULATOR_MODE_IDLE) {
+			sm->lp_mode_req = true; /* Low power mode requested */
+			if (!((sm->shared_regulator)->
+			      shared_mode->lp_mode_req)) {
+				mutex_unlock(&shared_mode_mutex);
+				return 0; /* Other regulator prevent LP mode */
+			}
+		} else {
+			sm->lp_mode_req = false;
+		}
 	}
 
-	if (info->is_enabled) {
+	if (info->mode_mask) {
+		/* Dedicated register for handling mode */
+
+		dmr = true;
+
+		switch (mode) {
+		case REGULATOR_MODE_NORMAL:
+			val = info->mode_val_normal;
+			break;
+		case REGULATOR_MODE_IDLE:
+			val = info->mode_val_idle;
+			break;
+		default:
+			if (info->shared_mode)
+				mutex_unlock(&shared_mode_mutex);
+			return -EINVAL;
+		}
+
+		bank = info->mode_bank;
+		reg = info->mode_reg;
+		mask = info->mode_mask;
+	} else {
+		/* Mode register same as enable register */
+
+		switch (mode) {
+		case REGULATOR_MODE_NORMAL:
+			info->update_val = info->update_val_normal;
+			val = info->update_val_normal;
+			break;
+		case REGULATOR_MODE_IDLE:
+			info->update_val = info->update_val_idle;
+			val = info->update_val_idle;
+			break;
+		default:
+			if (info->shared_mode)
+				mutex_unlock(&shared_mode_mutex);
+			return -EINVAL;
+		}
+
+		bank = info->update_bank;
+		reg = info->update_reg;
+		mask = info->update_mask;
+	}
+
+	if (info->is_enabled || dmr) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
-			info->update_bank, info->update_reg,
-			info->update_mask, info->update_val);
+			bank, reg, mask, val);
 		if (ret < 0)
 			dev_err(rdev_get_dev(rdev),
 				"couldn't set regulator mode\n");
@@ -300,10 +382,13 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		dev_vdbg(rdev_get_dev(rdev),
 			"%s-set_mode (bank, reg, mask, value): "
 			"0x%x, 0x%x, 0x%x, 0x%x\n",
-			info->desc.name, info->update_bank, info->update_reg,
-			info->update_mask, info->update_val);
+			info->desc.name, bank, reg,
+			mask, val);
 	}
 
+	if (info->shared_mode)
+		mutex_unlock(&shared_mode_mutex);
+
 	return ret;
 }
 
@@ -311,15 +396,41 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret;
+	u8 val;
+	u8 val_normal;
+	u8 val_idle;
 
 	if (info == NULL) {
 		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
 	}
 
-	if (info->update_val == info->update_val_normal)
+	/* Need special handling for shared mode */
+	if (info->shared_mode) {
+		if (info->shared_mode->lp_mode_req)
+			return REGULATOR_MODE_IDLE;
+		else
+			return REGULATOR_MODE_NORMAL;
+	}
+
+	if (info->mode_mask) {
+		/* Dedicated register for handling mode */
+		ret = abx500_get_register_interruptible(info->dev,
+		info->mode_bank, info->mode_reg, &val);
+		val = val & info->mode_mask;
+
+		val_normal = info->mode_val_normal;
+		val_idle = info->mode_val_idle;
+	} else {
+		/* Mode register same as enable register */
+		val = info->update_val;
+		val_normal = info->update_val_normal;
+		val_idle = info->update_val_idle;
+	}
+
+	if (val == val_normal)
 		ret = REGULATOR_MODE_NORMAL;
-	else if (info->update_val == info->update_val_idle)
+	else if (val == val_idle)
 		ret = REGULATOR_MODE_IDLE;
 	else
 		ret = -EINVAL;
@@ -574,6 +685,15 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.list_voltage		= regulator_list_voltage_table,
 };
 
+static struct regulator_ops ab8500_regulator_anamic_mode_ops = {
+	.enable		= ab8500_regulator_enable,
+	.disable	= ab8500_regulator_disable,
+	.is_enabled	= ab8500_regulator_is_enabled,
+	.set_mode	= ab8500_regulator_set_mode,
+	.get_mode	= ab8500_regulator_get_mode,
+	.list_voltage	= regulator_list_voltage_table,
+};
+
 /* AB8500 regulator information */
 static struct ab8500_regulator_info
 		ab8500_regulator_info[AB8500_NUM_REGULATORS] = {
@@ -1004,32 +1124,44 @@ static struct ab8500_regulator_info
 	[AB8505_LDO_ANAMIC1] = {
 		.desc = {
 			.name		= "LDO-ANAMIC1",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_anamic_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8505_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
 		},
+		.shared_mode = &ldo_anamic1_shared,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
 		.update_val		= 0x08,
+		.mode_bank		= 0x01,
+		.mode_reg		= 0x54,
+		.mode_mask		= 0x04,
+		.mode_val_idle		= 0x04,
+		.mode_val_normal	= 0x00,
 	},
 	[AB8505_LDO_ANAMIC2] = {
 		.desc = {
 			.name		= "LDO-ANAMIC2",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_anamic_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8505_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
 		},
+		.shared_mode = &ldo_anamic2_shared,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
 		.update_val		= 0x10,
+		.mode_bank		= 0x01,
+		.mode_reg		= 0x54,
+		.mode_mask		= 0x04,
+		.mode_val_idle		= 0x04,
+		.mode_val_normal	= 0x00,
 	},
 	[AB8505_LDO_AUX8] = {
 		.desc = {
@@ -1564,6 +1696,14 @@ static struct ab8500_regulator_info
 	},
 };
 
+static struct ab8500_shared_mode ldo_anamic1_shared = {
+	.shared_regulator = &ab8505_regulator_info[AB8505_LDO_ANAMIC2],
+};
+
+static struct ab8500_shared_mode ldo_anamic2_shared = {
+	.shared_regulator = &ab8505_regulator_info[AB8505_LDO_ANAMIC1],
+};
+
 struct ab8500_reg_init {
 	u8 bank;
 	u8 addr;
-- 
1.7.9.5

