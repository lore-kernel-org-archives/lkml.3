Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3GTI4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:56:54 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47593 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3GTI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:56:50 -0400
Message-ID: <1374310605.30336.2.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65912: Convert tps65912_ops_ldo to use
 linear ranges
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 20 Jul 2013 16:56:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ldo voltage table is composed of linear ranges.

Below is the equation in original code (tps65912_vsel_to_uv_ldo):
0 ... 32:      uv = vsel * 25000 + 800000;
33 ... 60:     uv = (vsel - 32) * 50000 + 1600000;
                  = (vsel -33) * 50000 + 1650000;
61 ...63:      uv = (vsel - 60) * 100000 + 3000000;
                  = (vsel - 61) * 100000 + 3100000;

This patch converts tps65912_ops_ldo to use multiple linear ranges APIs.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65912-regulator.c | 39 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 17e994e..281e52a 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -118,6 +118,15 @@ struct tps65912_reg {
 	int eco_reg;
 };
 
+static const struct regulator_linear_range tps65912_ldo_ranges[] = {
+	{ .min_uV = 800000, .max_uV = 1600000, .min_sel =  0, .max_sel = 32,
+	  .uV_step = 25000 },
+	{ .min_uV = 1650000, .max_uV = 3000000, .min_sel = 33, .max_sel = 60,
+	  .uV_step = 50000 },
+	{ .min_uV = 3100000, .max_uV = 3300000, .min_sel = 61, .max_sel = 63,
+	  .uV_step = 100000 },
+};
+
 static int tps65912_get_range(struct tps65912_reg *pmic, int id)
 {
 	struct tps65912 *mfd = pmic->mfd;
@@ -184,20 +193,6 @@ static unsigned long tps65912_vsel_to_uv_range3(u8 vsel)
 	return uv;
 }
 
-static unsigned long tps65912_vsel_to_uv_ldo(u8 vsel)
-{
-	unsigned long uv = 0;
-
-	if (vsel <= 32)
-		uv = ((vsel * 25000) + 800000);
-	else if (vsel > 32 && vsel <= 60)
-		uv = (((vsel - 32) * 50000) + 1600000);
-	else if (vsel > 60)
-		uv = (((vsel - 60) * 100000) + 3000000);
-
-	return uv;
-}
-
 static int tps65912_get_ctrl_register(int id)
 {
 	if (id >= TPS65912_REG_DCDC1 && id <= TPS65912_REG_LDO4)
@@ -376,9 +371,6 @@ static int tps65912_list_voltage(struct regulator_dev *dev, unsigned selector)
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	int range, voltage = 0, id = rdev_get_id(dev);
 
-	if (id >= TPS65912_REG_LDO1 && id <= TPS65912_REG_LDO10)
-		return tps65912_vsel_to_uv_ldo(selector);
-
 	if (id > TPS65912_REG_DCDC4)
 		return -EINVAL;
 
@@ -456,7 +448,8 @@ static struct regulator_ops tps65912_ops_ldo = {
 	.disable = tps65912_reg_disable,
 	.get_voltage_sel = tps65912_get_voltage_sel,
 	.set_voltage_sel = tps65912_set_voltage_sel,
-	.list_voltage = tps65912_list_voltage,
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
 };
 
 static int tps65912_probe(struct platform_device *pdev)
@@ -495,8 +488,14 @@ static int tps65912_probe(struct platform_device *pdev)
 		pmic->desc[i].name = info->name;
 		pmic->desc[i].id = i;
 		pmic->desc[i].n_voltages = 64;
-		pmic->desc[i].ops = (i > TPS65912_REG_DCDC4 ?
-			&tps65912_ops_ldo : &tps65912_ops_dcdc);
+		if (i > TPS65912_REG_DCDC4) {
+			pmic->desc[i].ops = &tps65912_ops_ldo;
+			pmic->desc[i].linear_ranges = tps65912_ldo_ranges;
+			pmic->desc[i].n_linear_ranges =
+					ARRAY_SIZE(tps65912_ldo_ranges);
+		} else {
+			pmic->desc[i].ops = &tps65912_ops_dcdc;
+		}
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
 		range = tps65912_get_range(pmic, i);
-- 
1.8.1.2



