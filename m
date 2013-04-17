Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966847Ab3DQOzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:55:54 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64679 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966461Ab3DQOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:55:51 -0400
Message-ID: <1366210545.15800.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: ab8500: Get rid of voltage_shift field from
 struct ab8500_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 22:55:45 +0800
In-Reply-To: <1366210440.15800.0.camel@phoenix>
References: <1366210440.15800.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage_shift can be calculated from voltage_mask.
Let's remove voltage_shift fied from struct ab8500_regulator_info, this change
can prevent missing voltage_shift setting issue.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ece31a3..f6656b8 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -61,7 +61,6 @@ struct ab8500_shared_mode {
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @voltage_shift: shift to control regulator voltage
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
@@ -83,7 +82,6 @@ struct ab8500_regulator_info {
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
-	u8 voltage_shift;
 	struct {
 		u8 voltage_limit;
 		u8 voltage_bank;
@@ -480,7 +478,7 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 
 static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
-	int ret, val;
+	int ret, voltage_shift;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	u8 regval;
 
@@ -489,6 +487,8 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		return -EINVAL;
 	}
 
+	voltage_shift = ffs(info->voltage_mask) - 1;
+
 	ret = abx500_get_register_interruptible(info->dev,
 			info->voltage_bank, info->voltage_reg, &regval);
 	if (ret < 0) {
@@ -502,15 +502,14 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		"0x%x, 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->voltage_bank,
 		info->voltage_reg, info->voltage_mask,
-		info->voltage_shift, regval);
+		voltage_shift, regval);
 
-	val = regval & info->voltage_mask;
-	return val >> info->voltage_shift;
+	return (regval & info->voltage_mask) >> voltage_shift;
 }
 
 static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
-	int ret;
+	int ret, voltage_shift;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	u8 regval, regval_expand;
 
@@ -550,13 +549,15 @@ static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		 info->desc.name, info->voltage_bank, info->voltage_reg,
 		 info->voltage_mask, regval);
 
-	return (regval & info->voltage_mask) >> info->voltage_shift;
+	voltage_shift = ffs(info->voltage_mask) - 1;
+
+	return (regval & info->voltage_mask) >> voltage_shift;
 }
 
 static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 					    unsigned selector)
 {
-	int ret;
+	int ret, voltage_shift;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	u8 regval;
 
@@ -565,8 +566,10 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	voltage_shift = ffs(info->voltage_mask) - 1;
+
 	/* set the registers for the request */
-	regval = (u8)selector << info->voltage_shift;
+	regval = (u8)selector << voltage_shift;
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 			info->voltage_bank, info->voltage_reg,
 			info->voltage_mask, regval);
@@ -596,7 +599,9 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	}
 
 	if (selector < info->expand_register.voltage_limit) {
-		regval = (u8)selector << info->voltage_shift;
+		int voltage_shift = ffs(info->voltage_mask) - 1;
+
+		regval = (u8)selector << voltage_shift;
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 					info->voltage_bank, info->voltage_reg,
 					info->voltage_mask, regval);
@@ -791,7 +796,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltage_shift		= 3,
 	},
 
 	/*
@@ -1066,7 +1070,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltage_shift		= 3,
 	},
 
 	/*
@@ -1127,7 +1130,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x57,
 		.voltage_mask		= 0x70,
-		.voltage_shift		= 4,
 	},
 	[AB8505_LDO_ANAMIC1] = {
 		.desc = {
@@ -1327,7 +1329,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltage_shift		= 3,
 	},
 
 	/*
@@ -1622,7 +1623,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltage_shift		= 3,
 	},
 
 	/*
@@ -1724,7 +1724,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x83,
 		.voltage_mask		= 0xc0,
-		.voltage_shift		= 6,
 	},
 
 	/*
-- 
1.7.10.4



