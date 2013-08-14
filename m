Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3HNVYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:24:07 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38868 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191Ab3HNVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:24:00 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Bryan Wu <cooloney@gmail.com>,
        Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 1/5] leds-pca9633: Add support for PCA9634
Date: Wed, 14 Aug 2013 23:23:47 +0200
Message-Id: <1376515431-9504-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376515431-9504-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1376515431-9504-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for PCA9634 chip, which belongs to the same family as the
9633 but with support for 8 outputs instead of 4.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 Documentation/devicetree/bindings/leds/pca9633.txt |   11 +-
 drivers/leds/Kconfig                               |    7 +-
 drivers/leds/leds-pca9633.c                        |  108 ++++++++++++++------
 3 files changed, 85 insertions(+), 41 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/pca9633.txt b/Documentation/devicetree/bindings/leds/pca9633.txt
index 6d9e1a9..aece3ea 100644
--- a/Documentation/devicetree/bindings/leds/pca9633.txt
+++ b/Documentation/devicetree/bindings/leds/pca9633.txt
@@ -1,24 +1,25 @@
-LEDs connected to pca9633 or pca9632
+LEDs connected to pca9632, pca9633 or pca9634
 
 Required properties:
-- compatible : should be : "nxp,pca963x"
+- compatible : should be : "nxp,pca9632", "nxp,pca9633" or "nxp,pca9634"
 
 Optional properties:
 - nxp,totem-pole : use totem pole (push-pull) instead of default open-drain
 - nxp,hw-blink : use hardware blinking instead of software blinking
 
-Each led is represented as a sub-node of the nxp,pca9633 device.
+Each led is represented as a sub-node of the nxp,pca963x device.
 
 LED sub-node properties:
 - label : (optional) see Documentation/devicetree/bindings/leds/common.txt
-- reg : number of LED line (could be from 0 to 4)
+- reg : number of LED line (could be from 0 to 3  in pca9632 or pca9633
+		or 0 to 7 in pca9634)
 - linux,default-trigger : (optional)
    see Documentation/devicetree/bindings/leds/common.txt
 
 Examples:
 
 pca9632: pca9632 {
-	compatible = "nxp,pca9632", "nxp,pca963x";
+	compatible = "nxp,pca9632";
 	#address-cells = <1>;
 	#size-cells = <0>;
 	reg = <0x62>;
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f2c738d..e7977aa 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -292,12 +292,13 @@ config LEDS_PCA955X
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
 config LEDS_PCA9633
-	tristate "LED support for PCA9633 I2C chip"
+	tristate "LED support for PCA963x I2C chip"
 	depends on LEDS_CLASS
 	depends on I2C
 	help
-	  This option enables support for LEDs connected to the PCA9633
-	  LED driver chip accessed via the I2C bus.
+	  This option enables support for LEDs connected to the PCA963x
+	  LED driver chip accessed via the I2C bus. Supported
+	  devices include PCA9633 and PCA9634
 
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
index ecd1449..e59ca0a 100644
--- a/drivers/leds/leds-pca9633.c
+++ b/drivers/leds/leds-pca9633.c
@@ -1,7 +1,9 @@
 /*
  * Copyright 2011 bct electronic GmbH
+ * Copyright 2013 Qtechnology/AS
  *
  * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
  *
  * Based on leds-pca955x.c
  *
@@ -10,6 +12,7 @@
  * directory of this archive for more details.
  *
  * LED driver for the PCA9633 I2C LED driver (7-bit slave address 0x62)
+ * LED driver for the PCA9634 I2C LED driver (7-bit slave address set by hw.)
  *
  * Note that hardware blinking violates the leds infrastructure driver
  * interface since the hardware only supports blinking all LEDs with the
@@ -45,16 +48,42 @@
 #define PCA9633_MODE1		0x00
 #define PCA9633_MODE2		0x01
 #define PCA9633_PWM_BASE	0x02
-#define PCA9633_GRPPWM		0x06
-#define PCA9633_GRPFREQ		0x07
-#define PCA9633_LEDOUT		0x08
+
+enum pca9633_type {
+	pca9633,
+	pca9634,
+};
+
+struct pca9633_chipdef {
+	u8			grppwm;
+	u8			grpfreq;
+	u8			ledout_base;
+	int			n_leds;
+};
+
+static struct pca9633_chipdef pca9633_chipdefs[] = {
+	[pca9633] = {
+		.grppwm		= 0x6,
+		.grpfreq	= 0x7,
+		.ledout_base	= 0x8,
+		.n_leds		= 4,
+	},
+	[pca9634] = {
+		.grppwm		= 0xa,
+		.grpfreq	= 0xb,
+		.ledout_base	= 0xc,
+		.n_leds		= 8,
+	},
+};
 
 /* Total blink period in milliseconds */
 #define PCA9632_BLINK_PERIOD_MIN	42
 #define PCA9632_BLINK_PERIOD_MAX	10667
 
 static const struct i2c_device_id pca9633_id[] = {
-	{ "pca9633", 0 },
+	{ "pca9632", pca9633 },
+	{ "pca9633", pca9633 },
+	{ "pca9634", pca9634 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca9633_id);
@@ -66,10 +95,11 @@ enum pca9633_cmd {
 
 struct pca9633_led {
 	struct i2c_client *client;
+	struct pca9633_chipdef *chipdef;
 	struct work_struct work;
 	enum led_brightness brightness;
 	struct led_classdev led_cdev;
-	int led_num; /* 0 .. 3 potentially */
+	int led_num; /* 0 .. 7 potentially */
 	enum pca9633_cmd cmd;
 	char name[32];
 	u8 gdc;
@@ -78,24 +108,26 @@ struct pca9633_led {
 
 static void pca9633_brightness_work(struct pca9633_led *pca9633)
 {
-	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
-	int shift = 2 * pca9633->led_num;
+	u8 ledout_addr = pca9633->chipdef->ledout_base + (pca9633->led_num / 4);
+	u8 ledout;
+	int shift = 2 * (pca9633->led_num % 4);
 	u8 mask = 0x3 << shift;
 
+	ledout = i2c_smbus_read_byte_data(pca9633->client, ledout_addr);
 	switch (pca9633->brightness) {
 	case LED_FULL:
-		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
 			(ledout & ~mask) | (PCA9633_LED_ON << shift));
 		break;
 	case LED_OFF:
-		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
 			ledout & ~mask);
 		break;
 	default:
 		i2c_smbus_write_byte_data(pca9633->client,
 			PCA9633_PWM_BASE + pca9633->led_num,
 			pca9633->brightness);
-		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
 			(ledout & ~mask) | (PCA9633_LED_PWM << shift));
 		break;
 	}
@@ -103,15 +135,16 @@ static void pca9633_brightness_work(struct pca9633_led *pca9633)
 
 static void pca9633_blink_work(struct pca9633_led *pca9633)
 {
-	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
+	u8 ledout_addr = pca9633->chipdef->ledout_base + (pca9633->led_num / 4);
+	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, ledout_addr);
 	u8 mode2 = i2c_smbus_read_byte_data(pca9633->client, PCA9633_MODE2);
-	int shift = 2 * pca9633->led_num;
+	int shift = 2 * (pca9633->led_num % 4);
 	u8 mask = 0x3 << shift;
 
-	i2c_smbus_write_byte_data(pca9633->client, PCA9633_GRPPWM,
+	i2c_smbus_write_byte_data(pca9633->client, pca9633->chipdef->grppwm,
 		pca9633->gdc);
 
-	i2c_smbus_write_byte_data(pca9633->client, PCA9633_GRPFREQ,
+	i2c_smbus_write_byte_data(pca9633->client, pca9633->chipdef->grpfreq,
 		pca9633->gfrq);
 
 	if (!(mode2 & PCA9633_MODE2_DMBLNK))
@@ -119,7 +152,7 @@ static void pca9633_blink_work(struct pca9633_led *pca9633)
 			mode2 | PCA9633_MODE2_DMBLNK);
 
 	if ((ledout & mask) != (PCA9633_LED_GRP_PWM << shift))
-		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+		i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
 			(ledout & ~mask) | (PCA9633_LED_GRP_PWM << shift));
 }
 
@@ -215,7 +248,7 @@ static int pca9633_blink_set(struct led_classdev *led_cdev,
 
 #if IS_ENABLED(CONFIG_OF)
 static struct pca9633_platform_data *
-pca9633_dt_init(struct i2c_client *client)
+pca9633_dt_init(struct i2c_client *client, struct pca9633_chipdef *chip)
 {
 	struct device_node *np = client->dev.of_node, *child;
 	struct pca9633_platform_data *pdata;
@@ -223,11 +256,11 @@ pca9633_dt_init(struct i2c_client *client)
 	int count;
 
 	count = of_get_child_count(np);
-	if (!count || count > 4)
+	if (!count || count > chip->n_leds)
 		return ERR_PTR(-ENODEV);
 
 	pca9633_leds = devm_kzalloc(&client->dev,
-				sizeof(struct led_info) * count, GFP_KERNEL);
+			sizeof(struct led_info) * chip->n_leds, GFP_KERNEL);
 	if (!pca9633_leds)
 		return ERR_PTR(-ENOMEM);
 
@@ -269,12 +302,14 @@ pca9633_dt_init(struct i2c_client *client)
 }
 
 static const struct of_device_id of_pca9633_match[] = {
-	{ .compatible = "nxp,pca963x", },
+	{ .compatible = "nxp,pca9632", },
+	{ .compatible = "nxp,pca9633", },
+	{ .compatible = "nxp,pca9634", },
 	{},
 };
 #else
 static struct pca9633_platform_data *
-pca9633_dt_init(struct i2c_client *client)
+pca9633_dt_init(struct i2c_client *client, struct pca9633_chipdef *chip)
 {
 	return ERR_PTR(-ENODEV);
 }
@@ -285,34 +320,38 @@ static int pca9633_probe(struct i2c_client *client,
 {
 	struct pca9633_led *pca9633;
 	struct pca9633_platform_data *pdata;
+	struct pca9633_chipdef *chip;
 	int i, err;
 
+	chip = &pca9633_chipdefs[id->driver_data];
 	pdata = dev_get_platdata(&client->dev);
 
 	if (!pdata) {
-		pdata = pca9633_dt_init(client);
+		pdata = pca9633_dt_init(client, chip);
 		if (IS_ERR(pdata)) {
 			dev_warn(&client->dev, "could not parse configuration\n");
 			pdata = NULL;
 		}
 	}
 
-	if (pdata) {
-		if (pdata->leds.num_leds <= 0 || pdata->leds.num_leds > 4) {
-			dev_err(&client->dev, "board info must claim at most 4 LEDs");
-			return -EINVAL;
-		}
+	if (pdata && (pdata->leds.num_leds < 1 ||
+				 pdata->leds.num_leds > chip->n_leds)) {
+		dev_err(&client->dev, "board info must claim 1-%d LEDs",
+								chip->n_leds);
+		return -EINVAL;
 	}
 
-	pca9633 = devm_kzalloc(&client->dev, 4 * sizeof(*pca9633), GFP_KERNEL);
+	pca9633 = devm_kzalloc(&client->dev, chip->n_leds * sizeof(*pca9633),
+								GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, pca9633);
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < chip->n_leds; i++) {
 		pca9633[i].client = client;
 		pca9633[i].led_num = i;
+		pca9633[i].chipdef = chip;
 
 		/* Platform data can specify LED names and default triggers */
 		if (pdata && i < pdata->leds.num_leds) {
@@ -349,7 +388,9 @@ static int pca9633_probe(struct i2c_client *client,
 		i2c_smbus_write_byte_data(client, PCA9633_MODE2, 0x01);
 
 	/* Turn off LEDs */
-	i2c_smbus_write_byte_data(client, PCA9633_LEDOUT, 0x00);
+	i2c_smbus_write_byte_data(client, chip->ledout_base, 0x00);
+	if (chip->n_leds > 4)
+		i2c_smbus_write_byte_data(client, chip->ledout_base + 1, 0x00);
 
 	return 0;
 
@@ -367,10 +408,11 @@ static int pca9633_remove(struct i2c_client *client)
 	struct pca9633_led *pca9633 = i2c_get_clientdata(client);
 	int i;
 
-	for (i = 0; i < 4; i++) {
-		led_classdev_unregister(&pca9633[i].led_cdev);
-		cancel_work_sync(&pca9633[i].work);
-	}
+	for (i = 0; i < pca9633->chipdef->n_leds; i++)
+		if (pca9633[i].client != NULL) {
+			led_classdev_unregister(&pca9633[i].led_cdev);
+			cancel_work_sync(&pca9633[i].work);
+		}
 
 	return 0;
 }
-- 
1.7.10.4

