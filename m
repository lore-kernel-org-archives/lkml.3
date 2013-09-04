Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426Ab3IDF4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:32 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51058 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3IDF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:26 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 9/9] regulator: max8998: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:08:02 +0530
Message-Id: <1378273082-28305-9-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8998.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index a4c53b2..ae3f065 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -790,16 +790,14 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"MAX8998 SET1 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set1);
-			ret = -EIO;
-			goto err_out;
+			return -EIO;
 		}
 		/* Check if SET2 is not equal to 0 */
 		if (!pdata->buck1_set2) {
 			dev_err(&pdev->dev,
 				"MAX8998 SET2 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set2);
-			ret = -EIO;
-			goto err_out;
+			return -EIO;
 		}
 
 		gpio_request(pdata->buck1_set1, "MAX8998 BUCK1_SET1");
@@ -823,7 +821,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 			ret = max8998_write_reg(i2c,
 					MAX8998_REG_BUCK1_VOLTAGE1 + v, i);
 			if (ret)
-				goto err_out;
+				return ret;
 		}
 	}
 
@@ -833,8 +831,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"MAX8998 SET3 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck2_set3);
-			ret = -EIO;
-			goto err_out;
+			return -EIO;
 		}
 		gpio_request(pdata->buck2_set3, "MAX8998 BUCK2_SET3");
 		gpio_direction_output(pdata->buck2_set3,
@@ -852,7 +849,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 			ret = max8998_write_reg(i2c,
 					MAX8998_REG_BUCK2_VOLTAGE1 + v, i);
 			if (ret)
-				goto err_out;
+				return ret;
 		}
 	}
 
@@ -875,34 +872,19 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = max8998;
 
-		rdev[i] = regulator_register(&regulators[index], &config);
+		rdev[i] = devm_regulator_register(&pdev->dev,
+						  &regulators[index], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(max8998->dev, "regulator %s init failed (%d)\n",
 						regulators[index].name, ret);
 			rdev[i] = NULL;
-			goto err;
+			return ret;
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
-static int max8998_pmic_remove(struct platform_device *pdev)
-{
-	struct max8998_data *max8998 = platform_get_drvdata(pdev);
-	struct regulator_dev **rdev = max8998->rdev;
-	int i;
-
-	for (i = 0; i < max8998->num_regulators; i++)
-		regulator_unregister(rdev[i]);
-	return 0;
 }
 
 static const struct platform_device_id max8998_pmic_id[] = {
@@ -918,7 +900,6 @@ static struct platform_driver max8998_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = max8998_pmic_probe,
-	.remove = max8998_pmic_remove,
 	.id_table = max8998_pmic_id,
 };
 
-- 
1.7.9.5

