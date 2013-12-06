Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab3LFXYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:24:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161247Ab3LFXUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 059/152] drm/ttm: Fix ttm_bo_move_memcpy
Date: Fri,  6 Dec 2013 15:09:43 -0800
Message-Id: <1386371476-2477-60-git-send-email-kamal@canonical.com>
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

commit da95c788ef0c645378ffccb7060a0df1a33aee38 upstream.

All error paths will want to keep the mm node, so handle this at the
function exit. This fixes an ioremap failure error path.
Also add some comments to make the function a bit easier to understand.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 037f101..2a90955 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -337,21 +337,25 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 	if (ret)
 		goto out;
 
+	/*
+	 * Single TTM move. NOP.
+	 */
 	if (old_iomap == NULL && new_iomap == NULL)
 		goto out2;
+
+	/*
+	 * Move nonexistent data. NOP.
+	 */
 	if (old_iomap == NULL && ttm == NULL)
 		goto out2;
 
-	/* TTM might be null for moves within the same region.
+	/*
+	 * TTM might be null for moves within the same region.
 	 */
 	if (ttm && ttm->state == tt_unpopulated) {
 		ret = ttm->bdev->driver->ttm_tt_populate(ttm);
-		if (ret) {
-			/* if we fail here don't nuke the mm node
-			 * as the bo still owns it */
-			old_copy.mm_node = NULL;
+		if (ret)
 			goto out1;
-		}
 	}
 
 	add = 0;
@@ -377,11 +381,8 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 						   prot);
 		} else
 			ret = ttm_copy_io_page(new_iomap, old_iomap, page);
-		if (ret) {
-			/* failing here, means keep old copy as-is */
-			old_copy.mm_node = NULL;
+		if (ret)
 			goto out1;
-		}
 	}
 	mb();
 out2:
@@ -399,7 +400,12 @@ out1:
 	ttm_mem_reg_iounmap(bdev, old_mem, new_iomap);
 out:
 	ttm_mem_reg_iounmap(bdev, &old_copy, old_iomap);
-	ttm_bo_mem_put(bo, &old_copy);
+
+	/*
+	 * On error, keep the mm node!
+	 */
+	if (!ret)
+		ttm_bo_mem_put(bo, &old_copy);
 	return ret;
 }
 EXPORT_SYMBOL(ttm_bo_move_memcpy);
-- 
1.8.3.2

