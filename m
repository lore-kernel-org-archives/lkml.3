Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBKSFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:05:42 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.165]:13699 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbaBKSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:05:38 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 13:05:37 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-12.tower-38.messagelabs.com!1392141522!1728940!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402111758.s1BHweP2015522@swsrvapps-01.diasemi.com>
From: Steve Twiss <stwiss.opensource@diasemi.com>
Date: Tue, 11 Feb 2014 17:46:41 +0000
Subject: [PATCH V1] regulator: da9063: Bug fix when setting max voltage on
 LDOs 5-11
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

Bug fix to allow the setting of maximum voltage for certain LDOs.

Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
---
Checks performed with next-20140211/scripts/checkpatch.pl
 da9063-regulator.c        total: 0 errors, 0 warnings, 927 lines checked

This patch applies against kernel version linux-next next-20140211

This fixes a problem caused by an invalid calculation of n_voltages
in the driver. This n_voltages value has the potential to be
different for each regulator and the new calculation takes this
into account.

Several of the regulators have a non-linear response of voltage
versus voltage selector. This is true for the following LDOs:
5, 6, 7, 8, 9, 10 and 11.

This patch also includes several minor alterations to clean up
the code so that checkpatch.pl will not display any warnings.

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/regulator/da9063-regulator.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 56727eb..6a2b26f 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -1,3 +1,4 @@
+
 /*
  * Regulator driver for DA9063 PMIC series
  *
@@ -60,7 +61,8 @@ struct da9063_regulator_info {
 	.desc.ops = &da9063_ldo_ops, \
 	.desc.min_uV = (min_mV) * 1000, \
 	.desc.uV_step = (step_mV) * 1000, \
-	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1), \
+	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1 \
+		+ (DA9063_V##regl_name##_BIAS)), \
 	.desc.enable_reg = DA9063_REG_##regl_name##_CONT, \
 	.desc.enable_mask = DA9063_LDO_EN, \
 	.desc.vsel_reg = DA9063_REG_V##regl_name##_A, \
@@ -387,7 +389,8 @@ static int da9063_suspend_disable(struct regulator_dev *rdev)
 	return regmap_field_write(regl->suspend, 0);
 }
 
-static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev, unsigned mode)
+static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev,
+					unsigned mode)
 {
 	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
 	int val;
@@ -409,7 +412,8 @@ static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev, unsigned mod
 	return regmap_field_write(regl->mode, val);
 }
 
-static int da9063_ldo_set_suspend_mode(struct regulator_dev *rdev, unsigned mode)
+static int da9063_ldo_set_suspend_mode(struct regulator_dev *rdev,
+				       unsigned mode)
 {
 	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
 	unsigned val;
@@ -833,8 +837,9 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 			regl->sleep = devm_regmap_field_alloc(&pdev->dev,
 					da9063->regmap, regl->info->sleep);
 		if (regl->info->suspend_sleep.reg)
-			regl->suspend_sleep = devm_regmap_field_alloc(&pdev->dev,
-					da9063->regmap, regl->info->suspend_sleep);
+			regl->suspend_sleep =
+				devm_regmap_field_alloc(&pdev->dev,
+				da9063->regmap, regl->info->suspend_sleep);
 		if (regl->info->ilimit.reg)
 			regl->ilimit = devm_regmap_field_alloc(&pdev->dev,
 					da9063->regmap, regl->info->ilimit);
@@ -842,7 +847,8 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 		/* Register regulator */
 		memset(&config, 0, sizeof(config));
 		config.dev = &pdev->dev;
-		config.init_data = da9063_get_regulator_initdata(regl_pdata, id);
+		config.init_data =
+			da9063_get_regulator_initdata(regl_pdata, id);
 		config.driver_data = regl;
 		if (da9063_reg_matches)
 			config.of_node = da9063_reg_matches[id].of_node;
-- 
end-of-patch for PATCH V1

