Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab3KMGzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:55:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3KMGzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:55:18 -0500
Message-ID: <1384325714.7101.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: lp3972: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 13 Nov 2013 14:55:14 +0800
In-Reply-To: <1384325546.7101.2.camel@phoenix>
References: <1384325546.7101.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both num_regulators and **rdev are no longer required after this conversion,
thus remove them from struct lp3972.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp3972.c | 41 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 093e6f4..aea485a 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -22,8 +22,6 @@ struct lp3972 {
 	struct device *dev;
 	struct mutex io_lock;
 	struct i2c_client *i2c;
-	int num_regulators;
-	struct regulator_dev **rdev;
 };
 
 /* LP3972 Control Registers */
@@ -478,41 +476,27 @@ static int setup_regulators(struct lp3972 *lp3972,
 {
 	int i, err;
 
-	lp3972->num_regulators = pdata->num_regulators;
-	lp3972->rdev = kcalloc(pdata->num_regulators,
-				sizeof(struct regulator_dev *), GFP_KERNEL);
-	if (!lp3972->rdev) {
-		err = -ENOMEM;
-		goto err_nomem;
-	}
-
 	/* Instantiate the regulators */
 	for (i = 0; i < pdata->num_regulators; i++) {
 		struct lp3972_regulator_subdev *reg = &pdata->regulators[i];
 		struct regulator_config config = { };
+		struct regulator_dev *rdev;
 
 		config.dev = lp3972->dev;
 		config.init_data = reg->initdata;
 		config.driver_data = lp3972;
 
-		lp3972->rdev[i] = regulator_register(&regulators[reg->id],
-						     &config);
-		if (IS_ERR(lp3972->rdev[i])) {
-			err = PTR_ERR(lp3972->rdev[i]);
+		rdev = devm_regulator_register(lp3972->dev,
+					       &regulators[reg->id], &config);
+		if (IS_ERR(rdev)) {
+			err = PTR_ERR(rdev);
 			dev_err(lp3972->dev, "regulator init failed: %d\n",
 				err);
-			goto error;
+			return err;
 		}
 	}
 
 	return 0;
-error:
-	while (--i >= 0)
-		regulator_unregister(lp3972->rdev[i]);
-	kfree(lp3972->rdev);
-	lp3972->rdev = NULL;
-err_nomem:
-	return err;
 }
 
 static int lp3972_i2c_probe(struct i2c_client *i2c,
@@ -557,18 +541,6 @@ static int lp3972_i2c_probe(struct i2c_client *i2c,
 	return 0;
 }
 
-static int lp3972_i2c_remove(struct i2c_client *i2c)
-{
-	struct lp3972 *lp3972 = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < lp3972->num_regulators; i++)
-		regulator_unregister(lp3972->rdev[i]);
-	kfree(lp3972->rdev);
-
-	return 0;
-}
-
 static const struct i2c_device_id lp3972_i2c_id[] = {
 	{ "lp3972", 0 },
 	{ }
@@ -581,7 +553,6 @@ static struct i2c_driver lp3972_i2c_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe    = lp3972_i2c_probe,
-	.remove   = lp3972_i2c_remove,
 	.id_table = lp3972_i2c_id,
 };
 
-- 
1.8.1.2



