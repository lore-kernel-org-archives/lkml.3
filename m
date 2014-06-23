Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaFWJBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55478 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/111] drm/radeon: also try GART for CPU accessed buffers
Date: Mon, 23 Jun 2014 10:31:00 +0200
Message-Id: <bac59d1b797d8b80eb8a38d609f89666bf9f0179.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 544092596e8ac269f70e70961b5e9381909c9b1e upstream.

Placing them exclusively into VRAM might not work all the time.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=78297

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_object.c | 38 ++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index c0fa4aa9ceea..315b8e227e49 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -586,22 +586,30 @@ int radeon_bo_fault_reserve_notify(struct ttm_buffer_object *bo)
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
2.0.0

