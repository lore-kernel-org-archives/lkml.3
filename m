Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3APQCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3APQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 082/222] drm/i915: Close race between processing unpin task and queueing the flip
Date: Wed, 16 Jan 2013 13:54:42 -0200
Message-Id: <1358351822-7675-83-git-send-email-herton.krzesinski@canonical.com>
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

commit e7d841ca03b7ab668620045cd7b428eda9f41601 upstream.

Before queuing the flip but crucially after attaching the unpin-work to
the crtc, we continue to setup the unpin-work. However, should the
hardware fire early, we see the connected unpin-work and queue the task.
The task then promptly runs and unpins the fb before we finish taking
the required references or even pinning it... Havoc.

To close the race, we use the flip-pending atomic to indicate when the
flip is finally setup and enqueued. So during the flip-done processing,
we can check more accurately whether the flip was expected.

v2: Add the appropriate mb() to ensure that the writes to the page-flip
worker are complete prior to marking it active and emitting the MI_FLIP.
On the read side, the mb should be enforced by the spinlocks.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Review the barriers a bit, we need a write barrier both
before and after updating ->pending. Similarly we need a read barrier
in the interrupt handler both before and after reading ->pending. With
well-ordered irqs only one barrier in each place should be required,
but since this patch explicitly sets out to combat spurious interrupts
with is staged activation of the unpin work we need to go full-bore on
the barriers, too. Discussed with Chris Wilson on irc and changes
acked by him.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c  |    4 ++--
 drivers/gpu/drm/i915/i915_irq.c      |    4 +++-
 drivers/gpu/drm/i915/intel_display.c |   39 ++++++++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_drv.h     |    5 ++++-
 4 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 5363e9c..e4e6ba7 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -324,7 +324,7 @@ static int i915_gem_pageflip_info(struct seq_file *m, void *data)
 			seq_printf(m, "No flip due on pipe %c (plane %c)\n",
 				   pipe, plane);
 		} else {
-			if (!work->pending) {
+			if (atomic_read(&work->pending) < INTEL_FLIP_COMPLETE) {
 				seq_printf(m, "Flip queued on pipe %c (plane %c)\n",
 					   pipe, plane);
 			} else {
@@ -335,7 +335,7 @@ static int i915_gem_pageflip_info(struct seq_file *m, void *data)
 				seq_printf(m, "Stall check enabled, ");
 			else
 				seq_printf(m, "Stall check waiting for page flip ioctl, ");
-			seq_printf(m, "%d prepares\n", work->pending);
+			seq_printf(m, "%d prepares\n", atomic_read(&work->pending));
 
 			if (work->old_fb_obj) {
 				struct drm_i915_gem_object *obj = work->old_fb_obj;
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 972a32f..8d54d38 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1336,7 +1336,9 @@ static void i915_pageflip_stall_check(struct drm_device *dev, int pipe)
 	spin_lock_irqsave(&dev->event_lock, flags);
 	work = intel_crtc->unpin_work;
 
-	if (work == NULL || work->pending || !work->enable_stall_check) {
+	if (work == NULL ||
+	    atomic_read(&work->pending) >= INTEL_FLIP_COMPLETE ||
+	    !work->enable_stall_check) {
 		/* Either the pending flip IRQ arrived, or we're too early. Don't check */
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		return;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f320aaf..c69444a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5906,11 +5906,18 @@ static void do_intel_finish_page_flip(struct drm_device *dev,
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 	work = intel_crtc->unpin_work;
-	if (work == NULL || !work->pending) {
+
+	/* Ensure we don't miss a work->pending update ... */
+	smp_rmb();
+
+	if (work == NULL || atomic_read(&work->pending) < INTEL_FLIP_COMPLETE) {
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		return;
 	}
 
+	/* and that the unpin work is consistent wrt ->pending. */
+	smp_rmb();
+
 	intel_crtc->unpin_work = NULL;
 
 	if (work->event) {
@@ -5982,16 +5989,25 @@ void intel_prepare_page_flip(struct drm_device *dev, int plane)
 		to_intel_crtc(dev_priv->plane_to_crtc_mapping[plane]);
 	unsigned long flags;
 
+	/* NB: An MMIO update of the plane base pointer will also
+	 * generate a page-flip completion irq, i.e. every modeset
+	 * is also accompanied by a spurious intel_prepare_page_flip().
+	 */
 	spin_lock_irqsave(&dev->event_lock, flags);
-	if (intel_crtc->unpin_work) {
-		if ((++intel_crtc->unpin_work->pending) > 1)
-			DRM_ERROR("Prepared flip multiple times\n");
-	} else {
-		DRM_DEBUG_DRIVER("preparing flip with no unpin work?\n");
-	}
+	if (intel_crtc->unpin_work)
+		atomic_inc_not_zero(&intel_crtc->unpin_work->pending);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 }
 
+inline static void intel_mark_page_flip_active(struct intel_crtc *intel_crtc)
+{
+	/* Ensure that the work item is consistent when activating it ... */
+	smp_wmb();
+	atomic_set(&intel_crtc->unpin_work->pending, INTEL_FLIP_PENDING);
+	/* and that it is marked active as soon as the irq could fire. */
+	smp_wmb();
+}
+
 static int intel_gen2_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
@@ -6029,6 +6045,8 @@ static int intel_gen2_queue_flip(struct drm_device *dev,
 	intel_ring_emit(ring, fb->pitches[0]);
 	intel_ring_emit(ring, obj->gtt_offset + offset);
 	intel_ring_emit(ring, 0); /* aux display base address, unused */
+
+	intel_mark_page_flip_active(intel_crtc);
 	intel_ring_advance(ring);
 	return 0;
 
@@ -6073,6 +6091,7 @@ static int intel_gen3_queue_flip(struct drm_device *dev,
 	intel_ring_emit(ring, obj->gtt_offset + offset);
 	intel_ring_emit(ring, MI_NOOP);
 
+	intel_mark_page_flip_active(intel_crtc);
 	intel_ring_advance(ring);
 	return 0;
 
@@ -6117,6 +6136,8 @@ static int intel_gen4_queue_flip(struct drm_device *dev,
 	pf = 0;
 	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	intel_ring_emit(ring, pf | pipesrc);
+
+	intel_mark_page_flip_active(intel_crtc);
 	intel_ring_advance(ring);
 	return 0;
 
@@ -6159,6 +6180,8 @@ static int intel_gen6_queue_flip(struct drm_device *dev,
 	pf = 0;
 	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	intel_ring_emit(ring, pf | pipesrc);
+
+	intel_mark_page_flip_active(intel_crtc);
 	intel_ring_advance(ring);
 	return 0;
 
@@ -6213,6 +6236,8 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
 	intel_ring_emit(ring, (fb->pitches[0] | obj->tiling_mode));
 	intel_ring_emit(ring, (obj->gtt_offset));
 	intel_ring_emit(ring, (MI_NOOP));
+
+	intel_mark_page_flip_active(intel_crtc);
 	intel_ring_advance(ring);
 	return 0;
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 9040191..8fa11cb 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -323,7 +323,10 @@ struct intel_unpin_work {
 	struct drm_i915_gem_object *old_fb_obj;
 	struct drm_i915_gem_object *pending_flip_obj;
 	struct drm_pending_vblank_event *event;
-	int pending;
+	atomic_t pending;
+#define INTEL_FLIP_INACTIVE	0
+#define INTEL_FLIP_PENDING	1
+#define INTEL_FLIP_COMPLETE	2
 	bool enable_stall_check;
 };
 
-- 
1.7.9.5

