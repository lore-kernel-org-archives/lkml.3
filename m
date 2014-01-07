Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaAGOzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:55:05 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34053 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaAGOyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:54:31 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 2/4] drm/i915: factor out intel_lvds_get_edid()
Date: Tue,  7 Jan 2014 20:24:30 +0530
Message-Id: <1389106472-11389-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
References: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corresponding to

  intel_crt_get_edid()
  intel_sdvo_get_edid()
  intel_dp_get_edid()

add a intel_lvds_get_edid(). We plan to call this during a
switcheroo-reprobe in later patches.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/intel_lvds.c | 100 ++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c3b4da7..e7aa285 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -921,6 +921,60 @@ static bool intel_lvds_supported(struct drm_device *dev)
 	return false;
 }
 
+static struct edid *intel_lvds_get_edid(struct drm_connector *connector,
+					struct i2c_adapter *i2c)
+{
+	struct edid *edid;
+	struct intel_lvds_connector *lvds_connector = to_lvds_connector(connector);
+	struct drm_device *dev = connector->dev;
+	struct drm_display_mode *scan; /* *modes, *bios_mode; */
+	struct drm_display_mode *fixed_mode = NULL;
+
+	/*
+	 * Attempt to get the fixed panel mode from DDC.  Assume that the
+	 * preferred mode is the right one.
+	 */
+	edid = drm_get_edid(connector, i2c);
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
+				return edid;
+			}
+		}
+	}
+	return NULL;
+}
+
 /**
  * intel_lvds_init - setup LVDS connectors on this device
  * @dev: drm device
@@ -937,7 +991,6 @@ void intel_lvds_init(struct drm_device *dev)
 	struct intel_connector *intel_connector;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
-	struct drm_display_mode *scan; /* *modes, *bios_mode; */
 	struct drm_display_mode *fixed_mode = NULL;
 	struct edid *edid;
 	struct drm_crtc *crtc;
@@ -1036,48 +1089,9 @@ void intel_lvds_init(struct drm_device *dev)
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
+	edid = intel_lvds_get_edid(connector, intel_gmbus_get_adapter(dev_priv, pin));
+	if (edid)
+		goto out;
 
 	/* Failed to get EDID, what about VBT? */
 	if (dev_priv->vbt.lfp_lvds_vbt_mode) {
-- 
1.8.5.2.229.g4448466

