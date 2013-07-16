Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab3GPCSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:18:22 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57019 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3GPCSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:18:21 -0400
Message-ID: <1373941094.13228.4.camel@phoenix>
Subject: [PATCH RFT] regulator: da903x: Convert da9034 ldo12 to use linear
 ranges
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 10:18:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage table of da9034 LDO12 is:
1700000, 1750000, 1800000, 1850000, 1900000, 1950000, 2000000, 2050000
2700000, 2750000, 2800000, 2850000, 2900000, 2950000, 3000000, 3050000

The voltage table is composed of two linear ranges:
for selector 0 ... 7:
        volt = 1700000 + 50000 * selector
for selector 8 ... 15:
        volt = 2700000 + 50000 * (selector - 8)

This patch converts da9034 LDO12 to use newly introduced helpers for multiple
linear ranges.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da903x.c | 45 ++++++++++-----------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 2afa573..1378a24 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -252,39 +252,12 @@ static int da9034_set_dvc_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int da9034_map_ldo12_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	int sel;
-
-	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
-		return -EINVAL;
-	}
-
-	sel = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
-	sel = (sel >= 20) ? sel - 12 : ((sel > 7) ? 8 : sel);
-
-	return sel;
-}
-
-static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
-				     unsigned selector)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	int volt;
-
-	if (selector >= 8)
-		volt = 2700000 + rdev->desc->uV_step * (selector - 8);
-	else
-		volt = rdev->desc->min_uV + rdev->desc->uV_step * selector;
-
-	if (volt > info->max_uV)
-		return -EINVAL;
-
-	return volt;
-}
+static const struct regulator_linear_range da9034_ldo12_ranges[] = {
+	{ .min_uV = 1700000, .max_uV = 2050000, .min_sel =  0, .max_sel = 7,
+	  .uV_step =  50000 },
+	{ .min_uV = 2700000, .max_uV = 3050000, .min_sel =  8, .max_sel = 15,
+	  .uV_step =  50000 },
+};
 
 static struct regulator_ops da903x_regulator_ldo_ops = {
 	.set_voltage_sel = da903x_set_voltage_sel,
@@ -332,8 +305,8 @@ static struct regulator_ops da9034_regulator_dvc_ops = {
 static struct regulator_ops da9034_regulator_ldo12_ops = {
 	.set_voltage_sel = da903x_set_voltage_sel,
 	.get_voltage_sel = da903x_get_voltage_sel,
-	.list_voltage	= da9034_list_ldo12_voltage,
-	.map_voltage	= da9034_map_ldo12_voltage,
+	.list_voltage	= regulator_list_voltage_linear_range,
+	.map_voltage	= regulator_map_voltage_linear_range,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -476,6 +449,8 @@ static int da903x_regulator_probe(struct platform_device *pdev)
 	if (ri->desc.id == DA9034_ID_LDO12) {
 		ri->desc.ops = &da9034_regulator_ldo12_ops;
 		ri->desc.n_voltages = 16;
+		ri->desc.linear_ranges = da9034_ldo12_ranges;
+		ri->desc.n_linear_ranges = ARRAY_SIZE(da9034_ldo12_ranges);
 	}
 
 	if (ri->desc.id == DA9030_ID_LDO14)
-- 
1.8.1.2



