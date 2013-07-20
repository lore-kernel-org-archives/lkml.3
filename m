Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3GTHyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 03:54:41 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58111 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3GTHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 03:54:40 -0400
Message-ID: <1374306873.25751.1.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65217: Convert to use linear ranges
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 20 Jul 2013 15:54:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the equation in original code:

tps65217_uv1_ranges:
        0  ... 24: uV = vsel * 25000 + 900000;
        25 ... 52: uV = (vsel - 24) * 50000 + 1500000;
                      = (vsel - 25) * 50000 + 1550000;
        53 ... 55: uV = (vsel - 52) * 100000 + 2900000;
                      = (vsel - 53) * 100000 + 3000000;
        56 ... 62: uV = 3300000;

tps65217_uv2_ranges:
        0  ...  8: uV = vsel * 50000 + 1500000;
        9  ... 13: uV = (vsel - 8) * 100000 + 1900000;
                      = (vsel - 9) * 100000 + 2000000;
        14 ... 31: uV = (vsel - 13) * 50000 + 2400000;
                      = (vsel - 14) * 50000 + 2450000;

The voltage tables are composed of linear ranges.
This patch converts this driver to use multiple linear ranges APIs.

In original code, voltage range for DCDC1 is 900000 ~ 1800000 and voltage range
for DCDC3 is 900000 ~ 1500000.  Thus this patch separates the range 25~52 in
tps65217_uv1_ranges table to two linear ranges: 25~30 and 31~52.
This change makes it possible to reuse the same linear_ranges table for DCDCx.

Note, I checked the datasheet and there is a side note shows that DCDC1 & DCDC3
can support up to 3.3V ( Contact factory for 3.3-V option ).
This conversion does not change any behavior any way.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65217-regulator.c | 182 +++++++--------------------------
 include/linux/mfd/tps65217.h           |  19 ----
 2 files changed, 37 insertions(+), 164 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 2df4616..90861d6 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -27,7 +27,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/tps65217.h>
 
-#define TPS65217_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _em, _t) \
+#define TPS65217_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _em, _t, _lr, _nlr) \
 	{						\
 		.name		= _name,		\
 		.id		= _id,			\
@@ -40,17 +40,10 @@
 		.enable_reg	= TPS65217_REG_ENABLE,	\
 		.enable_mask	= _em,			\
 		.volt_table	= _t,			\
+		.linear_ranges	= _lr,			\
+		.n_linear_ranges = _nlr,		\
 	}						\
 
-#define TPS65217_INFO(_nm, _min, _max, _f1, _f2)	\
-	{						\
-		.name		= _nm,			\
-		.min_uV		= _min,			\
-		.max_uV		= _max,			\
-		.vsel_to_uv	= _f1,			\
-		.uv_to_vsel	= _f2,			\
-	}
-
 static const unsigned int LDO1_VSEL_table[] = {
 	1000000, 1100000, 1200000, 1250000,
 	1300000, 1350000, 1400000, 1500000,
@@ -58,88 +51,26 @@ static const unsigned int LDO1_VSEL_table[] = {
 	2800000, 3000000, 3100000, 3300000,
 };
 
-static int tps65217_vsel_to_uv1(unsigned int vsel)
-{
-	int uV = 0;
-
-	if (vsel > 63)
-		return -EINVAL;
-
-	if (vsel <= 24)
-		uV = vsel * 25000 + 900000;
-	else if (vsel <= 52)
-		uV = (vsel - 24) * 50000 + 1500000;
-	else if (vsel < 56)
-		uV = (vsel - 52) * 100000 + 2900000;
-	else
-		uV = 3300000;
-
-	return uV;
-}
-
-static int tps65217_uv_to_vsel1(int uV, unsigned int *vsel)
-{
-	if (uV < 0 || uV > 3300000)
-		return -EINVAL;
-
-	if (uV <= 1500000)
-		*vsel = DIV_ROUND_UP(uV - 900000, 25000);
-	else if (uV <= 2900000)
-		*vsel = 24 + DIV_ROUND_UP(uV - 1500000, 50000);
-	else if (uV < 3300000)
-		*vsel = 52 + DIV_ROUND_UP(uV - 2900000, 100000);
-	else
-		*vsel = 56;
-
-	return 0;
-}
-
-static int tps65217_vsel_to_uv2(unsigned int vsel)
-{
-	int uV = 0;
-
-	if (vsel > 31)
-		return -EINVAL;
-
-	if (vsel <= 8)
-		uV = vsel * 50000 + 1500000;
-	else if (vsel <= 13)
-		uV = (vsel - 8) * 100000 + 1900000;
-	else
-		uV = (vsel - 13) * 50000 + 2400000;
-
-	return uV;
-}
-
-static int tps65217_uv_to_vsel2(int uV, unsigned int *vsel)
-{
-	if (uV < 0 || uV > 3300000)
-		return -EINVAL;
-
-	if (uV <= 1900000)
-		*vsel = DIV_ROUND_UP(uV - 1500000, 50000);
-	else if (uV <= 2400000)
-		*vsel = 8 + DIV_ROUND_UP(uV - 1900000, 100000);
-	else
-		*vsel = 13 + DIV_ROUND_UP(uV - 2400000, 50000);
-
-	return 0;
-}
+static const struct regulator_linear_range tps65217_uv1_ranges[] = {
+	{ .min_uV = 900000, .max_uV = 1500000, .min_sel =  0, .max_sel = 24,
+	  .uV_step = 25000 },
+	{ .min_uV = 1550000, .max_uV = 1800000, .min_sel = 25, .max_sel = 30,
+	  .uV_step = 50000 },
+	{ .min_uV = 1850000, .max_uV = 2900000, .min_sel = 31, .max_sel = 52,
+	  .uV_step = 50000 },
+	{ .min_uV = 3000000, .max_uV = 3200000, .min_sel = 53, .max_sel = 55,
+	  .uV_step = 100000 },
+	{ .min_uV = 3300000, .max_uV = 3300000, .min_sel = 56, .max_sel = 62,
+	  .uV_step = 0 },
+};
 
-static struct tps_info tps65217_pmic_regs[] = {
-	TPS65217_INFO("DCDC1", 900000, 1800000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1),
-	TPS65217_INFO("DCDC2", 900000, 3300000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1),
-	TPS65217_INFO("DCDC3", 900000, 1500000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1),
-	TPS65217_INFO("LDO1", 1000000, 3300000, NULL, NULL),
-	TPS65217_INFO("LDO2", 900000, 3300000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1),
-	TPS65217_INFO("LDO3", 1800000, 3300000, tps65217_vsel_to_uv2,
-			tps65217_uv_to_vsel2),
-	TPS65217_INFO("LDO4", 1800000, 3300000, tps65217_vsel_to_uv2,
-			tps65217_uv_to_vsel2),
+static const struct regulator_linear_range tps65217_uv2_ranges[] = {
+	{ .min_uV = 1500000, .max_uV = 1900000, .min_sel =  0, .max_sel = 8,
+	  .uV_step = 50000 },
+	{ .min_uV = 2000000, .max_uV = 2400000, .min_sel = 9, .max_sel = 13,
+	  .uV_step = 100000 },
+	{ .min_uV = 2450000, .max_uV = 3300000, .min_sel = 14, .max_sel = 31,
+	  .uV_step = 50000 },
 };
 
 static int tps65217_pmic_enable(struct regulator_dev *dev)
@@ -192,49 +123,6 @@ static int tps65217_pmic_set_voltage_sel(struct regulator_dev *dev,
 	return ret;
 }
 
-static int tps65217_pmic_map_voltage(struct regulator_dev *dev,
-				     int min_uV, int max_uV)
-{
-
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int sel, rid = rdev_get_id(dev);
-	int ret;
-
-	/* LDO1 uses regulator_map_voltage_iterate() */
-	if (rid == TPS65217_LDO_1)
-		return -EINVAL;
-
-	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
-		return -EINVAL;
-
-	if (min_uV < tps->info[rid]->min_uV)
-		min_uV = tps->info[rid]->min_uV;
-
-	if (max_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
-		return -EINVAL;
-
-	ret = tps->info[rid]->uv_to_vsel(min_uV, &sel);
-	if (ret)
-		return ret;
-
-	return sel;
-}
-
-static int tps65217_pmic_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
-
-	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
-		return -EINVAL;
-
-	if (selector >= dev->desc->n_voltages)
-		return -EINVAL;
-
-	return tps->info[rid]->vsel_to_uv(selector);
-}
-
 /* Operations permitted on DCDCx, LDO2, LDO3 and LDO4 */
 static struct regulator_ops tps65217_pmic_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
@@ -242,8 +130,8 @@ static struct regulator_ops tps65217_pmic_ops = {
 	.disable		= tps65217_pmic_disable,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= tps65217_pmic_set_voltage_sel,
-	.list_voltage		= tps65217_pmic_list_voltage,
-	.map_voltage		= tps65217_pmic_map_voltage,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
 };
 
 /* Operations permitted on LDO1 */
@@ -259,27 +147,33 @@ static struct regulator_ops tps65217_pmic_ldo1_ops = {
 static const struct regulator_desc regulators[] = {
 	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFDCDC1, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC1_EN, NULL),
+			   TPS65217_ENABLE_DC1_EN, NULL, tps65217_uv1_ranges,
+			   2),	/* DCDC1 voltage range: 900000 ~ 1800000 */
 	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFDCDC2, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC2_EN, NULL),
+			   TPS65217_ENABLE_DC2_EN, NULL, tps65217_uv1_ranges,
+			   ARRAY_SIZE(tps65217_uv1_ranges)),
 	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFDCDC3, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC3_EN, NULL),
+			   TPS65217_ENABLE_DC3_EN, NULL, tps65217_uv1_ranges,
+			   1),	/* DCDC3 voltage range: 900000 ~ 1500000 */
 	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, tps65217_pmic_ldo1_ops, 16,
 			   TPS65217_REG_DEFLDO1, TPS65217_DEFLDO1_LDO1_MASK,
-			   TPS65217_ENABLE_LDO1_EN, LDO1_VSEL_table),
+			   TPS65217_ENABLE_LDO1_EN, LDO1_VSEL_table, NULL, 0),
 	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFLDO2, TPS65217_DEFLDO2_LDO2_MASK,
-			   TPS65217_ENABLE_LDO2_EN, NULL),
+			   TPS65217_ENABLE_LDO2_EN, NULL, tps65217_uv1_ranges,
+			   ARRAY_SIZE(tps65217_uv1_ranges)),
 	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, tps65217_pmic_ops, 32,
 			   TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK,
 			   TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN,
-			   NULL),
+			   NULL, tps65217_uv2_ranges,
+			   ARRAY_SIZE(tps65217_uv2_ranges)),
 	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, tps65217_pmic_ops, 32,
 			   TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK,
 			   TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN,
-			   NULL),
+			   NULL, tps65217_uv2_ranges,
+			   ARRAY_SIZE(tps65217_uv2_ranges)),
 };
 
 #ifdef CONFIG_OF
@@ -368,8 +262,6 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 			continue;
 
 		/* Register the regulators */
-		tps->info[i] = &tps65217_pmic_regs[i];
-
 		config.dev = tps->dev;
 		config.init_data = reg_data;
 		config.driver_data = tps;
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index 29eab2b..a5a7f01 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -244,24 +244,6 @@ struct tps65217_board {
 };
 
 /**
- * struct tps_info - packages regulator constraints
- * @name:		Voltage regulator name
- * @min_uV:		minimum micro volts
- * @max_uV:		minimum micro volts
- * @vsel_to_uv:		Function pointer to get voltage from selector
- * @uv_to_vsel:		Function pointer to get selector from voltage
- *
- * This data is used to check the regualtor voltage limits while setting.
- */
-struct tps_info {
-	const char *name;
-	int min_uV;
-	int max_uV;
-	int (*vsel_to_uv)(unsigned int vsel);
-	int (*uv_to_vsel)(int uV, unsigned int *vsel);
-};
-
-/**
  * struct tps65217 - tps65217 sub-driver chip access routines
  *
  * Device data may be used to access the TPS65217 chip
@@ -273,7 +255,6 @@ struct tps65217 {
 	unsigned int id;
 	struct regulator_desc desc[TPS65217_NUM_REGULATOR];
 	struct regulator_dev *rdev[TPS65217_NUM_REGULATOR];
-	struct tps_info *info[TPS65217_NUM_REGULATOR];
 	struct regmap *regmap;
 };
 
-- 
1.8.1.2



