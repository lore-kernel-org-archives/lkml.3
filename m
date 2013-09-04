Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647Ab3IDMGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:06:00 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57822 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762574Ab3IDMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:58 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 05/10] regulator: tps65090: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:48 +0530
Message-Id: <1378295273-32257-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps65090-regulator.c |   35 +++++---------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index c8e7045..bd611cdf 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -279,7 +279,7 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 				if (ret < 0) {
 					dev_err(&pdev->dev,
 						"failed disable ext control\n");
-					goto scrub;
+					return ret;
 				}
 			}
 		}
@@ -296,12 +296,11 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 		else
 			config.of_node = NULL;
 
-		rdev = regulator_register(ri->desc, &config);
+		rdev = devm_regulator_register(&pdev->dev, ri->desc, &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc->name);
-			ret = PTR_ERR(rdev);
-			goto scrub;
+			return PTR_ERR(rdev);
 		}
 		ri->rdev = rdev;
 
@@ -309,36 +308,13 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data &&
 				tps_pdata->enable_ext_control) {
 			ret = tps65090_config_ext_control(ri, true);
-			if (ret < 0) {
-				/* Increment num to get unregister rdev */
-				num++;
-				goto scrub;
-			}
+			if (ret < 0)
+				return ret;
 		}
 	}
 
 	platform_set_drvdata(pdev, pmic);
 	return 0;
-
-scrub:
-	while (--num >= 0) {
-		ri = &pmic[num];
-		regulator_unregister(ri->rdev);
-	}
-	return ret;
-}
-
-static int tps65090_regulator_remove(struct platform_device *pdev)
-{
-	struct tps65090_regulator *pmic = platform_get_drvdata(pdev);
-	struct tps65090_regulator *ri;
-	int num;
-
-	for (num = 0; num < TPS65090_REGULATOR_MAX; ++num) {
-		ri = &pmic[num];
-		regulator_unregister(ri->rdev);
-	}
-	return 0;
 }
 
 static struct platform_driver tps65090_regulator_driver = {
@@ -347,7 +323,6 @@ static struct platform_driver tps65090_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= tps65090_regulator_probe,
-	.remove		= tps65090_regulator_remove,
 };
 
 static int __init tps65090_regulator_init(void)
-- 
1.7.9.5

