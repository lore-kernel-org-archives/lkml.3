Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaBJToB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:44:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34732 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaBJTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 078/124] drm/radeon: set the full cache bit for fences on r7xx+
Date: Mon, 10 Feb 2014 11:40:18 -0800
Message-Id: <1392061264-28124-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d45b964a22cad962d3ede1eba8d24f5cee7b2a92 upstream.

Needed to properly flush the read caches for fences.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/r600.c  | 13 +++++++------
 drivers/gpu/drm/radeon/r600d.h |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 040d27a..3d14719 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2519,14 +2519,17 @@ void r600_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence)
 {
 	struct radeon_ring *ring = &rdev->ring[fence->ring];
+	u32 cp_coher_cntl = PACKET3_TC_ACTION_ENA | PACKET3_VC_ACTION_ENA |
+		PACKET3_SH_ACTION_ENA;
+
+	if (rdev->family >= CHIP_RV770)
+		cp_coher_cntl |= PACKET3_FULL_CACHE_ENA;
 
 	if (rdev->wb.use_event) {
 		u64 addr = rdev->fence_drv[fence->ring].gpu_addr;
 		/* flush read cache over gart */
 		radeon_ring_write(ring, PACKET3(PACKET3_SURFACE_SYNC, 3));
-		radeon_ring_write(ring, PACKET3_TC_ACTION_ENA |
-					PACKET3_VC_ACTION_ENA |
-					PACKET3_SH_ACTION_ENA);
+		radeon_ring_write(ring, cp_coher_cntl);
 		radeon_ring_write(ring, 0xFFFFFFFF);
 		radeon_ring_write(ring, 0);
 		radeon_ring_write(ring, 10); /* poll interval */
@@ -2540,9 +2543,7 @@ void r600_fence_ring_emit(struct radeon_device *rdev,
 	} else {
 		/* flush read cache over gart */
 		radeon_ring_write(ring, PACKET3(PACKET3_SURFACE_SYNC, 3));
-		radeon_ring_write(ring, PACKET3_TC_ACTION_ENA |
-					PACKET3_VC_ACTION_ENA |
-					PACKET3_SH_ACTION_ENA);
+		radeon_ring_write(ring, cp_coher_cntl);
 		radeon_ring_write(ring, 0xFFFFFFFF);
 		radeon_ring_write(ring, 0);
 		radeon_ring_write(ring, 10); /* poll interval */
diff --git a/drivers/gpu/drm/radeon/r600d.h b/drivers/gpu/drm/radeon/r600d.h
index 8a8308b..9e2ac73 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -1220,6 +1220,7 @@
 #              define PACKET3_CP_DMA_CMD_DAIC      (1 << 29)
 #define	PACKET3_SURFACE_SYNC				0x43
 #              define PACKET3_CB0_DEST_BASE_ENA    (1 << 6)
+#              define PACKET3_FULL_CACHE_ENA       (1 << 20) /* r7xx+ only */
 #              define PACKET3_TC_ACTION_ENA        (1 << 23)
 #              define PACKET3_VC_ACTION_ENA        (1 << 24)
 #              define PACKET3_CB_ACTION_ENA        (1 << 25)
-- 
1.8.3.2

