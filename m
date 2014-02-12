Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaBLGvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:51:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:6271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaBLGvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:51:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,831,1384329600"; 
   d="scan'208";a="480086049"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Sagar Kamble <sagar.a.kamble@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, vijay.a.purushothaman@intel.com,
        Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH v6 1/1] drm/i915: Add 180 degree primary plane rotation support
Date: Wed, 12 Feb 2014 12:22:00 +0530
Message-Id: <1392187920-27870-1-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <20140211211937.GZ3891@intel.com>
References: <20140211211937.GZ3891@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

Primary planes support 180 degree rotation. Expose the feature
through rotation drm property.

v2: Calculating linear/tiled offsets based on pipe source width and
height. Added 180 degree rotation support in ironlake_update_plane.

v3: Checking if CRTC is active before issueing update_plane. Added
wait for vblank to make sure we dont overtake page flips. Disabling
FBC since it does not work with rotated planes.

v4: Updated rotation checks for pending flips, fbc disable. Creating
rotation property only for Gen4 onwards. Property resetting as part
of lastclose.

v5: Resetting property in i915_driver_lastclose properly for planes
and crtcs. Fixed linear offset calculation that was off by 1 w.r.t
width in i9xx_update_plane and ironlake_update_plane. Removed tab
based indentation and unnecessary braces in intel_crtc_set_property
and intel_update_fbc. FBC and flip related checks should be done only
for valid crtcs.

v6: Minor nits in FBC disable checks for comments in intel_crtc_set_property
and positioning the disable code in intel_update_fbc.

Testcase: igt/kms_plane_rotation_crc
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: vijay.a.purushothaman@intel.com
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/i915_dma.c      | 17 +++++++
 drivers/gpu/drm/i915/i915_reg.h      |  1 +
 drivers/gpu/drm/i915/intel_display.c | 86 ++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_drv.h     |  2 +
 drivers/gpu/drm/i915/intel_pm.c      |  8 ++++
 5 files changed, 110 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 258b1be..19e22a2 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1836,6 +1836,8 @@ int i915_driver_open(struct drm_device *dev, struct drm_file *file)
 void i915_driver_lastclose(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *crtc;
+	struct intel_plane *plane;
 
 	/* On gen6+ we refuse to init without kms enabled, but then the drm core
 	 * goes right around and calls lastclose. Check for this and don't clean
@@ -1843,6 +1845,21 @@ void i915_driver_lastclose(struct drm_device * dev)
 	if (!dev_priv)
 		return;
 
+	if (dev_priv->rotation_property) {
+		list_for_each_entry(crtc, &dev->mode_config.crtc_list, base.head) {
+			crtc->rotation = BIT(DRM_ROTATE_0);
+			drm_object_property_set_value(&crtc->base.base,
+						dev_priv->rotation_property,
+						crtc->rotation);
+		}
+		list_for_each_entry(plane, &dev->mode_config.plane_list, base.head) {
+			plane->rotation = BIT(DRM_ROTATE_0);
+			drm_object_property_set_value(&plane->base.base,
+						dev_priv->rotation_property,
+						plane->rotation);
+		}
+	}
+
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		intel_fbdev_restore_mode(dev);
 		vga_switcheroo_process_delayed_switch();
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 57906c5..d3000c4 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3553,6 +3553,7 @@
 #define   DISPPLANE_NO_LINE_DOUBLE		0
 #define   DISPPLANE_STEREO_POLARITY_FIRST	0
 #define   DISPPLANE_STEREO_POLARITY_SECOND	(1<<18)
+#define   DISPPLANE_ROTATE_180			(1<<15)
 #define   DISPPLANE_TRICKLE_FEED_DISABLE	(1<<14) /* Ironlake */
 #define   DISPPLANE_TILED			(1<<10)
 #define _DSPAADDR		(dev_priv->info->display_mmio_offset + 0x70184)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 4d4a0d9..f6fee29 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2037,6 +2037,7 @@ static int i9xx_update_plane(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	unsigned long linear_offset;
 	u32 dspcntr;
 	u32 reg;
+	int pixel_size;
 
 	switch (plane) {
 	case 0:
@@ -2047,6 +2048,7 @@ static int i9xx_update_plane(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		return -EINVAL;
 	}
 
+	pixel_size = drm_format_plane_cpp(fb->pixel_format, 0);
 	intel_fb = to_intel_framebuffer(fb);
 	obj = intel_fb->obj;
 
@@ -2054,6 +2056,8 @@ static int i9xx_update_plane(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	dspcntr = I915_READ(reg);
 	/* Mask out pixel format bits in case we change it */
 	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+	dspcntr &= ~DISPPLANE_ROTATE_180;
+
 	switch (fb->pixel_format) {
 	case DRM_FORMAT_C8:
 		dspcntr |= DISPPLANE_8BPP;
@@ -2095,8 +2099,6 @@ static int i9xx_update_plane(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	if (IS_G4X(dev))
 		dspcntr |= DISPPLANE_TRICKLE_FEED_DISABLE;
 
-	I915_WRITE(reg, dspcntr);
-
 	linear_offset = y * fb->pitches[0] + x * (fb->bits_per_pixel / 8);
 
 	if (INTEL_INFO(dev)->gen >= 4) {
@@ -2109,6 +2111,17 @@ static int i9xx_update_plane(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		intel_crtc->dspaddr_offset = linear_offset;
 	}
 
+	if (intel_crtc->rotation == BIT(DRM_ROTATE_180)) {
+		dspcntr |= DISPPLANE_ROTATE_180;
+
+		x += (intel_crtc->config.pipe_src_w - 1);
+		y += (intel_crtc->config.pipe_src_h - 1);
+		linear_offset += (intel_crtc->config.pipe_src_h - 1) * fb->pitches[0] +
+                                   (intel_crtc->config.pipe_src_w - 1) * pixel_size;
+	}
+
+	I915_WRITE(reg, dspcntr);
+
 	DRM_DEBUG_KMS("Writing base %08lX %08lX %d %d %d\n",
 		      i915_gem_obj_ggtt_offset(obj), linear_offset, x, y,
 		      fb->pitches[0]);
@@ -2137,6 +2150,7 @@ static int ironlake_update_plane(struct drm_crtc *crtc,
 	unsigned long linear_offset;
 	u32 dspcntr;
 	u32 reg;
+	int pixel_size;
 
 	switch (plane) {
 	case 0:
@@ -2148,6 +2162,7 @@ static int ironlake_update_plane(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
+	pixel_size = drm_format_plane_cpp(fb->pixel_format, 0);
 	intel_fb = to_intel_framebuffer(fb);
 	obj = intel_fb->obj;
 
@@ -2155,6 +2170,8 @@ static int ironlake_update_plane(struct drm_crtc *crtc,
 	dspcntr = I915_READ(reg);
 	/* Mask out pixel format bits in case we change it */
 	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+	dspcntr &= ~DISPPLANE_ROTATE_180;
+
 	switch (fb->pixel_format) {
 	case DRM_FORMAT_C8:
 		dspcntr |= DISPPLANE_8BPP;
@@ -2192,8 +2209,6 @@ static int ironlake_update_plane(struct drm_crtc *crtc,
 	else
 		dspcntr |= DISPPLANE_TRICKLE_FEED_DISABLE;
 
-	I915_WRITE(reg, dspcntr);
-
 	linear_offset = y * fb->pitches[0] + x * (fb->bits_per_pixel / 8);
 	intel_crtc->dspaddr_offset =
 		intel_gen4_compute_page_offset(&x, &y, obj->tiling_mode,
@@ -2201,6 +2216,19 @@ static int ironlake_update_plane(struct drm_crtc *crtc,
 					       fb->pitches[0]);
 	linear_offset -= intel_crtc->dspaddr_offset;
 
+	if (intel_crtc->rotation == BIT(DRM_ROTATE_180)) {
+		dspcntr |= DISPPLANE_ROTATE_180;
+
+		if (!IS_HASWELL(dev) && !IS_BROADWELL(dev)) {
+			x += (intel_crtc->config.pipe_src_w - 1);
+			y += (intel_crtc->config.pipe_src_h - 1);
+			linear_offset += (intel_crtc->config.pipe_src_h - 1) * fb->pitches[0] +
+					(intel_crtc->config.pipe_src_w - 1) * pixel_size;
+		}
+	}
+
+	I915_WRITE(reg, dspcntr);
+
 	DRM_DEBUG_KMS("Writing base %08lX %08lX %d %d %d\n",
 		      i915_gem_obj_ggtt_offset(obj), linear_offset, x, y,
 		      fb->pitches[0]);
@@ -8748,6 +8776,42 @@ free_work:
 	return ret;
 }
 
+static int intel_crtc_set_property(struct drm_crtc *crtc,
+				    struct drm_property *prop,
+				    uint64_t val)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
+	uint64_t old_val;
+	int ret = -ENOENT;
+
+	if (prop == dev_priv->rotation_property) {
+		/* exactly one rotation angle please */
+		if (hweight32(val & 0xf) != 1)
+			return -EINVAL;
+
+		old_val = intel_crtc->rotation;
+		intel_crtc->rotation = val;
+
+		if (intel_crtc->active) {
+			intel_crtc_wait_for_pending_flips(crtc);
+
+			/* FBC does not work on some platforms for rotated planes */
+			if (dev_priv->fbc.plane == intel_crtc->plane &&
+			    INTEL_INFO(dev)->gen <= 4 && !IS_G4X(dev) &&
+			    intel_crtc->rotation != BIT(DRM_ROTATE_0))
+				intel_disable_fbc(dev);
+
+			ret = dev_priv->display.update_plane(crtc, crtc->fb, 0, 0);
+			if (ret)
+				intel_crtc->rotation = old_val;
+		}
+	}
+
+	return ret;
+}
+
 static struct drm_crtc_helper_funcs intel_helper_funcs = {
 	.mode_set_base_atomic = intel_pipe_set_base_atomic,
 	.load_lut = intel_crtc_load_lut,
@@ -10160,6 +10224,7 @@ static const struct drm_crtc_funcs intel_crtc_funcs = {
 	.set_config = intel_crtc_set_config,
 	.destroy = intel_crtc_destroy,
 	.page_flip = intel_crtc_page_flip,
+	.set_property = intel_crtc_set_property
 };
 
 static void intel_cpu_pll_init(struct drm_device *dev)
@@ -10288,6 +10353,7 @@ static void intel_crtc_init(struct drm_device *dev, int pipe)
 	 */
 	intel_crtc->pipe = pipe;
 	intel_crtc->plane = pipe;
+	intel_crtc->rotation = BIT(DRM_ROTATE_0);
 	if (HAS_FBC(dev) && INTEL_INFO(dev)->gen < 4) {
 		DRM_DEBUG_KMS("swapping pipes & planes for FBC\n");
 		intel_crtc->plane = !pipe;
@@ -10298,6 +10364,18 @@ static void intel_crtc_init(struct drm_device *dev, int pipe)
 	dev_priv->plane_to_crtc_mapping[intel_crtc->plane] = &intel_crtc->base;
 	dev_priv->pipe_to_crtc_mapping[intel_crtc->pipe] = &intel_crtc->base;
 
+	if (INTEL_INFO(dev)->gen >= 4) {
+		if (!dev_priv->rotation_property)
+			dev_priv->rotation_property =
+				drm_mode_create_rotation_property(dev,
+								BIT(DRM_ROTATE_0) |
+								BIT(DRM_ROTATE_180));
+		if (dev_priv->rotation_property)
+			drm_object_attach_property(&intel_crtc->base.base,
+						dev_priv->rotation_property,
+						intel_crtc->rotation);
+	}
+
 	drm_crtc_helper_add(&intel_crtc->base, &intel_helper_funcs);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 7a79b8e..02dfdb6 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -331,6 +331,8 @@ struct intel_crtc {
 	struct drm_crtc base;
 	enum pipe pipe;
 	enum plane plane;
+	unsigned int rotation;
+
 	u8 lut_r[256], lut_g[256], lut_b[256];
 	/*
 	 * Whether the crtc and the connected output pipeline is active. Implies
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 3c79b63..029d485 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -557,6 +557,14 @@ void intel_update_fbc(struct drm_device *dev)
 		goto out_disable;
 	}
 
+	if (INTEL_INFO(dev)->gen <= 4 && !IS_G4X(dev) &&
+	    intel_crtc->rotation != BIT(DRM_ROTATE_0)) {
+		if (set_no_fbc_reason(dev_priv, FBC_UNSUPPORTED_MODE))
+			DRM_DEBUG_KMS("mode incompatible with compression, "
+				      "disabling\n");
+		goto out_disable;
+	}
+
 	/* If the kernel debugger is active, always disable compression */
 	if (in_dbg_master())
 		goto out_disable;
-- 
1.8.5

