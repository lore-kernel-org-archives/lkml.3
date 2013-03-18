Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3CREez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:34:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33717 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab3CREbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:13 -0400
Message-Id: <20130318042146.263343934@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 20/82] drm/i915: Dont clobber crtc->fb when queue_flip fails
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 4a35f83b2b7c6aae3fc0d1c4554fdc99dc33ad07 upstream.

Restore crtc->fb to the old framebuffer if queue_flip fails.

While at it, kill the pointless intel_fb temp variable.

v2: Update crtc->fb before queue_flip and restore it back
    after a failure.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-Tested-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7280,8 +7280,8 @@ static int intel_crtc_page_flip(struct d
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_framebuffer *intel_fb;
-	struct drm_i915_gem_object *obj;
+	struct drm_framebuffer *old_fb = crtc->fb;
+	struct drm_i915_gem_object *obj = to_intel_framebuffer(fb)->obj;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	struct intel_unpin_work *work;
 	unsigned long flags;
@@ -7293,8 +7293,7 @@ static int intel_crtc_page_flip(struct d
 
 	work->event = event;
 	work->dev = crtc->dev;
-	intel_fb = to_intel_framebuffer(crtc->fb);
-	work->old_fb_obj = intel_fb->obj;
+	work->old_fb_obj = to_intel_framebuffer(old_fb)->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
 
 	ret = drm_vblank_get(dev, intel_crtc->pipe);
@@ -7314,9 +7313,6 @@ static int intel_crtc_page_flip(struct d
 	intel_crtc->unpin_work = work;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
-	intel_fb = to_intel_framebuffer(fb);
-	obj = intel_fb->obj;
-
 	mutex_lock(&dev->struct_mutex);
 
 	/* Reference the objects for the scheduled work. */
@@ -7347,6 +7343,7 @@ static int intel_crtc_page_flip(struct d
 
 cleanup_pending:
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	crtc->fb = old_fb;
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);


