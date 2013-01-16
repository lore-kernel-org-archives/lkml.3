Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3APQIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3APQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 164/222] drm/i915: Flush outstanding unpin tasks before pageflipping
Date: Wed, 16 Jan 2013 13:56:04 -0200
Message-Id: <1358351822-7675-165-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

If we accumulate unpin tasks because we are pageflipping faster than the
system can schedule its workers, we can effectively create a
pin-leak. The solution taken here is to limit the number of unpin tasks
we have per-crtc and to flush those outstanding tasks if we accumulate
too many. This should prevent any jitter in the normal case, and also
prevent the hang if we should run too fast.

Note: It is important that we switch from the system workqueue to our
own dev_priv->wq since all work items on that queue are guaranteed to
only need the dev->struct_mutex and not any modeset resources. For
otherwise if we have a work item ahead in the queue which needs the
modeset lock (like the output detect work used by both polling or
hpd), this work and so the unpin work will never execute since the
pageflip code already holds that lock. Unfortunately there's no
lockdep support for this scenario in the workqueue code.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=46991
Reported-and-tested-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Added note about workqueu deadlock.]
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=56337
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=58732
Tested-by: Daniel Gnoutcheff <daniel@gnoutcheff.name>
[dg: Adjusted context, removed a whitespace change]
BugLink: http://bugs.launchpad.net/bugs/1094173
[ herton: drop whitespace change, maintain original diff ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |   22 ++++++++++++++++------
 drivers/gpu/drm/i915/intel_drv.h     |    4 +++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index fb20654..5cd6449 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5842,14 +5842,19 @@ static void intel_unpin_work_fn(struct work_struct *__work)
 {
 	struct intel_unpin_work *work =
 		container_of(__work, struct intel_unpin_work, work);
+	struct drm_device *dev = work->crtc->dev;
 
-	mutex_lock(&work->dev->struct_mutex);
+	mutex_lock(&dev->struct_mutex);
 	intel_unpin_fb_obj(work->old_fb_obj);
 	drm_gem_object_unreference(&work->pending_flip_obj->base);
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 
-	intel_update_fbc(work->dev);
-	mutex_unlock(&work->dev->struct_mutex);
+	intel_update_fbc(dev);
+	mutex_unlock(&dev->struct_mutex);
+
+	BUG_ON(atomic_read(&to_intel_crtc(work->crtc)->unpin_work_count) == 0);
+	atomic_dec(&to_intel_crtc(work->crtc)->unpin_work_count);
+
 	kfree(work);
 }
 
@@ -5925,9 +5930,9 @@ static void do_intel_finish_page_flip(struct drm_device *dev,
 
 	atomic_clear_mask(1 << intel_crtc->plane,
 			  &obj->pending_flip.counter);
-
 	wake_up(&dev_priv->pending_flip_queue);
-	schedule_work(&work->work);
+
+	queue_work(dev_priv->wq, &work->work);
 
 	trace_i915_flip_complete(intel_crtc->plane, work->pending_flip_obj);
 }
@@ -6239,7 +6244,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 		return -ENOMEM;
 
 	work->event = event;
-	work->dev = crtc->dev;
+	work->crtc = crtc;
 	intel_fb = to_intel_framebuffer(crtc->fb);
 	work->old_fb_obj = intel_fb->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
@@ -6264,6 +6269,9 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	intel_fb = to_intel_framebuffer(fb);
 	obj = intel_fb->obj;
 
+	if (atomic_read(&intel_crtc->unpin_work_count) >= 2)
+		flush_workqueue(dev_priv->wq);
+
 	mutex_lock(&dev->struct_mutex);
 
 	/* Reference the objects for the scheduled work. */
@@ -6280,6 +6288,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	 * the flip occurs and the object is no longer visible.
 	 */
 	atomic_add(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	atomic_inc(&intel_crtc->unpin_work_count);
 
 	ret = dev_priv->display.queue_flip(dev, crtc, fb, obj);
 	if (ret)
@@ -6294,6 +6303,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	return 0;
 
 cleanup_pending:
+	atomic_dec(&intel_crtc->unpin_work_count);
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 8fa11cb..873847f 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -176,6 +176,8 @@ struct intel_crtc {
 	struct intel_unpin_work *unpin_work;
 	int fdi_lanes;
 
+	atomic_t unpin_work_count;
+
 	struct drm_i915_gem_object *cursor_bo;
 	uint32_t cursor_addr;
 	int16_t cursor_x, cursor_y;
@@ -319,7 +321,7 @@ intel_get_crtc_for_plane(struct drm_device *dev, int plane)
 
 struct intel_unpin_work {
 	struct work_struct work;
-	struct drm_device *dev;
+	struct drm_crtc *crtc;
 	struct drm_i915_gem_object *old_fb_obj;
 	struct drm_i915_gem_object *pending_flip_obj;
 	struct drm_pending_vblank_event *event;
-- 
1.7.9.5

