Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbaGIM3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:29:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44848 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbaGIM3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:29:51 -0400
Subject: [PATCH 08/17] drm/radeon: add timeout argument to
 radeon_fence_wait_seq
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Wed, 09 Jul 2014 14:29:48 +0200
Message-ID: <20140709122948.11354.35297.stgit@patser>
In-Reply-To: <20140709093124.11354.3774.stgit@patser>
References: <20140709093124.11354.3774.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to wait for a specific amount of time,
rather than wait until infinity.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reviewed-by: Christian König <deathsimple@vodafone.de>
---
 drivers/gpu/drm/radeon/radeon_fence.c |   60 ++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 913787085dfa..6435719fd45b 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -283,28 +283,35 @@ static bool radeon_fence_any_seq_signaled(struct radeon_device *rdev, u64 *seq)
 }
 
 /**
- * radeon_fence_wait_seq - wait for a specific sequence numbers
+ * radeon_fence_wait_seq_timeout - wait for a specific sequence numbers
  *
  * @rdev: radeon device pointer
  * @target_seq: sequence number(s) we want to wait for
  * @intr: use interruptable sleep
+ * @timeout: maximum time to wait, or MAX_SCHEDULE_TIMEOUT for infinite wait
  *
  * Wait for the requested sequence number(s) to be written by any ring
  * (all asics).  Sequnce number array is indexed by ring id.
  * @intr selects whether to use interruptable (true) or non-interruptable
  * (false) sleep when waiting for the sequence number.  Helper function
  * for radeon_fence_wait_*().
- * Returns 0 if the sequence number has passed, error for all other cases.
+ * Returns remaining time if the sequence number has passed, 0 when
+ * the wait timeout, or an error for all other cases.
  * -EDEADLK is returned when a GPU lockup has been detected.
  */
-static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
-				 bool intr)
+static long radeon_fence_wait_seq_timeout(struct radeon_device *rdev,
+					  u64 *target_seq, bool intr,
+					  long timeout)
 {
 	uint64_t last_seq[RADEON_NUM_RINGS];
 	bool signaled;
-	int i, r;
+	int i;
 
 	while (!radeon_fence_any_seq_signaled(rdev, target_seq)) {
+		long r, waited;
+
+		waited = timeout < RADEON_FENCE_JIFFIES_TIMEOUT ?
+			 timeout : RADEON_FENCE_JIFFIES_TIMEOUT;
 
 		/* Save current sequence values, used to check for GPU lockups */
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
@@ -319,11 +326,11 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 		if (intr) {
 			r = wait_event_interruptible_timeout(rdev->fence_queue, (
 				(signaled = radeon_fence_any_seq_signaled(rdev, target_seq))
-				 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
+				 || rdev->needs_reset), waited);
 		} else {
 			r = wait_event_timeout(rdev->fence_queue, (
 				(signaled = radeon_fence_any_seq_signaled(rdev, target_seq))
-				 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
+				 || rdev->needs_reset), waited);
 		}
 
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
@@ -337,6 +344,14 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 		if (unlikely(r < 0))
 			return r;
 
+		timeout -= waited - r;
+
+		/*
+		 * If this is a timed wait and the wait completely timed out just return.
+		 */
+		if (!timeout)
+			break;
+
 		if (unlikely(!signaled)) {
 			if (rdev->needs_reset)
 				return -EDEADLK;
@@ -379,14 +394,14 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 			}
 		}
 	}
-	return 0;
+	return timeout;
 }
 
 /**
  * radeon_fence_wait - wait for a fence to signal
  *
  * @fence: radeon fence object
- * @intr: use interruptable sleep
+ * @intr: use interruptible sleep
  *
  * Wait for the requested fence to signal (all asics).
  * @intr selects whether to use interruptable (true) or non-interruptable
@@ -396,7 +411,7 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
 int radeon_fence_wait(struct radeon_fence *fence, bool intr)
 {
 	uint64_t seq[RADEON_NUM_RINGS] = {};
-	int r;
+	long r;
 
 	if (fence == NULL) {
 		WARN(1, "Querying an invalid fence : %p !\n", fence);
@@ -407,9 +422,10 @@ int radeon_fence_wait(struct radeon_fence *fence, bool intr)
 	if (seq[fence->ring] == RADEON_FENCE_SIGNALED_SEQ)
 		return 0;
 
-	r = radeon_fence_wait_seq(fence->rdev, seq, intr);
-	if (r)
+	r = radeon_fence_wait_seq_timeout(fence->rdev, seq, intr, MAX_SCHEDULE_TIMEOUT);
+	if (r < 0) {
 		return r;
+	}
 
 	fence->seq = RADEON_FENCE_SIGNALED_SEQ;
 	return 0;
@@ -434,7 +450,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
 {
 	uint64_t seq[RADEON_NUM_RINGS];
 	unsigned i, num_rings = 0;
-	int r;
+	long r;
 
 	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
 		seq[i] = 0;
@@ -455,8 +471,8 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
 	if (num_rings == 0)
 		return -ENOENT;
 
-	r = radeon_fence_wait_seq(rdev, seq, intr);
-	if (r) {
+	r = radeon_fence_wait_seq_timeout(rdev, seq, intr, MAX_SCHEDULE_TIMEOUT);
+	if (r < 0) {
 		return r;
 	}
 	return 0;
@@ -475,6 +491,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
 int radeon_fence_wait_next(struct radeon_device *rdev, int ring)
 {
 	uint64_t seq[RADEON_NUM_RINGS] = {};
+	long r;
 
 	seq[ring] = atomic64_read(&rdev->fence_drv[ring].last_seq) + 1ULL;
 	if (seq[ring] >= rdev->fence_drv[ring].sync_seq[ring]) {
@@ -482,7 +499,10 @@ int radeon_fence_wait_next(struct radeon_device *rdev, int ring)
 		   already the last emited fence */
 		return -ENOENT;
 	}
-	return radeon_fence_wait_seq(rdev, seq, false);
+	r = radeon_fence_wait_seq_timeout(rdev, seq, false, MAX_SCHEDULE_TIMEOUT);
+	if (r < 0)
+		return r;
+	return 0;
 }
 
 /**
@@ -498,18 +518,18 @@ int radeon_fence_wait_next(struct radeon_device *rdev, int ring)
 int radeon_fence_wait_empty(struct radeon_device *rdev, int ring)
 {
 	uint64_t seq[RADEON_NUM_RINGS] = {};
-	int r;
+	long r;
 
 	seq[ring] = rdev->fence_drv[ring].sync_seq[ring];
 	if (!seq[ring])
 		return 0;
 
-	r = radeon_fence_wait_seq(rdev, seq, false);
-	if (r) {
+	r = radeon_fence_wait_seq_timeout(rdev, seq, false, MAX_SCHEDULE_TIMEOUT);
+	if (r < 0) {
 		if (r == -EDEADLK)
 			return -EDEADLK;
 
-		dev_err(rdev->dev, "error waiting for ring[%d] to become idle (%d)\n",
+		dev_err(rdev->dev, "error waiting for ring[%d] to become idle (%ld)\n",
 			ring, r);
 	}
 	return 0;

