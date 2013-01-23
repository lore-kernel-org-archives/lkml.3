Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3AWRrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:47:42 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65398 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3AWRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:47:40 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] USB: misc: usb3503: add dt support
Date: Thu, 24 Jan 2013 02:47:10 +0900
Message-Id: <1358963242-2596-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added device tree support for usb3503 driver and add new document with device tree binding information.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 Documentation/devicetree/bindings/usb/usb3503.txt |   20 +++++++++++++
 drivers/usb/misc/usb3503.c                        |   31 +++++++++++++++++----
 2 files changed, 46 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/usb3503.txt

diff --git a/Documentation/devicetree/bindings/usb/usb3503.txt b/Documentation/devicetree/bindings/usb/usb3503.txt
new file mode 100644
index 0000000..6813a71
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/usb3503.txt
@@ -0,0 +1,20 @@
+SMSC USB3503 High-Speed Hub Controller
+
+Required properties:
+- compatible: Should be "smsc,usb3503".
+- reg: Specifies the i2c slave address, it should be 0x08.
+- connect-gpios: Should specify GPIO for connect.
+- intn-gpios: Should specify GPIO for interrupt.
+- reset-gpios: Should specify GPIO for reset.
+- initial-mode: Should specify initial mode.
+                (1 for HUB mode, 2 for STANDBY mode)
+
+Examples:
+	usb3503@08 {
+		compatible = "smsc,usb3503";
+		reg = <0x08>;
+		connect-gpios = <&gpx3 0 1>;
+		intn-gpios = <&gpx3 4 1>;
+		reset-gpios = <&gpx3 5 1>;
+		initial-mode = <1>;
+	};
diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index dc2c993..471218a 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb3503.h>
 
@@ -181,8 +182,10 @@ err_hubmode:
 static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 {
 	struct usb3503_platform_data *pdata = i2c->dev.platform_data;
+	struct device_node *np = i2c->dev.of_node;
 	struct usb3503 *hub;
 	int err = -ENOMEM;
+	u32 mode;
 
 	hub = kzalloc(sizeof(struct usb3503), GFP_KERNEL);
 	if (!hub) {
@@ -193,14 +196,23 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	i2c_set_clientdata(i2c, hub);
 	hub->client = i2c;
 
-	if (!pdata) {
-		dev_dbg(&i2c->dev, "missing platform data\n");
-		goto err_out;
-	} else {
+	if (pdata) {
 		hub->gpio_intn		= pdata->gpio_intn;
 		hub->gpio_connect	= pdata->gpio_connect;
 		hub->gpio_reset		= pdata->gpio_reset;
 		hub->mode		= pdata->initial_mode;
+	} else if (np) {
+		hub->gpio_intn	= of_get_named_gpio(np, "connect-gpios", 0);
+		if (hub->gpio_intn == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		hub->gpio_connect = of_get_named_gpio(np, "intn-gpios", 0);
+		if (hub->gpio_connect == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		hub->gpio_reset	= of_get_named_gpio(np, "reset-gpios", 0);
+		if (hub->gpio_reset == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		of_property_read_u32(np, "initial-mode", &mode);
+		hub->mode = mode;
 	}
 
 	if (gpio_is_valid(hub->gpio_intn)) {
@@ -236,7 +248,7 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		}
 	}
 
-	usb3503_switch_mode(hub, pdata->initial_mode);
+	usb3503_switch_mode(hub, hub->mode);
 
 	dev_info(&i2c->dev, "%s: probed on  %s mode\n", __func__,
 			(hub->mode == USB3503_MODE_HUB) ? "hub" : "standby");
@@ -277,9 +289,18 @@ static const struct i2c_device_id usb3503_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, usb3503_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id usb3503_of_match[] = {
+	{ .compatible = "smsc,usb3503", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, usb3503_of_match);
+#endif
+
 static struct i2c_driver usb3503_driver = {
 	.driver = {
 		.name = USB3503_I2C_NAME,
+		.of_match_table = of_match_ptr(usb3503_of_match),
 	},
 	.probe		= usb3503_probe,
 	.remove		= usb3503_remove,
-- 
1.7.10.4

