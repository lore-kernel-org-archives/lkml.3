Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaJ2My1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:54:27 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14394 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbaJ2MqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:14 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 09/35] UBI: Fastmap: Make ubi_refill_pools() fair
Date: Wed, 29 Oct 2014 13:45:32 +0100
Message-Id: <1414586758-9972-10-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ubi_refill_pools() first fills the first and then
the second one.
If only very few free PEBs are available the second pool can get
zero PEBs.
Change ubi_refill_pools() to distribute free PEBs fair between
all pools.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 73 ++++++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 95bb12b..0639353 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -571,59 +571,58 @@ static void return_unused_pool_pebs(struct ubi_device *ubi,
 }
 
 /**
- * refill_wl_pool - refills all the fastmap pool used by the
- * WL sub-system.
+ * ubi_refill_pools - refills all fastmap PEB pools.
  * @ubi: UBI device description object
  */
-static void refill_wl_pool(struct ubi_device *ubi)
+void ubi_refill_pools(struct ubi_device *ubi)
 {
+	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
 	struct ubi_wl_entry *e;
-	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
+	int enough;
 
+	spin_lock(&ubi->wl_lock);
+
+	return_unused_pool_pebs(ubi, wl_pool);
 	return_unused_pool_pebs(ubi, pool);
 
-	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
-		if (!ubi->free.rb_node ||
-		   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
-			break;
+	wl_pool->size = 0;
+	pool->size = 0;
 
-		e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
-		self_check_in_wl_tree(ubi, e, &ubi->free);
-		rb_erase(&e->u.rb, &ubi->free);
-		ubi->free_count--;
+	for (;;) {
+		enough = 0;
+		if (pool->size < pool->max_size) {
+			e = wl_get_wle(ubi);
+			if (!e)
+				break;
 
-		pool->pebs[pool->size] = e->pnum;
-	}
-	pool->used = 0;
-}
+			pool->pebs[pool->size] = e->pnum;
+			pool->size++;
+		} else
+			enough++;
 
-/**
- * refill_wl_user_pool - refills all the fastmap pool used by ubi_wl_get_peb.
- * @ubi: UBI device description object
- */
-static void refill_wl_user_pool(struct ubi_device *ubi)
-{
-	struct ubi_fm_pool *pool = &ubi->fm_pool;
+		if (wl_pool->size < wl_pool->max_size) {
+			if (!ubi->free.rb_node ||
+			   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
+				break;
 
-	return_unused_pool_pebs(ubi, pool);
+			e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
+			self_check_in_wl_tree(ubi, e, &ubi->free);
+			rb_erase(&e->u.rb, &ubi->free);
+			ubi->free_count--;
+
+			wl_pool->pebs[wl_pool->size] = e->pnum;
+			wl_pool->size++;
+		} else
+			enough++;
 
-	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
-		pool->pebs[pool->size] = __wl_get_peb(ubi);
-		if (pool->pebs[pool->size] < 0)
+		if (enough == 2)
 			break;
 	}
+
+	wl_pool->used = 0;
 	pool->used = 0;
-}
 
-/**
- * ubi_refill_pools - refills all fastmap PEB pools.
- * @ubi: UBI device description object
- */
-void ubi_refill_pools(struct ubi_device *ubi)
-{
-	spin_lock(&ubi->wl_lock);
-	refill_wl_pool(ubi);
-	refill_wl_user_pool(ubi);
 	spin_unlock(&ubi->wl_lock);
 }
 
-- 
1.8.4.5

