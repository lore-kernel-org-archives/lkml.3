Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaBKTOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:14:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaBKTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.4 20/30] drm/radeon: set the full cache bit for fences on r7xx+
Date: Tue, 11 Feb 2014 11:06:20 -0800
Message-Id: <20140211184647.721797077@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d45b964a22cad962d3ede1eba8d24f5cee7b2a92 upstream.

Needed to properly flush the read caches for fences.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600.c  |   13 +++++++------
 drivers/gpu/drm/radeon/r600d.h |    1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2313,14 +2313,17 @@ void r600_fence_ring_emit(struct radeon_
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
@@ -2334,9 +2337,7 @@ void r600_fence_ring_emit(struct radeon_
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
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -873,6 +873,7 @@
 #define	PACKET3_INDIRECT_BUFFER				0x32
 #define	PACKET3_SURFACE_SYNC				0x43
 #              define PACKET3_CB0_DEST_BASE_ENA    (1 << 6)
+#              define PACKET3_FULL_CACHE_ENA       (1 << 20) /* r7xx+ only */
 #              define PACKET3_TC_ACTION_ENA        (1 << 23)
 #              define PACKET3_VC_ACTION_ENA        (1 << 24)
 #              define PACKET3_CB_ACTION_ENA        (1 << 25)


