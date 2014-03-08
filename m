Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaCHNTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 08:19:14 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51208 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaCHNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 08:19:12 -0500
Message-ID: <1394284747.12881.4.camel@phoenix>
Subject: [PATCH] regulator: act8865: Remove unnecessary *rdev[] from struct
 act8865
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 08 Mar 2014 21:19:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we are using devm_regulator_register(), so we don't need the *rdev[] array
to store return value of devm_regulator_register. Use a *rdev variable is
enough for checking return status.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/act8865-regulator.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index a5ff30c..b92d7dd 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -62,7 +62,6 @@
 #define	ACT8865_VOLTAGE_NUM	64
 
 struct act8865 {
-	struct regulator_dev *rdev[ACT8865_REG_NUM];
 	struct regmap *regmap;
 };
 
@@ -256,7 +255,7 @@ static inline int act8865_pdata_from_dt(struct device *dev,
 static int act8865_pmic_probe(struct i2c_client *client,
 			   const struct i2c_device_id *i2c_id)
 {
-	struct regulator_dev **rdev;
+	struct regulator_dev *rdev;
 	struct device *dev = &client->dev;
 	struct act8865_platform_data *pdata = dev_get_platdata(dev);
 	struct regulator_config config = { };
@@ -290,8 +289,6 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	if (!act8865)
 		return -ENOMEM;
 
-	rdev = act8865->rdev;
-
 	act8865->regmap = devm_regmap_init_i2c(client, &act8865_regmap_config);
 	if (IS_ERR(act8865->regmap)) {
 		error = PTR_ERR(act8865->regmap);
@@ -311,12 +308,12 @@ static int act8865_pmic_probe(struct i2c_client *client,
 		config.driver_data = act8865;
 		config.regmap = act8865->regmap;
 
-		rdev[i] = devm_regulator_register(&client->dev,
-						&act8865_reg[i], &config);
-		if (IS_ERR(rdev[i])) {
+		rdev = devm_regulator_register(&client->dev, &act8865_reg[i],
+					       &config);
+		if (IS_ERR(rdev)) {
 			dev_err(dev, "failed to register %s\n",
 				act8865_reg[id].name);
-			return PTR_ERR(rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.8.1.2



