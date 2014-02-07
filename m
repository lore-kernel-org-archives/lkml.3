Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaBGLfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:35:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaBGLYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 58/88] drm/radeon: set the full cache bit for fences on r7xx+
Date: Fri,  7 Feb 2014 11:22:55 +0000
Message-Id: <1391772205-22239-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d45b964a22cad962d3ede1eba8d24f5cee7b2a92 upstream.

Needed to properly flush the read caches for fences.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600.c  | 13 +++++++------
 drivers/gpu/drm/radeon/r600d.h |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 3458d4a..ec1a029 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2249,14 +2249,17 @@ void r600_fence_ring_emit(struct radeon_device *rdev,
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
@@ -2270,9 +2273,7 @@ void r600_fence_ring_emit(struct radeon_device *rdev,
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
index 025fd5b..6dea105 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -1108,6 +1108,7 @@
 #define	PACKET3_INDIRECT_BUFFER				0x32
 #define	PACKET3_SURFACE_SYNC				0x43
 #              define PACKET3_CB0_DEST_BASE_ENA    (1 << 6)
+#              define PACKET3_FULL_CACHE_ENA       (1 << 20) /* r7xx+ only */
 #              define PACKET3_TC_ACTION_ENA        (1 << 23)
 #              define PACKET3_VC_ACTION_ENA        (1 << 24)
 #              define PACKET3_CB_ACTION_ENA        (1 << 25)
-- 
1.8.3.2

