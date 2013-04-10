Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623Ab3DJGlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:41:02 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37469 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935294Ab3DJGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:40:59 -0400
Message-ID: <1365576052.4283.2.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: ab8500: Fix set voltage for
 AB8540_LDO_AUX3
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 14:40:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting voltage for AB8540_LDO_AUX3, current code only updates one of
info->voltage_reg and info->expand_register registers which is wrong.
To ensure we set to correct voltage, it always needs to clear or set
expand_register.voltage_mask bit of expand_register.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   55 ++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 9ebd131..222a63e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -605,39 +605,54 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
 {
 	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-	u8 regval;
+	u8 regval, regval_expand;
 
 	if (info == NULL) {
 		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
 	}
 
-	if (selector >= info->expand_register.voltage_limit) {
-		/* Vaux3 bit4 has different layout */
-		regval = (u8)selector << info->expand_register.voltage_shift;
-		ret = abx500_mask_and_set_register_interruptible(info->dev,
-					info->expand_register.voltage_bank,
-					info->expand_register.voltage_reg,
-					info->expand_register.voltage_mask,
-					regval);
-	} else {
-		/* set the registers for the request */
-		regval = (u8)selector << info->voltage_shift;
-		ret = abx500_mask_and_set_register_interruptible(info->dev,
+	if (selector >= info->expand_register.voltage_limit)
+		regval_expand = info->expand_register.voltage_mask;
+	else
+		regval_expand = 0;
+
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+				info->expand_register.voltage_bank,
+				info->expand_register.voltage_reg,
+				info->expand_register.voltage_mask,
+				regval_expand);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't set expand voltage reg for regulator\n");
+		return ret;
+	}
+
+	dev_vdbg(rdev_get_dev(rdev),
+		 "%s-set_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		 info->desc.name, info->expand_register.voltage_bank,
+		 info->expand_register.voltage_reg,
+		 info->expand_register.voltage_mask, regval_expand);
+
+	if (selector >= info->expand_register.voltage_limit)
+		return 0;
+
+	regval = (u8)selector << info->voltage_shift;
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
 				info->voltage_bank, info->voltage_reg,
 				info->voltage_mask, regval);
-	}
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set voltage reg for regulator\n");
+		return ret;
+	}
 
 	dev_vdbg(rdev_get_dev(rdev),
-			"%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
-			" 0x%x\n",
-			info->desc.name, info->voltage_bank, info->voltage_reg,
-			info->voltage_mask, regval);
+		 "%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		 info->desc.name, info->voltage_bank, info->voltage_reg,
+		 info->voltage_mask, regval);
 
-	return ret;
+	return 0;
 }
 
 static struct regulator_ops ab8500_regulator_volt_mode_ops = {
-- 
1.7.10.4



