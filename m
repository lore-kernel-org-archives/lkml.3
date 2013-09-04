Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095Ab3IDGtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:49:14 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38946 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab3IDGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:49:10 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Subject: [PATCH 4/7] regulator: mc13892: Use devm_regulator_register
Date: Wed,  4 Sep 2013 12:01:00 +0530
Message-Id: <1378276263-10735-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/mc13892-regulator.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 1037e07..96c9f80 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -611,43 +611,27 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 		config.driver_data = priv;
 		config.of_node = node;
 
-		priv->regulators[i] = regulator_register(desc, &config);
+		priv->regulators[i] = devm_regulator_register(&pdev->dev, desc,
+							      &config);
 		if (IS_ERR(priv->regulators[i])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 				mc13892_regulators[i].desc.name);
-			ret = PTR_ERR(priv->regulators[i]);
-			goto err;
+			return PTR_ERR(priv->regulators[i]);
 		}
 	}
 
 	return 0;
-err:
-	while (--i >= 0)
-		regulator_unregister(priv->regulators[i]);
-	return ret;
 
 err_unlock:
 	mc13xxx_unlock(mc13892);
 	return ret;
 }
 
-static int mc13892_regulator_remove(struct platform_device *pdev)
-{
-	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < priv->num_regulators; i++)
-		regulator_unregister(priv->regulators[i]);
-
-	return 0;
-}
-
 static struct platform_driver mc13892_regulator_driver = {
 	.driver	= {
 		.name	= "mc13892-regulator",
 		.owner	= THIS_MODULE,
 	},
-	.remove	= mc13892_regulator_remove,
 	.probe	= mc13892_regulator_probe,
 };
 
-- 
1.7.9.5

