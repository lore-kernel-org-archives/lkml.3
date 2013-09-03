Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab3ICU3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:29:09 -0400
Received: from smtp1.newsguy.com ([74.209.136.71]:59597 "EHLO
	smtp1.newsguy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab3ICU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:29:06 -0400
X-Greylist: delayed 3658 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 16:29:05 EDT
From: Mike Dunn <mikedunn@newsguy.com>
To: thierry.reding@gmail.com
Cc: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH] pwm-backlight: add support for device tree gpio control
Date: Tue,  3 Sep 2013 12:26:12 -0700
Message-Id: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for controlling an arbitrary number of gpios to the
pwm-backlight driver.  This was left as a TODO when initial device tree support
was added by Thierry a while back.  This functionality replaces the callbacks
that are passed in the platform data for non-DT cases.  Users can avail
themselves of this feature by adding a 'gpios' property to the 'backlight' node.
When the update_status() callback in backlight_ops runs, the gpios listed in the
property are asserted/deasserted if the specified brightness is non-zero/zero.

Tested on a pxa270-based Palm Treo 680.

Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
---

Thanks for looking!

 .../bindings/video/backlight/pwm-backlight.txt     |   4 +
 drivers/video/backlight/pwm_bl.c                   | 128 ++++++++++++++++++---
 2 files changed, 113 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..4583e68 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,9 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - gpios:     An arbitrary number of gpios that must be asserted when the
+               backlight is on, and de-asserted when off.  They will be asserted
+               in the order they appear, and de-asserted in reverse order.
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -25,4 +28,5 @@ Example:
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+		gpios = <&gpio 77 0>, <&gpio 25 1>;  /* gpio 25 is active low */
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1fea627..1e2ab52 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -20,6 +20,12 @@
 #include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
 #include <linux/slab.h>
+#include <linux/of_gpio.h>
+
+struct pwm_bl_gpio {
+	unsigned int gpio;
+	enum of_gpio_flags flags;
+};
 
 struct pwm_bl_data {
 	struct pwm_device	*pwm;
@@ -27,6 +33,8 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	unsigned int		num_gpios;
+	struct pwm_bl_gpio	*gpios;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -94,14 +102,77 @@ static const struct backlight_ops pwm_backlight_ops = {
 };
 
 #ifdef CONFIG_OF
+static int pwm_backlight_dt_notify(struct device *dev, int brightness)
+{
+	struct backlight_device *bl = dev_get_drvdata(dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
+	int i;
+
+	if (brightness) {
+		for (i = 0; i < pb->num_gpios; i++) {
+			if (pb->gpios[i].flags == OF_GPIO_ACTIVE_LOW)
+				gpio_set_value(pb->gpios[i].gpio, 0);
+			else
+				gpio_set_value(pb->gpios[i].gpio, 1);
+		}
+		return 0;
+	}
+
+	/* de-assert gpios in reverse order, in case this is important */
+	for (i = pb->num_gpios - 1; i >= 0; i--) {
+		if (pb->gpios[i].flags == OF_GPIO_ACTIVE_LOW)
+			gpio_set_value(pb->gpios[i].gpio, 1);
+		else
+			gpio_set_value(pb->gpios[i].gpio, 0);
+	}
+	return 0;
+}
+
+static void pwm_backlight_dt_exit(struct pwm_bl_data *pb)
+{
+	int i;
+
+	for (i = 0; i < pb->num_gpios; i++)
+		gpio_free(pb->gpios[i].gpio);
+}
+
+static int pwm_backlight_dt_init(struct device *dev, struct pwm_bl_data *pb)
+{
+	int i, j, ret;
+
+	/* request gpios and drive in the inactive state */
+	for (i = 0; i < pb->num_gpios; i++) {
+		char gpio_name[32];
+		unsigned long flags;
+		if (pb->gpios[i].flags == OF_GPIO_ACTIVE_LOW)
+			flags = GPIOF_OUT_INIT_LOW;
+		else
+			flags = GPIOF_OUT_INIT_HIGH;
+		snprintf(gpio_name, 32, "%s.%d", dev_name(dev), i);
+		ret = gpio_request_one(pb->gpios[i].gpio, flags, gpio_name);
+		if (ret) {
+			dev_err(dev, "gpio #%d request failed\n", i);
+			goto gpio_err;
+		}
+	}
+	return 0;
+
+ gpio_err:
+	for (j = 0; j < i; j++)
+		gpio_free(pb->gpios[j].gpio);
+	return ret;
+}
+
 static int pwm_backlight_parse_dt(struct device *dev,
-				  struct platform_pwm_backlight_data *data)
+				  struct platform_pwm_backlight_data *data,
+				  struct pwm_bl_data *pb)
 {
 	struct device_node *node = dev->of_node;
 	struct property *prop;
 	int length;
 	u32 value;
-	int ret;
+	int ret, i, num_gpios;
+	size_t gpiosize;
 
 	if (!node)
 		return -ENODEV;
@@ -138,13 +209,29 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
+	/* read gpios from DT property */
+	num_gpios = of_gpio_count(node);
+	if (num_gpios == -ENOENT)
+		return 0;	/* no 'gpios' property present */
+	if (num_gpios < 0) {
+		dev_err(dev, "invalid DT node: gpios\n");
+		return -EINVAL;
+	}
+	gpiosize = sizeof(struct pwm_bl_gpio) * num_gpios;
+	pb->gpios = devm_kzalloc(dev, gpiosize, GFP_KERNEL);
+	if (!pb->gpios)
+		return -ENOMEM;
+	for (i = 0; i < num_gpios; i++) {
+		int gpio;
+		enum of_gpio_flags flags;
+		gpio = of_get_gpio_flags(node, i, &flags);
+		pb->gpios[i].gpio = (unsigned int)gpio;
+		pb->gpios[i].flags = flags;
+	}
+	pb->num_gpios = (unsigned int)num_gpios;
+	pb->notify = pwm_backlight_dt_notify;
 
-	return 0;
+	return pwm_backlight_dt_init(dev, pb);
 }
 
 static struct of_device_id pwm_backlight_of_match[] = {
@@ -155,10 +242,12 @@ static struct of_device_id pwm_backlight_of_match[] = {
 MODULE_DEVICE_TABLE(of, pwm_backlight_of_match);
 #else
 static int pwm_backlight_parse_dt(struct device *dev,
-				  struct platform_pwm_backlight_data *data)
+				  struct platform_pwm_backlight_data *data,
+				  struct pwm_bl_data *pb)
 {
 	return -ENODEV;
 }
+static void pwm_backlight_dt_exit(struct pwm_bl_data *pb) {}
 #endif
 
 static int pwm_backlight_probe(struct platform_device *pdev)
@@ -171,8 +260,14 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	unsigned int max;
 	int ret;
 
+	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
+	if (!pb) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
 	if (!data) {
-		ret = pwm_backlight_parse_dt(&pdev->dev, &defdata);
+		ret = pwm_backlight_parse_dt(&pdev->dev, &defdata, pb);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to find platform data\n");
 			return ret;
@@ -187,20 +282,14 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
-	if (!pb) {
-		dev_err(&pdev->dev, "no memory for state\n");
-		ret = -ENOMEM;
-		goto err_alloc;
-	}
-
 	if (data->levels) {
 		max = data->levels[data->max_brightness];
 		pb->levels = data->levels;
 	} else
 		max = data->max_brightness;
 
-	pb->notify = data->notify;
+	if (pb->notify == NULL)	/* not using DT and its built-in notify() */
+		pb->notify = data->notify;
 	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
 	pb->exit = data->exit;
@@ -250,9 +339,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	}
 
 	bl->props.brightness = data->dft_brightness;
+	platform_set_drvdata(pdev, bl);
 	backlight_update_status(bl);
 
-	platform_set_drvdata(pdev, bl);
 	return 0;
 
 err_alloc:
@@ -271,6 +360,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	pwm_disable(pb->pwm);
 	if (pb->exit)
 		pb->exit(&pdev->dev);
+	pwm_backlight_dt_exit(pb);
 	return 0;
 }
 
-- 
1.8.1.5

