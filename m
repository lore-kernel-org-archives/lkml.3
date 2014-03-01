Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbaCAFEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:04:35 -0500
Received: from gnurou.org ([207.192.72.5]:45658 "EHLO mail.gnurou.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbaCAFEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:04:13 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Thierry Reding <treding@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] drm/panel: use gpiod interface for enable GPIO
Date: Sat,  1 Mar 2014 14:00:58 +0900
Message-Id: <1393650059-5152-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new GPIO descriptor interface to handle the panel's enable GPIO.
This considerably simplifies the code.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 69 ++++++++++--------------------------
 1 file changed, 18 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 94cbf06..d1cabfa 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -22,9 +22,8 @@
  */
 
 #include <linux/backlight.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/module.h>
-#include <linux/of_gpio.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
@@ -44,9 +43,6 @@ struct panel_desc {
 	} size;
 };
 
-/* TODO: convert to gpiod_*() API once it's been merged */
-#define GPIO_ACTIVE_LOW	(1 << 0)
-
 struct panel_simple {
 	struct drm_panel base;
 	bool enabled;
@@ -57,8 +53,7 @@ struct panel_simple {
 	struct regulator *supply;
 	struct i2c_adapter *ddc;
 
-	unsigned long enable_gpio_flags;
-	int enable_gpio;
+	struct gpio_desc *enable_gpio;
 };
 
 static inline struct panel_simple *to_panel_simple(struct drm_panel *panel)
@@ -110,12 +105,8 @@ static int panel_simple_disable(struct drm_panel *panel)
 		backlight_update_status(p->backlight);
 	}
 
-	if (gpio_is_valid(p->enable_gpio)) {
-		if (p->enable_gpio_flags & GPIO_ACTIVE_LOW)
-			gpio_set_value(p->enable_gpio, 1);
-		else
-			gpio_set_value(p->enable_gpio, 0);
-	}
+	if (p->enable_gpio)
+		gpiod_set_value(p->enable_gpio, 0);
 
 	regulator_disable(p->supply);
 	p->enabled = false;
@@ -137,12 +128,8 @@ static int panel_simple_enable(struct drm_panel *panel)
 		return err;
 	}
 
-	if (gpio_is_valid(p->enable_gpio)) {
-		if (p->enable_gpio_flags & GPIO_ACTIVE_LOW)
-			gpio_set_value(p->enable_gpio, 0);
-		else
-			gpio_set_value(p->enable_gpio, 1);
-	}
+	if (p->enable_gpio)
+		gpiod_set_value(p->enable_gpio, 1);
 
 	if (p->backlight) {
 		p->backlight->props.power = FB_BLANK_UNBLANK;
@@ -185,7 +172,6 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
 {
 	struct device_node *backlight, *ddc;
 	struct panel_simple *panel;
-	enum of_gpio_flags flags;
 	int err;
 
 	panel = devm_kzalloc(dev, sizeof(*panel), GFP_KERNEL);
@@ -199,30 +185,19 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
 	if (IS_ERR(panel->supply))
 		return PTR_ERR(panel->supply);
 
-	panel->enable_gpio = of_get_named_gpio_flags(dev->of_node,
-						     "enable-gpios", 0,
-						     &flags);
-	if (gpio_is_valid(panel->enable_gpio)) {
-		unsigned int value;
-
-		if (flags & OF_GPIO_ACTIVE_LOW)
-			panel->enable_gpio_flags |= GPIO_ACTIVE_LOW;
-
-		err = gpio_request(panel->enable_gpio, "enable");
+	panel->enable_gpio = devm_gpiod_get(dev, "enable");
+	if (!IS_ERR(panel->enable_gpio)) {
+		err = gpiod_direction_output(panel->enable_gpio, 0);
 		if (err < 0) {
-			dev_err(dev, "failed to request GPIO#%u: %d\n",
-				panel->enable_gpio, err);
+			dev_err(dev, "failed to setup enable GPIO: %d\n", err);
 			return err;
 		}
-
-		value = (panel->enable_gpio_flags & GPIO_ACTIVE_LOW) != 0;
-
-		err = gpio_direction_output(panel->enable_gpio, value);
-		if (err < 0) {
-			dev_err(dev, "failed to setup GPIO%u: %d\n",
-				panel->enable_gpio, err);
-			goto free_gpio;
-		}
+	} else if (PTR_ERR(panel->enable_gpio) == -ENOENT) {
+		panel->enable_gpio = NULL;
+	} else {
+		err = PTR_ERR(panel->enable_gpio);
+		dev_err(dev, "failed to request enable GPIO: %d\n", err);
+		return err;
 	}
 
 	backlight = of_parse_phandle(dev->of_node, "backlight", 0);
@@ -230,10 +205,8 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
 		panel->backlight = of_find_backlight_by_node(backlight);
 		of_node_put(backlight);
 
-		if (!panel->backlight) {
-			err = -EPROBE_DEFER;
-			goto free_gpio;
-		}
+		if (!panel->backlight)
+			return -EPROBE_DEFER;
 	}
 
 	ddc = of_parse_phandle(dev->of_node, "ddc-i2c-bus", 0);
@@ -265,9 +238,6 @@ free_ddc:
 free_backlight:
 	if (panel->backlight)
 		put_device(&panel->backlight->dev);
-free_gpio:
-	if (gpio_is_valid(panel->enable_gpio))
-		gpio_free(panel->enable_gpio);
 
 	return err;
 }
@@ -287,9 +257,6 @@ static int panel_simple_remove(struct device *dev)
 	if (panel->backlight)
 		put_device(&panel->backlight->dev);
 
-	if (gpio_is_valid(panel->enable_gpio))
-		gpio_free(panel->enable_gpio);
-
 	regulator_disable(panel->supply);
 
 	return 0;
-- 
1.9.0

