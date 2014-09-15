Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbaIOWOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:14:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652AbaIOWOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Andreas Boll <andreas.boll.dev@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 158/187] drm/radeon: use packet2 for nop on hawaii with old firmware
Date: Mon, 15 Sep 2014 15:09:28 -0700
Message-Id: <1410818997-9432-159-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0e16e4cfde70e1cf00f9fe3a8f601d10e73e0ec6 upstream.

Older firmware didn't support the new nop packet.

v2 (Andreas Boll):
 - Drop usage of packet3 for new firmware

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com> (v1)
Signed-off-by: Andreas Boll <andreas.boll.dev@gmail.com>
[ kamal: backport to 3.13: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index f605f6e..1523902 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7576,6 +7576,7 @@ restart_ih:
 static int cik_startup(struct radeon_device *rdev)
 {
 	struct radeon_ring *ring;
+	u32 nop;
 	int r;
 
 	/* enable pcie gen2/3 link */
@@ -7693,10 +7694,16 @@ static int cik_startup(struct radeon_device *rdev)
 	}
 	cik_irq_set(rdev);
 
+	if (rdev->family == CHIP_HAWAII) {
+		nop = RADEON_CP_PACKET2;
+	} else {
+		nop = PACKET3(PACKET3_NOP, 0x3FFF);
+	}
+
 	ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	r = radeon_ring_init(rdev, ring, ring->ring_size, RADEON_WB_CP_RPTR_OFFSET,
 			     CP_RB0_RPTR, CP_RB0_WPTR,
-			     PACKET3(PACKET3_NOP, 0x3FFF));
+			     nop);
 	if (r)
 		return r;
 
@@ -7705,7 +7712,7 @@ static int cik_startup(struct radeon_device *rdev)
 	ring = &rdev->ring[CAYMAN_RING_TYPE_CP1_INDEX];
 	r = radeon_ring_init(rdev, ring, ring->ring_size, RADEON_WB_CP1_RPTR_OFFSET,
 			     CP_HQD_PQ_RPTR, CP_HQD_PQ_WPTR,
-			     PACKET3(PACKET3_NOP, 0x3FFF));
+			     nop);
 	if (r)
 		return r;
 	ring->me = 1; /* first MEC */
@@ -7717,7 +7724,7 @@ static int cik_startup(struct radeon_device *rdev)
 	ring = &rdev->ring[CAYMAN_RING_TYPE_CP2_INDEX];
 	r = radeon_ring_init(rdev, ring, ring->ring_size, RADEON_WB_CP2_RPTR_OFFSET,
 			     CP_HQD_PQ_RPTR, CP_HQD_PQ_WPTR,
-			     PACKET3(PACKET3_NOP, 0x3FFF));
+			     nop);
 	if (r)
 		return r;
 	/* dGPU only have 1 MEC */
-- 
1.9.1

