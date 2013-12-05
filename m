Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3LERgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:36:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3LERgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 12/90] drm/ttm: Fix ttm_bo_move_memcpy
Date: Thu,  5 Dec 2013 17:34:54 +0000
Message-Id: <1386264972-5399-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit da95c788ef0c645378ffccb7060a0df1a33aee38 upstream.

All error paths will want to keep the mm node, so handle this at the
function exit. This fixes an ioremap failure error path.
Also add some comments to make the function a bit easier to understand.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 2d69262..05577e8 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -337,12 +337,20 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
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
@@ -392,7 +400,12 @@ out1:
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

