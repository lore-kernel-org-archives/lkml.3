Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621Ab3IDMFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:05:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62168 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537Ab3IDMFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:50 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 03/10] regulator: tps65023: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:46 +0530
Message-Id: <1378295273-32257-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps65023-regulator.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 9d053e2..8fbbdcc 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -277,12 +277,12 @@ static int tps_65023_probe(struct i2c_client *client,
 		config.regmap = tps->regmap;
 
 		/* Register the regulators */
-		rdev = regulator_register(&tps->desc[i], &config);
+		rdev = devm_regulator_register(&client->dev, &tps->desc[i],
+					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&client->dev, "failed to register %s\n",
 				id->name);
-			error = PTR_ERR(rdev);
-			goto fail;
+			return PTR_ERR(rdev);
 		}
 
 		/* Save regulator for cleanup */
@@ -296,21 +296,6 @@ static int tps_65023_probe(struct i2c_client *client,
 			TPS65023_REG_CTRL2_CORE_ADJ, TPS65023_REG_CTRL2_CORE_ADJ);
 
 	return 0;
-
- fail:
-	while (--i >= 0)
-		regulator_unregister(tps->rdev[i]);
-	return error;
-}
-
-static int tps_65023_remove(struct i2c_client *client)
-{
-	struct tps_pmic *tps = i2c_get_clientdata(client);
-	int i;
-
-	for (i = 0; i < TPS65023_NUM_REGULATOR; i++)
-		regulator_unregister(tps->rdev[i]);
-	return 0;
 }
 
 static const struct tps_info tps65020_regs[] = {
@@ -430,7 +415,6 @@ static struct i2c_driver tps_65023_i2c_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = tps_65023_probe,
-	.remove = tps_65023_remove,
 	.id_table = tps_65023_id,
 };
 
-- 
1.7.9.5

