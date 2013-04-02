Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab3DBW5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:57:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab3DBWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 35/56] drm/i915: Dont clobber crtc->fb when queue_flip fails
Date: Tue,  2 Apr 2013 15:50:02 -0700
Message-Id: <20130402224715.932384945@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 4a35f83b2b7c6aae3fc0d1c4554fdc99dc33ad07 upstream.

Restore crtc->fb to the old framebuffer if queue_flip fails.

While at it, kill the pointless intel_fb temp variable.

v2: Update crtc->fb before queue_flip and restore it back
    after a failure.

[Backported for 3.0-stable. Adjusted context. Please
cherry-pick commit 7317c75e66fce0c9f82fbe6f72f7e5256b315422
upstream before this patch as it provides necessary context
and fixes a panic.]

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-Tested-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6507,8 +6507,8 @@ static int intel_crtc_page_flip(struct d
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
@@ -6520,8 +6520,7 @@ static int intel_crtc_page_flip(struct d
 
 	work->event = event;
 	work->dev = crtc->dev;
-	intel_fb = to_intel_framebuffer(crtc->fb);
-	work->old_fb_obj = intel_fb->obj;
+	work->old_fb_obj = to_intel_framebuffer(old_fb)->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
 
 	ret = drm_vblank_get(dev, intel_crtc->pipe);
@@ -6541,9 +6540,6 @@ static int intel_crtc_page_flip(struct d
 	intel_crtc->unpin_work = work;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
-	intel_fb = to_intel_framebuffer(fb);
-	obj = intel_fb->obj;
-
 	mutex_lock(&dev->struct_mutex);
 
 	/* Reference the objects for the scheduled work. */
@@ -6573,6 +6569,7 @@ static int intel_crtc_page_flip(struct d
 
 cleanup_pending:
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	crtc->fb = old_fb;
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);


