Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab3BZX55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262Ab3BZX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 082/150] drm/i915: Only run idle processing from i915_gem_retire_requests_worker
Date: Tue, 26 Feb 2013 15:55:39 -0800
Message-Id: <20130226235532.611736288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 725a5b54028916cd2511a251c5b5b13d1715addc upstream.

When adding the fb idle detection to mark-inactive, it was forgotten
that userspace can drive the processing of retire-requests. We assumed
that it would be principally driven by the retire requests worker,
running once every second whilst active and so we would get the deferred
timer for free. Instead we spend too many CPU cycles reclocking the LVDS
preventing real work from being done.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-tested-by: Alexander Lam <lambchop468@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=58843
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c      |    3 ---
 drivers/gpu/drm/i915/intel_display.c |   12 +++---------
 drivers/gpu/drm/i915/intel_drv.h     |    3 +--
 3 files changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1918,9 +1918,6 @@ i915_gem_object_move_to_inactive(struct
 	BUG_ON(obj->base.write_domain & ~I915_GEM_GPU_DOMAINS);
 	BUG_ON(!obj->active);
 
-	if (obj->pin_count) /* are we a framebuffer? */
-		intel_mark_fb_idle(obj);
-
 	list_move_tail(&obj->mm_list, &dev_priv->mm.inactive_list);
 
 	list_del_init(&obj->ring_list);
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6993,11 +6993,6 @@ void intel_mark_busy(struct drm_device *
 
 void intel_mark_idle(struct drm_device *dev)
 {
-}
-
-void intel_mark_fb_busy(struct drm_i915_gem_object *obj)
-{
-	struct drm_device *dev = obj->base.dev;
 	struct drm_crtc *crtc;
 
 	if (!i915_powersave)
@@ -7007,12 +7002,11 @@ void intel_mark_fb_busy(struct drm_i915_
 		if (!crtc->fb)
 			continue;
 
-		if (to_intel_framebuffer(crtc->fb)->obj == obj)
-			intel_increase_pllclock(crtc);
+		intel_decrease_pllclock(crtc);
 	}
 }
 
-void intel_mark_fb_idle(struct drm_i915_gem_object *obj)
+void intel_mark_fb_busy(struct drm_i915_gem_object *obj)
 {
 	struct drm_device *dev = obj->base.dev;
 	struct drm_crtc *crtc;
@@ -7025,7 +7019,7 @@ void intel_mark_fb_idle(struct drm_i915_
 			continue;
 
 		if (to_intel_framebuffer(crtc->fb)->obj == obj)
-			intel_decrease_pllclock(crtc);
+			intel_increase_pllclock(crtc);
 	}
 }
 
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -440,9 +440,8 @@ extern bool intel_sdvo_init(struct drm_d
 extern void intel_dvo_init(struct drm_device *dev);
 extern void intel_tv_init(struct drm_device *dev);
 extern void intel_mark_busy(struct drm_device *dev);
-extern void intel_mark_idle(struct drm_device *dev);
 extern void intel_mark_fb_busy(struct drm_i915_gem_object *obj);
-extern void intel_mark_fb_idle(struct drm_i915_gem_object *obj);
+extern void intel_mark_idle(struct drm_device *dev);
 extern bool intel_lvds_init(struct drm_device *dev);
 extern void intel_dp_init(struct drm_device *dev, int output_reg,
 			  enum port port);


