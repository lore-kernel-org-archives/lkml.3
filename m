Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762634Ab3IDMF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:05:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62656 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537Ab3IDMFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:54 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 04/10] regulator: tps6507x: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:47 +0530
Message-Id: <1378295273-32257-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps6507x-regulator.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 4117ff5..162a0fa 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -508,13 +508,13 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 			config.of_node = tps6507x_reg_matches[i].of_node;
 		}
 
-		rdev = regulator_register(&tps->desc[i], &config);
+		rdev = devm_regulator_register(&pdev->dev, &tps->desc[i],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps6507x_dev->dev,
 				"failed to register %s regulator\n",
 				pdev->name);
-			error = PTR_ERR(rdev);
-			goto fail;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
@@ -525,22 +525,6 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, tps6507x_dev);
 
 	return 0;
-
-fail:
-	while (--i >= 0)
-		regulator_unregister(tps->rdev[i]);
-	return error;
-}
-
-static int tps6507x_pmic_remove(struct platform_device *pdev)
-{
-	struct tps6507x_dev *tps6507x_dev = platform_get_drvdata(pdev);
-	struct tps6507x_pmic *tps = tps6507x_dev->pmic;
-	int i;
-
-	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++)
-		regulator_unregister(tps->rdev[i]);
-	return 0;
 }
 
 static struct platform_driver tps6507x_pmic_driver = {
@@ -549,7 +533,6 @@ static struct platform_driver tps6507x_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = tps6507x_pmic_probe,
-	.remove = tps6507x_pmic_remove,
 };
 
 static int __init tps6507x_pmic_init(void)
-- 
1.7.9.5

