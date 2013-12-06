Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab3LFXWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:22:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423079Ab3LFXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:21:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 060/152] drm/ttm: Fix memory type compatibility check
Date: Fri,  6 Dec 2013 15:09:44 -0800
Message-Id: <1386371476-2477-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 59c8e66378fb78adbcd05f0d09783dde6fef282b upstream.

Also check the busy placements before deciding to move a buffer object.
Failing to do this may result in a completely unneccessary move within a
single memory type.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 52b20b1..ba60a89 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1090,24 +1090,32 @@ out_unlock:
 	return ret;
 }
 
-static int ttm_bo_mem_compat(struct ttm_placement *placement,
-			     struct ttm_mem_reg *mem)
+static bool ttm_bo_mem_compat(struct ttm_placement *placement,
+			      struct ttm_mem_reg *mem,
+			      uint32_t *new_flags)
 {
 	int i;
 
 	if (mem->mm_node && placement->lpfn != 0 &&
 	    (mem->start < placement->fpfn ||
 	     mem->start + mem->num_pages > placement->lpfn))
-		return -1;
+		return false;
 
 	for (i = 0; i < placement->num_placement; i++) {
-		if ((placement->placement[i] & mem->placement &
-			TTM_PL_MASK_CACHING) &&
-			(placement->placement[i] & mem->placement &
-			TTM_PL_MASK_MEM))
-			return i;
+		*new_flags = placement->placement[i];
+		if ((*new_flags & mem->placement & TTM_PL_MASK_CACHING) &&
+		    (*new_flags & mem->placement & TTM_PL_MASK_MEM))
+			return true;
+	}
+
+	for (i = 0; i < placement->num_busy_placement; i++) {
+		*new_flags = placement->busy_placement[i];
+		if ((*new_flags & mem->placement & TTM_PL_MASK_CACHING) &&
+		    (*new_flags & mem->placement & TTM_PL_MASK_MEM))
+			return true;
 	}
-	return -1;
+
+	return false;
 }
 
 int ttm_bo_validate(struct ttm_buffer_object *bo,
@@ -1116,6 +1124,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 			bool no_wait_gpu)
 {
 	int ret;
+	uint32_t new_flags;
 
 	BUG_ON(!ttm_bo_is_reserved(bo));
 	/* Check that range is valid */
@@ -1126,8 +1135,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 	/*
 	 * Check whether we need to move buffer.
 	 */
-	ret = ttm_bo_mem_compat(placement, &bo->mem);
-	if (ret < 0) {
+	if (!ttm_bo_mem_compat(placement, &bo->mem, &new_flags)) {
 		ret = ttm_bo_move_buffer(bo, placement, interruptible,
 					 no_wait_gpu);
 		if (ret)
@@ -1137,7 +1145,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 		 * Use the access and other non-mapping-related flag bits from
 		 * the compatible memory placement flags to the active flags
 		 */
-		ttm_flag_masked(&bo->mem.placement, placement->placement[ret],
+		ttm_flag_masked(&bo->mem.placement, new_flags,
 				~TTM_PL_MASK_MEMTYPE);
 	}
 	/*
-- 
1.8.3.2

