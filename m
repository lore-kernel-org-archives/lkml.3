Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaIUDAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 23:00:52 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47525 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaIUDAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 23:00:36 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        zonque@gmail.com, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH 1/3] cap1106: Add support for various cap11xx devices
Date: Sat, 20 Sep 2014 20:01:07 -0700
Message-Id: <1411268469-21283-2-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several other variants of the cap11xx device exists with a varying
number of capacitance detection channels. Add support for creating
the channels dynamically.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 drivers/input/keyboard/cap1106.c | 54 +++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
index d70b65a..b9c43b5 100644
--- a/drivers/input/keyboard/cap1106.c
+++ b/drivers/input/keyboard/cap1106.c
@@ -55,8 +55,6 @@
 #define CAP1106_REG_MANUFACTURER_ID	0xfe
 #define CAP1106_REG_REVISION		0xff
 
-#define CAP1106_NUM_CHN 6
-#define CAP1106_PRODUCT_ID	0x55
 #define CAP1106_MANUFACTURER_ID	0x5d
 
 struct cap1106_priv {
@@ -64,7 +62,8 @@ struct cap1106_priv {
 	struct input_dev *idev;
 
 	/* config */
-	unsigned short keycodes[CAP1106_NUM_CHN];
+	u32 *keycodes;
+	unsigned int num_channels;
 };
 
 static const struct reg_default cap1106_reg_defaults[] = {
@@ -151,7 +150,7 @@ static irqreturn_t cap1106_thread_func(int irq_num, void *data)
 	if (ret < 0)
 		goto out;
 
-	for (i = 0; i < CAP1106_NUM_CHN; i++)
+	for (i = 0; i < priv->num_channels; i++)
 		input_report_key(priv->idev, priv->keycodes[i],
 				 status & (1 << i));
 
@@ -189,27 +188,23 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
 	struct cap1106_priv *priv;
 	struct device_node *node;
 	int i, error, irq, gain = 0;
-	unsigned int val, rev;
-	u32 gain32, keycodes[CAP1106_NUM_CHN];
+	unsigned int val, prod, rev;
+	u32 gain32;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->num_channels = (unsigned long) id->driver_data;
+	priv->keycodes = devm_kzalloc(dev,
+		sizeof(u32) * priv->num_channels, GFP_KERNEL);
+	if (!priv->keycodes)
+		return -ENOMEM;
+
 	priv->regmap = devm_regmap_init_i2c(i2c_client, &cap1106_regmap_config);
 	if (IS_ERR(priv->regmap))
 		return PTR_ERR(priv->regmap);
 
-	error = regmap_read(priv->regmap, CAP1106_REG_PRODUCT_ID, &val);
-	if (error)
-		return error;
-
-	if (val != CAP1106_PRODUCT_ID) {
-		dev_err(dev, "Product ID: Got 0x%02x, expected 0x%02x\n",
-			val, CAP1106_PRODUCT_ID);
-		return -ENODEV;
-	}
-
 	error = regmap_read(priv->regmap, CAP1106_REG_MANUFACTURER_ID, &val);
 	if (error)
 		return error;
@@ -220,6 +215,10 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
 		return -ENODEV;
 	}
 
+	error = regmap_read(priv->regmap, CAP1106_REG_PRODUCT_ID, &prod);
+	if (error < 0)
+		return error;
+
 	error = regmap_read(priv->regmap, CAP1106_REG_REVISION, &rev);
 	if (error < 0)
 		return error;
@@ -235,17 +234,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
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
+				  priv->keycodes, priv->num_channels);
 
 	error = regmap_update_bits(priv->regmap, CAP1106_REG_MAIN_CONTROL,
 				   CAP1106_REG_MAIN_CONTROL_GAIN_MASK,
@@ -269,17 +263,17 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
 	if (of_property_read_bool(node, "autorepeat"))
 		__set_bit(EV_REP, priv->idev->evbit);
 
-	for (i = 0; i < CAP1106_NUM_CHN; i++)
+	for (i = 0; i < priv->num_channels; i++)
 		__set_bit(priv->keycodes[i], priv->idev->keybit);
 
 	__clear_bit(KEY_RESERVED, priv->idev->keybit);
 
 	priv->idev->keycode = priv->keycodes;
 	priv->idev->keycodesize = sizeof(priv->keycodes[0]);
-	priv->idev->keycodemax = ARRAY_SIZE(priv->keycodes);
+	priv->idev->keycodemax = priv->num_channels;
 
 	priv->idev->id.vendor = CAP1106_MANUFACTURER_ID;
-	priv->idev->id.product = CAP1106_PRODUCT_ID;
+	priv->idev->id.product = prod;
 	priv->idev->id.version = rev;
 
 	priv->idev->open = cap1106_input_open;
@@ -313,12 +307,16 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
 
 static const struct of_device_id cap1106_dt_ids[] = {
 	{ .compatible = "microchip,cap1106", },
+	{ .compatible = "microchip,cap1126", },
+	{ .compatible = "microchip,cap1188", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, cap1106_dt_ids);
 
 static const struct i2c_device_id cap1106_i2c_ids[] = {
-	{ "cap1106", 0 },
+	{ "cap1106", 6 },
+	{ "cap1126", 6 },
+	{ "cap1188", 8 },
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, cap1106_i2c_ids);
-- 
1.9.1

