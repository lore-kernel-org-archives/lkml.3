Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab3CUQOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:14:23 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:38461 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3CUQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:00:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        =?UTF-8?q?Ludovic=20Barr=C3=A9?= <ludovic.barre@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/46] regulator: ab8500: Add set_mode/get_mode support
Date: Thu, 21 Mar 2013 15:58:59 +0000
Message-Id: <1363881583-15234-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emeric Vigier <emeric.vigier@stericsson.com>

Signed-off-by: Ludovic Barré <ludovic.barre@stericsson.com>
Signed-off-by: Emeric Vigier <emeric.vigier@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
---
 drivers/regulator/ab8500.c |  112 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 94 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 4d9d556..283d9a5 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -30,10 +30,13 @@
  * @dev: device pointer
  * @desc: regulator description
  * @regulator_dev: regulator device
+ * @is_enabled: status of regulator (on/off)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
- * @update_mask: mask to enable/disable regulator
- * @update_val_enable: bits to enable the regulator in normal (high power) mode
+ * @update_mask: mask to enable/disable and set mode of regulator
+ * @update_val: bits holding the regulator current mode
+ * @update_val_idle: bits to enable the regulator in idle (low power) mode
+ * @update_val_normal: bits to enable the regulator in normal (high power) mode
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
@@ -44,10 +47,13 @@ struct ab8500_regulator_info {
 	struct device		*dev;
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
+	bool is_enabled;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
-	u8 update_val_enable;
+	u8 update_val;
+	u8 update_val_idle;
+	u8 update_val_normal;
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
@@ -108,15 +114,17 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 
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
@@ -138,6 +146,8 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
 
+	info->is_enabled = false;
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -146,6 +156,61 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	return ret;
 }
 
+static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
+{
+	int ret = 0;
+
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		info->update_val = info->update_val_normal;
+		break;
+	case REGULATOR_MODE_IDLE:
+		info->update_val = info->update_val_idle;
+		break;
+	default:
+		return -EINVAL;
+	}
+
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
+}
+
+static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (info->update_val == info->update_val_normal)
+		ret = REGULATOR_MODE_NORMAL;
+	else if (info->update_val == info->update_val_idle)
+		ret = REGULATOR_MODE_IDLE;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
 static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 {
 	int ret;
@@ -172,9 +237,11 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
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
@@ -249,6 +316,8 @@ static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 static struct regulator_ops ab8500_regulator_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
+	.set_mode	= ab8500_regulator_set_mode,
+	.get_mode	= ab8500_regulator_get_mode,
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
@@ -284,7 +353,9 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x03,
-		.update_val_enable	= 0x01,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
@@ -302,7 +373,9 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x0c,
-		.update_val_enable	= 0x04,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x04,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
@@ -320,7 +393,9 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
 		.update_mask		= 0x03,
-		.update_val_enable	= 0x01,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
@@ -338,7 +413,9 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
-		.update_val_enable	= 0x04,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x44,
+		.update_val_normal	= 0x04,
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
@@ -365,7 +442,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x82,
-		.update_val_enable	= 0x02,
+		.update_val		= 0x02,
 	},
 	[AB8500_LDO_USB] = {
 		.desc = {
@@ -380,7 +457,6 @@ static struct ab8500_regulator_info
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
-		.update_val_enable      = 0x01,
 	},
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
@@ -395,7 +471,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
-		.update_val_enable	= 0x02,
+		.update_val		= 0x02,
 	},
 	[AB8500_LDO_ANAMIC1] = {
 		.desc = {
@@ -410,7 +486,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
-		.update_val_enable	= 0x08,
+		.update_val		= 0x08,
 	},
 	[AB8500_LDO_ANAMIC2] = {
 		.desc = {
@@ -425,7 +501,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
-		.update_val_enable	= 0x10,
+		.update_val		= 0x10,
 	},
 	[AB8500_LDO_DMIC] = {
 		.desc = {
@@ -440,7 +516,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
-		.update_val_enable	= 0x04,
+		.update_val		= 0x04,
 	},
 	[AB8500_LDO_ANA] = {
 		.desc = {
@@ -455,7 +531,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
 		.update_mask		= 0x0c,
-		.update_val_enable	= 0x04,
+		.update_val		= 0x04,
 	},
 
 
-- 
1.7.10.4

