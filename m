Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaCaAWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36311 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.261225043@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 047/200] drm/radeon: set the full cache bit for fences
 on r7xx+
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d45b964a22cad962d3ede1eba8d24f5cee7b2a92 upstream.

Needed to properly flush the read caches for fences.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2:
 - Adjust context
 - s/\bring\b/rdev/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2315,14 +2315,18 @@ int r600_ring_test(struct radeon_device
 void r600_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence)
 {
+	u32 cp_coher_cntl = PACKET3_TC_ACTION_ENA | PACKET3_VC_ACTION_ENA |
+		PACKET3_SH_ACTION_ENA;
+
+	if (rdev->family >= CHIP_RV770)
+		cp_coher_cntl |= PACKET3_FULL_CACHE_ENA;
+
 	if (rdev->wb.use_event) {
 		u64 addr = rdev->wb.gpu_addr + R600_WB_EVENT_OFFSET +
 			(u64)(rdev->fence_drv.scratch_reg - rdev->scratch.reg_base);
 		/* flush read cache over gart */
 		radeon_ring_write(rdev, PACKET3(PACKET3_SURFACE_SYNC, 3));
-		radeon_ring_write(rdev, PACKET3_TC_ACTION_ENA |
-					PACKET3_VC_ACTION_ENA |
-					PACKET3_SH_ACTION_ENA);
+		radeon_ring_write(rdev, cp_coher_cntl);
 		radeon_ring_write(rdev, 0xFFFFFFFF);
 		radeon_ring_write(rdev, 0);
 		radeon_ring_write(rdev, 10); /* poll interval */
@@ -2336,9 +2340,7 @@ void r600_fence_ring_emit(struct radeon_
 	} else {
 		/* flush read cache over gart */
 		radeon_ring_write(rdev, PACKET3(PACKET3_SURFACE_SYNC, 3));
-		radeon_ring_write(rdev, PACKET3_TC_ACTION_ENA |
-					PACKET3_VC_ACTION_ENA |
-					PACKET3_SH_ACTION_ENA);
+		radeon_ring_write(rdev, cp_coher_cntl);
 		radeon_ring_write(rdev, 0xFFFFFFFF);
 		radeon_ring_write(rdev, 0);
 		radeon_ring_write(rdev, 10); /* poll interval */
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -838,6 +838,7 @@
 #define	PACKET3_INDIRECT_BUFFER				0x32
 #define	PACKET3_SURFACE_SYNC				0x43
 #              define PACKET3_CB0_DEST_BASE_ENA    (1 << 6)
+#              define PACKET3_FULL_CACHE_ENA       (1 << 20) /* r7xx+ only */
 #              define PACKET3_TC_ACTION_ENA        (1 << 23)
 #              define PACKET3_VC_ACTION_ENA        (1 << 24)
 #              define PACKET3_CB_ACTION_ENA        (1 << 25)

