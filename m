Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3JJQGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:06:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3JJPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:46:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rafael Aquini <aquini@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 092/104] mm: avoid reinserting isolated balloon pages into LRU lists
Date: Thu, 10 Oct 2013 08:42:20 -0700
Message-Id: <1381419752-29733-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Aquini <aquini@redhat.com>

commit 117aad1e9e4d97448d1df3f84b08bd65811e6d6a upstream.

Isolated balloon pages can wrongly end up in LRU lists when
migrate_pages() finishes its round without draining all the isolated
page list.

The same issue can happen when reclaim_clean_pages_from_list() tries to
reclaim pages from an isolated page list, before migration, in the CMA
path.  Such balloon page leak opens a race window against LRU lists
shrinkers that leads us to the following kernel panic:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
  IP: [<ffffffff810c2625>] shrink_page_list+0x24e/0x897
  PGD 3cda2067 PUD 3d713067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 0 PID: 340 Comm: kswapd0 Not tainted 3.12.0-rc1-22626-g4367597 #87
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  RIP: shrink_page_list+0x24e/0x897
  RSP: 0000:ffff88003da499b8  EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff88003e82bd60 RCX: 00000000000657d5
  RDX: 0000000000000000 RSI: 000000000000031f RDI: ffff88003e82bd40
  RBP: ffff88003da49ab0 R08: 0000000000000001 R09: 0000000081121a45
  R10: ffffffff81121a45 R11: ffff88003c4a9a28 R12: ffff88003e82bd40
  R13: ffff88003da0e800 R14: 0000000000000001 R15: ffff88003da49d58
  FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000067d9000 CR3: 000000003ace5000 CR4: 00000000000407b0
  Call Trace:
    shrink_inactive_list+0x240/0x3de
    shrink_lruvec+0x3e0/0x566
    __shrink_zone+0x94/0x178
    shrink_zone+0x3a/0x82
    balance_pgdat+0x32a/0x4c2
    kswapd+0x2f0/0x372
    kthread+0xa2/0xaa
    ret_from_fork+0x7c/0xb0
  Code: 80 7d 8f 01 48 83 95 68 ff ff ff 00 4c 89 e7 e8 5a 7b 00 00 48 85 c0 49 89 c5 75 08 80 7d 8f 00 74 3e eb 31 48 8b 80 18 01 00 00 <48> 8b 74 0d 48 8b 78 30 be 02 00 00 00 ff d2 eb
  RIP  [<ffffffff810c2625>] shrink_page_list+0x24e/0x897
   RSP <ffff88003da499b8>
  CR2: 0000000000000028
  ---[ end trace 703d2451af6ffbfd ]---
  Kernel panic - not syncing: Fatal exception

This patch fixes the issue, by assuring the proper tests are made at
putback_movable_pages() & reclaim_clean_pages_from_list() to avoid
isolated balloon pages being wrongly reinserted in LRU lists.

[akpm@linux-foundation.org: clarify awkward comment text]
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reported-by: Luiz Capitulino <lcapitulino@redhat.com>
Tested-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/balloon_compaction.h | 25 +++++++++++++++++++++++++
 mm/migrate.c                       |  2 +-
 mm/vmscan.c                        |  4 +++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index f7f1d71..089743a 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -159,6 +159,26 @@ static inline bool balloon_page_movable(struct page *page)
 }
 
 /*
+ * isolated_balloon_page - identify an isolated balloon page on private
+ *			   compaction/migration page lists.
+ *
+ * After a compaction thread isolates a balloon page for migration, it raises
+ * the page refcount to prevent concurrent compaction threads from re-isolating
+ * the same page. For that reason putback_movable_pages(), or other routines
+ * that need to identify isolated balloon pages on private pagelists, cannot
+ * rely on balloon_page_movable() to accomplish the task.
+ */
+static inline bool isolated_balloon_page(struct page *page)
+{
+	/* Already isolated balloon pages, by default, have a raised refcount */
+	if (page_flags_cleared(page) && !page_mapped(page) &&
+	    page_count(page) >= 2)
+		return __is_movable_balloon_page(page);
+
+	return false;
+}
+
+/*
  * balloon_page_insert - insert a page into the balloon's page list and make
  *		         the page->mapping assignment accordingly.
  * @page    : page to be assigned as a 'balloon page'
@@ -243,6 +263,11 @@ static inline bool balloon_page_movable(struct page *page)
 	return false;
 }
 
+static inline bool isolated_balloon_page(struct page *page)
+{
+	return false;
+}
+
 static inline bool balloon_page_isolate(struct page *page)
 {
 	return false;
diff --git a/mm/migrate.c b/mm/migrate.c
index 8f1bd12..ba30b16 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -103,7 +103,7 @@ void putback_movable_pages(struct list_head *l)
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		if (unlikely(balloon_page_movable(page)))
+		if (unlikely(isolated_balloon_page(page)))
 			balloon_page_putback(page);
 		else
 			putback_lru_page(page);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6f50bc..8142623 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -47,6 +47,7 @@
 #include <asm/div64.h>
 
 #include <linux/swapops.h>
+#include <linux/balloon_compaction.h>
 
 #include "internal.h"
 
@@ -977,7 +978,8 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 	LIST_HEAD(clean_pages);
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
-		if (page_is_file_cache(page) && !PageDirty(page)) {
+		if (page_is_file_cache(page) && !PageDirty(page) &&
+		    !isolated_balloon_page(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
 		}
-- 
1.8.1.2

