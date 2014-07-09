Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaGINXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:23:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaGINXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:23:54 -0400
Message-ID: <53BD4265.2040508@canonical.com>
Date: Wed, 09 Jul 2014 15:23:49 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "airlied@linux.ie" <airlied@linux.ie>
CC: "thellstrom@vmware.com" <thellstrom@vmware.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "bskeggs@redhat.com" <bskeggs@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: [PATCH v2 09/17] drm/radeon: use common fence implementation for
 fences
References: <20140709093124.11354.3774.stgit@patser> <20140709122953.11354.46381.stgit@patser> <A3397C8B8B789E45844E7EC5DEAD89D04D5D246C@satlexdag05.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D04D5D246C@satlexdag05.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 09-07-14 14:57, Deucher, Alexander schreef:
>> <snip>
>> +static const char *radeon_fence_get_timeline_name(struct fence *f)
>> +{
>> +	struct radeon_fence *fence = to_radeon_fence(f);
>> +	switch (fence->ring) {
>> +	case RADEON_RING_TYPE_GFX_INDEX: return "radeon.gfx";
>> +	case CAYMAN_RING_TYPE_CP1_INDEX: return "radeon.cp1";
>> +	case CAYMAN_RING_TYPE_CP2_INDEX: return "radeon.cp2";
>> +	case R600_RING_TYPE_DMA_INDEX: return "radeon.dma";
>> +	case CAYMAN_RING_TYPE_DMA1_INDEX: return "radeon.dma1";
>> +	case R600_RING_TYPE_UVD_INDEX: return "radeon.uvd";
> Radeon supports vce rings on newer ascis.  Probably want to add the case for those here too.
>
> Alex
>
Indeed, how about this?
----------8<-------
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/radeon/radeon.h        |  15 +--
 drivers/gpu/drm/radeon/radeon_device.c |  60 ++++++++-
 drivers/gpu/drm/radeon/radeon_fence.c  | 225 +++++++++++++++++++++++++++------
 3 files changed, 250 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 29d9cc04c04e..03a5567f2c2f 100644
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
@@ -350,12 +348,15 @@ struct radeon_fence_driver {
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
@@ -2268,6 +2269,7 @@ struct radeon_device {
 	struct radeon_mman		mman;
 	struct radeon_fence_driver	fence_drv[RADEON_NUM_RINGS];
 	wait_queue_head_t		fence_queue;
+	unsigned			fence_context;
 	struct mutex			ring_lock;
 	struct radeon_ring		ring[RADEON_NUM_RINGS];
 	bool				ib_pool_ready;
@@ -2358,11 +2360,6 @@ u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 index);
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
index 03686fab842d..86699df7c8f3 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1213,6 +1213,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	for (i = 0; i < RADEON_NUM_RINGS; i++) {
 		rdev->ring[i].idx = i;
 	}
+	rdev->fence_context = fence_context_alloc(RADEON_NUM_RINGS);
 
 	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
 		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
@@ -1607,6 +1608,54 @@ int radeon_resume_kms(struct drm_device *dev, bool resume, bool fbcon)
 	return 0;
 }
 
+static uint32_t radeon_gpu_mask_sw_irq(struct radeon_device *rdev)
+{
+	uint32_t mask = 0;
+	int i;
+
+	if (!rdev->ddev->irq_enabled)
+		return mask;
+
+	/*
+	 * increase refcount on sw interrupts for all rings to stop
+	 * enabling interrupts in radeon_fence_enable_signaling during
+	 * gpu reset.
+	 */
+
+	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
+		if (!rdev->ring[i].ready)
+			continue;
+
+		atomic_inc(&rdev->irq.ring_int[i]);
+		mask |= 1 << i;
+	}
+	return mask;
+}
+
+static void radeon_gpu_unmask_sw_irq(struct radeon_device *rdev, uint32_t mask)
+{
+	unsigned long irqflags;
+	int i;
+
+	if (!mask)
+		return;
+
+	/*
+	 * undo refcount increase, and reset irqs to correct value.
+	 */
+
+	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
+		if (!(mask & (1 << i)))
+			continue;
+
+		atomic_dec(&rdev->irq.ring_int[i]);
+	}
+
+	spin_lock_irqsave(&rdev->irq.lock, irqflags);
+	radeon_irq_set(rdev);
+	spin_unlock_irqrestore(&rdev->irq.lock, irqflags);
+}
+
 /**
  * radeon_gpu_reset - reset the asic
  *
@@ -1624,6 +1673,7 @@ int radeon_gpu_reset(struct radeon_device *rdev)
 
 	int i, r;
 	int resched;
+	uint32_t sw_mask;
 
 	down_write(&rdev->exclusive_lock);
 
@@ -1637,6 +1687,7 @@ int radeon_gpu_reset(struct radeon_device *rdev)
 	radeon_save_bios_scratch_regs(rdev);
 	/* block TTM */
 	resched = ttm_bo_lock_delayed_workqueue(&rdev->mman.bdev);
+	sw_mask = radeon_gpu_mask_sw_irq(rdev);
 	radeon_pm_suspend(rdev);
 	radeon_suspend(rdev);
 
@@ -1686,13 +1737,20 @@ retry:
 	radeon_pm_resume(rdev);
 	drm_helper_resume_force_mode(rdev->ddev);
 
+	radeon_gpu_unmask_sw_irq(rdev, sw_mask);
 	ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
 	if (r) {
 		/* bad news, how to tell it to userspace ? */
 		dev_info(rdev->dev, "GPU reset failed\n");
 	}
 
-	up_write(&rdev->exclusive_lock);
+	/*
+	 * force all waiters to recheck, some may have been
+	 * added while the exclusive_lock was unavailable
+	 */
+	downgrade_write(&rdev->exclusive_lock);
+	wake_up_all(&rdev->fence_queue);
+	up_read(&rdev->exclusive_lock);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 6435719fd45b..763b7928026d 100644
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
@@ -111,30 +120,55 @@ int radeon_fence_emit(struct radeon_device *rdev,
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
 
 /**
- * radeon_fence_process - process a fence
+ * radeon_fence_check_signaled - callback from fence_queue
  *
- * @rdev: radeon_device pointer
- * @ring: ring index the fence is associated with
- *
- * Checks the current fence value and wakes the fence queue
- * if the sequence number has increased (all asics).
+ * this function is called with fence_queue lock held, which is also used
+ * for the fence locking itself, so unlocked variants are used for
+ * fence_signal, and remove_wait_queue.
  */
-void radeon_fence_process(struct radeon_device *rdev, int ring)
+static int radeon_fence_check_signaled(wait_queue_t *wait, unsigned mode, int flags, void *key)
+{
+	struct radeon_fence *fence;
+	u64 seq;
+
+	fence = container_of(wait, struct radeon_fence, fence_wake);
+
+	seq = atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq);
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
+static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
 {
 	uint64_t seq, last_seq, last_emitted;
 	unsigned count_loop = 0;
@@ -190,23 +224,22 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
 		}
 	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
 
-	if (wake)
-		wake_up_all(&rdev->fence_queue);
+	return wake;
 }
 
 /**
- * radeon_fence_destroy - destroy a fence
+ * radeon_fence_process - process a fence
  *
- * @kref: fence kref
+ * @rdev: radeon_device pointer
+ * @ring: ring index the fence is associated with
  *
- * Frees the fence object (all asics).
+ * Checks the current fence value and wakes the fence queue
+ * if the sequence number has increased (all asics).
  */
-static void radeon_fence_destroy(struct kref *kref)
+void radeon_fence_process(struct radeon_device *rdev, int ring)
 {
-	struct radeon_fence *fence;
-
-	fence = container_of(kref, struct radeon_fence, kref);
-	kfree(fence);
+	if (__radeon_fence_process(rdev, ring))
+		wake_up_all(&rdev->fence_queue);
 }
 
 /**
@@ -237,6 +270,69 @@ static bool radeon_fence_seq_signaled(struct radeon_device *rdev,
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
+	radeon_irq_kms_sw_irq_get(rdev, fence->ring);
+
+	if (down_read_trylock(&rdev->exclusive_lock)) {
+		if (__radeon_fence_process(rdev, fence->ring))
+			wake_up_all_locked(&rdev->fence_queue);
+
+		up_read(&rdev->exclusive_lock);
+	}
+
+	/* did fence get signaled after we enabled the sw irq? */
+	if (atomic64_read(&rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
+		radeon_irq_kms_sw_irq_put(rdev, fence->ring);
+		return false;
+	}
+
+	fence->fence_wake.flags = 0;
+	fence->fence_wake.private = NULL;
+	fence->fence_wake.func = radeon_fence_check_signaled;
+	__add_wait_queue(&rdev->fence_queue, &fence->fence_wake);
+	fence_get(f);
+
+	return true;
+}
+
 /**
  * radeon_fence_signaled - check if a fence has signaled
  *
@@ -250,11 +346,13 @@ bool radeon_fence_signaled(struct radeon_fence *fence)
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
@@ -413,21 +511,18 @@ int radeon_fence_wait(struct radeon_fence *fence, bool intr)
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
 
@@ -459,12 +554,13 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
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
@@ -545,7 +641,7 @@ int radeon_fence_wait_empty(struct radeon_device *rdev, int ring)
  */
 struct radeon_fence *radeon_fence_ref(struct radeon_fence *fence)
 {
-	kref_get(&fence->kref);
+	fence_get(&fence->base);
 	return fence;
 }
 
@@ -561,9 +657,8 @@ void radeon_fence_unref(struct radeon_fence **fence)
 	struct radeon_fence *tmp = *fence;
 
 	*fence = NULL;
-	if (tmp) {
-		kref_put(&tmp->kref, radeon_fence_destroy);
-	}
+	if (tmp)
+		fence_put(&tmp->base);
 }
 
 /**
@@ -872,3 +967,53 @@ int radeon_debugfs_fence_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+static long __radeon_fence_wait(struct fence *f, bool intr, long timeout)
+{
+	struct radeon_fence *fence = to_radeon_fence(f);
+	u64 target_seq[RADEON_NUM_RINGS] = {};
+	struct radeon_device *rdev = fence->rdev;
+	long r;
+
+	target_seq[fence->ring] = fence->seq;
+
+	down_read(&rdev->exclusive_lock);
+	r = radeon_fence_wait_seq_timeout(fence->rdev, target_seq, intr, timeout);
+
+	if (r > 0 && !fence_signal(&fence->base))
+		FENCE_TRACE(&fence->base, "signaled from __radeon_fence_wait\n");
+
+	up_read(&rdev->exclusive_lock);
+	return r;
+
+}
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
+static const struct fence_ops radeon_fence_ops = {
+	.get_driver_name = radeon_fence_get_driver_name,
+	.get_timeline_name = radeon_fence_get_timeline_name,
+	.enable_signaling = radeon_fence_enable_signaling,
+	.signaled = __radeon_fence_signaled,
+	.wait = __radeon_fence_wait,
+	.release = NULL,
+};
-- 
2.0.0


