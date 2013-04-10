Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765121Ab3DJGq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:46:27 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48096 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3DJGqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:46:25 -0400
Message-ID: <1365576380.4283.5.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: ab8500: Optimize
 ab8540_aux3_regulator_get_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 14:46:20 +0800
In-Reply-To: <1365576052.4283.2.camel@phoenix>
References: <1365576052.4283.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can save a register read operation in some case if read
expand_register first.
If info->expand_register.voltage_mask bit is set, no need to read
voltage_reg.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 222a63e..7a86fe6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -521,7 +521,7 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 
 static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
-	int ret, val;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	u8 regval, regval_expand;
 
@@ -531,18 +531,25 @@ static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
 	}
 
 	ret = abx500_get_register_interruptible(info->dev,
-			info->voltage_bank, info->voltage_reg, &regval);
-
+			info->expand_register.voltage_bank,
+			info->expand_register.voltage_reg, &regval_expand);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
-			"couldn't read voltage reg for regulator\n");
+			"couldn't read voltage expand reg for regulator\n");
 		return ret;
 	}
 
-	ret = abx500_get_register_interruptible(info->dev,
-			info->expand_register.voltage_bank,
-			info->expand_register.voltage_reg, &regval_expand);
+	dev_vdbg(rdev_get_dev(rdev),
+		 "%s-get_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		 info->desc.name, info->expand_register.voltage_bank,
+		 info->expand_register.voltage_reg,
+		 info->expand_register.voltage_mask, regval_expand);
+
+	if (regval_expand & info->expand_register.voltage_mask)
+		return info->expand_register.voltage_limit;
 
+	ret = abx500_get_register_interruptible(info->dev,
+			info->voltage_bank, info->voltage_reg, &regval);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't read voltage reg for regulator\n");
@@ -550,24 +557,11 @@ static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
 	}
 
 	dev_vdbg(rdev_get_dev(rdev),
-		"%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
-		" 0x%x\n",
-		info->desc.name, info->voltage_bank, info->voltage_reg,
-		info->voltage_mask, regval);
-	dev_vdbg(rdev_get_dev(rdev),
-		"%s-get_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
-		" 0x%x\n",
-		info->desc.name, info->expand_register.voltage_bank,
-		info->expand_register.voltage_reg,
-		info->expand_register.voltage_mask, regval_expand);
-
-	if (regval_expand&(info->expand_register.voltage_mask))
-		/* Vaux3 has a different layout */
-		val = info->expand_register.voltage_limit;
-	else
-		val = (regval & info->voltage_mask) >> info->voltage_shift;
+		 "%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		 info->desc.name, info->voltage_bank, info->voltage_reg,
+		 info->voltage_mask, regval);
 
-	return val;
+	return (regval & info->voltage_mask) >> info->voltage_shift;
 }
 
 static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
-- 
1.7.10.4



