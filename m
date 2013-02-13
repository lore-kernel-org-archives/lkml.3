Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab3BMRdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:33:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49311 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180Ab3BMRde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:33:34 -0500
Date: Wed, 13 Feb 2013 12:33:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH] xen-blkfront: drop the use of llist_for_each_entry_safe
Message-ID: <20130213173312.GA20866@phenom.dumpdata.com>
References: <1360599058-1567-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1360599058-1567-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 05:10:58PM +0100, Roger Pau Monne wrote:
> Replace llist_for_each_entry_safe with a while loop and
> llist_del_first.
> 
> llist_for_each_entry_safe can trigger a bug in GCC 4.1, so it's best
> to remove it and use a while loop and llist_del_first (which is
> already in llist.h).

I spruced this up a bit:

commit f73be4e09510cda1457ab96abf356e664ba96d4a
Author: Roger Pau Monne <roger.pau@citrix.com>
Date:   Mon Feb 11 17:10:58 2013 +0100

    xen-blkfront: drop the use of llist_for_each_entry_safe
    
    Replace llist_for_each_entry_safe with a while loop and
    llist_del_first.
    
    llist_for_each_entry_safe can trigger a bug in GCC 4.1, so it's best
    to remove it and use a while loop and llist_del_first (which is
    already in llist.h).
    
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
    
    Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
    Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Cc: xen-devel@lists.xen.org
    [v1: Spruced the description]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

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
