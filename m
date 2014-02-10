Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaBJHcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:32:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:41877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbaBJHcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:32:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607403"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Sagar Kamble <sagar.a.kamble@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, vijay.a.purushothaman@intel.com
Subject: [PATCH v5 11/11] drm/i915: Calling rotate and inverse rotate transformations after clipping
Date: Mon, 10 Feb 2014 13:01:18 +0530
Message-Id: <1392017478-4945-12-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

With clipped sprites these transformations are not working. these
functions transform complete sprite irrespective of clipping present.
This leads to invisible portion of sprite show up when rotate 180 if
it was out of visible area before.

v4: Moved rotate transform for source rectangle after clipping.
Added rotate and inverse rotate transform for destination rect.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: vijay.a.purushothaman@intel.com
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/intel_sprite.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 62b9f84..799f6a9 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -769,9 +769,6 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 	max_scale = intel_plane->max_downscale << 16;
 	min_scale = intel_plane->can_scale ? 1 : (1 << 16);
 
-	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
-			intel_plane->rotation);
-
 	hscale = drm_rect_calc_hscale_relaxed(&src, &dst, min_scale, max_scale);
 	BUG_ON(hscale < 0);
 
@@ -785,6 +782,13 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 	crtc_w = drm_rect_width(&dst);
 	crtc_h = drm_rect_height(&dst);
 
+	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
+				intel_plane->rotation);
+
+	drm_rect_rotate(&dst, intel_crtc->config.pipe_src_w,
+				intel_crtc->config.pipe_src_h,
+				intel_plane->rotation);
+
 	if (visible) {
 		/* check again in case clipping clamped the results */
 		hscale = drm_rect_calc_hscale(&src, &dst, min_scale, max_scale);
@@ -811,7 +815,11 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 				     drm_rect_height(&dst) * vscale - drm_rect_height(&src));
 
 		drm_rect_rotate_inv(&src, fb->width << 16, fb->height << 16,
-				    intel_plane->rotation);
+					intel_plane->rotation);
+
+		drm_rect_rotate_inv(&dst, intel_crtc->config.pipe_src_w,
+					intel_crtc->config.pipe_src_h,
+					intel_plane->rotation);
 
 		/* sanity check to make sure the src viewport wasn't enlarged */
 		WARN_ON(src.x1 < (int) src_x ||
-- 
1.8.5

