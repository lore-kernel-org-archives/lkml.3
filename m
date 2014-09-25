Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaIYFXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:23:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36780 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaIYFXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:23:45 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, dmitry.torokhov@gmail.com, zonque@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v3 2/3] cap11xx: Add support for various cap11xx devices
Date: Wed, 24 Sep 2014 22:24:21 -0700
Message-Id: <1411622662-16581-3-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411622662-16581-1-git-send-email-mranostay@gmail.com>
References: <1411622662-16581-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several other variants of the cap11xx device exists with a varying
number of capacitance detection channels. Add support for creating
the channels dynamically.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 .../devicetree/bindings/input/cap11xx.txt          |  3 +-
 drivers/input/keyboard/cap11xx.c                   | 65 +++++++++++++++-------
 2 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/cap11xx.txt b/Documentation/devicetree/bindings/input/cap11xx.txt
index 738f5f3..8031aa5 100644
--- a/Documentation/devicetree/bindings/input/cap11xx.txt
+++ b/Documentation/devicetree/bindings/input/cap11xx.txt
@@ -7,9 +7,10 @@ Required properties:
 
 	compatible:		Must be on the following, depending on the model:
 					"microchip,cap1106"
+					"microchip,cap1126"
+					"microchip,cap1188"
 
 	reg:			The I2C slave address of the device.
-				Only 0x28 is valid.
 
 	interrupts:		Property describing the interrupt line the
 				device's ALERT#/CM_IRQ# pin is connected to.
diff --git a/drivers/input/keyboard/cap11xx.c b/drivers/input/keyboard/cap11xx.c
index 0da2e83..adb979e 100644
--- a/drivers/input/keyboard/cap11xx.c
+++ b/drivers/input/keyboard/cap11xx.c
@@ -1,7 +1,6 @@
 /*
  * Input driver for Microchip CAP11xx based capacitive touch sensors
  *
- *
  * (c) 2014 Daniel Mack <linux@zonque.org>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -54,8 +53,6 @@
 #define CAP11XX_REG_MANUFACTURER_ID	0xfe
 #define CAP11XX_REG_REVISION		0xff
 
-#define CAP11XX_NUM_CHN 6
-#define CAP11XX_PRODUCT_ID	0x55
 #define CAP11XX_MANUFACTURER_ID	0x5d
 
 struct cap11xx_priv {
@@ -63,7 +60,25 @@ struct cap11xx_priv {
 	struct input_dev *idev;
 
 	/* config */
-	unsigned short keycodes[CAP11XX_NUM_CHN];
+	u32 *keycodes;
+	unsigned int num_channels;
+};
+
+struct cap11xx_hw_model {
+	uint8_t product_id;
+	unsigned int num_channels;
+};
+
+enum {
+	CAP1106,
+	CAP1126,
+	CAP1188,
+};
+
+struct cap11xx_hw_model cap11xx_devices[] = {
+	[CAP1106] = { .product_id = 0x55, .num_channels = 6 },
+	[CAP1126] = { .product_id = 0x53, .num_channels = 6 },
+	[CAP1188] = { .product_id = 0x50, .num_channels = 8 },
 };
 
 static const struct reg_default cap11xx_reg_defaults[] = {
@@ -150,7 +165,7 @@ static irqreturn_t cap11xx_thread_func(int irq_num, void *data)
 	if (ret < 0)
 		goto out;
 
-	for (i = 0; i < CAP11XX_NUM_CHN; i++)
+	for (i = 0; i < priv->num_channels; i++)
 		input_report_key(priv->idev, priv->keycodes[i],
 				 status & (1 << i));
 
@@ -187,14 +202,23 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 	struct device *dev = &i2c_client->dev;
 	struct cap11xx_priv *priv;
 	struct device_node *node;
+	struct cap11xx_hw_model *cap = &cap11xx_devices[id->driver_data];
 	int i, error, irq, gain = 0;
 	unsigned int val, rev;
-	u32 gain32, keycodes[CAP11XX_NUM_CHN];
+	u32 gain32;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	BUG_ON(!cap->num_channels);
+
+	priv->num_channels = cap->num_channels;
+	priv->keycodes = devm_kcalloc(dev,
+		priv->num_channels, sizeof(u32), GFP_KERNEL);
+	if (!priv->keycodes)
+		return -ENOMEM;
+
 	priv->regmap = devm_regmap_init_i2c(i2c_client, &cap11xx_regmap_config);
 	if (IS_ERR(priv->regmap))
 		return PTR_ERR(priv->regmap);
@@ -203,9 +227,9 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 	if (error)
 		return error;
 
-	if (val != CAP11XX_PRODUCT_ID) {
+	if (val != cap->product_id) {
 		dev_err(dev, "Product ID: Got 0x%02x, expected 0x%02x\n",
-			val, CAP11XX_PRODUCT_ID);
+			val, cap->product_id);
 		return -ENODEV;
 	}
 
@@ -234,17 +258,12 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 			dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(keycodes) != ARRAY_SIZE(priv->keycodes));
-
 	/* Provide some useful defaults */
-	for (i = 0; i < ARRAY_SIZE(keycodes); i++)
-		keycodes[i] = KEY_A + i;
+	for (i = 0; i < priv->num_channels; i++)
+		priv->keycodes[i] = KEY_A + i;
 
 	of_property_read_u32_array(node, "linux,keycodes",
-				   keycodes, ARRAY_SIZE(keycodes));
-
-	for (i = 0; i < ARRAY_SIZE(keycodes); i++)
-		priv->keycodes[i] = keycodes[i];
+		priv->keycodes, priv->num_channels);
 
 	error = regmap_update_bits(priv->regmap, CAP11XX_REG_MAIN_CONTROL,
 				   CAP11XX_REG_MAIN_CONTROL_GAIN_MASK,
@@ -268,17 +287,17 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 	if (of_property_read_bool(node, "autorepeat"))
 		__set_bit(EV_REP, priv->idev->evbit);
 
-	for (i = 0; i < CAP11XX_NUM_CHN; i++)
+	for (i = 0; i < priv->num_channels; i++)
 		__set_bit(priv->keycodes[i], priv->idev->keybit);
 
 	__clear_bit(KEY_RESERVED, priv->idev->keybit);
 
 	priv->idev->keycode = priv->keycodes;
-	priv->idev->keycodesize = sizeof(priv->keycodes[0]);
-	priv->idev->keycodemax = ARRAY_SIZE(priv->keycodes);
+	priv->idev->keycodesize = sizeof(u32);
+	priv->idev->keycodemax = priv->num_channels;
 
 	priv->idev->id.vendor = CAP11XX_MANUFACTURER_ID;
-	priv->idev->id.product = CAP11XX_PRODUCT_ID;
+	priv->idev->id.product = cap->product_id;
 	priv->idev->id.version = rev;
 
 	priv->idev->open = cap11xx_input_open;
@@ -312,12 +331,16 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 
 static const struct of_device_id cap11xx_dt_ids[] = {
 	{ .compatible = "microchip,cap1106", },
+	{ .compatible = "microchip,cap1126", },
+	{ .compatible = "microchip,cap1188", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, cap11xx_dt_ids);
 
 static const struct i2c_device_id cap11xx_i2c_ids[] = {
-	{ "cap1106", 0 },
+	{ "cap1106", CAP1106 },
+	{ "cap1126", CAP1126 },
+	{ "cap1188", CAP1188 },
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, cap11xx_i2c_ids);
-- 
1.9.1

