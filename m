Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaBKTUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:20:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaBKTIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 53/79] drm/radeon: fix surface sync in fence on cayman (v2)
Date: Tue, 11 Feb 2014 11:05:57 -0800
Message-Id: <20140211184722.492721044@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 10e9ffae463396c5a25fdfe8a48d7c98a87f6b85 upstream.

We need to set the engine bit to select the ME and
also set the full cache bit.  Should help stability
on TN and cayman.

V2: fix up surface sync in ib execute as well

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c  |   16 +++++++---------
 drivers/gpu/drm/radeon/nid.h |    1 +
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1178,13 +1178,12 @@ void cayman_fence_ring_emit(struct radeo
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
@@ -1200,6 +1199,8 @@ void cayman_fence_ring_emit(struct radeo
 void cayman_ring_ib_execute(struct radeon_device *rdev, struct radeon_ib *ib)
 {
 	struct radeon_ring *ring = &rdev->ring[ib->ring];
+	u32 cp_coher_cntl = PACKET3_FULL_CACHE_ENA | PACKET3_TC_ACTION_ENA |
+		PACKET3_SH_ACTION_ENA;
 
 	/* set to DX10/11 mode */
 	radeon_ring_write(ring, PACKET3(PACKET3_MODE_CONTROL, 0));
@@ -1224,14 +1225,11 @@ void cayman_ring_ib_execute(struct radeo
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
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -573,6 +573,7 @@
 #              define PACKET3_DB_ACTION_ENA        (1 << 26)
 #              define PACKET3_SH_ACTION_ENA        (1 << 27)
 #              define PACKET3_SX_ACTION_ENA        (1 << 28)
+#              define PACKET3_ENGINE_ME            (1 << 31)
 #define	PACKET3_ME_INITIALIZE				0x44
 #define		PACKET3_ME_INITIALIZE_DEVICE_ID(x) ((x) << 16)
 #define	PACKET3_COND_WRITE				0x45


