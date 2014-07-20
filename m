Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaGTLTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:19:41 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61870 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaGTLTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:19:39 -0400
Message-ID: <1405855175.27371.1.camel@phoenix>
Subject: [PATCH] regulator: da9211: Remove unnecessary
 devm_regulator_unregister() calls
From: Axel Lin <axel.lin@ingics.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: James Ban <James.Ban.opensource@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 20 Jul 2014 19:19:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses devm_regulator_register(), so the resource management code
will ensure that the resource is freed.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9211-regulator.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index bd18506..1482ada 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -245,7 +245,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 	ret = regmap_read(chip->regmap, DA9211_REG_CONFIG_E, &data);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to read CONTROL_E reg: %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	data &= DA9211_SLAVE_SEL;
@@ -259,9 +259,8 @@ static int da9211_regulator_init(struct da9211 *chip)
 		else
 			chip->num_regulator = 2;
 	} else {
-		ret = -EINVAL;
 		dev_err(chip->dev, "Configuration is mismatched\n");
-		goto err;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < chip->num_regulator; i++) {
@@ -278,8 +277,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 		if (IS_ERR(chip->rdev[i])) {
 			dev_err(chip->dev,
 				"Failed to register DA9211 regulator\n");
-			ret = PTR_ERR(chip->rdev[i]);
-			goto err_regulator;
+			return PTR_ERR(chip->rdev[i]);
 		}
 
 		if (chip->chip_irq != 0) {
@@ -288,18 +286,12 @@ static int da9211_regulator_init(struct da9211 *chip)
 			if (ret < 0) {
 				dev_err(chip->dev,
 					"Failed to update mask reg: %d\n", ret);
-				goto err_regulator;
+				return ret;
 			}
 		}
 	}
 
 	return 0;
-
-err_regulator:
-	while (--i >= 0)
-		devm_regulator_unregister(chip->dev, chip->rdev[i]);
-err:
-	return ret;
 }
 /*
  * I2C driver interface functions
@@ -353,17 +345,6 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	return ret;
 }
 
-static int da9211_i2c_remove(struct i2c_client *i2c)
-{
-	struct da9211 *chip = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < chip->num_regulator; i++)
-		devm_regulator_unregister(chip->dev, chip->rdev[i]);
-
-	return 0;
-}
-
 static const struct i2c_device_id da9211_i2c_id[] = {
 	{"da9211", 0},
 	{},
@@ -377,7 +358,6 @@ static struct i2c_driver da9211_regulator_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = da9211_i2c_probe,
-	.remove = da9211_i2c_remove,
 	.id_table = da9211_i2c_id,
 };
 
-- 
1.9.1



