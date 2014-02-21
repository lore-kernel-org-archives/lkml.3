Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaBUNB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:01:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbaBUNBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:01:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/60] mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()
Date: Fri, 21 Feb 2014 13:00:41 +0000
Message-Id: <1392987687-15367-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/page-writeback.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 31ea8e2..82a1891 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1987,11 +1987,12 @@ int __set_page_dirty_nobuffers(struct page *page)
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
@@ -2000,7 +2001,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
-		spin_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-- 
1.9.0

