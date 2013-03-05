Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab3CEEoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:44:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13978 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab3CEEoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:44:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 20:44:03 -0800
From: Andrew Chew <achew@nvidia.com>
To: <thierry.reding@avionic-design.de>, <acourbot@nvidia.com>
CC: <achew@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 v2] pwm_bl: Add support for backlight enable GPIO
Date: Mon, 4 Mar 2013 20:43:50 -0800
Message-ID: <1362458630-31576-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backlight enable GPIO is specified in the device tree node for
backlight.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
I decided to go ahead with disabling/enabling the backlight via GPIO as
needed.  Note that I named the new functions pwm_backlight_enable() and
pwm_backlight_disable() (instead of something more gpio-specific) because
I thought it would be convenient to have a generic hook for when someone
wants to add yet more stuff to be done on enable/disable.

I tested this by going into /sys/class/backlight/backlight.n and manually
adjusting the brightness, and checked the gpio state to see that it had
the appropriate value.

 .../bindings/video/backlight/pwm-backlight.txt     |    2 +
 drivers/video/backlight/pwm_bl.c                   |   50 ++++++++++++++++++--
 include/linux/pwm_backlight.h                      |    2 +
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..1ed4f0f 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,8 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - enable-gpio: a GPIO that needs to be used to enable the backlight
+  - enable-gpio-active-high: polarity of GPIO is active high (default is low)
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..7dd426e 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -20,10 +20,13 @@
 #include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
 #include <linux/slab.h>
+#include <linux/of_gpio.h>
 
 struct pwm_bl_data {
 	struct pwm_device	*pwm;
 	struct device		*dev;
+	int			enable_gpio;
+	unsigned int		enable_gpio_flags;
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
@@ -35,6 +38,20 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static void pwm_backlight_enable(struct pwm_bl_data *pb)
+{
+	if (gpio_is_valid(pb->enable_gpio))
+		gpio_set_value(pb->enable_gpio,
+			       pb->enable_gpio_flags & GPIOF_INIT_HIGH ? 1 : 0);
+}
+
+static void pwm_backlight_disable(struct pwm_bl_data *pb)
+{
+	if (gpio_is_valid(pb->enable_gpio))
+		gpio_set_value(pb->enable_gpio,
+			       pb->enable_gpio_flags & GPIOF_INIT_HIGH ? 0 : 1);
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -53,6 +70,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 	if (brightness == 0) {
 		pwm_config(pb->pwm, 0, pb->period);
 		pwm_disable(pb->pwm);
+		pwm_backlight_disable(pb);
 	} else {
 		int duty_cycle;
 
@@ -67,6 +85,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
 		pwm_config(pb->pwm, duty_cycle, pb->period);
 		pwm_enable(pb->pwm);
+		pwm_backlight_enable(pb);
 	}
 
 	if (pb->notify_after)
@@ -146,10 +165,15 @@ static int pwm_backlight_parse_dt(struct device *dev,
 	}
 
 	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
+	 * If "enable-gpio" is present, use that GPIO to enable the backlight.
+	 * The presence (or not) of "enable-gpio-active-high" will determine
+	 * the value of the GPIO.
 	 */
+	data->enable_gpio = of_get_named_gpio(node, "enable-gpio", 0);
+	if (of_property_read_bool(node, "enable-gpio-active-high"))
+		data->enable_gpio_flags = GPIOF_OUT_INIT_HIGH;
+	else
+		data->enable_gpio_flags = GPIOF_OUT_INIT_LOW;
 
 	return 0;
 }
@@ -207,12 +231,23 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		max = data->max_brightness;
 
+	pb->enable_gpio = data->enable_gpio;
+	pb->enable_gpio_flags = data->enable_gpio_flags;
 	pb->notify = data->notify;
 	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
 	pb->exit = data->exit;
 	pb->dev = &pdev->dev;
 
+	if (gpio_is_valid(pb->enable_gpio)) {
+		ret = gpio_request_one(pb->enable_gpio,
+			GPIOF_DIR_OUT | pb->enable_gpio_flags, "bl_en");
+		if (ret) {
+			dev_err(&pdev->dev, "failed to allocate bl_en gpio");
+			goto err_alloc;
+		}
+	}
+
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
@@ -221,7 +256,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		if (IS_ERR(pb->pwm)) {
 			dev_err(&pdev->dev, "unable to request legacy PWM\n");
 			ret = PTR_ERR(pb->pwm);
-			goto err_alloc;
+			goto err_gpio;
 		}
 	}
 
@@ -255,6 +290,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 	return 0;
 
+err_gpio:
+	if (gpio_is_valid(data->enable_gpio))
+		gpio_free(data->enable_gpio);
 err_alloc:
 	if (data->exit)
 		data->exit(&pdev->dev);
@@ -269,6 +307,9 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
+	pwm_backlight_disable(pb);
+	if (gpio_is_valid(pb->enable_gpio))
+		gpio_free(pb->enable_gpio);
 	if (pb->exit)
 		pb->exit(&pdev->dev);
 	return 0;
@@ -284,6 +325,7 @@ static int pwm_backlight_suspend(struct device *dev)
 		pb->notify(pb->dev, 0);
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
+	pwm_backlight_disable(pb);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..2706805 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -8,6 +8,8 @@
 
 struct platform_pwm_backlight_data {
 	int pwm_id;
+	int enable_gpio;
+	unsigned int enable_gpio_flags;
 	unsigned int max_brightness;
 	unsigned int dft_brightness;
 	unsigned int lth_brightness;
-- 
1.7.9.5

