Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3BFLGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:48 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61492 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3BFKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/49] regulator: ab8500: Added get_optimum_mode on regulators with idle mode
Date: Wed,  6 Feb 2013 10:53:26 +0000
Message-Id: <1360148051-7560-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

With this change, Vtvout, Vintcore12, Vaux1, 2 and 3 regulators
support DRMS (Dynamic Regulator Mode Switching) which will
dynamically handle requests for max current consumption from
several consumers and select a suitable regulator mode.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/regulator/ab8500.c |  115 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ebf4195..be9d842 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -31,6 +31,7 @@
  * @desc: regulator description
  * @regulator_dev: regulator device
  * @is_enabled: status of regulator (on/off)
+ * @load_lp_uA: maximum load in idle (low power) mode
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable and set mode of regulator
@@ -48,6 +49,7 @@ struct ab8500_regulator_info {
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
 	bool is_enabled;
+	int load_lp_uA;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
@@ -156,6 +158,27 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	return ret;
 }
 
+static unsigned int ab8500_regulator_get_optimum_mode(
+		struct regulator_dev *rdev, int input_uV,
+		int output_uV, int load_uA)
+{
+	unsigned int mode;
+
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (load_uA <= info->load_lp_uA)
+		mode = REGULATOR_MODE_IDLE;
+	else
+		mode = REGULATOR_MODE_NORMAL;
+
+	return mode;
+}
+
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
@@ -186,6 +209,12 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		if (ret < 0)
 			dev_err(rdev_get_dev(rdev),
 				"couldn't set regulator mode\n");
+
+		dev_vdbg(rdev_get_dev(rdev),
+			"%s-set_mode (bank, reg, mask, value): "
+			"0x%x, 0x%x, 0x%x, 0x%x\n",
+			info->desc.name, info->update_bank, info->update_reg,
+			info->update_mask, info->update_val);
 	}
 
 	return ret;
@@ -313,29 +342,43 @@ static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	return info->delay;
 }
 
-static struct regulator_ops ab8500_regulator_ops = {
-	.enable		= ab8500_regulator_enable,
-	.disable	= ab8500_regulator_disable,
-	.set_mode	= ab8500_regulator_set_mode,
-	.get_mode	= ab8500_regulator_get_mode,
-	.is_enabled	= ab8500_regulator_is_enabled,
-	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
-	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
-	.list_voltage	= regulator_list_voltage_table,
-	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
+static struct regulator_ops ab8500_regulator_volt_mode_ops = {
+	.enable			= ab8500_regulator_enable,
+	.disable		= ab8500_regulator_disable,
+	.is_enabled		= ab8500_regulator_is_enabled,
+	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_mode		= ab8500_regulator_set_mode,
+	.get_mode		= ab8500_regulator_get_mode,
+	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
+	.set_voltage_sel	= ab8500_regulator_set_voltage_sel,
+	.list_voltage		= regulator_list_voltage_table,
+	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
 };
 
-static struct regulator_ops ab8500_regulator_fixed_ops = {
-	.enable		= ab8500_regulator_enable,
-	.disable	= ab8500_regulator_disable,
-	.is_enabled	= ab8500_regulator_is_enabled,
-	.list_voltage	= regulator_list_voltage_linear,
+static struct regulator_ops ab8500_regulator_mode_ops = {
+	.enable			= ab8500_regulator_enable,
+	.disable		= ab8500_regulator_disable,
+	.is_enabled		= ab8500_regulator_is_enabled,
+	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_mode		= ab8500_regulator_set_mode,
+	.get_mode		= ab8500_regulator_get_mode,
+	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
+	.list_voltage		= regulator_list_voltage_table,
+	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
+};
+
+static struct regulator_ops ab8500_regulator_ops = {
+	.enable			= ab8500_regulator_enable,
+	.disable		= ab8500_regulator_disable,
+	.is_enabled		= ab8500_regulator_is_enabled,
+	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
+	.list_voltage		= regulator_list_voltage_table,
 };
 
 static struct ab8500_regulator_info
 		ab8500_regulator_info[AB8500_NUM_REGULATORS] = {
 	/*
-	 * Variable Voltage Regulators
+	 * Regulators with variable voltage and normal/idle modes
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
 	 *   volt bank, reg, mask
@@ -343,13 +386,14 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_AUX1] = {
 		.desc = {
 			.name		= "LDO-AUX1",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
 		},
+		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x03,
@@ -363,13 +407,14 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_AUX2] = {
 		.desc = {
 			.name		= "LDO-AUX2",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
 		},
+		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x0c,
@@ -383,13 +428,14 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_AUX3] = {
 		.desc = {
 			.name		= "LDO-AUX3",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
 		},
+		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
 		.update_mask		= 0x03,
@@ -403,13 +449,14 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_INTCORE] = {
 		.desc = {
 			.name		= "LDO-INTCORE",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
 		},
+		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
@@ -423,14 +470,14 @@ static struct ab8500_regulator_info
 	},
 
 	/*
-	 * Fixed Voltage Regulators
+	 * Regulators with fixed voltage and normal/idle modes
 	 *   name, fixed mV,
 	 *   update bank, reg, mask, enable val
 	 */
 	[AB8500_LDO_TVOUT] = {
 		.desc = {
 			.name		= "LDO-TVOUT",
-			.ops		= &ab8500_regulator_fixed_ops,
+			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
@@ -439,10 +486,13 @@ static struct ab8500_regulator_info
 			.enable_time	= 10000,
 		},
 		.delay			= 10000,
+		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x82,
 		.update_val		= 0x02,
+		.update_val_idle	= 0x82,
+		.update_val_normal	= 0x02,
 	},
 	[AB8500_LDO_USB] = {
 		.desc = {
@@ -459,10 +509,14 @@ static struct ab8500_regulator_info
 		.update_mask            = 0x03,
 		.update_val_enable      = 0x01,
 	},
+
+	/*
+	 * Regulators with fixed voltage and normal mode
+	 */
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
-			.ops		= &ab8500_regulator_fixed_ops,
+			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
@@ -477,7 +531,7 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_ANAMIC1] = {
 		.desc = {
 			.name		= "LDO-ANAMIC1",
-			.ops		= &ab8500_regulator_fixed_ops,
+			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
@@ -492,7 +546,7 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_ANAMIC2] = {
 		.desc = {
 			.name		= "LDO-ANAMIC2",
-			.ops		= &ab8500_regulator_fixed_ops,
+			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
@@ -507,7 +561,7 @@ static struct ab8500_regulator_info
 	[AB8500_LDO_DMIC] = {
 		.desc = {
 			.name		= "LDO-DMIC",
-			.ops		= &ab8500_regulator_fixed_ops,
+			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
@@ -519,20 +573,27 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x04,
 		.update_val		= 0x04,
 	},
+
+	/*
+	 * Regulators with fixed voltage and normal/idle modes
+	 */
 	[AB8500_LDO_ANA] = {
 		.desc = {
 			.name		= "LDO-ANA",
-			.ops		= &ab8500_regulator_fixed_ops,
+			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 1200000,
 		},
+		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
 		.update_mask		= 0x0c,
 		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x04,
 	},
 
 
-- 
1.7.9.5

