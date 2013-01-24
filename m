Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3AXDls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:41:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44249 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3AXD3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 30/74] regulator: max8997: Use uV in voltage_map_desc
Date: Thu, 24 Jan 2013 01:26:42 -0200
Message-Id: <1358998046-613-31-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit bc3b7756b5ff66828acf7bc24f148d28b8d61108 upstream.

Current code does integer division (min_vol = min_uV / 1000) before pass
min_vol to max8997_get_voltage_proper_val().
So it is possible min_vol is truncated to a smaller value.

For example, if the request min_uV is 800900 for ldo.
min_vol = 800900 / 1000 = 800 (mV)
Then max8997_get_voltage_proper_val returns 800 mV for this case which is lower
than the requested voltage.

Use uV rather than mV in voltage_map_desc to prevent truncation by integer
division.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/regulator/max8997.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 704cd49..f57f83f 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -69,26 +69,26 @@ struct voltage_map_desc {
 	int step;
 };
 
-/* Voltage maps in mV */
+/* Voltage maps in uV */
 static const struct voltage_map_desc ldo_voltage_map_desc = {
-	.min = 800,	.max = 3950,	.step = 50,
+	.min = 800000,	.max = 3950000,	.step = 50000,
 }; /* LDO1 ~ 18, 21 all */
 
 static const struct voltage_map_desc buck1245_voltage_map_desc = {
-	.min = 650,	.max = 2225,	.step = 25,
+	.min = 650000,	.max = 2225000,	.step = 25000,
 }; /* Buck1, 2, 4, 5 */
 
 static const struct voltage_map_desc buck37_voltage_map_desc = {
-	.min = 750,	.max = 3900,	.step = 50,
+	.min = 750000,	.max = 3900000,	.step = 50000,
 }; /* Buck3, 7 */
 
-/* current map in mA */
+/* current map in uA */
 static const struct voltage_map_desc charger_current_map_desc = {
-	.min = 200,	.max = 950,	.step = 50,
+	.min = 200000,	.max = 950000,	.step = 50000,
 };
 
 static const struct voltage_map_desc topoff_current_map_desc = {
-	.min = 50,	.max = 200,	.step = 10,
+	.min = 50000,	.max = 200000,	.step = 10000,
 };
 
 static const struct voltage_map_desc *reg_voltage_map[] = {
@@ -192,7 +192,7 @@ static int max8997_list_voltage(struct regulator_dev *rdev,
 	if (val > desc->max)
 		return -EINVAL;
 
-	return val * 1000;
+	return val;
 }
 
 static int max8997_get_enable_register(struct regulator_dev *rdev,
@@ -483,7 +483,6 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
 	int rid = rdev_get_id(rdev);
 	int i, reg, shift, mask, ret;
@@ -507,7 +506,7 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 
 	desc = reg_voltage_map[rid];
 
-	i = max8997_get_voltage_proper_val(desc, min_vol, max_vol);
+	i = max8997_get_voltage_proper_val(desc, min_uV, max_uV);
 	if (i < 0)
 		return i;
 
@@ -555,7 +554,7 @@ static int max8997_set_voltage_ldobuck_time_sel(struct regulator_dev *rdev,
 	case MAX8997_BUCK4:
 	case MAX8997_BUCK5:
 		return DIV_ROUND_UP(desc->step * (new_selector - old_selector),
-				    max8997->ramp_delay);
+				    max8997->ramp_delay * 1000);
 	}
 
 	return 0;
@@ -654,7 +653,6 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 	const struct voltage_map_desc *desc;
 	int new_val, new_idx, damage, tmp_val, tmp_idx, tmp_dmg;
 	bool gpio_dvs_mode = false;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 
 	if (rid < MAX8997_BUCK1 || rid > MAX8997_BUCK7)
 		return -EINVAL;
@@ -679,7 +677,7 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 						selector);
 
 	desc = reg_voltage_map[rid];
-	new_val = max8997_get_voltage_proper_val(desc, min_vol, max_vol);
+	new_val = max8997_get_voltage_proper_val(desc, min_uV, max_uV);
 	if (new_val < 0)
 		return new_val;
 
@@ -977,8 +975,8 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		max8997->buck1_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
-					pdata->buck1_voltage[i] / 1000,
-					pdata->buck1_voltage[i] / 1000 +
+					pdata->buck1_voltage[i],
+					pdata->buck1_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
 			goto err_out;
@@ -986,8 +984,8 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		max8997->buck2_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
-					pdata->buck2_voltage[i] / 1000,
-					pdata->buck2_voltage[i] / 1000 +
+					pdata->buck2_voltage[i],
+					pdata->buck2_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
 			goto err_out;
@@ -995,8 +993,8 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		max8997->buck5_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
-					pdata->buck5_voltage[i] / 1000,
-					pdata->buck5_voltage[i] / 1000 +
+					pdata->buck5_voltage[i],
+					pdata->buck5_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
 			goto err_out;
-- 
1.7.9.5

