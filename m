Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaIGKez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:34:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35485 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaIGKey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:34:54 -0400
Message-ID: <1410086091.4121.1.camel@phoenix>
Subject: [PATCH] regulator: as3711: Remove unused fields from
 as3711_regulator_info and as3711_regulator
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 07 Sep 2014 18:34:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max_uV is not used, so remove it from struct as3711_regulator_info.
Current code is using devm_regulator_register(), so we don't need to store *rdev
in struct as3711_regulator for clean up.

Also clean up AS3711_REG macro to remove _vshift, _min_uV and _max_uV arguments.
_vshift is always 0, so remove it.
_min_uV and _max_uV are not required, all required settings are set in
REGULATOR_LINEAR_RANGE macro.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c | 61 +++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index b47283f..8459b0b 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -22,12 +22,10 @@
 
 struct as3711_regulator_info {
 	struct regulator_desc	desc;
-	unsigned int		max_uV;
 };
 
 struct as3711_regulator {
 	struct as3711_regulator_info *reg_info;
-	struct regulator_dev *rdev;
 };
 
 /*
@@ -132,39 +130,37 @@ static const struct regulator_linear_range as3711_dldo_ranges[] = {
 	REGULATOR_LINEAR_RANGE(1750000, 0x20, 0x3f, 50000),
 };
 
-#define AS3711_REG(_id, _en_reg, _en_bit, _vmask, _vshift, _min_uV, _max_uV, _sfx)	\
-	[AS3711_REGULATOR_ ## _id] = {							\
-	.desc = {									\
-		.name = "as3711-regulator-" # _id,					\
-		.id = AS3711_REGULATOR_ ## _id,						\
-		.n_voltages = (_vmask + 1),						\
-		.ops = &as3711_ ## _sfx ## _ops,					\
-		.type = REGULATOR_VOLTAGE,						\
-		.owner = THIS_MODULE,							\
-		.vsel_reg = AS3711_ ## _id ## _VOLTAGE,					\
-		.vsel_mask = _vmask << _vshift,						\
-		.enable_reg = AS3711_ ## _en_reg,					\
-		.enable_mask = BIT(_en_bit),						\
-		.min_uV	= _min_uV,							\
-		.linear_ranges = as3711_ ## _sfx ## _ranges,				\
-		.n_linear_ranges = ARRAY_SIZE(as3711_ ## _sfx ## _ranges),		\
-	},										\
-	.max_uV = _max_uV,								\
+#define AS3711_REG(_id, _en_reg, _en_bit, _vmask, _sfx)			   \
+	[AS3711_REGULATOR_ ## _id] = {					   \
+	.desc = {							   \
+		.name = "as3711-regulator-" # _id,			   \
+		.id = AS3711_REGULATOR_ ## _id,				   \
+		.n_voltages = (_vmask + 1),				   \
+		.ops = &as3711_ ## _sfx ## _ops,			   \
+		.type = REGULATOR_VOLTAGE,				   \
+		.owner = THIS_MODULE,					   \
+		.vsel_reg = AS3711_ ## _id ## _VOLTAGE,			   \
+		.vsel_mask = _vmask,					   \
+		.enable_reg = AS3711_ ## _en_reg,			   \
+		.enable_mask = BIT(_en_bit),				   \
+		.linear_ranges = as3711_ ## _sfx ## _ranges,		   \
+		.n_linear_ranges = ARRAY_SIZE(as3711_ ## _sfx ## _ranges), \
+	},								   \
 }
 
 static struct as3711_regulator_info as3711_reg_info[] = {
-	AS3711_REG(SD_1, SD_CONTROL, 0, 0x7f, 0, 612500, 3350000, sd),
-	AS3711_REG(SD_2, SD_CONTROL, 1, 0x7f, 0, 612500, 3350000, sd),
-	AS3711_REG(SD_3, SD_CONTROL, 2, 0x7f, 0, 612500, 3350000, sd),
-	AS3711_REG(SD_4, SD_CONTROL, 3, 0x7f, 0, 612500, 3350000, sd),
-	AS3711_REG(LDO_1, LDO_1_VOLTAGE, 7, 0x1f, 0, 1200000, 3300000, aldo),
-	AS3711_REG(LDO_2, LDO_2_VOLTAGE, 7, 0x1f, 0, 1200000, 3300000, aldo),
-	AS3711_REG(LDO_3, LDO_3_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
-	AS3711_REG(LDO_4, LDO_4_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
-	AS3711_REG(LDO_5, LDO_5_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
-	AS3711_REG(LDO_6, LDO_6_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
-	AS3711_REG(LDO_7, LDO_7_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
-	AS3711_REG(LDO_8, LDO_8_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	AS3711_REG(SD_1, SD_CONTROL, 0, 0x7f, sd),
+	AS3711_REG(SD_2, SD_CONTROL, 1, 0x7f, sd),
+	AS3711_REG(SD_3, SD_CONTROL, 2, 0x7f, sd),
+	AS3711_REG(SD_4, SD_CONTROL, 3, 0x7f, sd),
+	AS3711_REG(LDO_1, LDO_1_VOLTAGE, 7, 0x1f, aldo),
+	AS3711_REG(LDO_2, LDO_2_VOLTAGE, 7, 0x1f, aldo),
+	AS3711_REG(LDO_3, LDO_3_VOLTAGE, 7, 0x3f, dldo),
+	AS3711_REG(LDO_4, LDO_4_VOLTAGE, 7, 0x3f, dldo),
+	AS3711_REG(LDO_5, LDO_5_VOLTAGE, 7, 0x3f, dldo),
+	AS3711_REG(LDO_6, LDO_6_VOLTAGE, 7, 0x3f, dldo),
+	AS3711_REG(LDO_7, LDO_7_VOLTAGE, 7, 0x3f, dldo),
+	AS3711_REG(LDO_8, LDO_8_VOLTAGE, 7, 0x3f, dldo),
 	/* StepUp output voltage depends on supplying regulator */
 };
 
@@ -263,7 +259,6 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 				ri->desc.name);
 			return PTR_ERR(rdev);
 		}
-		reg->rdev = rdev;
 	}
 	platform_set_drvdata(pdev, regs);
 	return 0;
-- 
1.9.1



