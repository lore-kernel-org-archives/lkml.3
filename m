Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaK3MWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:22:51 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaK3MWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:22:46 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] UBI: Fastmap: Remove is_fm_block()
Date: Sun, 30 Nov 2014 13:22:36 +0100
Message-Id: <1417350157-9373-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417350157-9373-1-git-send-email-richard@nod.at>
References: <1417350157-9373-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was added to fastmap in a very early stage
to have paranoid assertions.
With the current fastmap implementation this assert will never
trigger as fastmap PEBs are not seen by the WL sub-system.
Remove it to save us some CPU cycles.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap-wl.c | 19 -------------------
 drivers/mtd/ubi/wl.c         |  5 -----
 drivers/mtd/ubi/wl.h         |  5 -----
 3 files changed, 29 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 067aa90..b2a6653 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -29,25 +29,6 @@ static void update_fastmap_work_fn(struct work_struct *wrk)
 }
 
 /**
- *  is_fm_block - returns 1 if a PEB is currently used in a fastmap.
- *  @ubi: UBI device description object
- *  @pnum: the to be checked PEB
- */
-static int is_fm_block(struct ubi_device *ubi, int pnum)
-{
-	int i;
-
-	if (!ubi->fm)
-		return 0;
-
-	for (i = 0; i < ubi->fm->used_blocks; i++)
-		if (ubi->fm->e[i]->pnum == pnum)
-			return 1;
-
-	return 0;
-}
-
-/**
  * find_anchor_wl_entry - find wear-leveling entry to used as anchor PEB.
  * @root: the RB-tree where to look for
  */
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index c51c4e8..f642740 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -585,7 +585,6 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	struct ubi_work *wl_wrk;
 
 	ubi_assert(e);
-	ubi_assert(!is_fm_block(ubi, e->pnum));
 
 	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
 	       e->pnum, e->ec, torture);
@@ -1045,8 +1044,6 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	dbg_wl("erase PEB %d EC %d LEB %d:%d",
 	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);
 
-	ubi_assert(!is_fm_block(ubi, e->pnum));
-
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		/* Fine, we've erased it successfully */
@@ -1526,7 +1523,6 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
-		ubi_assert(!is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
 			wl_entry_destroy(ubi, e);
@@ -1547,7 +1543,6 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
 		ubi_assert(e->ec >= 0);
-		ubi_assert(!is_fm_block(ubi, e->pnum));
 
 		wl_tree_add(e, &ubi->free);
 		ubi->free_count++;
diff --git a/drivers/mtd/ubi/wl.h b/drivers/mtd/ubi/wl.h
index fbc2d8e..bd1f07e 100644
--- a/drivers/mtd/ubi/wl.h
+++ b/drivers/mtd/ubi/wl.h
@@ -1,7 +1,6 @@
 #ifndef UBI_WL_H
 #define UBI_WL_H
 #ifdef CONFIG_MTD_UBI_FASTMAP
-static int is_fm_block(struct ubi_device *ubi, int pnum);
 static int anchor_pebs_avalible(struct rb_root *root);
 static void update_fastmap_work_fn(struct work_struct *wrk);
 static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root);
@@ -18,10 +17,6 @@ static struct ubi_wl_entry *may_reserve_for_fm(struct ubi_device *ubi,
 					       struct rb_root *root);
 #else /* !CONFIG_MTD_UBI_FASTMAP */
 static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
-static inline int is_fm_block(struct ubi_device *ubi, int pnum)
-{
-	return 0;
-}
 static inline void ubi_fastmap_close(struct ubi_device *ubi) { }
 static inline void ubi_fastmap_init(struct ubi_device *ubi, int *count) { }
 static struct ubi_wl_entry *may_reserve_for_fm(struct ubi_device *ubi,
-- 
1.8.4.5

