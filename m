Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbbAZCZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:25:19 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44294 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbAZCZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:25:17 -0500
Message-ID: <1422239113.8261.1.camel@phoenix>
Subject: [PATCH] regulator: lp872x: Remove **regulators from struct lp872x
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2015 10:25:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code is using devm_regulator_register(), so we don't need to store *rdev
in struct lp872x for clean up.
Also clean up lp872x_probe() a bit to remove unnecessary goto and num_regulators
variable.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp872x.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 021d64d..3de328a 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -106,7 +106,6 @@ struct lp872x {
 	struct device *dev;
 	enum lp872x_id chipid;
 	struct lp872x_platform_data *pdata;
-	struct regulator_dev **regulators;
 	int num_regulators;
 	enum lp872x_dvs_state dvs_pin;
 	int dvs_gpio;
@@ -801,8 +800,6 @@ static int lp872x_regulator_register(struct lp872x *lp)
 			dev_err(lp->dev, "regulator register err");
 			return PTR_ERR(rdev);
 		}
-
-		*(lp->regulators + i) = rdev;
 	}
 
 	return 0;
@@ -906,7 +903,7 @@ static struct lp872x_platform_data
 static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp872x *lp;
-	int ret, size, num_regulators;
+	int ret;
 	const int lp872x_num_regulators[] = {
 		[LP8720] = LP8720_NUM_REGULATORS,
 		[LP8725] = LP8725_NUM_REGULATORS,
@@ -918,38 +915,27 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 
 	lp = devm_kzalloc(&cl->dev, sizeof(struct lp872x), GFP_KERNEL);
 	if (!lp)
-		goto err_mem;
-
-	num_regulators = lp872x_num_regulators[id->driver_data];
-	size = sizeof(struct regulator_dev *) * num_regulators;
+		return -ENOMEM;
 
-	lp->regulators = devm_kzalloc(&cl->dev, size, GFP_KERNEL);
-	if (!lp->regulators)
-		goto err_mem;
+	lp->num_regulators = lp872x_num_regulators[id->driver_data];
 
 	lp->regmap = devm_regmap_init_i2c(cl, &lp872x_regmap_config);
 	if (IS_ERR(lp->regmap)) {
 		ret = PTR_ERR(lp->regmap);
 		dev_err(&cl->dev, "regmap init i2c err: %d\n", ret);
-		goto err_dev;
+		return ret;
 	}
 
 	lp->dev = &cl->dev;
 	lp->pdata = dev_get_platdata(&cl->dev);
 	lp->chipid = id->driver_data;
-	lp->num_regulators = num_regulators;
 	i2c_set_clientdata(cl, lp);
 
 	ret = lp872x_config(lp);
 	if (ret)
-		goto err_dev;
+		return ret;
 
 	return lp872x_regulator_register(lp);
-
-err_mem:
-	return -ENOMEM;
-err_dev:
-	return ret;
 }
 
 static const struct of_device_id lp872x_dt_ids[] = {
-- 
1.9.1



