Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3K0C6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:58:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38506 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3K0C62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:58:28 -0500
Message-ID: <1385521101.29941.1.camel@phoenix>
Subject: [PATCH RESEND] regulator: lp3971: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 27 Nov 2013 10:58:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both num_regulators and **rdev are no longer required after this conversion,
thus remove them from struct lp3971.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Mark,
This patch was sent on https://lkml.org/lkml/2013/11/13/34 .
Although you replied applied, it still not in your tree.
So here is a resend.

Axel
 drivers/regulator/lp3971.c | 43 ++++++-------------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 947c05f..3b1102b 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -25,8 +25,6 @@ struct lp3971 {
 	struct device *dev;
 	struct mutex io_lock;
 	struct i2c_client *i2c;
-	int num_regulators;
-	struct regulator_dev **rdev;
 };
 
 static u8 lp3971_reg_read(struct lp3971 *lp3971, u8 reg);
@@ -383,42 +381,27 @@ static int setup_regulators(struct lp3971 *lp3971,
 {
 	int i, err;
 
-	lp3971->num_regulators = pdata->num_regulators;
-	lp3971->rdev = kcalloc(pdata->num_regulators,
-				sizeof(struct regulator_dev *), GFP_KERNEL);
-	if (!lp3971->rdev) {
-		err = -ENOMEM;
-		goto err_nomem;
-	}
-
 	/* Instantiate the regulators */
 	for (i = 0; i < pdata->num_regulators; i++) {
 		struct regulator_config config = { };
 		struct lp3971_regulator_subdev *reg = &pdata->regulators[i];
+		struct regulator_dev *rdev;
 
 		config.dev = lp3971->dev;
 		config.init_data = reg->initdata;
 		config.driver_data = lp3971;
 
-		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
-						     &config);
-		if (IS_ERR(lp3971->rdev[i])) {
-			err = PTR_ERR(lp3971->rdev[i]);
+		rdev = devm_regulator_register(lp3971->dev,
+					       &regulators[reg->id], &config);
+		if (IS_ERR(rdev)) {
+			err = PTR_ERR(rdev);
 			dev_err(lp3971->dev, "regulator init failed: %d\n",
 				err);
-			goto error;
+			return err;
 		}
 	}
 
 	return 0;
-
-error:
-	while (--i >= 0)
-		regulator_unregister(lp3971->rdev[i]);
-	kfree(lp3971->rdev);
-	lp3971->rdev = NULL;
-err_nomem:
-	return err;
 }
 
 static int lp3971_i2c_probe(struct i2c_client *i2c,
@@ -460,19 +443,6 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
 	return 0;
 }
 
-static int lp3971_i2c_remove(struct i2c_client *i2c)
-{
-	struct lp3971 *lp3971 = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < lp3971->num_regulators; i++)
-		regulator_unregister(lp3971->rdev[i]);
-
-	kfree(lp3971->rdev);
-
-	return 0;
-}
-
 static const struct i2c_device_id lp3971_i2c_id[] = {
 	{ "lp3971", 0 },
 	{ }
@@ -485,7 +455,6 @@ static struct i2c_driver lp3971_i2c_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe    = lp3971_i2c_probe,
-	.remove   = lp3971_i2c_remove,
 	.id_table = lp3971_i2c_id,
 };
 
-- 
1.8.1.2



