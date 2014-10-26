Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaJZNuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 09:50:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54218 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaJZNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 09:50:32 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com, richard@nod.at
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND 4/5 v2] mtd: ubi: Read threshold verification
Date: Sun, 26 Oct 2014 15:50:21 +0200
Message-Id: <1414331421-28674-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the criteria to scrub an eraseblock due to read disturb issue is
if that eraseblock was read from more times then a pre-defined threshold.
This is verified at each LEB read according to the read counter
parameter of the read PEB.
An eraseblock that is found needs scrubbing is added to the ubi->scrub
list.

Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
---
 drivers/mtd/ubi/eba.c |  7 ++++++-
 drivers/mtd/ubi/wl.c  | 56 +++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0e11671d..1c7b5f9 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1,5 +1,8 @@
 /*
  * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (c) 2014, Linux Foundation. All rights reserved.
+ * Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -466,8 +469,10 @@ retry:
 			goto out_unlock;
 		}
 	}
+	if (ubi->lookuptbl[pnum]->rc >= ubi->rd_threshold)
+		scrub = 1;
 
-	if (scrub)
+	if (scrub && !ubi_in_wl_tree(ubi->lookuptbl[pnum], &ubi->scrub))
 		err = ubi_wl_scrub_peb(ubi, pnum);
 
 	leb_read_unlock(ubi, vol_id, lnum);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 64c7dfd..a5d754f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -449,7 +449,7 @@ static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
 	return victim;
 }
 
-static int anchor_pebs_avalible(struct rb_root *root)
+static int anchor_pebs_avalible(struct rb_root *root, int rd_threshold)
 {
 	struct rb_node *p;
 	struct ubi_wl_entry *e;
@@ -560,6 +560,12 @@ static void return_unused_pool_pebs(struct ubi_device *ubi,
 
 	for (i = pool->used; i < pool->size; i++) {
 		e = ubi->lookuptbl[pool->pebs[i]];
+		/* If given PEB pending to be scrubbed - remove it */
+		if (ubi_in_wl_tree(e, &ubi->scrub)) {
+			ubi_err("PEB %d was pending scrubb", e->pnum);
+			self_check_in_wl_tree(ubi, e, &ubi->scrub);
+			rb_erase(&e->u.rb, &ubi->scrub);
+		}
 		wl_tree_add(e, &ubi->free);
 		ubi->free_count++;
 	}
@@ -919,6 +925,13 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	wl_wrk->lnum = lnum;
 	wl_wrk->torture = torture;
 
+	/* If given PEB pending to be scrubbed - remove it */
+	if (ubi_in_wl_tree(e, &ubi->scrub)) {
+		self_check_in_wl_tree(ubi, e, &ubi->scrub);
+		rb_erase(&e->u.rb, &ubi->scrub);
+		ubi_msg("PEB %d was pending scrubb",
+				e->pnum);
+	}
 	schedule_ubi_work(ubi, wl_wrk);
 	return 0;
 }
@@ -948,6 +961,14 @@ static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	wl_wrk->lnum = lnum;
 	wl_wrk->torture = torture;
 
+	/* If given PEB pending to be scrubbed - remove it */
+	if (ubi_in_wl_tree(e, &ubi->scrub)) {
+		self_check_in_wl_tree(ubi, e, &ubi->scrub);
+		rb_erase(&e->u.rb, &ubi->scrub);
+		ubi_msg("PEB %d was pending scrubb",
+				e->pnum);
+	}
+
 	return erase_worker(ubi, wl_wrk, 0);
 }
 
@@ -1052,7 +1073,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 #ifdef CONFIG_MTD_UBI_FASTMAP
 	/* Check whether we need to produce an anchor PEB */
 	if (!anchor)
-		anchor = !anchor_pebs_avalible(&ubi->free);
+		anchor = !anchor_pebs_avalible(&ubi->free, ubi->rd_threshold);
 
 	if (anchor) {
 		e1 = find_anchor_wl_entry(&ubi->used);
@@ -1613,6 +1634,8 @@ retry:
 		} else if (ubi_in_wl_tree(e, &ubi->scrub)) {
 			self_check_in_wl_tree(ubi, e, &ubi->scrub);
 			rb_erase(&e->u.rb, &ubi->scrub);
+			ubi_msg("PEB %d was pending scrubb",
+				e->pnum);
 		} else if (ubi_in_wl_tree(e, &ubi->erroneous)) {
 			self_check_in_wl_tree(ubi, e, &ubi->erroneous);
 			rb_erase(&e->u.rb, &ubi->erroneous);
@@ -1656,8 +1679,6 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum)
 {
 	struct ubi_wl_entry *e;
 
-	ubi_msg("schedule PEB %d for scrubbing", pnum);
-
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
@@ -1695,6 +1716,7 @@ retry:
 		}
 	}
 
+	ubi_msg("schedule PEB %d for scrubbing", pnum);
 	wl_tree_add(e, &ubi->scrub);
 	spin_unlock(&ubi->wl_lock);
 
@@ -1888,7 +1910,9 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	struct ubi_ainf_volume *av;
 	struct ubi_ainf_peb *aeb, *tmp;
 	struct ubi_wl_entry *e;
+	struct timeval tv;
 
+	do_gettimeofday(&tv);
 	ubi->used = ubi->erroneous = ubi->free = ubi->scrub = RB_ROOT;
 	spin_lock_init(&ubi->wl_lock);
 	mutex_init(&ubi->move_mutex);
@@ -1971,8 +1995,17 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ubi_assert(e->ec >= 0);
 		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 
-		wl_tree_add(e, &ubi->free);
-		ubi->free_count++;
+		/* Check last erase timestamp (in days) */
+		if (e->last_erase_time + ubi->dt_threshold <
+			(tv.tv_sec / NUM_SEC_IN_DAY)) {
+			if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
+				kmem_cache_free(ubi_wl_entry_slab, e);
+				goto out_free;
+			}
+		} else {
+			wl_tree_add(e, &ubi->free);
+			ubi->free_count++;
+		}
 
 		ubi->lookuptbl[e->pnum] = e;
 
@@ -2003,6 +2036,17 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			e->last_erase_time = aeb->last_erase_time;
 			ubi->lookuptbl[e->pnum] = e;
 
+			/*
+			 * Verify last erase timestamp
+			 * (in days) and read counter
+			 */
+			if (e->last_erase_time + ubi->dt_threshold <
+				(tv.tv_sec / NUM_SEC_IN_DAY) ||
+				e->rc > ubi->rd_threshold) {
+				ubi_msg("scrub PEB %d rc = %d",
+				       e->pnum, e->rc);
+				aeb->scrub = 1;
+			}
 			if (!aeb->scrub) {
 				dbg_wl("add PEB %d EC %d to the used tree",
 				       e->pnum, e->ec);
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project

