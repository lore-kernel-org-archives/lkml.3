Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaE0GON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:14:13 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:32888 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaE0GOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:14:12 -0400
Message-ID: <1401171246.11231.5.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Remove *regulators[] from struct
 pfuze_chip
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 14:14:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is using devm_regulator_register() so we don't need to save the
pointer for cleanup.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 930eb13..c12cbdf32 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -69,7 +69,6 @@ struct pfuze_chip {
 	struct regmap *regmap;
 	struct device *dev;
 	struct pfuze_regulator regulator_descs[PFUZE100_MAX_REGULATOR];
-	struct regulator_dev *regulators[PFUZE100_MAX_REGULATOR];
 };
 
 static const int pfuze100_swbst[] = {
@@ -411,6 +410,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 	struct pfuze_regulator_platform_data *pdata =
 	    dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
+	struct regulator_dev *rdev;
 	int i, ret;
 	const struct of_device_id *match;
 	u32 regulator_num;
@@ -508,12 +508,11 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		config.of_node = match_of_node(i);
 		config.ena_gpio = -EINVAL;
 
-		pfuze_chip->regulators[i] =
-			devm_regulator_register(&client->dev, desc, &config);
-		if (IS_ERR(pfuze_chip->regulators[i])) {
+		rdev = devm_regulator_register(&client->dev, desc, &config);
+		if (IS_ERR(rdev)) {
 			dev_err(&client->dev, "register regulator%s failed\n",
 				pfuze_regulators[i].desc.name);
-			return PTR_ERR(pfuze_chip->regulators[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.8.3.2



