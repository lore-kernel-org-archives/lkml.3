Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3LBU46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:56:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3LBTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.10 096/173] drm/ttm: Fix ttm_bo_move_memcpy
Date: Mon,  2 Dec 2013 11:11:19 -0800
Message-Id: <20131202191154.992659466@linuxfoundation.org>
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

commit da95c788ef0c645378ffccb7060a0df1a33aee38 upstream.

All error paths will want to keep the mm node, so handle this at the
function exit. This fixes an ioremap failure error path.
Also add some comments to make the function a bit easier to understand.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo_util.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -342,21 +342,25 @@ int ttm_bo_move_memcpy(struct ttm_buffer
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
@@ -382,11 +386,8 @@ int ttm_bo_move_memcpy(struct ttm_buffer
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


