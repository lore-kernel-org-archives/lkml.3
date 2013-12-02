Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3LBUyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:54:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LBTNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.10 094/173] drm/ttm: Fix memory type compatibility check
Date: Mon,  2 Dec 2013 11:11:17 -0800
Message-Id: <20131202191154.726876755@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 59c8e66378fb78adbcd05f0d09783dde6fef282b upstream.

Also check the busy placements before deciding to move a buffer object.
Failing to do this may result in a completely unneccessary move within a
single memory type.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1153,24 +1153,32 @@ out_unlock:
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
 	}
-	return -1;
+
+	for (i = 0; i < placement->num_busy_placement; i++) {
+		*new_flags = placement->busy_placement[i];
+		if ((*new_flags & mem->placement & TTM_PL_MASK_CACHING) &&
+		    (*new_flags & mem->placement & TTM_PL_MASK_MEM))
+			return true;
+	}
+
+	return false;
 }
 
 int ttm_bo_validate(struct ttm_buffer_object *bo,
@@ -1179,6 +1187,7 @@ int ttm_bo_validate(struct ttm_buffer_ob
 			bool no_wait_gpu)
 {
 	int ret;
+	uint32_t new_flags;
 
 	BUG_ON(!ttm_bo_is_reserved(bo));
 	/* Check that range is valid */
@@ -1189,8 +1198,7 @@ int ttm_bo_validate(struct ttm_buffer_ob
 	/*
 	 * Check whether we need to move buffer.
 	 */
-	ret = ttm_bo_mem_compat(placement, &bo->mem);
-	if (ret < 0) {
+	if (!ttm_bo_mem_compat(placement, &bo->mem, &new_flags)) {
 		ret = ttm_bo_move_buffer(bo, placement, interruptible,
 					 no_wait_gpu);
 		if (ret)
@@ -1200,7 +1208,7 @@ int ttm_bo_validate(struct ttm_buffer_ob
 		 * Use the access and other non-mapping-related flag bits from
 		 * the compatible memory placement flags to the active flags
 		 */
-		ttm_flag_masked(&bo->mem.placement, placement->placement[ret],
+		ttm_flag_masked(&bo->mem.placement, new_flags,
 				~TTM_PL_MASK_MEMTYPE);
 	}
 	/*


