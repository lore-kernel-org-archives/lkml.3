Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3AOW3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:41818 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab3AOW3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        =?ISO-8859-15?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 073/221] drm/radeon: dont leave fence blocked process on failed GPU reset
Date: Tue, 15 Jan 2013 10:50:00 -0800
Message-Id: <20130115185003.330746274@linuxfoundation.org>
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

commit 76903b96adbfbb38b049765add21e02e44c387a5 upstream.

Force all fence to signal if GPU reset failed so no process get stuck
on waiting fence.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon.h        |    1 +
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 drivers/gpu/drm/radeon/radeon_fence.c  |   19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -220,6 +220,7 @@ struct radeon_fence {
 int radeon_fence_driver_start_ring(struct radeon_device *rdev, int ring);
 int radeon_fence_driver_init(struct radeon_device *rdev);
 void radeon_fence_driver_fini(struct radeon_device *rdev);
+void radeon_fence_driver_force_completion(struct radeon_device *rdev);
 int radeon_fence_emit(struct radeon_device *rdev, struct radeon_fence **fence, int ring);
 void radeon_fence_process(struct radeon_device *rdev, int ring);
 bool radeon_fence_signaled(struct radeon_fence *fence);
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1356,6 +1356,7 @@ retry:
 			}
 		}
 	} else {
+		radeon_fence_driver_force_completion(rdev);
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
 			kfree(ring_data[i]);
 		}
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -868,6 +868,25 @@ void radeon_fence_driver_fini(struct rad
 	mutex_unlock(&rdev->ring_lock);
 }
 
+/**
+ * radeon_fence_driver_force_completion - force all fence waiter to complete
+ *
+ * @rdev: radeon device pointer
+ *
+ * In case of GPU reset failure make sure no process keep waiting on fence
+ * that will never complete.
+ */
+void radeon_fence_driver_force_completion(struct radeon_device *rdev)
+{
+	int ring;
+
+	for (ring = 0; ring < RADEON_NUM_RINGS; ring++) {
+		if (!rdev->fence_drv[ring].initialized)
+			continue;
+		radeon_fence_write(rdev, rdev->fence_drv[ring].sync_seq[ring], ring);
+	}
+}
+
 
 /*
  * Fence debugfs


