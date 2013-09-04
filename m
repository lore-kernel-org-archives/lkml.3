Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab3IDF4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59425 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3IDF4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:15 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 6/9] regulator: max8907-regulator: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:07:59 +0530
Message-Id: <1378273082-28305-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8907-regulator.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 4568c15..0c5fe6c 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -350,33 +350,17 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 				pmic->desc[i].ops = &max8907_out5v_hwctl_ops;
 		}
 
-		pmic->rdev[i] = regulator_register(&pmic->desc[i], &config);
+		pmic->rdev[i] = devm_regulator_register(&pdev->dev,
+						&pmic->desc[i], &config);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&pdev->dev,
 				"failed to register %s regulator\n",
 				pmic->desc[i].name);
-			ret = PTR_ERR(pmic->rdev[i]);
-			goto err_unregister_regulator;
+			return PTR_ERR(pmic->rdev[i]);
 		}
 	}
 
 	return 0;
-
-err_unregister_regulator:
-	while (--i >= 0)
-		regulator_unregister(pmic->rdev[i]);
-	return ret;
-}
-
-static int max8907_regulator_remove(struct platform_device *pdev)
-{
-	struct max8907_regulator *pmic = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < MAX8907_NUM_REGULATORS; i++)
-		regulator_unregister(pmic->rdev[i]);
-
-	return 0;
 }
 
 static struct platform_driver max8907_regulator_driver = {
@@ -385,7 +369,6 @@ static struct platform_driver max8907_regulator_driver = {
 		   .owner = THIS_MODULE,
 		   },
 	.probe = max8907_regulator_probe,
-	.remove = max8907_regulator_remove,
 };
 
 static int __init max8907_regulator_init(void)
-- 
1.7.9.5

