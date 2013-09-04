Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab3IDMGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:06:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56967 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934613Ab3IDMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:06:08 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 08/10] regulator: tps65910: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:51 +0530
Message-Id: <1378295273-32257-8-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps65910-regulator.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 45c1644..b8167df 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1177,35 +1177,19 @@ static int tps65910_probe(struct platform_device *pdev)
 		if (tps65910_reg_matches)
 			config.of_node = tps65910_reg_matches[i].of_node;
 
-		rdev = regulator_register(&pmic->desc[i], &config);
+		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[i],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65910->dev,
 				"failed to register %s regulator\n",
 				pdev->name);
-			err = PTR_ERR(rdev);
-			goto err_unregister_regulator;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
 		pmic->rdev[i] = rdev;
 	}
 	return 0;
-
-err_unregister_regulator:
-	while (--i >= 0)
-		regulator_unregister(pmic->rdev[i]);
-	return err;
-}
-
-static int tps65910_remove(struct platform_device *pdev)
-{
-	struct tps65910_reg *pmic = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < pmic->num_regulators; i++)
-		regulator_unregister(pmic->rdev[i]);
-
-	return 0;
 }
 
 static void tps65910_shutdown(struct platform_device *pdev)
@@ -1244,7 +1228,6 @@ static struct platform_driver tps65910_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = tps65910_probe,
-	.remove = tps65910_remove,
 	.shutdown = tps65910_shutdown,
 };
 
-- 
1.7.9.5

