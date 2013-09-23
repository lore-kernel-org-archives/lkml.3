Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3IWVoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:44:19 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:50518 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3IWVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:42:49 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] pwm-backlight: Use new enable_gpio field
Date: Mon, 23 Sep 2013 23:41:05 +0200
Message-Id: <1379972467-11243-9-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new enable_gpio field and allow it to be set from DT as
well. Now that all legacy users of platform data have been converted to
initialize this field to an invalid value, it is safe to use the field
from the driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../bindings/video/backlight/pwm-backlight.txt     |  3 ++
 drivers/video/backlight/pwm_bl.c                   | 54 +++++++++++++++++++---
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..052eb03 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,7 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - enable-gpios: a list of GPIOs to enable and disable the backlight
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -25,4 +26,6 @@ Example:
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+
+		enable-gpios = <&gpio 58 0>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 8a49b30..506810c 100644
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
@@ -27,6 +29,8 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	int			enable_gpio;
+	unsigned long		enable_gpio_flags;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -51,12 +55,27 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
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
 }
 
 static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 {
 	pwm_disable(pb->pwm);
+
+	if (gpio_is_valid(pb->enable_gpio)) {
+		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
+			gpio_set_value(pb->enable_gpio, 1);
+		else
+			gpio_set_value(pb->enable_gpio, 0);
+	}
 }
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
@@ -108,6 +127,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
 				  struct platform_pwm_backlight_data *data)
 {
 	struct device_node *node = dev->of_node;
+	enum of_gpio_flags flags;
 	struct property *prop;
 	int length;
 	u32 value;
@@ -148,11 +168,10 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
+	data->enable_gpio = of_get_named_gpio_flags(node, "enable-gpios", 0,
+						    &flags);
+	if (gpio_is_valid(data->enable_gpio) && (flags & OF_GPIO_ACTIVE_LOW))
+		data->enable_gpio_flags |= PWM_BACKLIGHT_GPIO_ACTIVE_LOW;
 
 	return 0;
 }
@@ -210,12 +229,30 @@ static int pwm_backlight_probe(struct platform_device *pdev)
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
@@ -224,7 +261,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		if (IS_ERR(pb->pwm)) {
 			dev_err(&pdev->dev, "unable to request legacy PWM\n");
 			ret = PTR_ERR(pb->pwm);
-			goto err_alloc;
+			goto err_gpio;
 		}
 	}
 
@@ -249,7 +286,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
-		goto err_alloc;
+		goto err_gpio;
 	}
 
 	if (data->dft_brightness > data->max_brightness) {
@@ -265,6 +302,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
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

