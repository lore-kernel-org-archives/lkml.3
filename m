Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaB0O3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:29:00 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:34828 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaB0O27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:28:59 -0500
From: Denis Carikli <denis@eukrea.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denis Carikli <denis@eukrea.com>
Subject: [PATCHv12] video: backlight: gpio-backlight: Add DT support.
Date: Thu, 27 Feb 2014 15:28:33 +0100
Message-Id: <1393511313-18756-1-git-send-email-denis@eukrea.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v11-resend->v12:
- Moved the Cc from the commit message to the "email patch".
- The documentation is now more clear.
- The unnecessary default_on variable was removed.
- gbl->fbdev was already NULL and didn't need to be re-assigned,
  so the re-assignement was removed.
- The of_device_id struct and .of_match_table are now guarded
  against the driver beeing compiled without CONFIG_OF.

ChangeLog v11->v11-resend:
- Removed the Cc list because it's only one patch.

ChangeLog v10->v11:
- Shrinked the Cc list.
- Fixed the of_match_table warning.

ChangeLog v9->v10:
- Only the respective maintainers, or people who responded to the patch
  were kept in the Cc.
- The unnecessary of_match_ptr in of_match_table was removed.

ChangeLog v8->v9:
- Added Shawn Guo in the Cc list.
- The default-brightness-level is now a boolean default-on property,
  the gpio is only touched if the gpio-backlight driver instance probes.
- The code and documentation was updated accordingly.

ChangeLog v7->v8:
- The default-state was renamed to default-brightness-level.
- default-brightness-level is now mandatory, like for backlight-pwm,
  That way we avoid having to handle the case where it's not set,
  which means that we would need not to set the gpio, but still
  report a brightness value for sysfs, when not all gpio controllers are
  able to read the gpio value.
- switched the default-brightness-level to boolean values (0 or 1) instead
  of using strings ("on", "off", "keep").
- The documentation was updated accordingly.
- The example in the documentation now uses the dts gpio defines.
- The "backlight: gpio_backlight: Use a default state enum." patch was then
  dropped, becuase it is not necessary anymore.

ChangeLog v6->v7:
- removed a compilation warning with the removal of the useless ret declaration.

ChangeLog v5->v6:
- The default state handling was reworked:
  - it's now called default-state, and looks like the gpio-leds default-state.
  - it now has a "keep" option, like for the gpio-leds.
  - that "keep" option is the default when the default-state property is not set.
- The documentation was updated accordingly.

ChangeLog v4->v5:
- The default-brightness property now defaults to 0 in the driver.
- def_value int becomes a bool.
- The check for the gpio validity has been reworked.
---
 .../bindings/video/backlight/gpio-backlight.txt    |   16 ++++++
 drivers/video/backlight/gpio_backlight.c           |   58 +++++++++++++++++---
 2 files changed, 67 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt

diff --git a/Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt b/Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt
new file mode 100644
index 0000000..321be66
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt
@@ -0,0 +1,16 @@
+gpio-backlight bindings
+
+Required properties:
+  - compatible: "gpio-backlight"
+  - gpios: describes the gpio that is used for enabling/disabling the backlight.
+    refer to bindings/gpio/gpio.txt for more details.
+
+Optional properties:
+  - default-on: enable the backlight at boot.
+
+Example:
+	backlight {
+		compatible = "gpio-backlight";
+		gpios = <&gpio3 4 GPIO_ACTIVE_HIGH>;
+		default-on;
+	};
diff --git a/drivers/video/backlight/gpio_backlight.c b/drivers/video/backlight/gpio_backlight.c
index 81fb127..a2eba12 100644
--- a/drivers/video/backlight/gpio_backlight.c
+++ b/drivers/video/backlight/gpio_backlight.c
@@ -13,6 +13,8 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_data/gpio_backlight.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -23,6 +25,7 @@ struct gpio_backlight {
 
 	int gpio;
 	int active;
+	int def_value;
 };
 
 static int gpio_backlight_update_status(struct backlight_device *bl)
@@ -60,6 +63,29 @@ static const struct backlight_ops gpio_backlight_ops = {
 	.check_fb	= gpio_backlight_check_fb,
 };
 
+static int gpio_backlight_probe_dt(struct platform_device *pdev,
+				   struct gpio_backlight *gbl)
+{
+	struct device_node *np = pdev->dev.of_node;
+	enum of_gpio_flags gpio_flags;
+
+	gbl->gpio = of_get_gpio_flags(np, 0, &gpio_flags);
+
+	if (!gpio_is_valid(gbl->gpio)) {
+		if (gbl->gpio != -EPROBE_DEFER) {
+			dev_err(&pdev->dev,
+				"Error: The gpios parameter is missing or invalid.\n");
+		}
+		return gbl->gpio;
+	}
+
+	gbl->active = (gpio_flags & OF_GPIO_ACTIVE_LOW) ? 0 : 1;
+
+	gbl->def_value = of_property_read_bool(np, "default-on");
+
+	return 0;
+}
+
 static int gpio_backlight_probe(struct platform_device *pdev)
 {
 	struct gpio_backlight_platform_data *pdata =
@@ -67,10 +93,12 @@ static int gpio_backlight_probe(struct platform_device *pdev)
 	struct backlight_properties props;
 	struct backlight_device *bl;
 	struct gpio_backlight *gbl;
+	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "failed to find platform data\n");
+	if (!pdata && !np) {
+		dev_err(&pdev->dev,
+			"failed to find platform data or device tree node.\n");
 		return -ENODEV;
 	}
 
@@ -79,14 +107,22 @@ static int gpio_backlight_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	gbl->dev = &pdev->dev;
-	gbl->fbdev = pdata->fbdev;
-	gbl->gpio = pdata->gpio;
-	gbl->active = pdata->active_low ? 0 : 1;
+
+	if (np) {
+		ret = gpio_backlight_probe_dt(pdev, gbl);
+		if (ret)
+			return ret;
+	} else {
+		gbl->fbdev = pdata->fbdev;
+		gbl->gpio = pdata->gpio;
+		gbl->active = pdata->active_low ? 0 : 1;
+		gbl->def_value = pdata->def_value;
+	}
 
 	ret = devm_gpio_request_one(gbl->dev, gbl->gpio, GPIOF_DIR_OUT |
 				    (gbl->active ? GPIOF_INIT_LOW
 						 : GPIOF_INIT_HIGH),
-				    pdata->name);
+				    pdata ? pdata->name : "backlight");
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to request GPIO\n");
 		return ret;
@@ -103,17 +139,25 @@ static int gpio_backlight_probe(struct platform_device *pdev)
 		return PTR_ERR(bl);
 	}
 
-	bl->props.brightness = pdata->def_value;
+	bl->props.brightness = gbl->def_value;
 	backlight_update_status(bl);
 
 	platform_set_drvdata(pdev, bl);
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id gpio_backlight_of_match[] = {
+	{ .compatible = "gpio-backlight" },
+	{ /* sentinel */ }
+};
+#endif
+
 static struct platform_driver gpio_backlight_driver = {
 	.driver		= {
 		.name		= "gpio-backlight",
 		.owner		= THIS_MODULE,
+		.of_match_table = of_match_ptr(gpio_backlight_of_match),
 	},
 	.probe		= gpio_backlight_probe,
 };
-- 
1.7.9.5

