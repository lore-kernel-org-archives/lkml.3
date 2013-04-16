Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935953Ab3DPOqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:46:50 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52729 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935614Ab3DPOqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:46:45 -0400
Message-ID: <1366123590.14735.1.camel@phoenix>
Subject: [PATCH v2] regulator: ab8500: Fix set voltage for AB8540_LDO_AUX3
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 16 Apr 2013 22:46:30 +0800
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

The function of the expand register bit is the following (from the user manual):
0: VAUX3 output voltage is determined by Vaux3Sel bit settings in register
   VldoCVaux3Sel
1: VAUX3 output voltage is set to 3.05V regardless of Vaux3Sel settings in
   register VldoCVaux3Sel (VldoCVaux3Sel is the register at 0x0421)

So when going to 3.05V, set the expand register bit.
When leaving 3.05V for another voltage, set the target voltage before clearing
the expand register bit.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   69 ++++++++++++++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0a62ef9..84e064b 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -612,32 +612,65 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	/* Set the expand register bit for 3.05V.
+	   Once expand register bit is set, VAUX3 output voltage is set to 3.05V
+	   regardless of Vaux3Sel settings in register VldoCVaux3Sel.
+	 */
 	if (selector >= info->expand_register.voltage_limit) {
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
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
-				info->voltage_bank, info->voltage_reg,
-				info->voltage_mask, regval);
+				info->expand_register.voltage_bank,
+				info->expand_register.voltage_reg,
+				info->expand_register.voltage_mask,
+				info->expand_register.voltage_mask);
+		if (ret < 0) {
+			dev_err(rdev_get_dev(rdev),
+				"couldn't set expand voltage reg for regulator\n");
+			return ret;
+		}
+
+		dev_vdbg(rdev_get_dev(rdev),
+			 "%s-set_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+			 info->desc.name, info->expand_register.voltage_bank,
+			 info->expand_register.voltage_reg,
+			 info->expand_register.voltage_mask,
+			 info->expand_register.voltage_mask);
+
+		return 0;
 	}
-	if (ret < 0)
+
+	/* Set target voltage before clearing the expand register bit */
+	regval = (u8)selector << info->voltage_shift;
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+			info->voltage_bank, info->voltage_reg,
+			info->voltage_mask, regval);
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
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+			info->expand_register.voltage_bank,
+			info->expand_register.voltage_reg,
+			info->expand_register.voltage_mask, 0);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't clear expand voltage reg for regulator\n");
+		return ret;
+	}
+
+	dev_vdbg(rdev_get_dev(rdev),
+		 "%s-set_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		 info->desc.name, info->expand_register.voltage_bank,
+		 info->expand_register.voltage_reg,
+		 info->expand_register.voltage_mask, 0);
+
+	return 0;
 }
 
 static struct regulator_ops ab8500_regulator_volt_mode_ops = {
-- 
1.7.10.4



