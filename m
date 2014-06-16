Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaFPCMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 22:12:31 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60388 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaFPCMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 22:12:30 -0400
Message-ID: <1402884745.16047.2.camel@phoenix>
Subject: [PATCH] regulator: max8952: Convert to devm_gpio_request_one()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 10:12:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8952.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index c2792f0..f7f9efc 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -229,7 +229,6 @@ static int max8952_pmic_probe(struct i2c_client *client,
 		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 
 	rdev = devm_regulator_register(&client->dev, &regulator, &config);
-
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&client->dev, "regulator init failed (%d)\n", ret);
@@ -241,21 +240,19 @@ static int max8952_pmic_probe(struct i2c_client *client,
 
 	if (gpio_is_valid(pdata->gpio_vid0) &&
 			gpio_is_valid(pdata->gpio_vid1)) {
-		if (!gpio_request(pdata->gpio_vid0, "MAX8952 VID0"))
-			gpio_direction_output(pdata->gpio_vid0,
-					(pdata->default_mode) & 0x1);
-		else
+		unsigned long gpio_flags;
+
+		gpio_flags = max8952->vid0 ?
+			     GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+		if (devm_gpio_request_one(&client->dev, pdata->gpio_vid0,
+					  gpio_flags, "MAX8952 VID0"))
 			err = 1;
 
-		if (!gpio_request(pdata->gpio_vid1, "MAX8952 VID1"))
-			gpio_direction_output(pdata->gpio_vid1,
-				(pdata->default_mode >> 1) & 0x1);
-		else {
-			if (!err)
-				gpio_free(pdata->gpio_vid0);
+		gpio_flags = max8952->vid1 ?
+			     GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+		if (devm_gpio_request_one(&client->dev, pdata->gpio_vid1,
+					  gpio_flags, "MAX8952 VID1"))
 			err = 2;
-		}
-
 	} else
 		err = 3;
 
@@ -314,16 +311,6 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int max8952_pmic_remove(struct i2c_client *client)
-{
-	struct max8952_data *max8952 = i2c_get_clientdata(client);
-	struct max8952_platform_data *pdata = max8952->pdata;
-
-	gpio_free(pdata->gpio_vid0);
-	gpio_free(pdata->gpio_vid1);
-	return 0;
-}
-
 static const struct i2c_device_id max8952_ids[] = {
 	{ "max8952", 0 },
 	{ },
@@ -332,7 +319,6 @@ MODULE_DEVICE_TABLE(i2c, max8952_ids);
 
 static struct i2c_driver max8952_pmic_driver = {
 	.probe		= max8952_pmic_probe,
-	.remove		= max8952_pmic_remove,
 	.driver		= {
 		.name	= "max8952",
 		.of_match_table = of_match_ptr(max8952_dt_match),
-- 
1.8.3.2



