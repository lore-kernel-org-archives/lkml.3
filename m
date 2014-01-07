Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaAGJ7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:59:51 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52586 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaAGJ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:58:42 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 2/4] drm/i915: factor out intel_lvds_get_edid()
Date: Tue,  7 Jan 2014 15:28:41 +0530
Message-Id: <1389088723-30959-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code will be reused to support hybrid graphics on some Apple
machines that can't get a mode for the LVDS panel at boot, so move it
into a new function named intel_lvds_get_edid().

Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Original-patch-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/i915_drv.h   |   1 +
 drivers/gpu/drm/i915/intel_lvds.c | 104 ++++++++++++++++++++++----------------
 2 files changed, 61 insertions(+), 44 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 90fcccb..2c055f8 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1496,6 +1496,7 @@ typedef struct drm_i915_private {
 	} wm;
 
 	struct i915_package_c8 pc8;
+	struct drm_connector *int_lvds_connector;
 
 	/* Old dri1 support infrastructure, beware the dragons ya fools entering
 	 * here! */
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c3b4da7..6c09617 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -42,6 +42,7 @@
 /* Private structure for the integrated LVDS support */
 struct intel_lvds_connector {
 	struct intel_connector base;
+	u8 i2c_pin;
 
 	struct notifier_block lid_notifier;
 };
@@ -921,6 +922,60 @@ static bool intel_lvds_supported(struct drm_device *dev)
 	return false;
 }
 
+static bool intel_lvds_get_edid(struct drm_device *dev)
+{
+	struct edid *edid;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct drm_connector *connector = dev_priv->int_lvds_connector;
+	struct intel_lvds_connector *lvds_connector = to_lvds_connector(connector);
+	struct drm_display_mode *scan; /* *modes, *bios_mode; */
+	struct drm_display_mode *fixed_mode = NULL;
+
+	/*
+	 * Attempt to get the fixed panel mode from DDC.  Assume that the
+	 * preferred mode is the right one.
+	 */
+	edid = drm_get_edid(connector, intel_gmbus_get_adapter(dev_priv, lvds_connector->i2c_pin));
+	if (edid) {
+		if (drm_add_edid_modes(connector, edid)) {
+			drm_mode_connector_update_edid_property(connector,
+								edid);
+		} else {
+			kfree(edid);
+			edid = ERR_PTR(-EINVAL);
+		}
+	} else {
+		edid = ERR_PTR(-ENOENT);
+	}
+	lvds_connector->base.edid = edid;
+
+	if (IS_ERR_OR_NULL(edid)) {
+		/* Didn't get an EDID, so
+		 * Set wide sync ranges so we get all modes
+		 * handed to valid_mode for checking
+		 */
+		connector->display_info.min_vfreq = 0;
+		connector->display_info.max_vfreq = 200;
+		connector->display_info.min_hfreq = 0;
+		connector->display_info.max_hfreq = 200;
+	}
+
+	list_for_each_entry(scan, &connector->probed_modes, head) {
+		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
+			DRM_DEBUG_KMS("using preferred mode from EDID: ");
+			drm_mode_debug_printmodeline(scan);
+
+			fixed_mode = drm_mode_duplicate(dev, scan);
+			if (fixed_mode) {
+				intel_find_lvds_downclock(dev, fixed_mode,
+							  connector);
+				return true;
+			}
+		}
+	}
+	return false;
+}
+
 /**
  * intel_lvds_init - setup LVDS connectors on this device
  * @dev: drm device
@@ -937,9 +992,7 @@ void intel_lvds_init(struct drm_device *dev)
 	struct intel_connector *intel_connector;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
-	struct drm_display_mode *scan; /* *modes, *bios_mode; */
 	struct drm_display_mode *fixed_mode = NULL;
-	struct edid *edid;
 	struct drm_crtc *crtc;
 	u32 lvds;
 	int pipe;
@@ -978,11 +1031,13 @@ void intel_lvds_init(struct drm_device *dev)
 	}
 
 	lvds_encoder->attached_connector = lvds_connector;
+	lvds_connector->i2c_pin = pin;
 
 	intel_encoder = &lvds_encoder->base;
 	encoder = &intel_encoder->base;
 	intel_connector = &lvds_connector->base;
 	connector = &intel_connector->base;
+	dev_priv->int_lvds_connector = connector;
 	drm_connector_init(dev, &intel_connector->base, &intel_lvds_connector_funcs,
 			   DRM_MODE_CONNECTOR_LVDS);
 
@@ -1036,48 +1091,8 @@ void intel_lvds_init(struct drm_device *dev)
 	 *    if closed, act like it's not there for now
 	 */
 
-	/*
-	 * Attempt to get the fixed panel mode from DDC.  Assume that the
-	 * preferred mode is the right one.
-	 */
-	edid = drm_get_edid(connector, intel_gmbus_get_adapter(dev_priv, pin));
-	if (edid) {
-		if (drm_add_edid_modes(connector, edid)) {
-			drm_mode_connector_update_edid_property(connector,
-								edid);
-		} else {
-			kfree(edid);
-			edid = ERR_PTR(-EINVAL);
-		}
-	} else {
-		edid = ERR_PTR(-ENOENT);
-	}
-	lvds_connector->base.edid = edid;
-
-	if (IS_ERR_OR_NULL(edid)) {
-		/* Didn't get an EDID, so
-		 * Set wide sync ranges so we get all modes
-		 * handed to valid_mode for checking
-		 */
-		connector->display_info.min_vfreq = 0;
-		connector->display_info.max_vfreq = 200;
-		connector->display_info.min_hfreq = 0;
-		connector->display_info.max_hfreq = 200;
-	}
-
-	list_for_each_entry(scan, &connector->probed_modes, head) {
-		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
-			DRM_DEBUG_KMS("using preferred mode from EDID: ");
-			drm_mode_debug_printmodeline(scan);
-
-			fixed_mode = drm_mode_duplicate(dev, scan);
-			if (fixed_mode) {
-				intel_find_lvds_downclock(dev, fixed_mode,
-							  connector);
-				goto out;
-			}
-		}
-	}
+	if (intel_lvds_get_edid(dev))
+		goto out;
 
 	/* Failed to get EDID, what about VBT? */
 	if (dev_priv->vbt.lfp_lvds_vbt_mode) {
@@ -1149,6 +1164,7 @@ out:
 
 failed:
 	DRM_DEBUG_KMS("No LVDS modes found, disabling.\n");
+	dev_priv->int_lvds_connector = NULL;
 	drm_connector_cleanup(connector);
 	drm_encoder_cleanup(encoder);
 	if (fixed_mode)
-- 
1.8.5.2.229.g4448466

