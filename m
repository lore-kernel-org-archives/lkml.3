Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356Ab3IDF4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:09 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34972 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab3IDF4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:06 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 3/9] regulator: max77693: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:07:56 +0530
Message-Id: <1378273082-28305-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max77693.c |   28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index ce4b96c..2054ae1 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -230,7 +230,7 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	struct max77693_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max77693_pmic_dev *max77693_pmic;
 	struct max77693_regulator_data *rdata = NULL;
-	int num_rdata, i, ret;
+	int num_rdata, i;
 	struct regulator_config config;
 
 	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
@@ -266,36 +266,17 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 		config.init_data = rdata[i].initdata;
 		config.of_node = rdata[i].of_node;
 
-		max77693_pmic->rdev[i] = regulator_register(&regulators[id],
-							    &config);
+		max77693_pmic->rdev[i] = devm_regulator_register(&pdev->dev,
+						&regulators[id], &config);
 		if (IS_ERR(max77693_pmic->rdev[i])) {
-			ret = PTR_ERR(max77693_pmic->rdev[i]);
 			dev_err(max77693_pmic->dev,
 				"Failed to initialize regulator-%d\n", id);
 			max77693_pmic->rdev[i] = NULL;
-			goto err;
+			return PTR_ERR(max77693_pmic->rdev[i]);
 		}
 	}
 
 	return 0;
- err:
-	while (--i >= 0)
-		regulator_unregister(max77693_pmic->rdev[i]);
-
-	return ret;
-}
-
-static int max77693_pmic_remove(struct platform_device *pdev)
-{
-	struct max77693_pmic_dev *max77693_pmic = platform_get_drvdata(pdev);
-	struct regulator_dev **rdev = max77693_pmic->rdev;
-	int i;
-
-	for (i = 0; i < max77693_pmic->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-
-	return 0;
 }
 
 static const struct platform_device_id max77693_pmic_id[] = {
@@ -311,7 +292,6 @@ static struct platform_driver max77693_pmic_driver = {
 		   .owner = THIS_MODULE,
 		   },
 	.probe = max77693_pmic_probe,
-	.remove = max77693_pmic_remove,
 	.id_table = max77693_pmic_id,
 };
 
-- 
1.7.9.5

