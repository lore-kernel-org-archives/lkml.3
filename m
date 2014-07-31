Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaGaPeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:00 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56813 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaGaPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:33:49 -0400
Subject: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:33:42 +0200
Message-ID: <20140731153342.15061.54264.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
V1 had a nasty bug breaking gpu lockup recovery. The fix is not
allowing radeon_fence_driver_check_lockup to take exclusive_lock,
and kill it during lockup recovery instead.
---
 drivers/gpu/drm/radeon/radeon.h        |    3 +
 drivers/gpu/drm/radeon/radeon_device.c |    5 +
 drivers/gpu/drm/radeon/radeon_fence.c  |  124 ++++++++++++++++++--------------
 drivers/gpu/drm/radeon/radeon_ring.c   |    1 
 4 files changed, 77 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 60c47f829122..b01d88fc10cb 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -347,6 +347,8 @@ struct radeon_fence_driver {
 	uint64_t			sync_seq[RADEON_NUM_RINGS];
 	atomic64_t			last_seq;
 	bool				initialized;
+	struct delayed_work	fence_check_work;
+	struct radeon_device	*rdev;
 };
 
 struct radeon_fence {
@@ -360,6 +362,7 @@ struct radeon_fence {
 
 int radeon_fence_driver_start_ring(struct radeon_device *rdev, int ring);
 int radeon_fence_driver_init(struct radeon_device *rdev);
+void radeon_fence_cancel_delayed_check(struct radeon_device *rdev, int ring);
 void radeon_fence_driver_fini(struct radeon_device *rdev);
 void radeon_fence_driver_force_completion(struct radeon_device *rdev);
 int radeon_fence_emit(struct radeon_device *rdev, struct radeon_fence **fence, int ring);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 697add2cd4e3..21efd32d07ee 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1637,6 +1637,11 @@ int radeon_gpu_reset(struct radeon_device *rdev)
 	radeon_save_bios_scratch_regs(rdev);
 	/* block TTM */
 	resched = ttm_bo_lock_delayed_workqueue(&rdev->mman.bdev);
+
+	/* kill all the hangcheck tests too */
+	for (i = 0; i < RADEON_NUM_RINGS; ++i)
+		radeon_fence_cancel_delayed_check(rdev, i);
+
 	radeon_pm_suspend(rdev);
 	radeon_suspend(rdev);
 
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 913787085dfa..c055acc3a271 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -125,16 +125,7 @@ int radeon_fence_emit(struct radeon_device *rdev,
 	return 0;
 }
 
-/**
- * radeon_fence_process - process a fence
- *
- * @rdev: radeon_device pointer
- * @ring: ring index the fence is associated with
- *
- * Checks the current fence value and wakes the fence queue
- * if the sequence number has increased (all asics).
- */
-void radeon_fence_process(struct radeon_device *rdev, int ring)
+static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
 {
 	uint64_t seq, last_seq, last_emitted;
 	unsigned count_loop = 0;
@@ -190,7 +181,51 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
 		}
 	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
 
-	if (wake)
+	if (seq < last_emitted)
+		mod_delayed_work(system_power_efficient_wq,
+				 &rdev->fence_drv[ring].fence_check_work,
+				 RADEON_FENCE_JIFFIES_TIMEOUT);
+
+	return wake;
+}
+
+static void radeon_fence_driver_check_lockup(struct work_struct *work)
+{
+	struct radeon_fence_driver *fence_drv;
+	struct radeon_device *rdev;
+	unsigned long iring;
+
+	fence_drv = container_of(work, struct radeon_fence_driver, fence_check_work.work);
+	rdev = fence_drv->rdev;
+	iring = fence_drv - &rdev->fence_drv[0];
+
+	if (__radeon_fence_process(rdev, iring))
+		wake_up_all(&rdev->fence_queue);
+	else if (radeon_ring_is_lockup(rdev, iring, &rdev->ring[iring])) {
+		/* good news we believe it's a lockup */
+		dev_warn(rdev->dev, "GPU lockup (current fence id "
+			 "0x%016llx last fence id 0x%016llx on ring %ld)\n",
+			 (uint64_t)atomic64_read(&fence_drv->last_seq),
+			 fence_drv->sync_seq[iring], iring);
+
+		/* remember that we need an reset */
+		rdev->needs_reset = true;
+		wake_up_all(&rdev->fence_queue);
+	}
+}
+
+/**
+ * radeon_fence_process - process a fence
+ *
+ * @rdev: radeon_device pointer
+ * @ring: ring index the fence is associated with
+ *
+ * Checks the current fence value and wakes the fence queue
+ * if the sequence number has increased (all asics).
+ */
+void radeon_fence_process(struct radeon_device *rdev, int ring)
+{
+	if (__radeon_fence_process(rdev, ring))
 		wake_up_all(&rdev->fence_queue);
 }
 
@@ -302,9 +337,10 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 {
 	uint64_t last_seq[RADEON_NUM_RINGS];
 	bool signaled;
-	int i, r;
+	int i;
 
 	while (!radeon_fence_any_seq_signaled(rdev, target_seq)) {
+		long r;
 
 		/* Save current sequence values, used to check for GPU lockups */
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
@@ -319,11 +355,11 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 		if (intr) {
 			r = wait_event_interruptible_timeout(rdev->fence_queue, (
 				(signaled = radeon_fence_any_seq_signaled(rdev, target_seq))
-				 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
+				 || rdev->needs_reset), MAX_SCHEDULE_TIMEOUT);
 		} else {
 			r = wait_event_timeout(rdev->fence_queue, (
 				(signaled = radeon_fence_any_seq_signaled(rdev, target_seq))
-				 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
+				 || rdev->needs_reset), MAX_SCHEDULE_TIMEOUT);
 		}
 
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
@@ -334,50 +370,11 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 			trace_radeon_fence_wait_end(rdev->ddev, i, target_seq[i]);
 		}
 
-		if (unlikely(r < 0))
+		if (r < 0)
 			return r;
 
-		if (unlikely(!signaled)) {
-			if (rdev->needs_reset)
-				return -EDEADLK;
-
-			/* we were interrupted for some reason and fence
-			 * isn't signaled yet, resume waiting */
-			if (r)
-				continue;
-
-			for (i = 0; i < RADEON_NUM_RINGS; ++i) {
-				if (!target_seq[i])
-					continue;
-
-				if (last_seq[i] != atomic64_read(&rdev->fence_drv[i].last_seq))
-					break;
-			}
-
-			if (i != RADEON_NUM_RINGS)
-				continue;
-
-			for (i = 0; i < RADEON_NUM_RINGS; ++i) {
-				if (!target_seq[i])
-					continue;
-
-				if (radeon_ring_is_lockup(rdev, i, &rdev->ring[i]))
-					break;
-			}
-
-			if (i < RADEON_NUM_RINGS) {
-				/* good news we believe it's a lockup */
-				dev_warn(rdev->dev, "GPU lockup (waiting for "
-					 "0x%016llx last fence id 0x%016llx on"
-					 " ring %d)\n",
-					 target_seq[i], last_seq[i], i);
-
-				/* remember that we need an reset */
-				rdev->needs_reset = true;
-				wake_up_all(&rdev->fence_queue);
-				return -EDEADLK;
-			}
-		}
+		if (rdev->needs_reset)
+			return -EDEADLK;
 	}
 	return 0;
 }
@@ -711,6 +708,8 @@ static void radeon_fence_driver_init_ring(struct radeon_device *rdev, int ring)
 		rdev->fence_drv[ring].sync_seq[i] = 0;
 	atomic64_set(&rdev->fence_drv[ring].last_seq, 0);
 	rdev->fence_drv[ring].initialized = false;
+	INIT_DELAYED_WORK(&rdev->fence_drv[ring].fence_check_work, radeon_fence_driver_check_lockup);
+	rdev->fence_drv[ring].rdev = rdev;
 }
 
 /**
@@ -740,6 +739,17 @@ int radeon_fence_driver_init(struct radeon_device *rdev)
 }
 
 /**
+ * radeon_fence_cancel_delayed_check - cancel all delayed checks on a ring during lockup
+ *
+ * This prevents the lockup check from being done while suspend is running
+ * during a recovery from a lockup.
+ */
+void radeon_fence_cancel_delayed_check(struct radeon_device *rdev, int ring)
+{
+	cancel_delayed_work_sync(&rdev->fence_drv[ring].fence_check_work);
+}
+
+/**
  * radeon_fence_driver_fini - tear down the fence driver
  * for all possible rings.
  *
@@ -755,6 +765,8 @@ void radeon_fence_driver_fini(struct radeon_device *rdev)
 	for (ring = 0; ring < RADEON_NUM_RINGS; ring++) {
 		if (!rdev->fence_drv[ring].initialized)
 			continue;
+
+		cancel_delayed_work_sync(&rdev->fence_drv[ring].fence_check_work);
 		r = radeon_fence_wait_empty(rdev, ring);
 		if (r) {
 			/* no need to trigger GPU reset as we are unloading */
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index f8050f5429e2..594d871a6fce 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -261,6 +261,7 @@ int radeon_ib_ring_tests(struct radeon_device *rdev)
 
 		r = radeon_ib_test(rdev, i, ring);
 		if (r) {
+			radeon_fence_cancel_delayed_check(rdev, i);
 			ring->ready = false;
 			rdev->needs_reset = false;
 

