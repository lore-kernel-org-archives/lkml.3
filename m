Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3BFK6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:58:41 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44697 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3BFKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:17 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        "xiaomei.zhang" <xiaomei.zhang@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 39/49] regulator: ab8500: Add new operations for Vaux3
Date: Wed,  6 Feb 2013 10:54:01 +0000
Message-Id: <1360148051-7560-40-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "xiaomei.zhang" <xiaomei.zhang@stericsson.com>

In former functions, only can set Vaux3 to 2.91V, because the
highest bit of Vaux3 register is put into another register. So
add new expanded functions for Vaux3's operation.

Signed-off-by: zhang xiaomei <xiaomei.zhang@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c |  120 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8c9f2ba..7f71acc 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -65,6 +65,13 @@ struct ab8500_regulator_info {
 	u8 voltage_mask;
 	u8 voltage_shift;
 	unsigned int delay;
+	struct {
+		u8 voltage_limit;
+		u8 voltage_bank;
+		u8 voltage_reg;
+		u8 voltage_mask;
+		u8 voltage_shift;
+	} expand_register;
 };
 
 /* voltage tables for the vauxn/vintcore supplies */
@@ -383,6 +390,57 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 	return val >> info->voltage_shift;
 }
 
+static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
+{
+	int ret, val;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval, regval_expand;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_get_register_interruptible(info->dev,
+			info->voltage_bank, info->voltage_reg, &regval);
+
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't read voltage reg for regulator\n");
+		return ret;
+	}
+
+	ret = abx500_get_register_interruptible(info->dev,
+			info->expand_register.voltage_bank,
+			info->expand_register.voltage_reg, &regval_expand);
+
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't read voltage reg for regulator\n");
+		return ret;
+	}
+
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+		" 0x%x\n",
+		info->desc.name, info->voltage_bank, info->voltage_reg,
+		info->voltage_mask, regval);
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-get_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+		" 0x%x\n",
+		info->desc.name, info->expand_register.voltage_bank,
+		info->expand_register.voltage_reg,
+		info->expand_register.voltage_mask, regval_expand);
+
+	if (regval_expand&(info->expand_register.voltage_mask))
+		/* Vaux3 has a different layout */
+		val = info->expand_register.voltage_limit;
+	else
+		val = (regval & info->voltage_mask) >> info->voltage_shift;
+
+	return val;
+}
+
 static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 					    unsigned selector)
 {
@@ -413,6 +471,46 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
+static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
+						unsigned selector)
+{
+	int ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (selector >= info->expand_register.voltage_limit) {
+		/* Vaux3 bit4 has different layout */
+		regval = (u8)selector << info->expand_register.voltage_shift;
+		ret = abx500_mask_and_set_register_interruptible(info->dev,
+					info->expand_register.voltage_bank,
+					info->expand_register.voltage_reg,
+					info->expand_register.voltage_mask,
+					regval);
+	} else {
+		/* set the registers for the request */
+		regval = (u8)selector << info->voltage_shift;
+		ret = abx500_mask_and_set_register_interruptible(info->dev,
+				info->voltage_bank, info->voltage_reg,
+				info->voltage_mask, regval);
+	}
+	if (ret < 0)
+		dev_err(rdev_get_dev(rdev),
+			"couldn't set voltage reg for regulator\n");
+
+	dev_vdbg(rdev_get_dev(rdev),
+			"%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+			" 0x%x\n",
+			info->desc.name, info->voltage_bank, info->voltage_reg,
+			info->voltage_mask, regval);
+
+	return ret;
+}
+
 static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 					     unsigned int old_sel,
 					     unsigned int new_sel)
@@ -435,6 +533,19 @@ static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
 };
 
+static struct regulator_ops ab8540_aux3_regulator_volt_mode_ops = {
+	.enable		= ab8500_regulator_enable,
+	.disable	= ab8500_regulator_disable,
+	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_mode	= ab8500_regulator_set_mode,
+	.get_mode	= ab8500_regulator_get_mode,
+	.is_enabled	= ab8500_regulator_is_enabled,
+	.get_voltage_sel = ab8540_aux3_regulator_get_voltage_sel,
+	.set_voltage_sel = ab8540_aux3_regulator_set_voltage_sel,
+	.list_voltage	= regulator_list_voltage_table,
+	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
+};
+
 static struct regulator_ops ab8500_regulator_volt_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
@@ -1260,7 +1371,7 @@ static struct ab8500_regulator_info
 	[AB8540_LDO_AUX3] = {
 		.desc = {
 			.name		= "LDO-AUX3",
-			.ops		= &ab8500_regulator_volt_mode_ops,
+			.ops		= &ab8540_aux3_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_AUX3,
 			.owner		= THIS_MODULE,
@@ -1277,6 +1388,13 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
+		.expand_register = {
+			.voltage_limit		= 8,
+			.voltage_bank		= 0x04,
+			.voltage_reg		= 0x01,
+			.voltage_mask		= 0x10,
+			.voltage_shift		= 1,
+		}
 	},
 	[AB8540_LDO_AUX4] = {
 		.desc = {
-- 
1.7.9.5

