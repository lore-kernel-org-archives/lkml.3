Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3L2CO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:14:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55847 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab3L2COB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:14:01 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Hellstrom" <thellstrom@vmware.com>,
        "Jakob Bornecrantz" <jakob@vmware.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.424344026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 030/185] drm/ttm: Fix memory type compatibility check
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 59c8e66378fb78adbcd05f0d09783dde6fef282b upstream.

Also check the busy placements before deciding to move a buffer object.
Failing to do this may result in a completely unneccessary move within a
single memory type.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1101,24 +1101,32 @@ out_unlock:
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
@@ -1127,6 +1135,7 @@ int ttm_bo_validate(struct ttm_buffer_ob
 			bool no_wait_gpu)
 {
 	int ret;
+	uint32_t new_flags;
 
 	BUG_ON(!atomic_read(&bo->reserved));
 	/* Check that range is valid */
@@ -1137,8 +1146,7 @@ int ttm_bo_validate(struct ttm_buffer_ob
 	/*
 	 * Check whether we need to move buffer.
 	 */
-	ret = ttm_bo_mem_compat(placement, &bo->mem);
-	if (ret < 0) {
+	if (!ttm_bo_mem_compat(placement, &bo->mem, &new_flags)) {
 		ret = ttm_bo_move_buffer(bo, placement, interruptible, no_wait_reserve, no_wait_gpu);
 		if (ret)
 			return ret;
@@ -1147,7 +1155,7 @@ int ttm_bo_validate(struct ttm_buffer_ob
 		 * Use the access and other non-mapping-related flag bits from
 		 * the compatible memory placement flags to the active flags
 		 */
-		ttm_flag_masked(&bo->mem.placement, placement->placement[ret],
+		ttm_flag_masked(&bo->mem.placement, new_flags,
 				~TTM_PL_MASK_MEMTYPE);
 	}
 	/*

