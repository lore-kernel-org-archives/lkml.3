Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698Ab3IDMGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:06:20 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36949 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934613Ab3IDMGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:06:16 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 10/10] regulator: tps80031: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:53 +0530
Message-Id: <1378295273-32257-10-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps80031-regulator.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 6511d0b..71f457a 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -719,7 +719,7 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 			if (ret < 0) {
 				dev_err(&pdev->dev,
 					"regulator config failed, e %d\n", ret);
-				goto fail;
+				return ret;
 			}
 
 			ret = tps80031_power_req_config(pdev->dev.parent,
@@ -727,41 +727,22 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 			if (ret < 0) {
 				dev_err(&pdev->dev,
 					"pwr_req config failed, err %d\n", ret);
-				goto fail;
+				return ret;
 			}
 		}
-		rdev = regulator_register(&ri->rinfo->desc, &config);
+		rdev = devm_regulator_register(&pdev->dev, &ri->rinfo->desc,
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
 				"register regulator failed %s\n",
 					ri->rinfo->desc.name);
-			ret = PTR_ERR(rdev);
-			goto fail;
+			return PTR_ERR(rdev);
 		}
 		ri->rdev = rdev;
 	}
 
 	platform_set_drvdata(pdev, pmic);
 	return 0;
-fail:
-	while (--num >= 0) {
-		ri = &pmic[num];
-		regulator_unregister(ri->rdev);
-	}
-	return ret;
-}
-
-static int tps80031_regulator_remove(struct platform_device *pdev)
-{
-	struct tps80031_regulator *pmic = platform_get_drvdata(pdev);
-	struct tps80031_regulator *ri = NULL;
-	int num;
-
-	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
-		ri = &pmic[num];
-		regulator_unregister(ri->rdev);
-	}
-	return 0;
 }
 
 static struct platform_driver tps80031_regulator_driver = {
@@ -770,7 +751,6 @@ static struct platform_driver tps80031_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= tps80031_regulator_probe,
-	.remove		= tps80031_regulator_remove,
 };
 
 static int __init tps80031_regulator_init(void)
-- 
1.7.9.5

