Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaBRMof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:44:35 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51210 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaBRMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:44:34 -0500
Message-ID: <1392727469.13262.4.camel@phoenix>
Subject: [RFT][PATCH] regulator: tps65218: Convert to use
 regulator_set_voltage_time_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Keerthy <j-keerthy@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 20:44:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use regulator_set_voltage_time_sel() instead of open-coded.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65218-regulator.c | 37 +++++++++-------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index cec72fa..69b4b77 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -27,12 +27,10 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/tps65218.h>
 
-static unsigned int tps65218_ramp_delay = 4000;
-
 enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 
 #define TPS65218_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _er, _em, _t, \
-			    _lr, _nlr)				\
+			    _lr, _nlr, _delay)			\
 	{							\
 		.name			= _name,		\
 		.id			= _id,			\
@@ -47,6 +45,7 @@ enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 		.volt_table		= _t,			\
 		.linear_ranges		= _lr,			\
 		.n_linear_ranges	= _nlr,			\
+		.ramp_delay		= _delay,		\
 	}							\
 
 #define TPS65218_INFO(_id, _nm, _min, _max)	\
@@ -152,22 +151,6 @@ static int tps65218_pmic_disable(struct regulator_dev *dev)
 				   dev->desc->enable_mask, TPS65218_PROTECT_L1);
 }
 
-static int tps65218_set_voltage_time_sel(struct regulator_dev *rdev,
-	unsigned int old_selector, unsigned int new_selector)
-{
-	int old_uv, new_uv;
-
-	old_uv = regulator_list_voltage_linear_range(rdev, old_selector);
-	if (old_uv < 0)
-		return old_uv;
-
-	new_uv = regulator_list_voltage_linear_range(rdev, new_selector);
-	if (new_uv < 0)
-		return new_uv;
-
-	return DIV_ROUND_UP(abs(old_uv - new_uv), tps65218_ramp_delay);
-}
-
 /* Operations permitted on DCDC1, DCDC2 */
 static struct regulator_ops tps65218_dcdc12_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
@@ -177,7 +160,7 @@ static struct regulator_ops tps65218_dcdc12_ops = {
 	.set_voltage_sel	= tps65218_pmic_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear_range,
 	.map_voltage		= regulator_map_voltage_linear_range,
-	.set_voltage_time_sel	= tps65218_set_voltage_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 };
 
 /* Operations permitted on DCDC3, DCDC4 and LDO1 */
@@ -203,33 +186,33 @@ static const struct regulator_desc regulators[] = {
 			   TPS65218_REG_CONTROL_DCDC1,
 			   TPS65218_CONTROL_DCDC1_MASK,
 			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC1_EN, NULL,
-			   dcdc1_dcdc2_ranges, 2),
+			   dcdc1_dcdc2_ranges, 2, 4000),
 	TPS65218_REGULATOR("DCDC2", TPS65218_DCDC_2, tps65218_dcdc12_ops, 64,
 			   TPS65218_REG_CONTROL_DCDC2,
 			   TPS65218_CONTROL_DCDC2_MASK,
 			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC2_EN, NULL,
-			   dcdc1_dcdc2_ranges, 2),
+			   dcdc1_dcdc2_ranges, 2, 4000),
 	TPS65218_REGULATOR("DCDC3", TPS65218_DCDC_3, tps65218_ldo1_dcdc34_ops,
 			   64, TPS65218_REG_CONTROL_DCDC3,
 			   TPS65218_CONTROL_DCDC3_MASK, TPS65218_REG_ENABLE1,
 			   TPS65218_ENABLE1_DC3_EN, NULL,
-			   ldo1_dcdc3_ranges, 2),
+			   ldo1_dcdc3_ranges, 2, 0),
 	TPS65218_REGULATOR("DCDC4", TPS65218_DCDC_4, tps65218_ldo1_dcdc34_ops,
 			   53, TPS65218_REG_CONTROL_DCDC4,
 			   TPS65218_CONTROL_DCDC4_MASK,
 			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC4_EN, NULL,
-			   dcdc4_ranges, 2),
+			   dcdc4_ranges, 2, 0),
 	TPS65218_REGULATOR("DCDC5", TPS65218_DCDC_5, tps65218_dcdc56_pmic_ops,
 			   1, -1, -1, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC5_EN, NULL, NULL, 0),
+			   TPS65218_ENABLE1_DC5_EN, NULL, NULL, 0, 0),
 	TPS65218_REGULATOR("DCDC6", TPS65218_DCDC_6, tps65218_dcdc56_pmic_ops,
 			   1, -1, -1, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC6_EN, NULL, NULL, 0),
+			   TPS65218_ENABLE1_DC6_EN, NULL, NULL, 0, 0),
 	TPS65218_REGULATOR("LDO1", TPS65218_LDO_1, tps65218_ldo1_dcdc34_ops, 64,
 			   TPS65218_REG_CONTROL_DCDC4,
 			   TPS65218_CONTROL_LDO1_MASK, TPS65218_REG_ENABLE2,
 			   TPS65218_ENABLE2_LDO1_EN, NULL, ldo1_dcdc3_ranges,
-			   2),
+			   2, 0),
 };
 
 static int tps65218_regulator_probe(struct platform_device *pdev)
-- 
1.8.1.2



