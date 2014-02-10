Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaBJHcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:32:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:34681 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbaBJHcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:32:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607218"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/11] drm/i915: Add rotation property for sprites
Date: Mon, 10 Feb 2014 13:01:16 +0530
Message-Id: <1392017478-4945-10-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Sprite planes support 180 degree rotation. The lower layers are now in
place, so hook in the standard rotation property to expose the feature
to the users.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Sagar Kamble <sagar.a.kamble@intel.com>
Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/i915_drv.h     |  1 +
 drivers/gpu/drm/i915/intel_sprite.c | 42 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index fa37dfd..ea2efc3 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1548,6 +1548,7 @@ typedef struct drm_i915_private {
 
 	struct drm_property *broadcast_rgb_property;
 	struct drm_property *force_audio_property;
+	struct drm_property *rotation_property;
 
 	uint32_t hw_context_size;
 	struct list_head context_list;
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 511934c..62b9f84 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -1047,6 +1047,30 @@ out_unlock:
 	return ret;
 }
 
+static int intel_plane_set_property(struct drm_plane *plane,
+				    struct drm_property *prop,
+				    uint64_t val)
+{
+	struct drm_i915_private *dev_priv = plane->dev->dev_private;
+	struct intel_plane *intel_plane = to_intel_plane(plane);
+	uint64_t old_val;
+	int ret = -ENOENT;
+
+	if (prop == dev_priv->rotation_property) {
+		/* exactly one rotation angle please */
+		if (hweight32(val & 0xf) != 1)
+			return -EINVAL;
+
+		old_val = intel_plane->rotation;
+		intel_plane->rotation = val;
+		ret = intel_plane_restore(plane);
+		if (ret)
+			intel_plane->rotation = old_val;
+	}
+
+	return ret;
+}
+
 int intel_plane_restore(struct drm_plane *plane)
 {
 	struct intel_plane *intel_plane = to_intel_plane(plane);
@@ -1073,6 +1097,7 @@ static const struct drm_plane_funcs intel_plane_funcs = {
 	.update_plane = intel_update_plane,
 	.disable_plane = intel_disable_plane,
 	.destroy = intel_destroy_plane,
+	.set_property = intel_plane_set_property,
 };
 
 static uint32_t ilk_plane_formats[] = {
@@ -1109,6 +1134,7 @@ static uint32_t vlv_plane_formats[] = {
 int
 intel_plane_init(struct drm_device *dev, enum pipe pipe, int plane)
 {
+	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_plane *intel_plane;
 	unsigned long possible_crtcs;
 	const uint32_t *plane_formats;
@@ -1183,8 +1209,22 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe, int plane)
 			     &intel_plane_funcs,
 			     plane_formats, num_plane_formats,
 			     false);
-	if (ret)
+	if (ret) {
 		kfree(intel_plane);
+		goto out;
+	}
+
+	if (!dev_priv->rotation_property)
+		dev_priv->rotation_property =
+			drm_mode_create_rotation_property(dev,
+							  BIT(DRM_ROTATE_0) |
+							  BIT(DRM_ROTATE_180));
+
+	if (dev_priv->rotation_property)
+		drm_object_attach_property(&intel_plane->base.base,
+					   dev_priv->rotation_property,
+					   intel_plane->rotation);
 
+ out:
 	return ret;
 }
-- 
1.8.5

