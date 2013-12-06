Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422661Ab3LFNnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:43:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44205 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab3LFNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 137/272] drm/ttm: Fix ttm_bo_move_memcpy
Date: Fri,  6 Dec 2013 12:57:06 +0000
Message-Id: <1386334761-25517-138-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit da95c788ef0c645378ffccb7060a0df1a33aee38 upstream.

All error paths will want to keep the mm node, so handle this at the
function exit. This fixes an ioremap failure error path.
Also add some comments to make the function a bit easier to understand.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 657aeb2..a291aad 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -342,21 +342,25 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
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
@@ -382,11 +386,8 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
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
@@ -404,7 +405,12 @@ out1:
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

