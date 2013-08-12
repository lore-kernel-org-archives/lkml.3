Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3HLWEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:04:31 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:33846 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3HLWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:04:28 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] pwm-backlight: add "max-brightness" property
Date: Mon, 12 Aug 2013 15:04:17 -0700
Message-Id: <1376345057-29895-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifying each individual brightness value via the "brightness-levels"
property can be a pain if we want to use a large continuous range of
brightness values.  Add the property "max-brightness", which can be
given in place of "brightness-levels", that specifies that all values
between 0 and the given value can be used.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 .../bindings/video/backlight/pwm-backlight.txt     | 22 +++++++++---
 drivers/video/backlight/pwm_bl.c                   | 39 +++++++++++++---------
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..856dfc9 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -3,15 +3,21 @@ pwm-backlight bindings
 Required properties:
   - compatible: "pwm-backlight"
   - pwms: OF device-tree PWM specification (see PWM binding[0])
+  - one of "brightness-levels" or "max-brightness", described below
+  - default-brightness-level: the default brightness level (index into the array
+      defined by the "brightness-levels" property or a value between 0 and
+      "max-brightness")
+
+Optional properties:
   - brightness-levels: Array of distinct brightness levels. Typically these
       are in the range from 0 to 255, but any range starting at 0 will do.
       The actual brightness level (PWM duty cycle) will be interpolated
       from these values. 0 means a 0% duty cycle (darkest/off), while the
       last value in the array represents a 100% duty cycle (brightest).
-  - default-brightness-level: the default brightness level (index into the
-      array defined by the "brightness-levels" property)
-
-Optional properties:
+  - max-brightness: Instead of specifying a complete set of brightness
+      levels, a single maximum brightness value may be given. This indicates
+      that all integers between 0 and max-brightness are valid brightness
+      values.
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
 
@@ -26,3 +32,11 @@ Example:
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
 	};
+or:
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 0 1000000 0>;
+
+		max-brightness = <1024>;
+		default-brightness-level = <700>;
+	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1fea627..92973b1 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -98,7 +98,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 				  struct platform_pwm_backlight_data *data)
 {
 	struct device_node *node = dev->of_node;
-	struct property *prop;
 	int length;
 	u32 value;
 	int ret;
@@ -108,34 +107,44 @@ static int pwm_backlight_parse_dt(struct device *dev,
 
 	memset(data, 0, sizeof(*data));
 
-	/* determine the number of brightness levels */
-	prop = of_find_property(node, "brightness-levels", &length);
-	if (!prop)
-		return -EINVAL;
+	if (of_find_property(node, "brightness-levels", &length)) {
+		data->max_brightness = length / sizeof(u32);
 
-	data->max_brightness = length / sizeof(u32);
+		/* read brightness levels from DT property */
+		if (data->max_brightness > 0) {
+			size_t size = sizeof(*data->levels) *
+					data->max_brightness;
 
-	/* read brightness levels from DT property */
-	if (data->max_brightness > 0) {
-		size_t size = sizeof(*data->levels) * data->max_brightness;
-
-		data->levels = devm_kzalloc(dev, size, GFP_KERNEL);
-		if (!data->levels)
-			return -ENOMEM;
+			data->levels = devm_kzalloc(dev, size, GFP_KERNEL);
+			if (!data->levels)
+				return -ENOMEM;
 
-		ret = of_property_read_u32_array(node, "brightness-levels",
+			ret = of_property_read_u32_array(node,
+						"brightness-levels",
 						 data->levels,
 						 data->max_brightness);
+			if (ret < 0)
+				return ret;
+
+			data->max_brightness--;
+		}
+	} else {
+		ret = of_property_read_u32(node, "max-brightness",
+					   &value);
 		if (ret < 0)
 			return ret;
 
+		/* brightness values are 0 to max-brightness */
+		data->max_brightness = value;
+	}
+
+	if (data->max_brightness > 0) {
 		ret = of_property_read_u32(node, "default-brightness-level",
 					   &value);
 		if (ret < 0)
 			return ret;
 
 		data->dft_brightness = value;
-		data->max_brightness--;
 	}
 
 	/*
-- 
1.8.3

