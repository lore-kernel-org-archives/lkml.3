Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377Ab3IDF4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40898 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab3IDF4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:12 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 5/9] regulator: max8660: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:07:58 +0530
Message-Id: <1378273082-28305-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8660.c |   29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index d428ef9..a057342 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -352,7 +352,7 @@ static int max8660_probe(struct i2c_client *client,
 	for (i = 0; i < pdata->num_subdevs; i++) {
 
 		if (!pdata->subdevs[i].platform_data)
-			goto err_out;
+			return ret;
 
 		boot_on = pdata->subdevs[i].platform_data->constraints.boot_on;
 
@@ -378,7 +378,7 @@ static int max8660_probe(struct i2c_client *client,
 		case MAX8660_V7:
 			if (!strcmp(i2c_id->name, "max8661")) {
 				dev_err(&client->dev, "Regulator not on this chip!\n");
-				goto err_out;
+				return ret;
 			}
 
 			if (boot_on)
@@ -388,7 +388,7 @@ static int max8660_probe(struct i2c_client *client,
 		default:
 			dev_err(&client->dev, "invalid regulator %s\n",
 				 pdata->subdevs[i].name);
-			goto err_out;
+			return ret;
 		}
 	}
 
@@ -401,33 +401,17 @@ static int max8660_probe(struct i2c_client *client,
 		config.init_data = pdata->subdevs[i].platform_data;
 		config.driver_data = max8660;
 
-		rdev[i] = regulator_register(&max8660_reg[id], &config);
+		rdev[i] = devm_regulator_register(&client->dev,
+						  &max8660_reg[id], &config);
 		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
 				max8660_reg[id].name);
-			goto err_unregister;
+			return PTR_ERR(rdev[i]);
 		}
 	}
 
 	i2c_set_clientdata(client, max8660);
 	return 0;
-
-err_unregister:
-	while (--i >= 0)
-		regulator_unregister(rdev[i]);
-err_out:
-	return ret;
-}
-
-static int max8660_remove(struct i2c_client *client)
-{
-	struct max8660 *max8660 = i2c_get_clientdata(client);
-	int i;
-
-	for (i = 0; i < MAX8660_V_END; i++)
-		regulator_unregister(max8660->rdev[i]);
-	return 0;
 }
 
 static const struct i2c_device_id max8660_id[] = {
@@ -439,7 +423,6 @@ MODULE_DEVICE_TABLE(i2c, max8660_id);
 
 static struct i2c_driver max8660_driver = {
 	.probe = max8660_probe,
-	.remove = max8660_remove,
 	.driver		= {
 		.name	= "max8660",
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

