Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaBGNqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:46:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:44760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaBGNqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:46:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,800,1384329600"; 
   d="scan'208";a="479633343"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: vijay.a.purushothaman@intel.com, airlied@linux.ie, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, tomi.valkeinen@ti.com, airlied@redhat.com,
        robdclark@gmail.com, archit@ti.com, gregkh@linuxfoundation.org,
        joe@perches.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>
Subject: [PATCH v4 07/11] drm/i915: Add 180 degree sprite rotation support
Date: Fri,  7 Feb 2014 19:15:12 +0530
Message-Id: <1391780716-21896-8-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The sprite planes (in fact all display planes starting from gen4)
support 180 degree rotation. Add the relevant low level bits to the
sprite code to make use of that feature.

The upper layers are not yet plugged in.

v2: HSW handles the rotated buffer offset automagically

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h     |  3 +++
 drivers/gpu/drm/i915/intel_drv.h    |  1 +
 drivers/gpu/drm/i915/intel_sprite.c | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index abd18cd..57906c5 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3637,6 +3637,7 @@
 #define   DVS_YUV_ORDER_UYVY	(1<<16)
 #define   DVS_YUV_ORDER_YVYU	(2<<16)
 #define   DVS_YUV_ORDER_VYUY	(3<<16)
+#define   DVS_ROTATE_180	(1<<15)
 #define   DVS_DEST_KEY		(1<<2)
 #define   DVS_TRICKLE_FEED_DISABLE (1<<14)
 #define   DVS_TILED		(1<<10)
@@ -3707,6 +3708,7 @@
 #define   SPRITE_YUV_ORDER_UYVY		(1<<16)
 #define   SPRITE_YUV_ORDER_YVYU		(2<<16)
 #define   SPRITE_YUV_ORDER_VYUY		(3<<16)
+#define   SPRITE_ROTATE_180		(1<<15)
 #define   SPRITE_TRICKLE_FEED_DISABLE	(1<<14)
 #define   SPRITE_INT_GAMMA_ENABLE	(1<<13)
 #define   SPRITE_TILED			(1<<10)
@@ -3780,6 +3782,7 @@
 #define   SP_YUV_ORDER_UYVY		(1<<16)
 #define   SP_YUV_ORDER_YVYU		(2<<16)
 #define   SP_YUV_ORDER_VYUY		(3<<16)
+#define   SP_ROTATE_180			(1<<15)
 #define   SP_TILED			(1<<10)
 #define _SPALINOFF		(VLV_DISPLAY_BASE + 0x72184)
 #define _SPASTRIDE		(VLV_DISPLAY_BASE + 0x72188)
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 44067bc..85864fc 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -397,6 +397,7 @@ struct intel_plane {
 	unsigned int crtc_w, crtc_h;
 	uint32_t src_x, src_y;
 	uint32_t src_w, src_h;
+	unsigned int rotation;
 
 	/* Since we need to change the watermarks before/after
 	 * enabling/disabling the planes, we need to store the parameters here
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 336ae6c..477d4d7 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -60,6 +60,7 @@ vlv_update_plane(struct drm_plane *dplane, struct drm_crtc *crtc,
 	sprctl &= ~SP_PIXFORMAT_MASK;
 	sprctl &= ~SP_YUV_BYTE_ORDER_MASK;
 	sprctl &= ~SP_TILED;
+	sprctl &= ~SP_ROTATE_180;
 
 	switch (fb->pixel_format) {
 	case DRM_FORMAT_YUYV:
@@ -131,6 +132,14 @@ vlv_update_plane(struct drm_plane *dplane, struct drm_crtc *crtc,
 							fb->pitches[0]);
 	linear_offset -= sprsurf_offset;
 
+	if (intel_plane->rotation == BIT(DRM_ROTATE_180)) {
+		sprctl |= SP_ROTATE_180;
+
+		x += src_w;
+		y += src_h;
+		linear_offset += src_h * fb->pitches[0] + src_w * pixel_size;
+	}
+
 	I915_WRITE(SPSTRIDE(pipe, plane), fb->pitches[0]);
 	I915_WRITE(SPPOS(pipe, plane), (crtc_y << 16) | crtc_x);
 
@@ -238,6 +247,7 @@ ivb_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 	sprctl &= ~SPRITE_RGB_ORDER_RGBX;
 	sprctl &= ~SPRITE_YUV_BYTE_ORDER_MASK;
 	sprctl &= ~SPRITE_TILED;
+	sprctl &= ~SPRITE_ROTATE_180;
 
 	switch (fb->pixel_format) {
 	case DRM_FORMAT_XBGR8888:
@@ -299,6 +309,17 @@ ivb_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 					       pixel_size, fb->pitches[0]);
 	linear_offset -= sprsurf_offset;
 
+	if (intel_plane->rotation == BIT(DRM_ROTATE_180)) {
+		sprctl |= SPRITE_ROTATE_180;
+
+		/* HSW does this automagically in hardware */
+		if (!IS_HASWELL(dev)) {
+			x += src_w;
+			y += src_h;
+			linear_offset += src_h * fb->pitches[0] + src_w * pixel_size;
+		}
+	}
+
 	I915_WRITE(SPRSTRIDE(pipe), fb->pitches[0]);
 	I915_WRITE(SPRPOS(pipe), (crtc_y << 16) | crtc_x);
 
@@ -422,6 +443,7 @@ ilk_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 	dvscntr &= ~DVS_RGB_ORDER_XBGR;
 	dvscntr &= ~DVS_YUV_BYTE_ORDER_MASK;
 	dvscntr &= ~DVS_TILED;
+	dvscntr &= ~DVS_ROTATE_180;
 
 	switch (fb->pixel_format) {
 	case DRM_FORMAT_XBGR8888:
@@ -478,6 +500,14 @@ ilk_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 					       pixel_size, fb->pitches[0]);
 	linear_offset -= dvssurf_offset;
 
+	if (intel_plane->rotation == BIT(DRM_ROTATE_180)) {
+		dvscntr |= DVS_ROTATE_180;
+
+		x += src_w;
+		y += src_h;
+		linear_offset += src_h * fb->pitches[0] + src_w * pixel_size;
+	}
+
 	I915_WRITE(DVSSTRIDE(pipe), fb->pitches[0]);
 	I915_WRITE(DVSPOS(pipe), (crtc_y << 16) | crtc_x);
 
@@ -739,6 +769,9 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 	max_scale = intel_plane->max_downscale << 16;
 	min_scale = intel_plane->can_scale ? 1 : (1 << 16);
 
+	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
+			intel_plane->rotation);
+
 	hscale = drm_rect_calc_hscale_relaxed(&src, &dst, min_scale, max_scale);
 	BUG_ON(hscale < 0);
 
@@ -777,6 +810,9 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 				     drm_rect_width(&dst) * hscale - drm_rect_width(&src),
 				     drm_rect_height(&dst) * vscale - drm_rect_height(&src));
 
+		drm_rect_rotate_inv(&src, fb->width << 16, fb->height << 16,
+				    intel_plane->rotation);
+
 		/* sanity check to make sure the src viewport wasn't enlarged */
 		WARN_ON(src.x1 < (int) src_x ||
 			src.y1 < (int) src_y ||
@@ -1141,6 +1177,7 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe, int plane)
 
 	intel_plane->pipe = pipe;
 	intel_plane->plane = plane;
+	intel_plane->rotation = BIT(DRM_ROTATE_0);
 	possible_crtcs = (1 << pipe);
 	ret = drm_plane_init(dev, &intel_plane->base, possible_crtcs,
 			     &intel_plane_funcs,
-- 
1.8.5

