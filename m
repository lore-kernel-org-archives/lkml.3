Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaFGBoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:44:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35958 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.855678454@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 78/92] drm/radeon: also try GART for CPU accessed buffers
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 544092596e8ac269f70e70961b5e9381909c9b1e upstream.

Placing them exclusively into VRAM might not work all the time.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=78297

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: ttm_bo_validate() takes an extra no_wait_reserve
 parameter; keep passing true]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_object.c | 38 ++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -513,22 +513,30 @@ int radeon_bo_fault_reserve_notify(struc
 	rbo = container_of(bo, struct radeon_bo, tbo);
 	radeon_bo_check_tiling(rbo, 0, 0);
 	rdev = rbo->rdev;
-	if (bo->mem.mem_type == TTM_PL_VRAM) {
-		size = bo->mem.num_pages << PAGE_SHIFT;
-		offset = bo->mem.start << PAGE_SHIFT;
-		if ((offset + size) > rdev->mc.visible_vram_size) {
-			/* hurrah the memory is not visible ! */
-			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_VRAM);
-			rbo->placement.lpfn = rdev->mc.visible_vram_size >> PAGE_SHIFT;
-			r = ttm_bo_validate(bo, &rbo->placement, false, true, false);
-			if (unlikely(r != 0))
-				return r;
-			offset = bo->mem.start << PAGE_SHIFT;
-			/* this should not happen */
-			if ((offset + size) > rdev->mc.visible_vram_size)
-				return -EINVAL;
-		}
+	if (bo->mem.mem_type != TTM_PL_VRAM)
+		return 0;
+
+	size = bo->mem.num_pages << PAGE_SHIFT;
+	offset = bo->mem.start << PAGE_SHIFT;
+	if ((offset + size) <= rdev->mc.visible_vram_size)
+		return 0;
+
+	/* hurrah the memory is not visible ! */
+	radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_VRAM);
+	rbo->placement.lpfn = rdev->mc.visible_vram_size >> PAGE_SHIFT;
+	r = ttm_bo_validate(bo, &rbo->placement, false, true, false);
+	if (unlikely(r == -ENOMEM)) {
+		radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_GTT);
+		return ttm_bo_validate(bo, &rbo->placement, false, true, false);
+	} else if (unlikely(r != 0)) {
+		return r;
 	}
+
+	offset = bo->mem.start << PAGE_SHIFT;
+	/* this should never happen */
+	if ((offset + size) > rdev->mc.visible_vram_size)
+		return -EINVAL;
+
 	return 0;
 }
 

