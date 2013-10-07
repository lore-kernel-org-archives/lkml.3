Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3JGLle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:41:34 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60475 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3JGLkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:40:05 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/12] pwm-backlight: Use new enable_gpio field
Date: Mon,  7 Oct 2013 13:37:44 +0200
Message-Id: <1381145866-445-11-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new enable_gpio field and allow it to be set from DT as
well. Now that all legacy users of platform data have been converted to
initialize this field to an invalid value, it is safe to use the field
from the driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- fix up binding documentation as suggested by Stephen Warren
- properly handle deferred probing

 .../bindings/video/backlight/pwm-backlight.txt     |  5 ++
 drivers/video/backlight/pwm_bl.c                   | 57 +++++++++++++++++++---
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..72810cc 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,8 +14,11 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - enable-gpios: contains a single GPIO specifier for the GPIO which enables
+                  and disables the backlight (see GPIO binding[1])
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
+[1]: Documentation/devicetree/bindings/gpio/gpio.txt
 
 Example:
 
@@ -25,4 +28,6 @@ Example:
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+
+		enable-gpios = <&gpio 58 0>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 4053efb..cdef4a3 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -28,6 +30,8 @@ struct pwm_bl_data {
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
 	bool			enabled;
+	int			enable_gpio;
+	unsigned long		enable_gpio_flags;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -55,6 +59,14 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
 		     pb->lth_brightness;
 
 	pwm_config(pb->pwm, duty_cycle, pb->period);
+
+	if (gpio_is_valid(pb->enable_gpio)) {
+		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
+			gpio_set_value(pb->enable_gpio, 0);
+		else
+			gpio_set_value(pb->enable_gpio, 1);
+	}
+
 	pwm_enable(pb->pwm);
 	pb->enabled = true;
 }
@@ -67,6 +79,13 @@ static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
 
+	if (gpio_is_valid(pb->enable_gpio)) {
+		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
+			gpio_set_value(pb->enable_gpio, 1);
+		else
+			gpio_set_value(pb->enable_gpio, 0);
+	}
+
 	pb->enabled = false;
 }
 
@@ -119,6 +138,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
 				  struct platform_pwm_backlight_data *data)
 {
 	struct device_node *node = dev->of_node;
+	enum of_gpio_flags flags;
 	struct property *prop;
 	int length;
 	u32 value;
@@ -159,11 +179,13 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
+	data->enable_gpio = of_get_named_gpio_flags(node, "enable-gpios", 0,
+						    &flags);
+	if (data->enable_gpio == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
+	if (gpio_is_valid(data->enable_gpio) && (flags & OF_GPIO_ACTIVE_LOW))
+		data->enable_gpio_flags |= PWM_BACKLIGHT_GPIO_ACTIVE_LOW;
 
 	return 0;
 }
@@ -221,6 +243,8 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		max = data->max_brightness;
 
+	pb->enable_gpio = data->enable_gpio;
+	pb->enable_gpio_flags = data->enable_gpio_flags;
 	pb->notify = data->notify;
 	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
@@ -228,6 +252,22 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	pb->dev = &pdev->dev;
 	pb->enabled = false;
 
+	if (gpio_is_valid(pb->enable_gpio)) {
+		unsigned long flags;
+
+		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
+			flags = GPIOF_OUT_INIT_HIGH;
+		else
+			flags = GPIOF_OUT_INIT_LOW;
+
+		ret = gpio_request_one(pb->enable_gpio, flags, "enable");
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to request GPIO#%d: %d\n",
+				pb->enable_gpio, ret);
+			goto err_alloc;
+		}
+	}
+
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
@@ -236,7 +276,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		if (IS_ERR(pb->pwm)) {
 			dev_err(&pdev->dev, "unable to request legacy PWM\n");
 			ret = PTR_ERR(pb->pwm);
-			goto err_alloc;
+			goto err_gpio;
 		}
 	}
 
@@ -261,7 +301,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
-		goto err_alloc;
+		goto err_gpio;
 	}
 
 	if (data->dft_brightness > data->max_brightness) {
@@ -277,6 +317,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 	return 0;
 
+err_gpio:
+	if (gpio_is_valid(pb->enable_gpio))
+		gpio_free(pb->enable_gpio);
 err_alloc:
 	if (data->exit)
 		data->exit(&pdev->dev);
-- 
1.8.4

