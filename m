Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaBRX1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:27:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaBRWqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 15/26] mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()
Date: Tue, 18 Feb 2014 14:47:11 -0800
Message-Id: <20140218224530.844334403@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit a85d9df1ea1d23682a0ed1e100e6965006595d06 upstream.

During aio stress test, we observed the following lockdep warning.  This
mean AIO+numa_balancing is currently deadlockable.

The problem is, aio_migratepage disable interrupt, but
__set_page_dirty_nobuffers unintentionally enable it again.

Generally, all helper function should use spin_lock_irqsave() instead of
spin_lock_irq() because they don't know caller at all.

   other info that might help us debug this:
    Possible unsafe locking scenario:

          CPU0
          ----
     lock(&(&ctx->completion_lock)->rlock);
     <Interrupt>
       lock(&(&ctx->completion_lock)->rlock);

    *** DEADLOCK ***

      dump_stack+0x19/0x1b
      print_usage_bug+0x1f7/0x208
      mark_lock+0x21d/0x2a0
      mark_held_locks+0xb9/0x140
      trace_hardirqs_on_caller+0x105/0x1d0
      trace_hardirqs_on+0xd/0x10
      _raw_spin_unlock_irq+0x2c/0x50
      __set_page_dirty_nobuffers+0x8c/0xf0
      migrate_page_copy+0x434/0x540
      aio_migratepage+0xb1/0x140
      move_to_new_page+0x7d/0x230
      migrate_pages+0x5e5/0x700
      migrate_misplaced_page+0xbc/0xf0
      do_numa_page+0x102/0x190
      handle_pte_fault+0x241/0x970
      handle_mm_fault+0x265/0x370
      __do_page_fault+0x172/0x5a0
      do_page_fault+0x1a/0x70
      page_fault+0x28/0x30

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2026,11 +2026,12 @@ int __set_page_dirty_nobuffers(struct pa
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 		struct address_space *mapping2;
+		unsigned long flags;
 
 		if (!mapping)
 			return 1;
 
-		spin_lock_irq(&mapping->tree_lock);
+		spin_lock_irqsave(&mapping->tree_lock, flags);
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
@@ -2039,7 +2040,7 @@ int __set_page_dirty_nobuffers(struct pa
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
-		spin_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);


