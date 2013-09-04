Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441Ab3IDF4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:49 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43420 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401Ab3IDF4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:22 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 8/9] regulator: max8997: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:08:01 +0530
Message-Id: <1378273082-28305-8-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8997.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index df20069..059e8ed 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1081,7 +1081,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 					pdata->buck1_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
-			goto err_out;
+			return ret;
 
 		max8997->buck2_vol[i] = ret =
 			max8997_get_voltage_proper_val(
@@ -1090,7 +1090,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 					pdata->buck2_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
-			goto err_out;
+			return ret;
 
 		max8997->buck5_vol[i] = ret =
 			max8997_get_voltage_proper_val(
@@ -1099,7 +1099,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 					pdata->buck5_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
-			goto err_out;
+			return ret;
 
 		if (max_buck1 < max8997->buck1_vol[i])
 			max_buck1 = max8997->buck1_vol[i];
@@ -1143,24 +1143,23 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 				!gpio_is_valid(pdata->buck125_gpios[1]) ||
 				!gpio_is_valid(pdata->buck125_gpios[2])) {
 			dev_err(&pdev->dev, "GPIO NOT VALID\n");
-			ret = -EINVAL;
-			goto err_out;
+			return -EINVAL;
 		}
 
 		ret = devm_gpio_request(&pdev->dev, pdata->buck125_gpios[0],
 					"MAX8997 SET1");
 		if (ret)
-			goto err_out;
+			return ret;
 
 		ret = devm_gpio_request(&pdev->dev, pdata->buck125_gpios[1],
 					"MAX8997 SET2");
 		if (ret)
-			goto err_out;
+			return ret;
 
 		ret = devm_gpio_request(&pdev->dev, pdata->buck125_gpios[2],
 				"MAX8997 SET3");
 		if (ret)
-			goto err_out;
+			return ret;
 
 		gpio_direction_output(pdata->buck125_gpios[0],
 				(max8997->buck125_gpioindex >> 2)
@@ -1205,33 +1204,17 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		config.driver_data = max8997;
 		config.of_node = pdata->regulators[i].reg_node;
 
-		rdev[i] = regulator_register(&regulators[id], &config);
+		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
+						  &config);
 		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
 			dev_err(max8997->dev, "regulator init failed for %d\n",
 					id);
 			rdev[i] = NULL;
-			goto err;
+			return PTR_ERR(rdev[i]);
 		}
 	}
 
 	return 0;
-err:
-	while (--i >= 0)
-		regulator_unregister(rdev[i]);
-err_out:
-	return ret;
-}
-
-static int max8997_pmic_remove(struct platform_device *pdev)
-{
-	struct max8997_data *max8997 = platform_get_drvdata(pdev);
-	struct regulator_dev **rdev = max8997->rdev;
-	int i;
-
-	for (i = 0; i < max8997->num_regulators; i++)
-		regulator_unregister(rdev[i]);
-	return 0;
 }
 
 static const struct platform_device_id max8997_pmic_id[] = {
@@ -1246,7 +1229,6 @@ static struct platform_driver max8997_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = max8997_pmic_probe,
-	.remove = max8997_pmic_remove,
 	.id_table = max8997_pmic_id,
 };
 
-- 
1.7.9.5

