Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080Ab3IDGtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:49:09 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60180 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab3IDGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:49:05 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Subject: [PATCH 2/7] regulator: isl6271a-regulator: Use devm_regulator_register
Date: Wed,  4 Sep 2013 12:00:58 +0530
Message-Id: <1378276263-10735-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/isl6271a-regulator.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index b99c49b..40c224f 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -112,7 +112,7 @@ static int isl6271a_probe(struct i2c_client *i2c,
 	struct regulator_config config = { };
 	struct regulator_init_data *init_data	= i2c->dev.platform_data;
 	struct isl_pmic *pmic;
-	int err, i;
+	int i;
 
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
@@ -133,32 +133,17 @@ static int isl6271a_probe(struct i2c_client *i2c,
 			config.init_data = NULL;
 		config.driver_data = pmic;
 
-		pmic->rdev[i] = regulator_register(&isl_rd[i], &config);
+		pmic->rdev[i] = devm_regulator_register(&i2c->dev, &isl_rd[i],
+							&config);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
-			err = PTR_ERR(pmic->rdev[i]);
-			goto error;
+			return PTR_ERR(pmic->rdev[i]);
 		}
 	}
 
 	i2c_set_clientdata(i2c, pmic);
 
 	return 0;
-
-error:
-	while (--i >= 0)
-		regulator_unregister(pmic->rdev[i]);
-	return err;
-}
-
-static int isl6271a_remove(struct i2c_client *i2c)
-{
-	struct isl_pmic *pmic = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < 3; i++)
-		regulator_unregister(pmic->rdev[i]);
-	return 0;
 }
 
 static const struct i2c_device_id isl6271a_id[] = {
@@ -174,7 +159,6 @@ static struct i2c_driver isl6271a_i2c_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = isl6271a_probe,
-	.remove = isl6271a_remove,
 	.id_table = isl6271a_id,
 };
 
-- 
1.7.9.5

