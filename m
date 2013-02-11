Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab3BKQMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:12:23 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:54858 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab3BKQMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:12:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,643,1355097600"; 
   d="scan'208";a="1337408"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen-blkfront: drop the use of llist_for_each_entry_safe
Date: Mon, 11 Feb 2013 17:10:58 +0100
Message-ID: <1360599058-1567-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace llist_for_each_entry_safe with a while loop and
llist_del_first.

llist_for_each_entry_safe can trigger a bug in GCC 4.1, so it's best
to remove it and use a while loop and llist_del_first (which is
already in llist.h).

Since xen-blkfront is the only user of the llist_for_each_entry_safe
macro remove it from llist.h.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    5 ++---
 include/linux/llist.h        |   25 -------------------------
 2 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 11043c1..c325062 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -790,7 +790,6 @@ static void blkif_restart_queue(struct work_struct *work)
 
 static void blkif_free(struct blkfront_info *info, int suspend)
 {
-	struct llist_node *all_gnts;
 	struct grant *persistent_gnt;
 	struct llist_node *n;
 
@@ -804,8 +803,8 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 
 	/* Remove all persistent grants */
 	if (info->persistent_gnts_c) {
-		all_gnts = llist_del_all(&info->persistent_gnts);
-		llist_for_each_entry_safe(persistent_gnt, n, all_gnts, node) {
+		while ((n = llist_del_first(&info->persistent_gnts)) != NULL) {
+			persistent_gnt = llist_entry(n, struct grant, node);
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
 			__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
diff --git a/include/linux/llist.h b/include/linux/llist.h
index d0ab98f..a5199f6 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -125,31 +125,6 @@ static inline void init_llist_head(struct llist_head *list)
 	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
- * llist_for_each_entry_safe - iterate safely against remove over some entries
- * of lock-less list of given type.
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as a temporary storage.
- * @node:	the fist entry of deleted list entries.
- * @member:	the name of the llist_node with the struct.
- *
- * In general, some entries of the lock-less list can be traversed
- * safely only after being removed from list, so start with an entry
- * instead of list head. This variant allows removal of entries
- * as we iterate.
- *
- * If being used on entries deleted from lock-less list directly, the
- * traverse order is from the newest to the oldest added entry.  If
- * you want to traverse from the oldest to the newest, you must
- * reverse the order by yourself before traversing.
- */
-#define llist_for_each_entry_safe(pos, n, node, member)		\
-	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
-	     (n) = (pos)->member.next;					\
-	     &(pos)->member != NULL;					\
-	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
-	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
-
-/**
  * llist_empty - tests whether a lock-less list is empty
  * @head:	the list to test
  *
-- 
1.7.7.5 (Apple Git-26)

