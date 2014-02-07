Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaBGMY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:24:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbaBGLvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 152/233] drm/radeon: fix surface sync in fence on cayman (v2)
Date: Fri,  7 Feb 2014 11:46:11 +0000
Message-Id: <1391773652-25214-153-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 10e9ffae463396c5a25fdfe8a48d7c98a87f6b85 upstream.

We need to set the engine bit to select the ME and
also set the full cache bit.  Should help stability
on TN and cayman.

V2: fix up surface sync in ib execute as well

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni.c  | 16 +++++++---------
 drivers/gpu/drm/radeon/nid.h |  1 +
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index b2a76f5..9a3849d 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1331,13 +1331,12 @@ void cayman_fence_ring_emit(struct radeon_device *rdev,
 {
 	struct radeon_ring *ring = &rdev->ring[fence->ring];
 	u64 addr = rdev->fence_drv[fence->ring].gpu_addr;
+	u32 cp_coher_cntl = PACKET3_FULL_CACHE_ENA | PACKET3_TC_ACTION_ENA |
+		PACKET3_SH_ACTION_ENA;
 
 	/* flush read cache over gart for this vmid */
-	radeon_ring_write(ring, PACKET3(PACKET3_SET_CONFIG_REG, 1));
-	radeon_ring_write(ring, (CP_COHER_CNTL2 - PACKET3_SET_CONFIG_REG_START) >> 2);
-	radeon_ring_write(ring, 0);
 	radeon_ring_write(ring, PACKET3(PACKET3_SURFACE_SYNC, 3));
-	radeon_ring_write(ring, PACKET3_TC_ACTION_ENA | PACKET3_SH_ACTION_ENA);
+	radeon_ring_write(ring, PACKET3_ENGINE_ME | cp_coher_cntl);
 	radeon_ring_write(ring, 0xFFFFFFFF);
 	radeon_ring_write(ring, 0);
 	radeon_ring_write(ring, 10); /* poll interval */
@@ -1353,6 +1352,8 @@ void cayman_fence_ring_emit(struct radeon_device *rdev,
 void cayman_ring_ib_execute(struct radeon_device *rdev, struct radeon_ib *ib)
 {
 	struct radeon_ring *ring = &rdev->ring[ib->ring];
+	u32 cp_coher_cntl = PACKET3_FULL_CACHE_ENA | PACKET3_TC_ACTION_ENA |
+		PACKET3_SH_ACTION_ENA;
 
 	/* set to DX10/11 mode */
 	radeon_ring_write(ring, PACKET3(PACKET3_MODE_CONTROL, 0));
@@ -1377,14 +1378,11 @@ void cayman_ring_ib_execute(struct radeon_device *rdev, struct radeon_ib *ib)
 			  (ib->vm ? (ib->vm->id << 24) : 0));
 
 	/* flush read cache over gart for this vmid */
-	radeon_ring_write(ring, PACKET3(PACKET3_SET_CONFIG_REG, 1));
-	radeon_ring_write(ring, (CP_COHER_CNTL2 - PACKET3_SET_CONFIG_REG_START) >> 2);
-	radeon_ring_write(ring, ib->vm ? ib->vm->id : 0);
 	radeon_ring_write(ring, PACKET3(PACKET3_SURFACE_SYNC, 3));
-	radeon_ring_write(ring, PACKET3_TC_ACTION_ENA | PACKET3_SH_ACTION_ENA);
+	radeon_ring_write(ring, PACKET3_ENGINE_ME | cp_coher_cntl);
 	radeon_ring_write(ring, 0xFFFFFFFF);
 	radeon_ring_write(ring, 0);
-	radeon_ring_write(ring, 10); /* poll interval */
+	radeon_ring_write(ring, ((ib->vm ? ib->vm->id : 0) << 24) | 10); /* poll interval */
 }
 
 void cayman_uvd_semaphore_emit(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/nid.h b/drivers/gpu/drm/radeon/nid.h
index 22421bc..d996033 100644
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -1154,6 +1154,7 @@
 #              define PACKET3_DB_ACTION_ENA        (1 << 26)
 #              define PACKET3_SH_ACTION_ENA        (1 << 27)
 #              define PACKET3_SX_ACTION_ENA        (1 << 28)
+#              define PACKET3_ENGINE_ME            (1 << 31)
 #define	PACKET3_ME_INITIALIZE				0x44
 #define		PACKET3_ME_INITIALIZE_DEVICE_ID(x) ((x) << 16)
 #define	PACKET3_COND_WRITE				0x45
-- 
1.8.3.2

