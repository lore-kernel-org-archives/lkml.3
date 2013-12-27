Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3L0BLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 20:11:47 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:40330 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3L0BLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 20:11:46 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>
Cc: Rhyland Klein <rklein@nvidia.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] bq24735: don't attempt I2C accesses if charger is not present
Date: Thu, 26 Dec 2013 17:11:29 -0800
Message-Id: <1388106689-26846-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have an AC-detect GPIO for the charger and the charger is not
present during probe time, don't attempt I2C accesses to the charger
as they are not guaranteed to succeed.  The charger will be configured
once it is plugged in.  Also initialize the AC-detect GPIO as an input
so that its value can be read reliably before setting it up as an IRQ.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/power/bq24735-charger.c | 81 +++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 32 deletions(-)

diff --git a/drivers/power/bq24735-charger.c b/drivers/power/bq24735-charger.c
index d022b82..df3e215 100644
--- a/drivers/power/bq24735-charger.c
+++ b/drivers/power/bq24735-charger.c
@@ -47,6 +47,7 @@ struct bq24735 {
 	struct power_supply	charger;
 	struct i2c_client	*client;
 	struct bq24735_platform	*pdata;
+	bool			configured;
 };
 
 static inline struct bq24735 *to_bq24735(struct power_supply *psy)
@@ -178,10 +179,15 @@ static irqreturn_t bq24735_charger_isr(int irq, void *devid)
 	struct power_supply *psy = devid;
 	struct bq24735 *charger = to_bq24735(psy);
 
-	if (bq24735_charger_is_present(charger))
+	if (bq24735_charger_is_present(charger)) {
+		if (!charger->configured) {
+			bq24735_config_charger(charger);
+			charger->configured = true;
+		}
 		bq24735_enable_charging(charger);
-	else
+	} else {
 		bq24735_disable_charging(charger);
+	}
 
 	power_supply_changed(psy);
 
@@ -290,33 +296,10 @@ static int bq24735_charger_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, charger);
 
-	ret = bq24735_read_word(client, BQ24735_MANUFACTURER_ID);
-	if (ret < 0) {
-		dev_err(&client->dev, "Failed to read manufacturer id : %d\n",
-			ret);
-		goto err_free_name;
-	} else if (ret != 0x0040) {
-		dev_err(&client->dev,
-			"manufacturer id mismatch. 0x0040 != 0x%04x\n", ret);
-		ret = -ENODEV;
-		goto err_free_name;
-	}
-
-	ret = bq24735_read_word(client, BQ24735_DEVICE_ID);
-	if (ret < 0) {
-		dev_err(&client->dev, "Failed to read device id : %d\n", ret);
-		goto err_free_name;
-	} else if (ret != 0x000B) {
-		dev_err(&client->dev,
-			"device id mismatch. 0x000b != 0x%04x\n", ret);
-		ret = -ENODEV;
-		goto err_free_name;
-	}
-
 	if (gpio_is_valid(charger->pdata->status_gpio)) {
-		ret = devm_gpio_request(&client->dev,
-					charger->pdata->status_gpio,
-					name);
+		ret = devm_gpio_request_one(&client->dev,
+						charger->pdata->status_gpio,
+						GPIOF_IN, name);
 		if (ret) {
 			dev_err(&client->dev,
 				"Failed GPIO request for GPIO %d: %d\n",
@@ -326,14 +309,48 @@ static int bq24735_charger_probe(struct i2c_client *client,
 		charger->pdata->status_gpio_valid = !ret;
 	}
 
-	ret = bq24735_config_charger(charger);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed in configuring charger");
-		goto err_free_name;
+	/*
+	 * If we have an AC-detect GPIO and we know the charger is not
+	 * present, don't bother with trying to access it over I2C as it
+	 * may not resopnd.
+	 */
+	if (!charger->pdata->status_gpio_valid ||
+		bq24735_charger_is_present(charger)) {
+		ret = bq24735_read_word(client, BQ24735_MANUFACTURER_ID);
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"Failed to read manufacturer id : %d\n", ret);
+			goto err_free_name;
+		} else if (ret != 0x0040) {
+			dev_err(&client->dev,
+				"manufacturer id mismatch. 0x0040 != 0x%04x\n",
+				ret);
+			ret = -ENODEV;
+			goto err_free_name;
+		}
+
+		ret = bq24735_read_word(client, BQ24735_DEVICE_ID);
+		if (ret < 0) {
+			dev_err(&client->dev, "Failed to read device id : %d\n",
+				ret);
+			goto err_free_name;
+		} else if (ret != 0x000B) {
+			dev_err(&client->dev,
+				"device id mismatch. 0x000b != 0x%04x\n", ret);
+			ret = -ENODEV;
+			goto err_free_name;
+		}
 	}
 
 	/* check for AC adapter presence */
 	if (bq24735_charger_is_present(charger)) {
+		ret = bq24735_config_charger(charger);
+		if (ret < 0) {
+			dev_err(&client->dev, "failed in configuring charger");
+			goto err_free_name;
+		}
+		charger->configured = true;
+
 		ret = bq24735_enable_charging(charger);
 		if (ret < 0) {
 			dev_err(&client->dev, "Failed to enable charging\n");
-- 
1.8.5.1

