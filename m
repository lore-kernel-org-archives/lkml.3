Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109Ab3IDGtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:49:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36901 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab3IDGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:49:14 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Subject: [PATCH 5/7] regulator: palmas: Use devm_regulator_register
Date: Wed,  4 Sep 2013 12:01:01 +0530
Message-Id: <1378276263-10735-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/palmas-regulator.c |   38 ++++++++++------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d0c8785..37b1068 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -852,7 +852,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			if (ret < 0) {
 				dev_err(&pdev->dev,
 					"reading TSTEP reg failed: %d\n", ret);
-				goto err_unregister_regulator;
+				return ret;
 			}
 			pmic->desc[id].ramp_delay =
 					palmas_smps_ramp_delay[reg & 0x3];
@@ -864,7 +864,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			reg_init = pdata->reg_init[id];
 			ret = palmas_smps_init(palmas, id, reg_init);
 			if (ret)
-				goto err_unregister_regulator;
+				return ret;
 		}
 
 		/* Register the regulators */
@@ -897,7 +897,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
 			if (ret)
-				goto err_unregister_regulator;
+				return ret;
 			if (reg & PALMAS_SMPS12_VOLTAGE_RANGE)
 				pmic->range[id] = 1;
 
@@ -913,7 +913,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			addr = palmas_regs_info[id].ctrl_addr;
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
 			if (ret)
-				goto err_unregister_regulator;
+				return ret;
 			pmic->current_reg_mode[id] = reg &
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 		}
@@ -929,13 +929,13 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		pmic->desc[id].supply_name = palmas_regs_info[id].sname;
 		config.of_node = palmas_matches[id].of_node;
 
-		rdev = regulator_register(&pmic->desc[id], &config);
+		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[id],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
 				"failed to register %s regulator\n",
 				pdev->name);
-			ret = PTR_ERR(rdev);
-			goto err_unregister_regulator;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
@@ -997,13 +997,13 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		pmic->desc[id].supply_name = palmas_regs_info[id].sname;
 		config.of_node = palmas_matches[id].of_node;
 
-		rdev = regulator_register(&pmic->desc[id], &config);
+		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[id],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
 				"failed to register %s regulator\n",
 				pdev->name);
-			ret = PTR_ERR(rdev);
-			goto err_unregister_regulator;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
@@ -1021,7 +1021,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 							id, reg_init);
 				if (ret) {
 					regulator_unregister(pmic->rdev[id]);
-					goto err_unregister_regulator;
+					return ret;
 				}
 			}
 		}
@@ -1029,21 +1029,6 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 
 
 	return 0;
-
-err_unregister_regulator:
-	while (--id >= 0)
-		regulator_unregister(pmic->rdev[id]);
-	return ret;
-}
-
-static int palmas_regulators_remove(struct platform_device *pdev)
-{
-	struct palmas_pmic *pmic = platform_get_drvdata(pdev);
-	int id;
-
-	for (id = 0; id < PALMAS_NUM_REGS; id++)
-		regulator_unregister(pmic->rdev[id]);
-	return 0;
 }
 
 static struct of_device_id of_palmas_match_tbl[] = {
@@ -1065,7 +1050,6 @@ static struct platform_driver palmas_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = palmas_regulators_probe,
-	.remove = palmas_regulators_remove,
 };
 
 static int __init palmas_init(void)
-- 
1.7.9.5

