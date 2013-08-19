Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3HSKRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:17:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3HSKRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:17:42 -0400
Message-ID: <5211F0C5.2040705@canonical.com>
Date: Mon, 19 Aug 2013 12:17:41 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [RFC PATCH] drm/radeon: rework to new fence interface
References: <20130815124308.14812.58197.stgit@patser>
In-Reply-To: <20130815124308.14812.58197.stgit@patser>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 9f19259..971284e 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -64,6 +64,7 @@
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/fence.h>
 
 #include <ttm/ttm_bo_api.h>
 #include <ttm/ttm_bo_driver.h>
@@ -114,9 +115,6 @@ extern int radeon_aspm;
 /* max number of rings */
 #define RADEON_NUM_RINGS			6
 
-/* fence seq are set to this number when signaled */
-#define RADEON_FENCE_SIGNALED_SEQ		0LL
-
 /* internal ring indices */
 /* r1xx+ has gfx CP ring */
 #define RADEON_RING_TYPE_GFX_INDEX	0
@@ -285,12 +283,15 @@ struct radeon_fence_driver {
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
@@ -2039,6 +2040,7 @@ struct radeon_device {
 	struct radeon_mman		mman;
 	struct radeon_fence_driver	fence_drv[RADEON_NUM_RINGS];
 	wait_queue_head_t		fence_queue;
+	unsigned			fence_context;
 	struct mutex			ring_lock;
 	struct radeon_ring		ring[RADEON_NUM_RINGS];
 	bool				ib_pool_ready;
@@ -2117,11 +2119,6 @@ u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 offset);
 void cik_mm_wdoorbell(struct radeon_device *rdev, u32 offset, u32 v);
 
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
index 63398ae..d76a187 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1150,6 +1150,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	for (i = 0; i < RADEON_NUM_RINGS; i++) {
 		rdev->ring[i].idx = i;
 	}
+	rdev->fence_context = fence_context_alloc(RADEON_NUM_RINGS);
 
 	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
 		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index ddb8f8e..92a1576 100644
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
@@ -111,14 +120,17 @@ int radeon_fence_emit(struct radeon_device *rdev,
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
+	__fence_init(&(*fence)->base, &radeon_fence_ops,
+		     &rdev->fence_queue.lock, rdev->fence_context + ring, seq);
 	(*fence)->rdev = rdev;
-	(*fence)->seq = ++rdev->fence_drv[ring].sync_seq[ring];
+	(*fence)->seq = seq;
 	(*fence)->ring = ring;
 	radeon_fence_ring_emit(rdev, ring, *fence);
 	trace_radeon_fence_emit(rdev->ddev, (*fence)->seq);
@@ -126,15 +138,38 @@ int radeon_fence_emit(struct radeon_device *rdev,
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
+		int ret = __fence_signal(&fence->base);
+
+		if (!ret)
+			FENCE_TRACE(&fence->base, "signaled from irq context\n");
+		else
+			FENCE_TRACE(&fence->base, "was already signaled\n");
+
+		/* probably a bad idea to call this from the irq handler, so lets not.. */
+		atomic_dec(&fence->rdev->irq.ring_int[fence->ring]);
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
@@ -190,25 +225,24 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
 		}
 	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
 
-	if (wake) {
+	if (wake)
 		rdev->fence_drv[ring].last_activity = jiffies;
-		wake_up_all(&rdev->fence_queue);
-	}
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
@@ -239,6 +273,49 @@ static bool radeon_fence_seq_signaled(struct radeon_device *rdev,
 	return false;
 }
 
+static bool __radeon_fence_signaled(struct fence *f)
+{
+	struct radeon_fence *fence = to_radeon_fence(f);
+
+	return radeon_fence_seq_signaled(fence->rdev, fence->seq, fence->ring);
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
+
+	if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq ||
+	    !fence->rdev->ddev->irq_enabled)
+		return false;
+
+	radeon_irq_kms_sw_irq_get(fence->rdev, fence->ring);
+
+	if (__radeon_fence_process(fence->rdev, fence->ring))
+		wake_up_all_locked(&fence->rdev->fence_queue);
+
+	/* did fence get signaled after we enabled the sw irq? */
+	if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
+		radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
+		return false;
+	}
+
+	fence->fence_wake.flags = 0;
+	fence->fence_wake.private = NULL;
+	fence->fence_wake.func = radeon_fence_check_signaled;
+	__add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
+	fence_get(f);
+
+	return true;
+}
+
 /**
  * radeon_fence_signaled - check if a fence has signaled
  *
@@ -252,11 +329,13 @@ bool radeon_fence_signaled(struct radeon_fence *fence)
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
@@ -379,7 +458,7 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 target_seq,
  * radeon_fence_wait - wait for a fence to signal
  *
  * @fence: radeon fence object
- * @intr: use interruptable sleep
+ * @intr: use interruptible sleep
  *
  * Wait for the requested fence to signal (all asics).
  * @intr selects whether to use interruptable (true) or non-interruptable
@@ -390,17 +469,17 @@ int radeon_fence_wait(struct radeon_fence *fence, bool intr)
 {
 	int r;
 
-	if (fence == NULL) {
-		WARN(1, "Querying an invalid fence : %p !\n", fence);
-		return -EINVAL;
-	}
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))
+		return 0;
 
 	r = radeon_fence_wait_seq(fence->rdev, fence->seq,
 				  fence->ring, intr, true);
 	if (r) {
 		return r;
 	}
-	fence->seq = RADEON_FENCE_SIGNALED_SEQ;
+	r = fence_signal(&fence->base);
+	if (!r)
+		FENCE_TRACE(&fence->base, "signaled from fence_wait\n");
 	return 0;
 }
 
@@ -567,8 +646,8 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
 			continue;
 		}
 
-		if (fences[i]->seq == RADEON_FENCE_SIGNALED_SEQ) {
-			/* something was allready signaled */
+		if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fences[i]->base.flags)) {
+			/* already signaled */
 			return 0;
 		}
 
@@ -641,7 +720,7 @@ int radeon_fence_wait_empty_locked(struct radeon_device *rdev, int ring)
  */
 struct radeon_fence *radeon_fence_ref(struct radeon_fence *fence)
 {
-	kref_get(&fence->kref);
+	fence_get(&fence->base);
 	return fence;
 }
 
@@ -657,9 +736,8 @@ void radeon_fence_unref(struct radeon_fence **fence)
 	struct radeon_fence *tmp = *fence;
 
 	*fence = NULL;
-	if (tmp) {
-		kref_put(&tmp->kref, radeon_fence_destroy);
-	}
+	if (tmp)
+		fence_put(&tmp->base);
 }
 
 /**
@@ -947,3 +1025,10 @@ int radeon_debugfs_fence_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+static const struct fence_ops radeon_fence_ops = {
+	.enable_signaling = radeon_fence_enable_signaling,
+	.signaled = __radeon_fence_signaled,
+	.wait = fence_default_wait,
+	.release = NULL,
+};

