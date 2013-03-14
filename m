Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3CNKql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:46:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab3CNKhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 60/88] drm/i915: Don't clobber crtc->fb when queue_flip fails
Date: Thu, 14 Mar 2013 10:35:53 +0000
Message-Id: <1363257381-15900-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 4a35f83b2b7c6aae3fc0d1c4554fdc99dc33ad07 upstream.

Restore crtc->fb to the old framebuffer if queue_flip fails.

While at it, kill the pointless intel_fb temp variable.

v2: Update crtc->fb before queue_flip and restore it back
    after a failure.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-Tested-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 142a918..1f06ab4 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6240,8 +6240,8 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
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
@@ -6253,8 +6253,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 
 	work->event = event;
 	work->crtc = crtc;
-	intel_fb = to_intel_framebuffer(crtc->fb);
-	work->old_fb_obj = intel_fb->obj;
+	work->old_fb_obj = to_intel_framebuffer(old_fb)->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
 
 	ret = drm_vblank_get(dev, intel_crtc->pipe);
@@ -6274,9 +6273,6 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	intel_crtc->unpin_work = work;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
-	intel_fb = to_intel_framebuffer(fb);
-	obj = intel_fb->obj;
-
 	if (atomic_read(&intel_crtc->unpin_work_count) >= 2)
 		flush_workqueue(dev_priv->wq);
 
@@ -6313,6 +6309,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 cleanup_pending:
 	atomic_dec(&intel_crtc->unpin_work_count);
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	crtc->fb = old_fb;
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);
-- 
1.8.1.2

