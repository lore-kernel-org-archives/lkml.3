Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab3HNVYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:24:55 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50508 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310Ab3HNVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:24:07 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Bryan Wu <cooloney@gmail.com>,
        Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 3/5] leds-pca9633: Add mutex to the ledout register
Date: Wed, 14 Aug 2013 23:23:49 +0200
Message-Id: <1376515431-9504-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376515431-9504-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1376515431-9504-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To update an LED a register has to be read, updated and writen. If
another LED whas been updated at the same time, this could lead into
wrong updates.

This patch adds a common mutex to all the leds of the same chip to
protect the ledout register.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/leds/leds-pca9633.c |   86 +++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 31 deletions(-)

diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
index 7dd48f8..aaa1c4a 100644
--- a/drivers/leds/leds-pca9633.c
+++ b/drivers/leds/leds-pca9633.c
@@ -93,9 +93,17 @@ enum pca9633_cmd {
 	BLINK_SET,
 };
 
-struct pca9633_led {
-	struct i2c_client *client;
+struct pca9633_led;
+
+struct pca9633 {
 	struct pca9633_chipdef *chipdef;
+	struct mutex mutex;
+	struct i2c_client *client;
+	struct pca9633_led *leds;
+};
+
+struct pca9633_led {
+	struct pca9633 *chip;
 	struct work_struct work;
 	enum led_brightness brightness;
 	struct led_classdev led_cdev;
@@ -108,52 +116,60 @@ struct pca9633_led {
 
 static void pca9633_brightness_work(struct pca9633_led *pca9633)
 {
-	u8 ledout_addr = pca9633->chipdef->ledout_base + (pca9633->led_num / 4);
+	u8 ledout_addr = pca9633->chip->chipdef->ledout_base
+		+ (pca9633->led_num / 4);
 	u8 ledout;
 	int shift = 2 * (pca9633->led_num % 4);
 	u8 mask = 0x3 << shift;
 
-	ledout = i2c_smbus_read_byte_data(pca9633->client, ledout_addr);
+	mutex_lock(&pca9633->chip->mutex);
+	ledout = i2c_smbus_read_byte_data(pca9633->chip->client, ledout_addr);
 	switch (pca9633->brightness) {
 	case LED_FULL:
-		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
+		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
 			(ledout & ~mask) | (PCA9633_LED_ON << shift));
 		break;
 	case LED_OFF:
-		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
+		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
 			ledout & ~mask);
 		break;
 	default:
-		i2c_smbus_write_byte_data(pca9633->client,
+		i2c_smbus_write_byte_data(pca9633->chip->client,
 			PCA9633_PWM_BASE + pca9633->led_num,
 			pca9633->brightness);
-		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
+		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
 			(ledout & ~mask) | (PCA9633_LED_PWM << shift));
 		break;
 	}
+	mutex_unlock(&pca9633->chip->mutex);
 }
 
 static void pca9633_blink_work(struct pca9633_led *pca9633)
 {
-	u8 ledout_addr = pca9633->chipdef->ledout_base + (pca9633->led_num / 4);
-	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, ledout_addr);
-	u8 mode2 = i2c_smbus_read_byte_data(pca9633->client, PCA9633_MODE2);
+	u8 ledout_addr = pca9633->chip->chipdef->ledout_base +
+		(pca9633->led_num / 4);
+	u8 ledout;
+	u8 mode2 = i2c_smbus_read_byte_data(pca9633->chip->client,
+							PCA9633_MODE2);
 	int shift = 2 * (pca9633->led_num % 4);
 	u8 mask = 0x3 << shift;
 
-	i2c_smbus_write_byte_data(pca9633->client, pca9633->chipdef->grppwm,
-		pca9633->gdc);
+	i2c_smbus_write_byte_data(pca9633->chip->client,
+			pca9633->chip->chipdef->grppwm,	pca9633->gdc);
 
-	i2c_smbus_write_byte_data(pca9633->client, pca9633->chipdef->grpfreq,
-		pca9633->gfrq);
+	i2c_smbus_write_byte_data(pca9633->chip->client,
+			pca9633->chip->chipdef->grpfreq, pca9633->gfrq);
 
 	if (!(mode2 & PCA9633_MODE2_DMBLNK))
-		i2c_smbus_write_byte_data(pca9633->client, PCA9633_MODE2,
+		i2c_smbus_write_byte_data(pca9633->chip->client, PCA9633_MODE2,
 			mode2 | PCA9633_MODE2_DMBLNK);
 
+	mutex_lock(&pca9633->chip->mutex);
+	ledout = i2c_smbus_read_byte_data(pca9633->chip->client, ledout_addr);
 	if ((ledout & mask) != (PCA9633_LED_GRP_PWM << shift))
-		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
+		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
 			(ledout & ~mask) | (PCA9633_LED_GRP_PWM << shift));
+	mutex_unlock(&pca9633->chip->mutex);
 }
 
 static void pca9633_work(struct work_struct *work)
@@ -318,6 +334,7 @@ pca9633_dt_init(struct i2c_client *client, struct pca9633_chipdef *chip)
 static int pca9633_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
+	struct pca9633 *pca9633_chip;
 	struct pca9633_led *pca9633;
 	struct pca9633_platform_data *pdata;
 	struct pca9633_chipdef *chip;
@@ -341,17 +358,30 @@ static int pca9633_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
+	pca9633_chip = devm_kzalloc(&client->dev, sizeof(*pca9633_chip),
+								GFP_KERNEL);
+	if (!pca9633_chip)
+		return -ENOMEM;
 	pca9633 = devm_kzalloc(&client->dev, chip->n_leds * sizeof(*pca9633),
 								GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, pca9633);
+	i2c_set_clientdata(client, pca9633_chip);
+
+	mutex_init(&pca9633_chip->mutex);
+	pca9633_chip->chipdef = chip;
+	pca9633_chip->client = client;
+	pca9633_chip->leds = pca9633;
+
+	/* Turn off LEDs by default*/
+	i2c_smbus_write_byte_data(client, chip->ledout_base, 0x00);
+	if (chip->n_leds > 4)
+		i2c_smbus_write_byte_data(client, chip->ledout_base + 1, 0x00);
 
 	for (i = 0; i < chip->n_leds; i++) {
-		pca9633[i].client = client;
 		pca9633[i].led_num = i;
-		pca9633[i].chipdef = chip;
+		pca9633[i].chip = pca9633_chip;
 
 		/* Platform data can specify LED names and default triggers */
 		if (pdata && i < pdata->leds.num_leds) {
@@ -389,11 +419,6 @@ static int pca9633_probe(struct i2c_client *client,
 	if (pdata && pdata->outdrv == PCA9633_OPEN_DRAIN)
 		i2c_smbus_write_byte_data(client, PCA9633_MODE2, 0x01);
 
-	/* Turn off LEDs */
-	i2c_smbus_write_byte_data(client, chip->ledout_base, 0x00);
-	if (chip->n_leds > 4)
-		i2c_smbus_write_byte_data(client, chip->ledout_base + 1, 0x00);
-
 	return 0;
 
 exit:
@@ -407,14 +432,13 @@ exit:
 
 static int pca9633_remove(struct i2c_client *client)
 {
-	struct pca9633_led *pca9633 = i2c_get_clientdata(client);
+	struct pca9633 *pca9633 = i2c_get_clientdata(client);
 	int i;
 
-	for (i = 0; i < pca9633->chipdef->n_leds; i++)
-		if (pca9633[i].client != NULL) {
-			led_classdev_unregister(&pca9633[i].led_cdev);
-			cancel_work_sync(&pca9633[i].work);
-		}
+	for (i = 0; i < pca9633->chipdef->n_leds; i++) {
+		led_classdev_unregister(&pca9633->leds[i].led_cdev);
+		cancel_work_sync(&pca9633->leds[i].work);
+	}
 
 	return 0;
 }
-- 
1.7.10.4

