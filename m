Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163Ab3IDGuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:50:35 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64946 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762068Ab3IDGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:49:09 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Subject: [PATCH 3/7] regulator: mc13783: Use devm_regulator_register
Date: Wed,  4 Sep 2013 12:00:59 +0530
Message-Id: <1378276263-10735-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/mc13783-regulator.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 5ff99d2..f036b26 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -400,7 +400,7 @@ static int mc13783_regulator_probe(struct platform_device *pdev)
 		dev_get_platdata(&pdev->dev);
 	struct mc13xxx_regulator_init_data *mc13xxx_data;
 	struct regulator_config config = { };
-	int i, ret, num_regulators;
+	int i, num_regulators;
 
 	num_regulators = mc13xxx_get_num_regulators_dt(pdev);
 
@@ -444,32 +444,16 @@ static int mc13783_regulator_probe(struct platform_device *pdev)
 		config.driver_data = priv;
 		config.of_node = node;
 
-		priv->regulators[i] = regulator_register(desc, &config);
+		priv->regulators[i] = devm_regulator_register(&pdev->dev, desc,
+							      &config);
 		if (IS_ERR(priv->regulators[i])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 				mc13783_regulators[i].desc.name);
-			ret = PTR_ERR(priv->regulators[i]);
-			goto err;
+			return PTR_ERR(priv->regulators[i]);
 		}
 	}
 
 	return 0;
-err:
-	while (--i >= 0)
-		regulator_unregister(priv->regulators[i]);
-
-	return ret;
-}
-
-static int mc13783_regulator_remove(struct platform_device *pdev)
-{
-	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < priv->num_regulators; i++)
-		regulator_unregister(priv->regulators[i]);
-
-	return 0;
 }
 
 static struct platform_driver mc13783_regulator_driver = {
@@ -477,7 +461,6 @@ static struct platform_driver mc13783_regulator_driver = {
 		.name	= "mc13783-regulator",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= mc13783_regulator_remove,
 	.probe		= mc13783_regulator_probe,
 };
 
-- 
1.7.9.5

