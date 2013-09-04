Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778Ab3IDMHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:07:14 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63015 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762650Ab3IDMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:06:05 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 07/10] regulator: tps6586x: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:50 +0530
Message-Id: <1378295273-32257-7-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps6586x-regulator.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 2c9155b..45e5d68 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -379,15 +379,14 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 		ri = find_regulator_info(id);
 		if (!ri) {
 			dev_err(&pdev->dev, "invalid regulator ID specified\n");
-			err = -EINVAL;
-			goto fail;
+			return -EINVAL;
 		}
 
 		err = tps6586x_regulator_preinit(pdev->dev.parent, ri);
 		if (err) {
 			dev_err(&pdev->dev,
 				"regulator %d preinit failed, e %d\n", id, err);
-			goto fail;
+			return err;
 		}
 
 		config.dev = pdev->dev.parent;
@@ -397,12 +396,12 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 		if (tps6586x_reg_matches)
 			config.of_node = tps6586x_reg_matches[id].of_node;
 
-		rdev[id] = regulator_register(&ri->desc, &config);
+		rdev[id] = devm_regulator_register(&pdev->dev, &ri->desc,
+						   &config);
 		if (IS_ERR(rdev[id])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 					ri->desc.name);
-			err = PTR_ERR(rdev[id]);
-			goto fail;
+			return PTR_ERR(rdev[id]);
 		}
 
 		if (reg_data) {
@@ -411,30 +410,13 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 			if (err < 0) {
 				dev_err(&pdev->dev,
 					"Slew rate config failed, e %d\n", err);
-				regulator_unregister(rdev[id]);
-				goto fail;
+				return err;
 			}
 		}
 	}
 
 	platform_set_drvdata(pdev, rdev);
 	return 0;
-
-fail:
-	while (--id >= 0)
-		regulator_unregister(rdev[id]);
-	return err;
-}
-
-static int tps6586x_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev **rdev = platform_get_drvdata(pdev);
-	int id = TPS6586X_ID_MAX_REGULATOR;
-
-	while (--id >= 0)
-		regulator_unregister(rdev[id]);
-
-	return 0;
 }
 
 static struct platform_driver tps6586x_regulator_driver = {
@@ -443,7 +425,6 @@ static struct platform_driver tps6586x_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= tps6586x_regulator_probe,
-	.remove		= tps6586x_regulator_remove,
 };
 
 static int __init tps6586x_regulator_init(void)
-- 
1.7.9.5

