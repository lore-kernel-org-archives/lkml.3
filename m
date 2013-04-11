Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936013Ab3DKVSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:18:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935488Ab3DKUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:56 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T3K_cDjNvn4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Te-VOcIUmooA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=taGs_qngAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=n7Cch7CHiCMA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202609.597329177@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 142/171 ] drm/i915: Dont clobber crtc->fb when queue_flip fails
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0142-drm-i915-Don-t-clobber-crtc-fb-when-queue_flip-fails.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

[ Upstream commit 4a35f83b2b7c6aae3fc0d1c4554fdc99dc33ad07 ]

Restore crtc->fb to the old framebuffer if queue_flip fails.

While at it, kill the pointless intel_fb temp variable.

v2: Update crtc->fb before queue_flip and restore it back
    after a failure.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-Tested-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_display.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0777c79..379abcb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6459,8 +6459,8 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
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
@@ -6485,8 +6485,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 
 	work->event = event;
 	work->dev = crtc->dev;
-	intel_fb = to_intel_framebuffer(crtc->fb);
-	work->old_fb_obj = intel_fb->obj;
+	work->old_fb_obj = to_intel_framebuffer(old_fb)->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
 
 	ret = drm_vblank_get(dev, intel_crtc->pipe);
@@ -6506,9 +6505,6 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	intel_crtc->unpin_work = work;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
-	intel_fb = to_intel_framebuffer(fb);
-	obj = intel_fb->obj;
-
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		goto cleanup;
@@ -6542,6 +6538,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 
 cleanup_pending:
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	crtc->fb = old_fb;
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);
-- 
1.7.10.4


