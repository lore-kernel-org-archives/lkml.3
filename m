Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaAWMnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:43:37 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:61564 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaAWMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:43:34 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: devicetree@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3 RESEND] mfd: tc3589x: Reform device tree probing
Date: Thu, 23 Jan 2014 13:43:28 +0100
Message-Id: <1390481008-23900-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the following mechanisms in the TC3589x device tree
probing path:

- Use the .of_match_table in struct device_driver to match the
  device in the device tree.
- Add matches for the proper compatible strings "toshiba,..."
  and all sub-variants, just as is done for the .id matches.
- Move over all the allocation of platform data etc to the
  tc3589x_of_probe() function and follow the pattern of passing
  a platform data pointer back, or an error pointer on error,
  as found in the STMPE driver.
- Match the new (proper) compatible strings for the GPIO and
  keypad MFD cells.
- Use of_device_is_compatible() rather than just !strcmp()
  to discover which cells to instantiate.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/tc3589x.c | 84 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 87ea51dc6234..ed1ee2634809 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -13,8 +13,10 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tc3589x.h>
+#include <linux/err.h>
 
 /**
  * enum tc3589x_version - indicates the TC3589x version
@@ -160,7 +162,7 @@ static struct mfd_cell tc3589x_dev_gpio[] = {
 		.name		= "tc3589x-gpio",
 		.num_resources	= ARRAY_SIZE(gpio_resources),
 		.resources	= &gpio_resources[0],
-		.of_compatible	= "tc3589x-gpio",
+		.of_compatible	= "toshiba,tc3589x-gpio",
 	},
 };
 
@@ -169,7 +171,7 @@ static struct mfd_cell tc3589x_dev_keypad[] = {
 		.name           = "tc3589x-keypad",
 		.num_resources  = ARRAY_SIZE(keypad_resources),
 		.resources      = &keypad_resources[0],
-		.of_compatible	= "tc3589x-keypad",
+		.of_compatible	= "toshiba,tc3589x-keypad",
 	},
 };
 
@@ -318,45 +320,74 @@ static int tc3589x_device_init(struct tc3589x *tc3589x)
 	return ret;
 }
 
-static int tc3589x_of_probe(struct device_node *np,
-			struct tc3589x_platform_data *pdata)
+#ifdef CONFIG_OF
+static const struct of_device_id tc3589x_match[] = {
+	/* Legacy compatible string */
+	{ .compatible = "tc3589x", .data = (void *) TC3589X_UNKNOWN },
+	{ .compatible = "toshiba,tc35890", .data = (void *) TC3589X_TC35890 },
+	{ .compatible = "toshiba,tc35892", .data = (void *) TC3589X_TC35892 },
+	{ .compatible = "toshiba,tc35893", .data = (void *) TC3589X_TC35893 },
+	{ .compatible = "toshiba,tc35894", .data = (void *) TC3589X_TC35894 },
+	{ .compatible = "toshiba,tc35895", .data = (void *) TC3589X_TC35895 },
+	{ .compatible = "toshiba,tc35896", .data = (void *) TC3589X_TC35896 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, tc3589x_match);
+
+static struct tc3589x_platform_data *
+tc3589x_of_probe(struct device *dev, enum tc3589x_version *version)
 {
+	struct device_node *np = dev->of_node;
+	struct tc3589x_platform_data *pdata;
 	struct device_node *child;
+	const struct of_device_id *of_id;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	of_id = of_match_device(tc3589x_match, dev);
+	if (!of_id)
+		return ERR_PTR(-ENODEV);
+	*version = (enum tc3589x_version) of_id->data;
 
 	for_each_child_of_node(np, child) {
-		if (!strcmp(child->name, "tc3589x_gpio")) {
+		if (of_device_is_compatible(child, "toshiba,tc3589x-gpio"))
 			pdata->block |= TC3589x_BLOCK_GPIO;
-		}
-		if (!strcmp(child->name, "tc3589x_keypad")) {
+		if (of_device_is_compatible(child, "toshiba,tc3589x-keypad"))
 			pdata->block |= TC3589x_BLOCK_KEYPAD;
-		}
 	}
 
-	return 0;
+	return pdata;
 }
+#else
+static inline struct tc3589x_platform_data *
+tc3589x_of_probe(struct device *dev, enum tc3589x_version *version)
+{
+	dev_err(dev, "no device tree support\n");
+	return ERR_PTR(-ENODEV);
+}
+#endif
 
 static int tc3589x_probe(struct i2c_client *i2c,
 				   const struct i2c_device_id *id)
 {
-	struct tc3589x_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
+	struct tc3589x_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct tc3589x *tc3589x;
+	enum tc3589x_version version;
 	int ret;
 
 	if (!pdata) {
-		if (np) {
-			pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
-			if (!pdata)
-				return -ENOMEM;
-
-			ret = tc3589x_of_probe(np, pdata);
-			if (ret)
-				return ret;
-		}
-		else {
+		pdata = tc3589x_of_probe(&i2c->dev, &version);
+		if (IS_ERR(pdata)) {
 			dev_err(&i2c->dev, "No platform data or DT found\n");
-			return -EINVAL;
+			return PTR_ERR(pdata);
 		}
+	} else {
+		/* When not probing from device tree we have this ID */
+		version = id->driver_data;
 	}
 
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA
@@ -375,7 +406,7 @@ static int tc3589x_probe(struct i2c_client *i2c,
 	tc3589x->pdata = pdata;
 	tc3589x->irq_base = pdata->irq_base;
 
-	switch (id->driver_data) {
+	switch (version) {
 	case TC3589X_TC35893:
 	case TC3589X_TC35895:
 	case TC3589X_TC35896:
@@ -471,9 +502,12 @@ static const struct i2c_device_id tc3589x_id[] = {
 MODULE_DEVICE_TABLE(i2c, tc3589x_id);
 
 static struct i2c_driver tc3589x_driver = {
-	.driver.name	= "tc3589x",
-	.driver.owner	= THIS_MODULE,
-	.driver.pm	= &tc3589x_dev_pm_ops,
+	.driver = {
+		.name	= "tc3589x",
+		.owner	= THIS_MODULE,
+		.pm	= &tc3589x_dev_pm_ops,
+		.of_match_table = of_match_ptr(tc3589x_match),
+	},
 	.probe		= tc3589x_probe,
 	.remove		= tc3589x_remove,
 	.id_table	= tc3589x_id,
-- 
1.8.4.2

