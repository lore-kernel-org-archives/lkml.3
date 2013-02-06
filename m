Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3BFLGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37079 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab3BFKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        =?UTF-8?q?Ludovic=20Barr=C3=A9?= <ludovic.barre@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/49] regulator: ab8500: Add set_mode/get_mode support
Date: Wed,  6 Feb 2013 10:53:24 +0000
Message-Id: <1360148051-7560-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
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
 drivers/regulator/ab8500.c |   71 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 4d9d556..8426c8e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -33,6 +33,8 @@
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable regulator
+ * @update_val: bits holding the regulator current mode
+ * @update_val_idle: bits to enable the regulator in idle (low power) mode
  * @update_val_enable: bits to enable the regulator in normal (high power) mode
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
@@ -47,6 +49,8 @@ struct ab8500_regulator_info {
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
+	u8 update_val;
+	u8 update_val_idle;
 	u8 update_val_enable;
 	u8 voltage_bank;
 	u8 voltage_reg;
@@ -146,6 +150,63 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	return ret;
 }
 
+static int ab8500_regulator_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * update_val_enable is protected by mutex
+	 * into regulator/core.c layout
+	 */
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		info->update_val = info->update_val_enable;
+		break;
+	case REGULATOR_MODE_IDLE:
+		info->update_val = info->update_val_idle;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ab8500_regulator_enable(rdev);
+}
+
+static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
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
+	regval &=info->update_mask;
+	if (regval == info->update_val_enable)
+		ret = REGULATOR_MODE_NORMAL;
+	else if (regval == info->update_val_idle)
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
@@ -249,6 +310,8 @@ static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 static struct regulator_ops ab8500_regulator_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
+	.set_mode	= ab8500_regulator_set_mode,
+	.get_mode	= ab8500_regulator_get_mode,
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
@@ -284,6 +347,8 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
 		.update_val_enable	= 0x01,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
@@ -302,6 +367,8 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
 		.update_val_enable	= 0x04,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
@@ -320,6 +387,8 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
 		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
 		.update_val_enable	= 0x01,
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
@@ -338,6 +407,8 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x44,
 		.update_val_enable	= 0x04,
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
-- 
1.7.9.5

