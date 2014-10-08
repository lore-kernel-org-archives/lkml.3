Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaJHAKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:10:03 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48053 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbaJHAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:10:00 -0400
Date: Tue, 7 Oct 2014 17:09:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matt Ranostay <mranostay@gmail.com>
Cc: galak@codeaurora.org, zonque@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] cap11xx: Add support for various cap11xx devices
Message-ID: <20141008000956.GN16469@dtor-ws>
References: <1412051189-22643-1-git-send-email-mranostay@gmail.com>
 <1412051189-22643-3-git-send-email-mranostay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412051189-22643-3-git-send-email-mranostay@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Mon, Sep 29, 2014 at 09:26:28PM -0700, Matt Ranostay wrote:
> +	priv->num_channels = cap->num_channels;
> +	priv->keycodes = devm_kcalloc(dev,
> +		priv->num_channels, sizeof(u32), GFP_KERNEL);
> +	if (!priv->keycodes)
> +		return -ENOMEM;

Instead of allocating keymap separately can we do something like below?

Thanks.

-- 
Dmitry


Input: cap11xx - add support for various cap11xx devices

From: Matt Ranostay <mranostay@gmail.com>

Several other variants of the cap11xx device exists with a varying
number of capacitance detection channels. Add support for creating
the channels dynamically.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
Reviewed-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 .../devicetree/bindings/input/cap11xx.txt          |    3 +
 drivers/input/keyboard/cap11xx.c                   |   62 +++++++++++++-------
 2 files changed, 42 insertions(+), 23 deletions(-)

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
index 0da2e83..87fa209 100644
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
@@ -63,7 +60,24 @@ struct cap11xx_priv {
 	struct input_dev *idev;
 
 	/* config */
-	unsigned short keycodes[CAP11XX_NUM_CHN];
+	u32 keycodes[];
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
+static const struct cap11xx_hw_model cap11xx_devices[] = {
+	[CAP1106] = { .product_id = 0x55, .num_channels = 6 },
+	[CAP1126] = { .product_id = 0x53, .num_channels = 6 },
+	[CAP1188] = { .product_id = 0x50, .num_channels = 8 },
 };
 
 static const struct reg_default cap11xx_reg_defaults[] = {
@@ -150,7 +164,7 @@ static irqreturn_t cap11xx_thread_func(int irq_num, void *data)
 	if (ret < 0)
 		goto out;
 
-	for (i = 0; i < CAP11XX_NUM_CHN; i++)
+	for (i = 0; i < priv->idev->keycodemax; i++)
 		input_report_key(priv->idev, priv->keycodes[i],
 				 status & (1 << i));
 
@@ -187,11 +201,16 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 	struct device *dev = &i2c_client->dev;
 	struct cap11xx_priv *priv;
 	struct device_node *node;
+	const struct cap11xx_hw_model *cap = &cap11xx_devices[id->driver_data];
 	int i, error, irq, gain = 0;
 	unsigned int val, rev;
-	u32 gain32, keycodes[CAP11XX_NUM_CHN];
+	u32 gain32;
+
+	BUG_ON(!cap->num_channels);
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev,
+			    sizeof(*priv) + cap->num_channels * sizeof(u32),
+			    GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -203,9 +222,9 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 	if (error)
 		return error;
 
-	if (val != CAP11XX_PRODUCT_ID) {
+	if (val != cap->product_id) {
 		dev_err(dev, "Product ID: Got 0x%02x, expected 0x%02x\n",
-			val, CAP11XX_PRODUCT_ID);
+			val, cap->product_id);
 		return -ENODEV;
 	}
 
@@ -225,8 +244,8 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 
 	dev_info(dev, "CAP11XX detected, revision 0x%02x\n", rev);
 	i2c_set_clientdata(i2c_client, priv);
-	node = dev->of_node;
 
+	node = dev->of_node;
 	if (!of_property_read_u32(node, "microchip,sensor-gain", &gain32)) {
 		if (is_power_of_2(gain32) && gain32 <= 8)
 			gain = ilog2(gain32);
@@ -234,17 +253,12 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 			dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(keycodes) != ARRAY_SIZE(priv->keycodes));
-
 	/* Provide some useful defaults */
-	for (i = 0; i < ARRAY_SIZE(keycodes); i++)
-		keycodes[i] = KEY_A + i;
+	for (i = 0; i < cap->num_channels; i++)
+		priv->keycodes[i] = KEY_A + i;
 
 	of_property_read_u32_array(node, "linux,keycodes",
-				   keycodes, ARRAY_SIZE(keycodes));
-
-	for (i = 0; i < ARRAY_SIZE(keycodes); i++)
-		priv->keycodes[i] = keycodes[i];
+		priv->keycodes, cap->num_channels);
 
 	error = regmap_update_bits(priv->regmap, CAP11XX_REG_MAIN_CONTROL,
 				   CAP11XX_REG_MAIN_CONTROL_GAIN_MASK,
@@ -268,17 +282,17 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 	if (of_property_read_bool(node, "autorepeat"))
 		__set_bit(EV_REP, priv->idev->evbit);
 
-	for (i = 0; i < CAP11XX_NUM_CHN; i++)
+	for (i = 0; i < cap->num_channels; i++)
 		__set_bit(priv->keycodes[i], priv->idev->keybit);
 
 	__clear_bit(KEY_RESERVED, priv->idev->keybit);
 
 	priv->idev->keycode = priv->keycodes;
 	priv->idev->keycodesize = sizeof(priv->keycodes[0]);
-	priv->idev->keycodemax = ARRAY_SIZE(priv->keycodes);
+	priv->idev->keycodemax = cap->num_channels;
 
 	priv->idev->id.vendor = CAP11XX_MANUFACTURER_ID;
-	priv->idev->id.product = CAP11XX_PRODUCT_ID;
+	priv->idev->id.product = cap->product_id;
 	priv->idev->id.version = rev;
 
 	priv->idev->open = cap11xx_input_open;
@@ -312,12 +326,16 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 
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
