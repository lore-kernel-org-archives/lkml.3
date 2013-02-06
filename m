Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3BFLGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:51 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:65020 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3BFKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/49] regulator: ab8500: Fix for regulator_set_mode functionality
Date: Wed,  6 Feb 2013 10:53:25 +0000
Message-Id: <1360148051-7560-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Reviewed-by: Emeric VIGIER <emeric.vigier@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500.c |   78 ++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8426c8e..ebf4195 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -30,12 +30,13 @@
  * @dev: device pointer
  * @desc: regulator description
  * @regulator_dev: regulator device
+ * @is_enabled: status of regulator (on/off)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
- * @update_mask: mask to enable/disable regulator
+ * @update_mask: mask to enable/disable and set mode of regulator
  * @update_val: bits holding the regulator current mode
  * @update_val_idle: bits to enable the regulator in idle (low power) mode
- * @update_val_enable: bits to enable the regulator in normal (high power) mode
+ * @update_val_normal: bits to enable the regulator in normal (high power) mode
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
@@ -46,12 +47,13 @@ struct ab8500_regulator_info {
 	struct device		*dev;
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
+	bool is_enabled;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
 	u8 update_val;
 	u8 update_val_idle;
-	u8 update_val_enable;
+	u8 update_val_normal;
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
@@ -112,15 +114,17 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
-		info->update_mask, info->update_val_enable);
+		info->update_mask, info->update_val);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
 
+	info->is_enabled = true;
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-enable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
-		info->update_mask, info->update_val_enable);
+		info->update_mask, info->update_val);
 
 	return ret;
 }
@@ -142,6 +146,8 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
 
+	info->is_enabled = false;
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -150,8 +156,11 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	return ret;
 }
 
-static int ab8500_regulator_set_mode(struct regulator_dev *rdev, unsigned int mode)
+static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
 {
+	int ret = 0;
+
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL) {
@@ -159,13 +168,9 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev, unsigned int mo
 		return -EINVAL;
 	}
 
-	/*
-	 * update_val_enable is protected by mutex
-	 * into regulator/core.c layout
-	 */
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
-		info->update_val = info->update_val_enable;
+		info->update_val = info->update_val_normal;
 		break;
 	case REGULATOR_MODE_IDLE:
 		info->update_val = info->update_val_idle;
@@ -174,32 +179,31 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev, unsigned int mo
 		return -EINVAL;
 	}
 
-	return ab8500_regulator_enable(rdev);
+	if (info->is_enabled) {
+		ret = abx500_mask_and_set_register_interruptible(info->dev,
+			info->update_bank, info->update_reg,
+			info->update_mask, info->update_val);
+		if (ret < 0)
+			dev_err(rdev_get_dev(rdev),
+				"couldn't set regulator mode\n");
+	}
+
+	return ret;
 }
 
 static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret;
-	u8 regval;
 
 	if (info == NULL) {
 		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
 	}
 
-	ret = abx500_get_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, &regval);
-	if (ret < 0) {
-		dev_err(rdev_get_dev(rdev),
-			"couldn't read 0x%x register\n", info->update_reg);
-		return ret;
-	}
-
-	regval &=info->update_mask;
-	if (regval == info->update_val_enable)
+	if (info->update_val == info->update_val_normal)
 		ret = REGULATOR_MODE_NORMAL;
-	else if (regval == info->update_val_idle)
+	else if (info->update_val == info->update_val_idle)
 		ret = REGULATOR_MODE_IDLE;
 	else
 		ret = -EINVAL;
@@ -233,9 +237,11 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 		info->update_mask, regval);
 
 	if (regval & info->update_mask)
-		return true;
+		info->is_enabled = true;
 	else
-		return false;
+		info->is_enabled = false;
+
+	return info->is_enabled;
 }
 
 static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
@@ -349,7 +355,7 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x03,
 		.update_val		= 0x01,
 		.update_val_idle	= 0x03,
-		.update_val_enable	= 0x01,
+		.update_val_normal	= 0x01,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
@@ -369,7 +375,7 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x0c,
 		.update_val		= 0x04,
 		.update_val_idle	= 0x0c,
-		.update_val_enable	= 0x04,
+		.update_val_normal	= 0x04,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
@@ -389,7 +395,7 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x03,
 		.update_val		= 0x01,
 		.update_val_idle	= 0x03,
-		.update_val_enable	= 0x01,
+		.update_val_normal	= 0x01,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
@@ -409,7 +415,7 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x44,
 		.update_val		= 0x04,
 		.update_val_idle	= 0x44,
-		.update_val_enable	= 0x04,
+		.update_val_normal	= 0x04,
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
@@ -436,7 +442,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x82,
-		.update_val_enable	= 0x02,
+		.update_val		= 0x02,
 	},
 	[AB8500_LDO_USB] = {
 		.desc = {
@@ -466,7 +472,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
-		.update_val_enable	= 0x02,
+		.update_val		= 0x02,
 	},
 	[AB8500_LDO_ANAMIC1] = {
 		.desc = {
@@ -481,7 +487,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
-		.update_val_enable	= 0x08,
+		.update_val		= 0x08,
 	},
 	[AB8500_LDO_ANAMIC2] = {
 		.desc = {
@@ -496,7 +502,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
-		.update_val_enable	= 0x10,
+		.update_val		= 0x10,
 	},
 	[AB8500_LDO_DMIC] = {
 		.desc = {
@@ -511,7 +517,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
-		.update_val_enable	= 0x04,
+		.update_val		= 0x04,
 	},
 	[AB8500_LDO_ANA] = {
 		.desc = {
@@ -526,7 +532,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
 		.update_mask		= 0x0c,
-		.update_val_enable	= 0x04,
+		.update_val		= 0x04,
 	},
 
 
-- 
1.7.9.5

