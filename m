Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaGaPeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56890 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaGaPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:04 -0400
Subject: [PATCH 11/19] drm/radeon: use common fence implementation for fences,
 v2
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:33:55 +0200
Message-ID: <20140731153355.15061.3119.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- Kill the sw interrupt dance, add and use
  radeon_irq_kms_sw_irq_get_delayed instead.
- Change custom wait function, lockdep complained about it.
  Holding exclusive_lock in the wait function might cause deadlocks.
  Instead do all the processing in .enable_signaling, and wait
  on the global fence_queue to pick up gpu resets.
- Process all fences in radeon_gpu_reset after reset to close a race
  with the trylock in enable_signaling.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/radeon/radeon.h         |   18 +-
 drivers/gpu/drm/radeon/radeon_device.c  |   22 ++-
 drivers/gpu/drm/radeon/radeon_fence.c   |  263 +++++++++++++++++++++++++++----
 drivers/gpu/drm/radeon/radeon_irq_kms.c |   43 +++++
 4 files changed, 293 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index b01d88fc10cb..599bb28e4104 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -64,6 +64,7 @@
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/fence.h>
 
 #include <ttm/ttm_bo_api.h>
 #include <ttm/ttm_bo_driver.h>
@@ -116,9 +117,6 @@ extern int radeon_deep_color;
 #define RADEONFB_CONN_LIMIT			4
 #define RADEON_BIOS_NUM_SCRATCH			8
 
-/* fence seq are set to this number when signaled */
-#define RADEON_FENCE_SIGNALED_SEQ		0LL
-
 /* internal ring indices */
 /* r1xx+ has gfx CP ring */
 #define RADEON_RING_TYPE_GFX_INDEX		0
@@ -352,12 +350,15 @@ struct radeon_fence_driver {
 };
 
 struct radeon_fence {
+	struct fence base;
+
 	struct radeon_device		*rdev;
-	struct kref			kref;
 	/* protected by radeon_fence.lock */
 	uint64_t			seq;
 	/* RB, DMA, etc. */
 	unsigned			ring;
+
+	wait_queue_t fence_wake;
 };
 
 int radeon_fence_driver_start_ring(struct radeon_device *rdev, int ring);
@@ -769,6 +770,7 @@ struct radeon_irq {
 int radeon_irq_kms_init(struct radeon_device *rdev);
 void radeon_irq_kms_fini(struct radeon_device *rdev);
 void radeon_irq_kms_sw_irq_get(struct radeon_device *rdev, int ring);
+void radeon_irq_kms_sw_irq_get_delayed(struct radeon_device *rdev, int ring);
 void radeon_irq_kms_sw_irq_put(struct radeon_device *rdev, int ring);
 void radeon_irq_kms_pflip_irq_get(struct radeon_device *rdev, int crtc);
 void radeon_irq_kms_pflip_irq_put(struct radeon_device *rdev, int crtc);
@@ -2276,6 +2278,7 @@ struct radeon_device {
 	struct radeon_mman		mman;
 	struct radeon_fence_driver	fence_drv[RADEON_NUM_RINGS];
 	wait_queue_head_t		fence_queue;
+	unsigned			fence_context;
 	struct mutex			ring_lock;
 	struct radeon_ring		ring[RADEON_NUM_RINGS];
 	bool				ib_pool_ready;
@@ -2314,6 +2317,8 @@ struct radeon_device {
 	struct work_struct hotplug_work;
 	struct work_struct audio_work;
 	struct work_struct reset_work;
+	struct work_struct delayed_irq_work;
+
 	int num_crtc; /* number of crtcs */
 	struct mutex dc_hw_i2c_mutex; /* display controller hw i2c mutex */
 	bool has_uvd;
@@ -2366,11 +2371,6 @@ u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 index);
 void cik_mm_wdoorbell(struct radeon_device *rdev, u32 index, u32 v);
 
 /*
- * Cast helper
- */
-#define to_radeon_fence(p) ((struct radeon_fence *)(p))
-
-/*
  * Registers read & write functions.
  */
 #define RREG8(reg) readb((rdev->rmmio) + (reg))
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 21efd32d07ee..dbf3a8bc91d2 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1213,6 +1213,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	for (i = 0; i < RADEON_NUM_RINGS; i++) {
 		rdev->ring[i].idx = i;
 	}
+	rdev->fence_context = fence_context_alloc(RADEON_NUM_RINGS);
 
 	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
 		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
@@ -1622,15 +1623,13 @@ int radeon_gpu_reset(struct radeon_device *rdev)
 
 	bool saved = false;
 
-	int i, r;
+	int i, r = 0;
 	int resched;
 
 	down_write(&rdev->exclusive_lock);
 
-	if (!rdev->needs_reset) {
-		up_write(&rdev->exclusive_lock);
-		return 0;
-	}
+	if (!rdev->needs_reset)
+		goto out;
 
 	rdev->needs_reset = false;
 
@@ -1697,7 +1696,18 @@ retry:
 		dev_info(rdev->dev, "GPU reset failed\n");
 	}
 
-	up_write(&rdev->exclusive_lock);
+out:
+	/*
+	 * force all waiters to recheck, some may have been
+	 * added while the exclusive_lock was unavailable
+	 */
+	downgrade_write(&rdev->exclusive_lock);
+	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
+		if (rdev->ring[i].ready)
+			radeon_fence_process(rdev, i);
+	}
+	wake_up_all(&rdev->fence_queue);
+	up_read(&rdev->exclusive_lock);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index f79e0b34582b..8ca56ca70503 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -39,6 +39,15 @@
 #include "radeon.h"
 #include "radeon_trace.h"
 
+static const struct fence_ops radeon_fence_ops;
+
+#define to_radeon_fence(p) \
+	({								\
+		struct radeon_fence *__f;				\
+		__f = container_of((p), struct radeon_fence, base);	\
+		__f->base.ops == &radeon_fence_ops ? __f : NULL;	\
+	})
+
 /*
  * Fences
  * Fences mark an event in the GPUs pipeline and are used
@@ -111,20 +120,82 @@ int radeon_fence_emit(struct radeon_device *rdev,
 		      struct radeon_fence **fence,
 		      int ring)
 {
+	u64 seq = ++rdev->fence_drv[ring].sync_seq[ring];
+
 	/* we are protected by the ring emission mutex */
 	*fence = kmalloc(sizeof(struct radeon_fence), GFP_KERNEL);
 	if ((*fence) == NULL) {
 		return -ENOMEM;
 	}
-	kref_init(&((*fence)->kref));
-	(*fence)->rdev = rdev;
-	(*fence)->seq = ++rdev->fence_drv[ring].sync_seq[ring];
 	(*fence)->ring = ring;
+	fence_init(&(*fence)->base, &radeon_fence_ops,
+		   &rdev->fence_queue.lock, rdev->fence_context + ring, seq);
+	(*fence)->rdev = rdev;
+	(*fence)->seq = seq;
 	radeon_fence_ring_emit(rdev, ring, *fence);
 	trace_radeon_fence_emit(rdev->ddev, ring, (*fence)->seq);
 	return 0;
 }
 
+/**
+ * __radeon_fence_read_seq - Returns the current fence value without updating
+ *
+ * @rdev: radeon_device pointer
+ * @ring: ring index to return the seqno of
+ */
+static uint64_t __radeon_fence_read_seq(struct radeon_device *rdev, int ring)
+{
+	uint64_t last_seq = atomic64_read(&rdev->fence_drv[ring].last_seq);
+	uint64_t last_emitted = rdev->fence_drv[ring].sync_seq[ring];
+	uint64_t seq = radeon_fence_read(rdev, ring);
+
+	seq = radeon_fence_read(rdev, ring);
+	seq |= last_seq & 0xffffffff00000000LL;
+	if (seq < last_seq) {
+		seq &= 0xffffffff;
+		seq |= last_emitted & 0xffffffff00000000LL;
+	}
+	return seq;
+}
+
+/**
+ * radeon_fence_check_signaled - callback from fence_queue
+ *
+ * this function is called with fence_queue lock held, which is also used
+ * for the fence locking itself, so unlocked variants are used for
+ * fence_signal, and remove_wait_queue.
+ */
+static int radeon_fence_check_signaled(wait_queue_t *wait, unsigned mode, int flags, void *key)
+{
+	struct radeon_fence *fence;
+	u64 seq;
+
+	fence = container_of(wait, struct radeon_fence, fence_wake);
+
+	/*
+	 * We cannot use radeon_fence_process here because we're already
+	 * in the waitqueue, in a call from wake_up_all.
+	 *
+	 * Because the current ring might not have been updated, call
+	 * __radeon_fence_read_seq here to check without updating.
+	 */
+	seq = __radeon_fence_read_seq(fence->rdev, fence->ring);
+	if (seq >= fence->seq) {
+		int ret = fence_signal_locked(&fence->base);
+
+		if (!ret)
+			FENCE_TRACE(&fence->base, "signaled from irq context\n");
+		else
+			FENCE_TRACE(&fence->base, "was already signaled\n");
+
+		radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
+		__remove_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
+		fence_put(&fence->base);
+	} else
+		FENCE_TRACE(&fence->base, "pending\n");
+	return 0;
+}
+
 static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
 {
 	uint64_t seq, last_seq, last_emitted;
@@ -230,21 +301,6 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
 }
 
 /**
- * radeon_fence_destroy - destroy a fence
- *
- * @kref: fence kref
- *
- * Frees the fence object (all asics).
- */
-static void radeon_fence_destroy(struct kref *kref)
-{
-	struct radeon_fence *fence;
-
-	fence = container_of(kref, struct radeon_fence, kref);
-	kfree(fence);
-}
-
-/**
  * radeon_fence_seq_signaled - check if a fence sequence number has signaled
  *
  * @rdev: radeon device pointer
@@ -272,6 +328,73 @@ static bool radeon_fence_seq_signaled(struct radeon_device *rdev,
 	return false;
 }
 
+static bool __radeon_fence_signaled(struct fence *f)
+{
+	struct radeon_fence *fence = to_radeon_fence(f);
+	struct radeon_device *rdev = fence->rdev;
+	unsigned ring = fence->ring;
+	u64 seq = fence->seq;
+
+	if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq) {
+		return true;
+	}
+
+	if (down_read_trylock(&rdev->exclusive_lock)) {
+		radeon_fence_process(rdev, ring);
+		up_read(&rdev->exclusive_lock);
+
+		if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq) {
+			return true;
+		}
+	}
+	return false;
+}
+
+/**
+ * radeon_fence_enable_signaling - enable signalling on fence
+ * @fence: fence
+ *
+ * This function is called with fence_queue lock held, and adds a callback
+ * to fence_queue that checks if this fence is signaled, and if so it
+ * signals the fence and removes itself.
+ */
+static bool radeon_fence_enable_signaling(struct fence *f)
+{
+	struct radeon_fence *fence = to_radeon_fence(f);
+	struct radeon_device *rdev = fence->rdev;
+
+	if (atomic64_read(&rdev->fence_drv[fence->ring].last_seq) >= fence->seq ||
+	    !rdev->ddev->irq_enabled)
+		return false;
+
+	if (down_read_trylock(&rdev->exclusive_lock)) {
+		radeon_irq_kms_sw_irq_get(rdev, fence->ring);
+
+		if (__radeon_fence_process(rdev, fence->ring))
+			wake_up_all_locked(&rdev->fence_queue);
+
+		/* did fence get signaled after we enabled the sw irq? */
+		if (atomic64_read(&rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
+			radeon_irq_kms_sw_irq_put(rdev, fence->ring);
+			up_read(&rdev->exclusive_lock);
+			return false;
+		}
+
+		up_read(&rdev->exclusive_lock);
+	} else
+		/* we're probably in a lockup, lets not fiddle too much */
+		radeon_irq_kms_sw_irq_get_delayed(rdev, fence->ring);
+
+	fence->fence_wake.flags = 0;
+	fence->fence_wake.private = NULL;
+	fence->fence_wake.func = radeon_fence_check_signaled;
+	__add_wait_queue(&rdev->fence_queue, &fence->fence_wake);
+	fence_get(f);
+
+	FENCE_TRACE(&fence->base, "armed on ring %i!\n", fence->ring);
+	return true;
+}
+
 /**
  * radeon_fence_signaled - check if a fence has signaled
  *
@@ -285,11 +408,13 @@ bool radeon_fence_signaled(struct radeon_fence *fence)
 	if (!fence) {
 		return true;
 	}
-	if (fence->seq == RADEON_FENCE_SIGNALED_SEQ) {
-		return true;
-	}
+
 	if (radeon_fence_seq_signaled(fence->rdev, fence->seq, fence->ring)) {
-		fence->seq = RADEON_FENCE_SIGNALED_SEQ;
+		int ret;
+
+		ret = fence_signal(&fence->base);
+		if (!ret)
+			FENCE_TRACE(&fence->base, "signaled from radeon_fence_signaled\n");
 		return true;
 	}
 	return false;
@@ -400,21 +525,18 @@ int radeon_fence_wait(struct radeon_fence *fence, bool intr)
 	uint64_t seq[RADEON_NUM_RINGS] = {};
 	long r;
 
-	if (fence == NULL) {
-		WARN(1, "Querying an invalid fence : %p !\n", fence);
-		return -EINVAL;
-	}
-
-	seq[fence->ring] = fence->seq;
-	if (seq[fence->ring] == RADEON_FENCE_SIGNALED_SEQ)
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))
 		return 0;
 
+	seq[fence->ring] = fence->seq;
 	r = radeon_fence_wait_seq_timeout(fence->rdev, seq, intr, MAX_SCHEDULE_TIMEOUT);
 	if (r < 0) {
 		return r;
 	}
 
-	fence->seq = RADEON_FENCE_SIGNALED_SEQ;
+	r = fence_signal(&fence->base);
+	if (!r)
+		FENCE_TRACE(&fence->base, "signaled from fence_wait\n");
 	return 0;
 }
 
@@ -446,12 +568,13 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
 			continue;
 		}
 
+		if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fences[i]->base.flags)) {
+			/* already signaled */
+			return 0;
+		}
+
 		seq[i] = fences[i]->seq;
 		++num_rings;
-
-		/* test if something was allready signaled */
-		if (seq[i] == RADEON_FENCE_SIGNALED_SEQ)
-			return 0;
 	}
 
 	/* nothing to wait for ? */
@@ -532,7 +655,7 @@ int radeon_fence_wait_empty(struct radeon_device *rdev, int ring)
  */
 struct radeon_fence *radeon_fence_ref(struct radeon_fence *fence)
 {
-	kref_get(&fence->kref);
+	fence_get(&fence->base);
 	return fence;
 }
 
@@ -548,9 +671,8 @@ void radeon_fence_unref(struct radeon_fence **fence)
 	struct radeon_fence *tmp = *fence;
 
 	*fence = NULL;
-	if (tmp) {
-		kref_put(&tmp->kref, radeon_fence_destroy);
-	}
+	if (tmp)
+		fence_put(&tmp->base);
 }
 
 /**
@@ -855,6 +977,7 @@ static int radeon_debugfs_gpu_reset(struct seq_file *m, void *data)
 	down_read(&rdev->exclusive_lock);
 	seq_printf(m, "%d\n", rdev->needs_reset);
 	rdev->needs_reset = true;
+	wake_up_all(&rdev->fence_queue);
 	up_read(&rdev->exclusive_lock);
 
 	return 0;
@@ -874,3 +997,67 @@ int radeon_debugfs_fence_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+static const char *radeon_fence_get_driver_name(struct fence *fence)
+{
+	return "radeon";
+}
+
+static const char *radeon_fence_get_timeline_name(struct fence *f)
+{
+	struct radeon_fence *fence = to_radeon_fence(f);
+	switch (fence->ring) {
+	case RADEON_RING_TYPE_GFX_INDEX: return "radeon.gfx";
+	case CAYMAN_RING_TYPE_CP1_INDEX: return "radeon.cp1";
+	case CAYMAN_RING_TYPE_CP2_INDEX: return "radeon.cp2";
+	case R600_RING_TYPE_DMA_INDEX: return "radeon.dma";
+	case CAYMAN_RING_TYPE_DMA1_INDEX: return "radeon.dma1";
+	case R600_RING_TYPE_UVD_INDEX: return "radeon.uvd";
+	case TN_RING_TYPE_VCE1_INDEX: return "radeon.vce1";
+	case TN_RING_TYPE_VCE2_INDEX: return "radeon.vce2";
+	default: WARN_ON_ONCE(1); return "radeon.unk";
+	}
+}
+
+static signed long __radeon_fence_default_wait(struct fence *f, bool intr,
+					       signed long timeout)
+{
+	struct radeon_fence *fence = to_radeon_fence(f);
+	struct radeon_device *rdev = fence->rdev;
+	bool signaled;
+
+	fence_enable_sw_signaling(&fence->base);
+
+	/*
+	 * This function has to return -EDEADLK, but cannot hold
+	 * exclusive_lock during the wait because some callers
+	 * may already hold it. This means checking needs_reset without
+	 * lock, and not fiddling with any gpu internals.
+	 *
+	 * The callback installed with fence_enable_sw_signaling will
+	 * run before our wait_event_*timeout call, so we will see
+	 * both the signaled fence and the changes to needs_reset.
+	 */
+
+	if (intr)
+		timeout = wait_event_interruptible_timeout(rdev->fence_queue,
+							   ((signaled = (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))) || rdev->needs_reset),
+							   timeout);
+	else
+		timeout = wait_event_timeout(rdev->fence_queue,
+					     ((signaled = (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))) || rdev->needs_reset),
+					     timeout);
+
+	if (timeout > 0 && !signaled)
+		return -EDEADLK;
+	return timeout;
+}
+
+static const struct fence_ops radeon_fence_ops = {
+	.get_driver_name = radeon_fence_get_driver_name,
+	.get_timeline_name = radeon_fence_get_timeline_name,
+	.enable_signaling = radeon_fence_enable_signaling,
+	.signaled = __radeon_fence_signaled,
+	.wait = __radeon_fence_default_wait,
+	.release = NULL,
+};
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 16807afab362..41310cec61a6 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -254,6 +254,25 @@ static bool radeon_msi_ok(struct radeon_device *rdev)
 	return true;
 }
 
+static void radeon_delayed_irq_set(struct work_struct *work)
+{
+	struct radeon_device *rdev;
+	unsigned long irqflags;
+
+	rdev = container_of(work, struct radeon_device, delayed_irq_work);
+
+	down_read(&rdev->exclusive_lock);
+
+	spin_lock_irqsave(&rdev->irq.lock, irqflags);
+	radeon_irq_set(rdev);
+	spin_unlock_irqrestore(&rdev->irq.lock, irqflags);
+
+	/* force all waiters to recheck */
+	wake_up_all(&rdev->fence_queue);
+
+	up_read(&rdev->exclusive_lock);
+}
+
 /**
  * radeon_irq_kms_init - init driver interrupt info
  *
@@ -285,6 +304,7 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
 	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
 	INIT_WORK(&rdev->reset_work, radeon_irq_reset_work_func);
+	INIT_WORK(&rdev->delayed_irq_work, radeon_delayed_irq_set);
 
 	rdev->irq.installed = true;
 	r = drm_irq_install(rdev->ddev, rdev->ddev->pdev->irq);
@@ -313,6 +333,7 @@ void radeon_irq_kms_fini(struct radeon_device *rdev)
 		rdev->irq.installed = false;
 		if (rdev->msi_enabled)
 			pci_disable_msi(rdev->pdev);
+		cancel_work_sync(&rdev->delayed_irq_work);
 		flush_work(&rdev->hotplug_work);
 	}
 }
@@ -342,6 +363,28 @@ void radeon_irq_kms_sw_irq_get(struct radeon_device *rdev, int ring)
 }
 
 /**
+ * radeon_irq_kms_sw_irq_get_delayed - enable software interrupt
+ *
+ * @rdev: radeon device pointer
+ * @ring: ring whose interrupt you want to enable
+ *
+ * Enables the software interrupt for a specific ring (all asics).
+ * The software interrupt is generally used to signal a fence on
+ * a particular ring.
+ *
+ * This function can be used without exclusive_lock grabbed,
+ * and will schedule later work for irqs to be set when needed.
+ */
+void radeon_irq_kms_sw_irq_get_delayed(struct radeon_device *rdev, int ring)
+{
+	if (!rdev->ddev->irq_enabled)
+		return;
+
+	if (atomic_inc_return(&rdev->irq.ring_int[ring]) == 1)
+		schedule_work(&rdev->delayed_irq_work);
+}
+
+/**
  * radeon_irq_kms_sw_irq_put - disable software interrupt
  *
  * @rdev: radeon device pointer

