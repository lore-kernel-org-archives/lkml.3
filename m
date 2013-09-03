Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab3ICGUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:20:32 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63073 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3ICGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:20:30 -0400
Message-ID: <1378189225.4621.5.camel@phoenix>
Subject: [PATCH 3/8] regulator: ad5398: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:20:25 +0800
In-Reply-To: <1378189056.4621.1.camel@phoenix>
References: <1378189056.4621.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ad5398.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 6b981b5..92f42fd 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -219,7 +219,6 @@ static int ad5398_probe(struct i2c_client *client,
 	struct ad5398_chip_info *chip;
 	const struct ad5398_current_data_format *df =
 			(struct ad5398_current_data_format *)id->driver_data;
-	int ret;
 
 	if (!init_data)
 		return -EINVAL;
@@ -240,33 +239,21 @@ static int ad5398_probe(struct i2c_client *client,
 	chip->current_offset = df->current_offset;
 	chip->current_mask = (chip->current_level - 1) << chip->current_offset;
 
-	chip->rdev = regulator_register(&ad5398_reg, &config);
+	chip->rdev = devm_regulator_register(&client->dev, &ad5398_reg,
+					     &config);
 	if (IS_ERR(chip->rdev)) {
-		ret = PTR_ERR(chip->rdev);
 		dev_err(&client->dev, "failed to register %s %s\n",
 			id->name, ad5398_reg.name);
-		goto err;
+		return PTR_ERR(chip->rdev);
 	}
 
 	i2c_set_clientdata(client, chip);
 	dev_dbg(&client->dev, "%s regulator driver is registered.\n", id->name);
 	return 0;
-
-err:
-	return ret;
-}
-
-static int ad5398_remove(struct i2c_client *client)
-{
-	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
-
-	regulator_unregister(chip->rdev);
-	return 0;
 }
 
 static struct i2c_driver ad5398_driver = {
 	.probe = ad5398_probe,
-	.remove = ad5398_remove,
 	.driver		= {
 		.name	= "ad5398",
 	},
-- 
1.8.1.2



