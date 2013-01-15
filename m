Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab3APAaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:30:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:41828 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab3AOW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        =?ISO-8859-15?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 074/221] drm/radeon: avoid deadlock in pm path when waiting for fence
Date: Tue, 15 Jan 2013 10:50:01 -0800
Message-Id: <20130115185003.399922590@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 5f8f635edd8ad5a6416bff4c5ff486500357f473 upstream.

radeon_fence_wait_empty_locked should not trigger GPU reset as no
place where it's call from would benefit from such thing and it
actually lead to a kernel deadlock in case the reset is triggered
from pm codepath. Instead force ring completion in place where it
makes sense or return early in others.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon.h        |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c |   13 +++++++++++--
 drivers/gpu/drm/radeon/radeon_fence.c  |   30 ++++++++++++++----------------
 drivers/gpu/drm/radeon/radeon_pm.c     |   15 ++++++++++++---
 4 files changed, 38 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -226,7 +226,7 @@ void radeon_fence_process(struct radeon_
 bool radeon_fence_signaled(struct radeon_fence *fence);
 int radeon_fence_wait(struct radeon_fence *fence, bool interruptible);
 int radeon_fence_wait_next_locked(struct radeon_device *rdev, int ring);
-void radeon_fence_wait_empty_locked(struct radeon_device *rdev, int ring);
+int radeon_fence_wait_empty_locked(struct radeon_device *rdev, int ring);
 int radeon_fence_wait_any(struct radeon_device *rdev,
 			  struct radeon_fence **fences,
 			  bool intr);
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1163,6 +1163,7 @@ int radeon_suspend_kms(struct drm_device
 	struct drm_crtc *crtc;
 	struct drm_connector *connector;
 	int i, r;
+	bool force_completion = false;
 
 	if (dev == NULL || dev->dev_private == NULL) {
 		return -ENODEV;
@@ -1205,8 +1206,16 @@ int radeon_suspend_kms(struct drm_device
 
 	mutex_lock(&rdev->ring_lock);
 	/* wait for gpu to finish processing current batch */
-	for (i = 0; i < RADEON_NUM_RINGS; i++)
-		radeon_fence_wait_empty_locked(rdev, i);
+	for (i = 0; i < RADEON_NUM_RINGS; i++) {
+		r = radeon_fence_wait_empty_locked(rdev, i);
+		if (r) {
+			/* delay GPU reset to resume */
+			force_completion = true;
+		}
+	}
+	if (force_completion) {
+		radeon_fence_driver_force_completion(rdev);
+	}
 	mutex_unlock(&rdev->ring_lock);
 
 	radeon_save_bios_scratch_regs(rdev);
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -609,26 +609,20 @@ int radeon_fence_wait_next_locked(struct
  * Returns 0 if the fences have passed, error for all other cases.
  * Caller must hold ring lock.
  */
-void radeon_fence_wait_empty_locked(struct radeon_device *rdev, int ring)
+int radeon_fence_wait_empty_locked(struct radeon_device *rdev, int ring)
 {
 	uint64_t seq = rdev->fence_drv[ring].sync_seq[ring];
+	int r;
 
-	while(1) {
-		int r;
-		r = radeon_fence_wait_seq(rdev, seq, ring, false, false);
+	r = radeon_fence_wait_seq(rdev, seq, ring, false, false);
+	if (r) {
 		if (r == -EDEADLK) {
-			mutex_unlock(&rdev->ring_lock);
-			r = radeon_gpu_reset(rdev);
-			mutex_lock(&rdev->ring_lock);
-			if (!r)
-				continue;
-		}
-		if (r) {
-			dev_err(rdev->dev, "error waiting for ring to become"
-				" idle (%d)\n", r);
+			return -EDEADLK;
 		}
-		return;
+		dev_err(rdev->dev, "error waiting for ring[%d] to become idle (%d)\n",
+			ring, r);
 	}
+	return 0;
 }
 
 /**
@@ -854,13 +848,17 @@ int radeon_fence_driver_init(struct rade
  */
 void radeon_fence_driver_fini(struct radeon_device *rdev)
 {
-	int ring;
+	int ring, r;
 
 	mutex_lock(&rdev->ring_lock);
 	for (ring = 0; ring < RADEON_NUM_RINGS; ring++) {
 		if (!rdev->fence_drv[ring].initialized)
 			continue;
-		radeon_fence_wait_empty_locked(rdev, ring);
+		r = radeon_fence_wait_empty_locked(rdev, ring);
+		if (r) {
+			/* no need to trigger GPU reset as we are unloading */
+			radeon_fence_driver_force_completion(rdev);
+		}
 		wake_up_all(&rdev->fence_queue);
 		radeon_scratch_free(rdev, rdev->fence_drv[ring].scratch_reg);
 		rdev->fence_drv[ring].initialized = false;
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -234,7 +234,7 @@ static void radeon_set_power_state(struc
 
 static void radeon_pm_set_clocks(struct radeon_device *rdev)
 {
-	int i;
+	int i, r;
 
 	/* no need to take locks, etc. if nothing's going to change */
 	if ((rdev->pm.requested_clock_mode_index == rdev->pm.current_clock_mode_index) &&
@@ -248,8 +248,17 @@ static void radeon_pm_set_clocks(struct
 	/* wait for the rings to drain */
 	for (i = 0; i < RADEON_NUM_RINGS; i++) {
 		struct radeon_ring *ring = &rdev->ring[i];
-		if (ring->ready)
-			radeon_fence_wait_empty_locked(rdev, i);
+		if (!ring->ready) {
+			continue;
+		}
+		r = radeon_fence_wait_empty_locked(rdev, i);
+		if (r) {
+			/* needs a GPU reset dont reset here */
+			mutex_unlock(&rdev->ring_lock);
+			up_write(&rdev->pm.mclk_lock);
+			mutex_unlock(&rdev->ddev->struct_mutex);
+			return;
+		}
 	}
 
 	radeon_unmap_vram_bos(rdev);


