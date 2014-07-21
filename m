Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaGUIZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:25:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49220 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaGUIZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:25:43 -0400
Date: Mon, 21 Jul 2014 13:55:35 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] misc: bh1770glc: Use managed functions
Message-ID: <20140721082534.GA3127@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interfaces like devm_kzalloc,
devm_regulator_bulk_get and does away with the functions to free the
allocated memory in the probe and remove functions. Also, some labels
are removed and renamed to preserve the ordering.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/misc/bh1770glc.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 99a0468..7b55f8a 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1185,7 +1185,7 @@ static int bh1770_probe(struct i2c_client *client,
 	struct bh1770_chip *chip;
 	int err;
 
-	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof *chip, GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -1198,8 +1198,7 @@ static int bh1770_probe(struct i2c_client *client,
 
 	if (client->dev.platform_data == NULL) {
 		dev_err(&client->dev, "platform data is mandatory\n");
-		err = -EINVAL;
-		goto fail1;
+		return -EINVAL;
 	}
 
 	chip->pdata		= client->dev.platform_data;
@@ -1224,24 +1223,24 @@ static int bh1770_probe(struct i2c_client *client,
 	chip->regs[0].supply = reg_vcc;
 	chip->regs[1].supply = reg_vleds;
 
-	err = regulator_bulk_get(&client->dev,
-				 ARRAY_SIZE(chip->regs), chip->regs);
+	err = devm_regulator_bulk_get(&client->dev,
+				      ARRAY_SIZE(chip->regs), chip->regs);
 	if (err < 0) {
 		dev_err(&client->dev, "Cannot get regulators\n");
-		goto fail1;
+		return err;
 	}
 
 	err = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
 				chip->regs);
 	if (err < 0) {
 		dev_err(&client->dev, "Cannot enable regulators\n");
-		goto fail2;
+		return err;
 	}
 
 	usleep_range(BH1770_STARTUP_DELAY, BH1770_STARTUP_DELAY * 2);
 	err = bh1770_detect(chip);
 	if (err < 0)
-		goto fail3;
+		goto fail0;
 
 	/* Start chip */
 	bh1770_chip_on(chip);
@@ -1252,14 +1251,14 @@ static int bh1770_probe(struct i2c_client *client,
 	if (chip->lux_corr == 0) {
 		dev_err(&client->dev, "Improper correction values\n");
 		err = -EINVAL;
-		goto fail3;
+		goto fail0;
 	}
 
 	if (chip->pdata->setup_resources) {
 		err = chip->pdata->setup_resources();
 		if (err) {
 			err = -EINVAL;
-			goto fail3;
+			goto fail0;
 		}
 	}
 
@@ -1267,7 +1266,7 @@ static int bh1770_probe(struct i2c_client *client,
 				&bh1770_attribute_group);
 	if (err < 0) {
 		dev_err(&chip->client->dev, "Sysfs registration failed\n");
-		goto fail4;
+		goto fail1;
 	}
 
 	/*
@@ -1283,22 +1282,18 @@ static int bh1770_probe(struct i2c_client *client,
 	if (err) {
 		dev_err(&client->dev, "could not get IRQ %d\n",
 			client->irq);
-		goto fail5;
+		goto fail2;
 	}
 	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
 	return err;
-fail5:
+fail2:
 	sysfs_remove_group(&chip->client->dev.kobj,
 			&bh1770_attribute_group);
-fail4:
+fail1:
 	if (chip->pdata->release_resources)
 		chip->pdata->release_resources();
-fail3:
+fail0:
 	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
-fail2:
-	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
-fail1:
-	kfree(chip);
 	return err;
 }
 
@@ -1322,8 +1317,6 @@ static int bh1770_remove(struct i2c_client *client)
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.9.1

