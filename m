Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaI1Ghs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 02:37:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54162 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaI1Ghq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 02:37:46 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedeking1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 3/5] mtd: ubi: Make in_wl_tree function public
Date: Sun, 28 Sep 2014 09:37:37 +0300
Message-Id: <1411886257-8603-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatyana Brokhman <tlinder@codeaurora.org>

Make the in_wl_tree function public to be used outside of wl.c.
Rename it to ubi_in_wl_tree.

Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
---
 drivers/mtd/ubi/ubi.h |  1 +
 drivers/mtd/ubi/wl.c  | 18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index e4c97ad..ed04de2 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -872,6 +872,7 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e,
 int ubi_is_erase_work(struct ubi_work *wrk);
 void ubi_refill_pools(struct ubi_device *ubi);
 int ubi_ensure_anchor_pebs(struct ubi_device *ubi);
+int ubi_in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 2b4e6fe..64c7dfd 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -291,14 +291,14 @@ static int produce_free_peb(struct ubi_device *ubi)
 }
 
 /**
- * in_wl_tree - check if wear-leveling entry is present in a WL RB-tree.
+ * ubi_in_wl_tree - check if wear-leveling entry is present in a WL RB-tree.
  * @e: the wear-leveling entry to check
  * @root: the root of the tree
  *
  * This function returns non-zero if @e is in the @root RB-tree and zero if it
  * is not.
  */
-static int in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
+int ubi_in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
 {
 	struct rb_node *p;
 
@@ -1607,13 +1607,13 @@ retry:
 		spin_unlock(&ubi->wl_lock);
 		return 0;
 	} else {
-		if (in_wl_tree(e, &ubi->used)) {
+		if (ubi_in_wl_tree(e, &ubi->used)) {
 			self_check_in_wl_tree(ubi, e, &ubi->used);
 			rb_erase(&e->u.rb, &ubi->used);
-		} else if (in_wl_tree(e, &ubi->scrub)) {
+		} else if (ubi_in_wl_tree(e, &ubi->scrub)) {
 			self_check_in_wl_tree(ubi, e, &ubi->scrub);
 			rb_erase(&e->u.rb, &ubi->scrub);
-		} else if (in_wl_tree(e, &ubi->erroneous)) {
+		} else if (ubi_in_wl_tree(e, &ubi->erroneous)) {
 			self_check_in_wl_tree(ubi, e, &ubi->erroneous);
 			rb_erase(&e->u.rb, &ubi->erroneous);
 			ubi->erroneous_peb_count -= 1;
@@ -1661,8 +1661,8 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum)
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
-	if (e == ubi->move_from || in_wl_tree(e, &ubi->scrub) ||
-				   in_wl_tree(e, &ubi->erroneous)) {
+	if (e == ubi->move_from || ubi_in_wl_tree(e, &ubi->scrub) ||
+				   ubi_in_wl_tree(e, &ubi->erroneous)) {
 		spin_unlock(&ubi->wl_lock);
 		return 0;
 	}
@@ -1680,7 +1680,7 @@ retry:
 		goto retry;
 	}
 
-	if (in_wl_tree(e, &ubi->used)) {
+	if (ubi_in_wl_tree(e, &ubi->used)) {
 		self_check_in_wl_tree(ubi, e, &ubi->used);
 		rb_erase(&e->u.rb, &ubi->used);
 	} else {
@@ -2150,7 +2150,7 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 	if (!ubi_dbg_chk_gen(ubi))
 		return 0;
 
-	if (in_wl_tree(e, root))
+	if (ubi_in_wl_tree(e, root))
 		return 0;
 
 	ubi_err("self-check failed for PEB %d, EC %d, RB-tree %p ",
-- 
1.8.5.2
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
