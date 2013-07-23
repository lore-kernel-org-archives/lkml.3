Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3GWCCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:02:23 -0400
Received: from home.keithp.com ([63.227.221.253]:43592 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab3GWCCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:02:19 -0400
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 5/5] drm/i915: Add async page flip support for SNB
Date: Mon, 22 Jul 2013 18:50:02 -0700
Message-Id: <1374544202-15496-6-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374544202-15496-1-git-send-email-keithp@keithp.com>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just copies the IVB code

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c | 39 ++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 1bcc6b4..9d7919b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7463,20 +7463,51 @@ static int intel_gen6_queue_flip(struct drm_device *dev,
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	struct intel_ring_buffer *ring = &dev_priv->ring[RCS];
 	uint32_t pf, pipesrc;
+	uint32_t cmd;
+	uint32_t base;
 	int ret;
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
 	if (ret)
 		goto err;
 
+	cmd = MI_DISPLAY_FLIP | MI_DISPLAY_FLIP_PLANE(intel_crtc->plane);
+	base = i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset;
+
+	if (flags & DRM_MODE_PAGE_FLIP_ASYNC) {
+
+		/* XXX check limitations for async flip here */
+
+		if (fb->pitches[0] != I915_READ(DSPSTRIDE(intel_crtc->plane))) {
+			WARN_ONCE(1, "mismatching stride in async plane flip (%d != %d)\n",
+				  fb->pitches[0], I915_READ(DSPSTRIDE(intel_crtc->plane)));
+			ret = -EINVAL;
+			goto err_unpin;
+		}
+
+		if (obj->tiling_mode != I915_TILING_X) {
+			WARN_ONCE(1, "async plane flip requires X tiling\n");
+			ret = -EINVAL;
+			goto err_unpin;
+		}
+
+		if ((I915_READ(DSPCNTR(intel_crtc->plane)) & DISPPLANE_TILED) == 0) {
+			WARN_ONCE(1, "display not currently tiled in async plane flip\n");
+			ret = -EINVAL;
+			goto err_unpin;
+		}
+		
+		cmd |= MI_DISPLAY_FLIP_ASYNC_INDICATOR;
+		base |= MI_DISPLAY_FLIP_TYPE_ASYNC;
+	}
+
 	ret = intel_ring_begin(ring, 4);
 	if (ret)
 		goto err_unpin;
 
-	intel_ring_emit(ring, MI_DISPLAY_FLIP |
-			MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
+	intel_ring_emit(ring, cmd);
 	intel_ring_emit(ring, fb->pitches[0] | obj->tiling_mode);
-	intel_ring_emit(ring, i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset);
+	intel_ring_emit(ring, base);
 
 	/* Contrary to the suggestions in the documentation,
 	 * "Enable Panel Fitter" does not seem to be required when page
@@ -9738,7 +9769,7 @@ void intel_modeset_init(struct drm_device *dev)
 		dev->mode_config.max_height = 8192;
 	}
 
-	if (IS_GEN7(dev))
+	if (IS_GEN6(dev) || IS_GEN7(dev))
 		dev->mode_config.async_page_flip = true;
 
 	dev->mode_config.fb_base = dev_priv->gtt.mappable_base;
-- 
1.8.3.2

