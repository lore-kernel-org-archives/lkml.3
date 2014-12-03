Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaLCVqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:46:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36482 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaLCVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:46:44 -0500
Date: Wed, 3 Dec 2014 22:46:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, sakari.ailus@iki.fi, m.chehab@samsung.com,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: j.anaszewski@samsung.com
Subject: [PATCH] media: i2c/adp1653: devicetree support for adp1653
Message-ID: <20141203214641.GA1390@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We are moving to device tree support on OMAP3, but that currently
breaks ADP1653 driver. This adds device tree support, plus required
documentation.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/adp1653.txt
@@ -0,0 +1,38 @@
+* Analog Devices ADP1653 flash LED driver
+
+Required Properties:
+
+  - compatible: Must contain one of the following
+    - "adi,adp1653"
+
+  - reg: I2C slave address
+
+  - gpios: References to the GPIO that controls the power for the chip.
+
+There are two led outputs available - flash and indicator. One led is
+represented by one child node, nodes need to be named "flash" and "indicator".
+
+Required properties of the LED child node:
+- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+
+Required properties of the flash LED child node:
+
+- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+- flash-timeout-microsec : see Documentation/devicetree/bindings/leds/common.txt
+
+Example:
+
+        adp1653: led-controller@30 {
+                compatible = "adi,adp1653";
+		reg = <0x30>;
+                gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
+
+		flash {
+                        flash-timeout-microsec = <500000>;
+                        flash-max-microamp = <320000>;
+                        max-microamp = <50000>;
+		};
+                indicator {
+                        max-microamp = <17500>;
+		};
+        };
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index cfddc3d..11d8afd 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -560,6 +567,22 @@
 
 		ti,usb-charger-detection = <&isp1704>;
 	};
+
+	adp1653: led-controller@30 {
+		compatible = "adi,adp1653";
+		reg = <0x30>;
+		gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
+
+		flash {
+			flash-timeout-microsec = <500000>;
+			flash-max-microamp = <320000>;
+			max-microamp = <50000>;
+		};
+
+		indicator {
+			max-microamp = <17500>;
+		};
+	};
 };
 
 &i2c3 {
diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index 873fe19..62601b2 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -8,6 +8,7 @@
  * Contributors:
  *	Sakari Ailus <sakari.ailus@iki.fi>
  *	Tuukka Toivonen <tuukkat76@gmail.com>
+ *      Pavel Machek <pavel@ucw.cz>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -34,9 +35,11 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/of_gpio.h>
+#include <linux/gpio.h>
 #include <media/adp1653.h>
 #include <media/v4l2-device.h>
 
 #define TIMEOUT_MAX		820000
 #define TIMEOUT_STEP		54600
 #define TIMEOUT_MIN		(TIMEOUT_MAX - ADP1653_REG_CONFIG_TMR_SET_MAX \
@@ -306,9 +318,18 @@ adp1653_init_device(struct adp1653_flash *flash)
 static int
 __adp1653_set_power(struct adp1653_flash *flash, int on)
 {
-	int ret;
+	int ret = 0;
 
-	ret = flash->platform_data->power(&flash->subdev, on);
+	if (flash->platform_data->power)
+		ret = flash->platform_data->power(&flash->subdev, on);
+	else {
+		gpio_set_value(flash->platform_data->power_gpio, on);
+		if (on) {
+			/* Some delay is apparently required. */
+			udelay(20);
+		}
+	}
+			
 	if (ret < 0)
 		return ret;
 
@@ -316,8 +337,13 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
 		return 0;
 
 	ret = adp1653_init_device(flash);
-	if (ret < 0)
+	if (ret >= 0)
+		return ret;
+
+	if (flash->platform_data->power)
 		flash->platform_data->power(&flash->subdev, 0);
+	else
+		gpio_set_value(flash->platform_data->power_gpio, 0);
 
 	return ret;
 }
@@ -407,21 +433,69 @@ static int adp1653_resume(struct device *dev)
 
 #endif /* CONFIG_PM */
 
+static int adp1653_of_init(struct i2c_client *client, struct adp1653_flash *flash, 
+			   struct device_node *node)
+{
+	u32 val;
+	struct adp1653_platform_data *pd;
+	enum of_gpio_flags flags;
+	int gpio;
+	struct device_node *child;
+
+	if (!node)
+		return -EINVAL;
+
+	pd = devm_kzalloc(&client->dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd)
+		return -ENOMEM;
+	flash->platform_data = pd;
+
+	child = of_get_child_by_name(node, "flash");
+	if (!child) return -EINVAL;
+	if (of_property_read_u32(child, "flash-timeout-microsec", &val)) return -EINVAL;
+	pd->max_flash_timeout = val;
+	if (of_property_read_u32(child, "flash-max-microamp", &val)) return -EINVAL;
+	pd->max_flash_intensity = val/1000;
+	if (of_property_read_u32(child, "max-microamp", &val)) return -EINVAL;
+	pd->max_torch_intensity = val/1000;
+
+	child = of_get_child_by_name(node, "indicator");
+	if (!child) return -EINVAL;
+	if (of_property_read_u32(child, "max-microamp", &val)) return -EINVAL;
+	pd->max_indicator_intensity = val;
+
+	if (!of_find_property(node, "gpios", NULL)) {
+		dev_err(&client->dev, "No gpio node\n");
+		return -EINVAL;
+	}
+
+	gpio = of_get_gpio_flags(node, 0, &flags);
+	if (gpio < 0) {
+		dev_err(&client->dev, "Error getting GPIO\n"); 
+		return -EINVAL;
+	}
+
+	pd->power_gpio = gpio;
+	return 0;
+}
+
+
 static int adp1653_probe(struct i2c_client *client,
 			 const struct i2c_device_id *devid)
 {
 	struct adp1653_flash *flash;
 	int ret;
 
-	/* we couldn't work without platform data */
-	if (client->dev.platform_data == NULL)
-		return -ENODEV;
-
 	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
 	if (flash == NULL)
 		return -ENOMEM;
 
 	flash->platform_data = client->dev.platform_data;
+	if (!flash->platform_data) {
+		ret = adp1653_of_init(client, flash, client->dev.of_node);
+		if (ret)
+			return ret;
+	}
 
 	mutex_init(&flash->power_lock);
 
diff --git a/include/media/adp1653.h b/include/media/adp1653.h
index 1d9b48a..b556580 100644
--- a/include/media/adp1653.h
+++ b/include/media/adp1653.h
@@ -100,9 +100,11 @@ struct adp1653_platform_data {
 	int (*power)(struct v4l2_subdev *sd, int on);
 
 	u32 max_flash_timeout;		/* flash light timeout in us */
-	u32 max_flash_intensity;	/* led intensity, flash mode */
-	u32 max_torch_intensity;	/* led intensity, torch mode */
-	u32 max_indicator_intensity;	/* indicator led intensity */
+	u32 max_flash_intensity;	/* led intensity, flash mode, mA */
+	u32 max_torch_intensity;	/* led intensity, torch mode, mA */
+	u32 max_indicator_intensity;	/* indicator led intensity, uA */
+
+	int power_gpio;			/* for device-tree based boot */
 };
 
 #define to_adp1653_flash(sd)	container_of(sd, struct adp1653_flash, subdev)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
