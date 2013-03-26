Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3CZLs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:48:56 -0400
Received: from mout.web.de ([212.227.15.3]:62264 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab3CZLsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:48:54 -0400
From: Danny Baumann <dannybaumann@web.de>
To: David Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH 1/1] drm/i915: Allow specifying a minimum brightness level for sysfs control.
Date: Tue, 26 Mar 2013 12:48:45 +0100
Message-Id: <1364298525-4337-2-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
X-Provags-ID: V02:K0:3rtyXq0UeWjy0H9UcXSuIMEp+2h8FFoken+WQN1LE57
 fJ4ovX/0smjuhEuZfCYqvW3oqqtfixTLuTxRzHeuCdgfz2RlRg
 9tPI4CBK7OZXD/n2O+mDaaU/Q2ZVddeDlau1y8TQ57jN116RGE
 /lifUlWdBeImJXiRd+kBRajR06VAOQFkANQhA5co8SNK5nz6Mr
 QMaxzr+3N/UdShWtJa5gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When controlling backlight devices via sysfs interface, user space
generally assumes the minimum level (0) still providing a brightness
that is usable by the user (probably due to the most commonly used
backlight device, acpi_videoX, behaving exactly like that). This doesn't
match the current behaviour of the intel_backlight control, though, as
the value 0 means 'backlight off'.

In order to make intel_backlight consistent to other backlight devices,
introduce a module parameter that allows shifting the 0 level of the
intel_backlight device. It's expressed in percentages of the maximum
level. The default is 5, which provides a backlight level that is barely
readable. Setting it to 0 restores the old behaviour.

Signed-off-by: Danny Baumann <dannybaumann@web.de>
---
 drivers/gpu/drm/i915/intel_panel.c | 48 ++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index bee8cb6..5bad49d 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -395,10 +395,35 @@ intel_panel_detect(struct drm_device *dev)
 }
 
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+static int i915_panel_min_brightness_percent = 5;
+MODULE_PARM_DESC(min_sysfs_brightness, "Minimum brightness percentage settable "
+	"via sysfs. This adjusts the brightness level of the value '0' in the "
+	"intel_backlight sysfs backlight interface.");
+module_param_named(min_sysfs_brightness,
+		   i915_panel_min_brightness_percent, int, 0400);
+
+static int intel_panel_min_brightness(struct drm_device *dev)
+{
+	int max;
+
+	if (i915_panel_min_brightness_percent <= 0)
+		return 0;
+
+	max = intel_panel_get_max_backlight(dev);
+	if (i915_panel_min_brightness_percent >= 100)
+		return max;
+
+	return max * i915_panel_min_brightness_percent / 100;
+}
+
 static int intel_panel_update_status(struct backlight_device *bd)
 {
 	struct drm_device *dev = bl_get_data(bd);
-	intel_panel_set_backlight(dev, bd->props.brightness);
+	int brightness =
+		bd->props.brightness + intel_panel_min_brightness(dev);
+
+	intel_panel_set_backlight(dev, brightness);
 	return 0;
 }
 
@@ -406,7 +431,10 @@ static int intel_panel_get_brightness(struct backlight_device *bd)
 {
 	struct drm_device *dev = bl_get_data(bd);
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	return dev_priv->backlight_level;
+	int brightness =
+		dev_priv->backlight_level - intel_panel_min_brightness(dev);
+
+	return brightness;
 }
 
 static const struct backlight_ops intel_panel_bl_ops = {
@@ -419,16 +447,21 @@ int intel_panel_setup_backlight(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct backlight_properties props;
+	int max_brightness;
 
 	intel_panel_init_backlight(dev);
 
-	memset(&props, 0, sizeof(props));
-	props.type = BACKLIGHT_RAW;
-	props.max_brightness = _intel_panel_get_max_backlight(dev);
-	if (props.max_brightness == 0) {
+	max_brightness = _intel_panel_get_max_backlight(dev);
+	if (max_brightness == 0) {
 		DRM_DEBUG_DRIVER("Failed to get maximum backlight value\n");
 		return -ENODEV;
 	}
+
+	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness =
+		max_brightness - intel_panel_min_brightness(dev);
+
 	dev_priv->backlight =
 		backlight_device_register("intel_backlight",
 					  &connector->kdev, dev,
@@ -440,7 +473,8 @@ int intel_panel_setup_backlight(struct drm_connector *connector)
 		dev_priv->backlight = NULL;
 		return -ENODEV;
 	}
-	dev_priv->backlight->props.brightness = intel_panel_get_backlight(dev);
+	dev_priv->backlight->props.brightness = intel_panel_get_backlight(dev)
+		- intel_panel_min_brightness(dev);
 	return 0;
 }
 
-- 
1.8.1.4

