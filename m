Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaB0FyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:54:10 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15093 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0FyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:54:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 26 Feb 2014 21:50:21 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-pwm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] pwm-backlight: switch to gpiod interface
Date: Thu, 27 Feb 2014 14:53:34 +0900
Message-ID: <1393480414-19473-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the new gpiod interface, which allows to handle GPIO
properties such as active low transparently and removes a whole bunch of
code.

There are still a couple of users of this driver that rely on passing
the enable GPIO number through platform data, so a fallback mechanism
using a GPIO number is still available to avoid breaking them. It will
be removed once current users have switched to the GPIO lookup tables
provided by the gpiod interface.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c | 72 +++++++++++++++++-----------------------
 include/linux/pwm_backlight.h    |  5 +--
 2 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index b75201ff46f6..533057688d93 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -10,8 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/gpio/consumer.h>
 #include <linux/gpio.h>
-#include <linux/of_gpio.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -32,8 +32,7 @@ struct pwm_bl_data {
 	unsigned int		*levels;
 	bool			enabled;
 	struct regulator	*power_supply;
-	int			enable_gpio;
-	unsigned long		enable_gpio_flags;
+	struct gpio_desc	*enable_gpio;
 	unsigned int		scale;
 	int			(*notify)(struct device *,
 					  int brightness);
@@ -54,12 +53,8 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness)
 	if (err < 0)
 		dev_err(pb->dev, "failed to enable power supply\n");
 
-	if (gpio_is_valid(pb->enable_gpio)) {
-		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
-			gpio_set_value(pb->enable_gpio, 0);
-		else
-			gpio_set_value(pb->enable_gpio, 1);
-	}
+	if (pb->enable_gpio)
+		gpiod_set_value(pb->enable_gpio, 1);
 
 	pwm_enable(pb->pwm);
 	pb->enabled = true;
@@ -73,12 +68,8 @@ static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
 
-	if (gpio_is_valid(pb->enable_gpio)) {
-		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
-			gpio_set_value(pb->enable_gpio, 1);
-		else
-			gpio_set_value(pb->enable_gpio, 0);
-	}
+	if (pb->enable_gpio)
+		gpiod_set_value(pb->enable_gpio, 0);
 
 	regulator_disable(pb->power_supply);
 	pb->enabled = false;
@@ -148,7 +139,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 				  struct platform_pwm_backlight_data *data)
 {
 	struct device_node *node = dev->of_node;
-	enum of_gpio_flags flags;
 	struct property *prop;
 	int length;
 	u32 value;
@@ -189,14 +179,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	data->enable_gpio = of_get_named_gpio_flags(node, "enable-gpios", 0,
-						    &flags);
-	if (data->enable_gpio == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-
-	if (gpio_is_valid(data->enable_gpio) && (flags & OF_GPIO_ACTIVE_LOW))
-		data->enable_gpio_flags |= PWM_BACKLIGHT_GPIO_ACTIVE_LOW;
-
 	return 0;
 }
 
@@ -256,8 +238,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		pb->scale = data->max_brightness;
 
-	pb->enable_gpio = data->enable_gpio;
-	pb->enable_gpio_flags = data->enable_gpio_flags;
 	pb->notify = data->notify;
 	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
@@ -265,26 +245,39 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	pb->dev = &pdev->dev;
 	pb->enabled = false;
 
-	if (gpio_is_valid(pb->enable_gpio)) {
-		unsigned long flags;
-
-		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
-			flags = GPIOF_OUT_INIT_HIGH;
-		else
-			flags = GPIOF_OUT_INIT_LOW;
+	pb->enable_gpio = devm_gpiod_get(&pdev->dev, "enable");
+	if (IS_ERR(pb->enable_gpio)) {
+		ret = PTR_ERR(pb->enable_gpio);
+		if (ret == -ENOENT) {
+			pb->enable_gpio = NULL;
+			ret = 0;
+		} else {
+			goto err_alloc;
+		}
+	}
 
-		ret = gpio_request_one(pb->enable_gpio, flags, "enable");
+	/*
+	 * Compatibility fallback for drivers still using the integer GPIO
+	 * platform data. Must go away soon.
+	 */
+	if (pb->enable_gpio == NULL && gpio_is_valid(data->enable_gpio)) {
+		ret = devm_gpio_request_one(&pdev->dev, data->enable_gpio,
+					    GPIOF_OUT_INIT_HIGH, "enable");
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to request GPIO#%d: %d\n",
-				pb->enable_gpio, ret);
+				data->enable_gpio, ret);
 			goto err_alloc;
 		}
+		pb->enable_gpio = gpio_to_desc(data->enable_gpio);
 	}
 
+	if (pb->enable_gpio)
+		gpiod_direction_output(pb->enable_gpio, 1);
+
 	pb->power_supply = devm_regulator_get(&pdev->dev, "power");
 	if (IS_ERR(pb->power_supply)) {
 		ret = PTR_ERR(pb->power_supply);
-		goto err_gpio;
+		goto err_alloc;
 	}
 
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
@@ -295,7 +288,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		if (IS_ERR(pb->pwm)) {
 			dev_err(&pdev->dev, "unable to request legacy PWM\n");
 			ret = PTR_ERR(pb->pwm);
-			goto err_gpio;
+			goto err_alloc;
 		}
 	}
 
@@ -320,7 +313,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
-		goto err_gpio;
+		goto err_alloc;
 	}
 
 	if (data->dft_brightness > data->max_brightness) {
@@ -336,9 +329,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 	return 0;
 
-err_gpio:
-	if (gpio_is_valid(pb->enable_gpio))
-		gpio_free(pb->enable_gpio);
 err_alloc:
 	if (data->exit)
 		data->exit(&pdev->dev);
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 2de2e275b2cb..efdd9227a49c 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -6,9 +6,6 @@
 
 #include <linux/backlight.h>
 
-/* TODO: convert to gpiod_*() API once it has been merged */
-#define PWM_BACKLIGHT_GPIO_ACTIVE_LOW	(1 << 0)
-
 struct platform_pwm_backlight_data {
 	int pwm_id;
 	unsigned int max_brightness;
@@ -16,8 +13,8 @@ struct platform_pwm_backlight_data {
 	unsigned int lth_brightness;
 	unsigned int pwm_period_ns;
 	unsigned int *levels;
+	/* TODO remove once all users are switched to gpiod_* API */
 	int enable_gpio;
-	unsigned long enable_gpio_flags;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
 	void (*notify_after)(struct device *dev, int brightness);
-- 
1.9.0

