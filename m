Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab3IDFz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:55:58 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41476 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3IDFz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:55:57 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 1/9] regulator: max77686: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:07:54 +0530
Message-Id: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This series is compile tested.
---
 drivers/regulator/max77686.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index f563057..de5b30e 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -478,32 +478,17 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		config.of_node = pdata->regulators[i].of_node;
 
 		max77686->opmode[i] = regulators[i].enable_mask;
-		max77686->rdev[i] = regulator_register(&regulators[i], &config);
+		max77686->rdev[i] = devm_regulator_register(&pdev->dev,
+						&regulators[i], &config);
 		if (IS_ERR(max77686->rdev[i])) {
-			ret = PTR_ERR(max77686->rdev[i]);
 			dev_err(&pdev->dev,
 				"regulator init failed for %d\n", i);
 			max77686->rdev[i] = NULL;
-			goto err;
+			return PTR_ERR(max77686->rdev[i]);
 		}
 	}
 
 	return 0;
-err:
-	while (--i >= 0)
-		regulator_unregister(max77686->rdev[i]);
-	return ret;
-}
-
-static int max77686_pmic_remove(struct platform_device *pdev)
-{
-	struct max77686_data *max77686 = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < MAX77686_REGULATORS; i++)
-		regulator_unregister(max77686->rdev[i]);
-
-	return 0;
 }
 
 static const struct platform_device_id max77686_pmic_id[] = {
@@ -518,7 +503,6 @@ static struct platform_driver max77686_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = max77686_pmic_probe,
-	.remove = max77686_pmic_remove,
 	.id_table = max77686_pmic_id,
 };
 
-- 
1.7.9.5

