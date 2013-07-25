Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3GYWPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:15:35 -0400
Received: from home.keithp.com ([63.227.221.253]:57133 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab3GYWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:15:32 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/2] drm/i915: Add async page flip support for SNB
Date: Thu, 25 Jul 2013 15:15:15 -0700
Message-Id: <1374790515-29657-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374790515-29657-1-git-send-email-keithp@keithp.com>
References: <CAKMK7uFiL+p48Phwc=jmWtsOgjNOYJzTCWmHe3Bp7-jWMpTtTA@mail.gmail.com>
 <1374790515-29657-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just copies the IVB code

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 166aa2c..4a118c3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7465,20 +7465,29 @@ static int intel_gen6_queue_flip(struct drm_device *dev,
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
@@ -9731,7 +9740,7 @@ void intel_modeset_init(struct drm_device *dev)
 		dev->mode_config.max_height = 8192;
 	}
 
-	if (IS_GEN7(dev))
+	if (IS_GEN6(dev) || IS_GEN7(dev))
 		dev->mode_config.async_page_flip = true;
 
 	dev->mode_config.fb_base = dev_priv->gtt.mappable_base;
-- 
1.8.3.2

