Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab3IDF4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:05 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42822 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab3IDF4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:01 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 2/9] regulator: max1586: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:07:55 +0530
Message-Id: <1378273082-28305-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max1586.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 54af610..3abf76a 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -166,7 +166,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
 	struct max1586_platform_data *pdata = client->dev.platform_data;
 	struct regulator_config config = { };
 	struct max1586_data *max1586;
-	int i, id, ret = -ENOMEM;
+	int i, id;
 
 	max1586 = devm_kzalloc(&client->dev, sizeof(struct max1586_data) +
 			sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
@@ -193,7 +193,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
 			continue;
 		if (id < MAX1586_V3 || id > MAX1586_V6) {
 			dev_err(&client->dev, "invalid regulator id %d\n", id);
-			goto err;
+			return -EINVAL;
 		}
 
 		if (id == MAX1586_V3) {
@@ -207,33 +207,18 @@ static int max1586_pmic_probe(struct i2c_client *client,
 		config.init_data = pdata->subdevs[i].platform_data;
 		config.driver_data = max1586;
 
-		rdev[i] = regulator_register(&max1586_reg[id], &config);
+		rdev[i] = devm_regulator_register(&client->dev,
+						  &max1586_reg[id], &config);
 		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
 				max1586_reg[id].name);
-			goto err;
+			return PTR_ERR(rdev[i]);
 		}
 	}
 
 	i2c_set_clientdata(client, max1586);
 	dev_info(&client->dev, "Maxim 1586 regulator driver loaded\n");
 	return 0;
-
-err:
-	while (--i >= 0)
-		regulator_unregister(rdev[i]);
-	return ret;
-}
-
-static int max1586_pmic_remove(struct i2c_client *client)
-{
-	struct max1586_data *max1586 = i2c_get_clientdata(client);
-	int i;
-
-	for (i = 0; i <= MAX1586_V6; i++)
-		regulator_unregister(max1586->rdev[i]);
-	return 0;
 }
 
 static const struct i2c_device_id max1586_id[] = {
@@ -244,7 +229,6 @@ MODULE_DEVICE_TABLE(i2c, max1586_id);
 
 static struct i2c_driver max1586_pmic_driver = {
 	.probe = max1586_pmic_probe,
-	.remove = max1586_pmic_remove,
 	.driver		= {
 		.name	= "max1586",
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

