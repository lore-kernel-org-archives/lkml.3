Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaBCQuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:50:20 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37097 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaBCQuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:50:15 -0500
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] mm: __set_page_dirty_nobuffers uses spin_lock_irqseve instead of spin_lock_irq
Date: Mon,  3 Feb 2014 11:49:55 -0500
Message-Id: <1391446195-9457-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

During aio stress test, we observed the following lockdep warning.
This mean AIO+numa_balancing is currently deadlockable.

The problem is, aio_migratepage disable interrupt, but __set_page_dirty_nobuffers
unintentionally enable it again.

Generally, all helper function should use spin_lock_irqsave()
instead of spin_lock_irq() because they don't know caller at all.

[  599.843948] other info that might help us debug this:
[  599.873748]  Possible unsafe locking scenario:
[  599.873748]
[  599.900902]        CPU0
[  599.912701]        ----
[  599.924929]   lock(&(&ctx->completion_lock)->rlock);
[  599.950299]   <Interrupt>
[  599.962576]     lock(&(&ctx->completion_lock)->rlock);
[  599.985771]
[  599.985771]  *** DEADLOCK ***

[  600.375623]  [<ffffffff81678d3c>] dump_stack+0x19/0x1b
[  600.398769]  [<ffffffff816731aa>] print_usage_bug+0x1f7/0x208
[  600.425092]  [<ffffffff810df370>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[  600.458981]  [<ffffffff810e08dd>] mark_lock+0x21d/0x2a0
[  600.482910]  [<ffffffff810e0a19>] mark_held_locks+0xb9/0x140
[  600.508956]  [<ffffffff8168201c>] ? _raw_spin_unlock_irq+0x2c/0x50
[  600.536825]  [<ffffffff810e0ba5>] trace_hardirqs_on_caller+0x105/0x1d0
[  600.566861]  [<ffffffff810e0c7d>] trace_hardirqs_on+0xd/0x10
[  600.593210]  [<ffffffff8168201c>] _raw_spin_unlock_irq+0x2c/0x50
[  600.620599]  [<ffffffff8117f72c>] __set_page_dirty_nobuffers+0x8c/0xf0
[  600.649992]  [<ffffffff811d1094>] migrate_page_copy+0x434/0x540
[  600.676635]  [<ffffffff8123f5b1>] aio_migratepage+0xb1/0x140
[  600.703126]  [<ffffffff811d126d>] move_to_new_page+0x7d/0x230
[  600.729022]  [<ffffffff811d1b45>] migrate_pages+0x5e5/0x700
[  600.754705]  [<ffffffff811d0070>] ? buffer_migrate_lock_buffers+0xb0/0xb0
[  600.785784]  [<ffffffff811d29cc>] migrate_misplaced_page+0xbc/0xf0
[  600.814029]  [<ffffffff8119eb62>] do_numa_page+0x102/0x190
[  600.839182]  [<ffffffff8119ee31>] handle_pte_fault+0x241/0x970
[  600.865875]  [<ffffffff811a0345>] handle_mm_fault+0x265/0x370
[  600.892071]  [<ffffffff81686d82>] __do_page_fault+0x172/0x5a0
[  600.918065]  [<ffffffff81682cd8>] ? retint_swapgs+0x13/0x1b
[  600.943493]  [<ffffffff816871ca>] do_page_fault+0x1a/0x70
[  600.968081]  [<ffffffff81682ff8>] page_fault+0x28/0x30

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: stable@vger.kernel.org
---
 mm/page-writeback.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2d30e2c..7106cb1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2173,11 +2173,12 @@ int __set_page_dirty_nobuffers(struct page *page)
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
@@ -2186,7 +2187,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
-		spin_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-- 
1.7.1

