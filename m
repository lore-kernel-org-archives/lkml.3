Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab3DBWu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397Ab3DBWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>
Subject: [ 34/56] drm/i915: dont set unpin_work if vblank_get fails
Date: Tue,  2 Apr 2013 15:50:01 -0700
Message-Id: <20130402224715.834353077@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 7317c75e66fce0c9f82fbe6f72f7e5256b315422 upstream.

This fixes a race where we may try to finish a page flip and decrement
the refcount even if our vblank_get failed and we ended up with a
spurious flip pending interrupt.

Fixes https://bugs.freedesktop.org/show_bug.cgi?id=34211.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6524,11 +6524,16 @@ static int intel_crtc_page_flip(struct d
 	work->old_fb_obj = intel_fb->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
 
+	ret = drm_vblank_get(dev, intel_crtc->pipe);
+	if (ret)
+		goto free_work;
+
 	/* We borrow the event spin lock for protecting unpin_work */
 	spin_lock_irqsave(&dev->event_lock, flags);
 	if (intel_crtc->unpin_work) {
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		kfree(work);
+		drm_vblank_put(dev, intel_crtc->pipe);
 
 		DRM_DEBUG_DRIVER("flip queue: crtc already busy\n");
 		return -EBUSY;
@@ -6547,10 +6552,6 @@ static int intel_crtc_page_flip(struct d
 
 	crtc->fb = fb;
 
-	ret = drm_vblank_get(dev, intel_crtc->pipe);
-	if (ret)
-		goto cleanup_objs;
-
 	work->pending_flip_obj = obj;
 
 	work->enable_stall_check = true;
@@ -6572,7 +6573,6 @@ static int intel_crtc_page_flip(struct d
 
 cleanup_pending:
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
-cleanup_objs:
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);
@@ -6581,6 +6581,8 @@ cleanup_objs:
 	intel_crtc->unpin_work = NULL;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
+	drm_vblank_put(dev, intel_crtc->pipe);
+free_work:
 	kfree(work);
 
 	return ret;


