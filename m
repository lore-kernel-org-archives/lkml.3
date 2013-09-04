Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab3IDMGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:06:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42660 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762574Ab3IDMGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:06:02 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 06/10] regulator: tps65217: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:49 +0530
Message-Id: <1378295273-32257-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps65217-regulator.c |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 2df4616..8c0467b 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -339,7 +339,7 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
-	int i, ret;
+	int i;
 
 	if (tps->dev->of_node)
 		pdata = tps65217_parse_dt(pdev);
@@ -377,35 +377,18 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 		if (tps->dev->of_node)
 			config.of_node = pdata->of_node[i];
 
-		rdev = regulator_register(&regulators[i], &config);
+		rdev = devm_regulator_register(&pdev->dev, &regulators[i],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps->dev, "failed to register %s regulator\n",
 				pdev->name);
-			ret = PTR_ERR(rdev);
-			goto err_unregister_regulator;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
 		tps->rdev[i] = rdev;
 	}
 	return 0;
-
-err_unregister_regulator:
-	while (--i >= 0)
-		regulator_unregister(tps->rdev[i]);
-
-	return ret;
-}
-
-static int tps65217_regulator_remove(struct platform_device *pdev)
-{
-	struct tps65217 *tps = platform_get_drvdata(pdev);
-	unsigned int i;
-
-	for (i = 0; i < TPS65217_NUM_REGULATOR; i++)
-		regulator_unregister(tps->rdev[i]);
-
-	return 0;
 }
 
 static struct platform_driver tps65217_regulator_driver = {
@@ -413,7 +396,6 @@ static struct platform_driver tps65217_regulator_driver = {
 		.name = "tps65217-pmic",
 	},
 	.probe = tps65217_regulator_probe,
-	.remove = tps65217_regulator_remove,
 };
 
 static int __init tps65217_regulator_init(void)
-- 
1.7.9.5

