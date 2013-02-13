Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465Ab3BMUTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:19:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3BMUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:19:48 -0500
Date: Wed, 13 Feb 2013 15:19:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH] xen-blkfront: drop the use of llist_for_each_entry_safe
Message-ID: <20130213201941.GA21909@phenom.dumpdata.com>
References: <1360599058-1567-1-git-send-email-roger.pau@citrix.com>
 <20130213173312.GA20866@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213173312.GA20866@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:33:12PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 11, 2013 at 05:10:58PM +0100, Roger Pau Monne wrote:
> > Replace llist_for_each_entry_safe with a while loop and
> > llist_del_first.
> > 
> > llist_for_each_entry_safe can trigger a bug in GCC 4.1, so it's best
> > to remove it and use a while loop and llist_del_first (which is
> > already in llist.h).
> 
> I spruced this up a bit:

And then I re-tested it once more and it did _not_ fix the problem. But this
did fix it:

>From 5f9c7b8388af474f3692cd78fade6d047981dcde Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 13 Feb 2013 13:01:55 -0500
Subject: [PATCH] xen-blkfront: drop the use of llist_for_each_entry_safe

Replace llist_for_each_entry_safe with a while loop.

llist_for_each_entry_safe can trigger a bug in GCC 4.1, so it's best
to remove it and use a while loop and do the deletion manually.

Specifically this bug can be triggered by hot-unplugging a disk, either
by doing xm block-detach or by save/restore cycle.

BUG: unable to handle kernel paging request at fffffffffffffff0
IP: [<ffffffffa0047223>] blkif_free+0x63/0x130 [xen_blkfront]
The crash call trace is:
	...
bad_area_nosemaphore+0x13/0x20
do_page_fault+0x25e/0x4b0
page_fault+0x25/0x30
? blkif_free+0x63/0x130 [xen_blkfront]
blkfront_resume+0x46/0xa0 [xen_blkfront]
xenbus_dev_resume+0x6c/0x140
pm_op+0x192/0x1b0
device_resume+0x82/0x1e0
dpm_resume+0xc9/0x1a0
dpm_resume_end+0x15/0x30
do_suspend+0x117/0x1e0

When drilling down to the assembler code, on newer GCC it does
.L29:
        cmpq    $-16, %r12      #, persistent_gnt check
        je      .L30    	#, out of the loop
.L25:
	... code in the loop
        testq   %r13, %r13      # n
        je      .L29    	#, back to the top of the loop
        cmpq    $-16, %r12      #, persistent_gnt check
        movq    16(%r12), %r13  # <variable>.node.next, n
        jne     .L25    	#,	back to the top of the loop
.L30:

While on GCC 4.1, it is:
L78:
	... code in the loop
	testq   %r13, %r13      # n
        je      .L78    #,	back to the top of the loop
        movq    16(%rbx), %r13  # <variable>.node.next, n
        jmp     .L78    #,	back to the top of the loop

Which basically means that the exit loop condition instead of
being:

	&(pos)->member != NULL;

is:
	;

which makes the loop unbound.

Since xen-blkfront is the only user of the llist_for_each_entry_safe
macro remove it from llist.h.

Orabug: 16263164
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c | 13 ++++++++++---
 include/linux/llist.h        | 25 -------------------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 11043c1..c3dae2e 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -791,7 +791,7 @@ static void blkif_restart_queue(struct work_struct *work)
 static void blkif_free(struct blkfront_info *info, int suspend)
 {
 	struct llist_node *all_gnts;
-	struct grant *persistent_gnt;
+	struct grant *persistent_gnt, *tmp;
 	struct llist_node *n;
 
 	/* Prevent new requests being issued until we fix things up. */
@@ -805,10 +805,17 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	/* Remove all persistent grants */
 	if (info->persistent_gnts_c) {
 		all_gnts = llist_del_all(&info->persistent_gnts);
-		llist_for_each_entry_safe(persistent_gnt, n, all_gnts, node) {
+		persistent_gnt = llist_entry(all_gnts, typeof(*(persistent_gnt)), node);
+		while (persistent_gnt) {
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
 			__free_page(pfn_to_page(persistent_gnt->pfn));
-			kfree(persistent_gnt);
+			tmp = persistent_gnt;
+			n = persistent_gnt->node.next;
+			if (n)
+				persistent_gnt = llist_entry(n, typeof(*(persistent_gnt)), node);
+			else
+				persistent_gnt = NULL;
+			kfree(tmp);
 		}
 		info->persistent_gnts_c = 0;
 	}
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
1.8.0.2

