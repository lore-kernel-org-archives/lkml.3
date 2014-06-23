Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaFWNDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaFWNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 12/93] drm/radeon: also try GART for CPU accessed buffers
Date: Mon, 23 Jun 2014 14:01:51 +0100
Message-Id: <1403528592-2163-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 544092596e8ac269f70e70961b5e9381909c9b1e upstream.

Placing them exclusively into VRAM might not work all the time.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=78297

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_object.c | 38 ++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 2020bf4a3830..58ab5994cd6d 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -587,22 +587,30 @@ int radeon_bo_fault_reserve_notify(struct ttm_buffer_object *bo)
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
-			r = ttm_bo_validate(bo, &rbo->placement, false, false);
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
+	r = ttm_bo_validate(bo, &rbo->placement, false, false);
+	if (unlikely(r == -ENOMEM)) {
+		radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_GTT);
+		return ttm_bo_validate(bo, &rbo->placement, false, false);
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
 
-- 
1.9.1

