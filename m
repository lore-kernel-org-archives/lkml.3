Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab3IDMGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:06:42 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51190 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934622Ab3IDMGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:06:12 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 09/10] regulator: tps65912: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:52 +0530
Message-Id: <1378295273-32257-9-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps65912-regulator.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 17e994e..3301af8 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -468,7 +468,7 @@ static int tps65912_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct tps65912_reg *pmic;
 	struct tps65912_board *pmic_plat_data;
-	int i, err;
+	int i;
 
 	pmic_plat_data = dev_get_platdata(tps65912->dev);
 	if (!pmic_plat_data)
@@ -505,34 +505,19 @@ static int tps65912_probe(struct platform_device *pdev)
 		config.init_data = reg_data;
 		config.driver_data = pmic;
 
-		rdev = regulator_register(&pmic->desc[i], &config);
+		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[i],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65912->dev,
 				"failed to register %s regulator\n",
 				pdev->name);
-			err = PTR_ERR(rdev);
-			goto err;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
 		pmic->rdev[i] = rdev;
 	}
 	return 0;
-
-err:
-	while (--i >= 0)
-		regulator_unregister(pmic->rdev[i]);
-	return err;
-}
-
-static int tps65912_remove(struct platform_device *pdev)
-{
-	struct tps65912_reg *tps65912_reg = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < TPS65912_NUM_REGULATOR; i++)
-		regulator_unregister(tps65912_reg->rdev[i]);
-	return 0;
 }
 
 static struct platform_driver tps65912_driver = {
@@ -541,7 +526,6 @@ static struct platform_driver tps65912_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = tps65912_probe,
-	.remove = tps65912_remove,
 };
 
 static int __init tps65912_init(void)
-- 
1.7.9.5

