Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbaGBAMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:12:34 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44538 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaGBAMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:12:31 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 3/3] mm: Free reclaimed pages indepdent of next reclaim
Date: Wed,  2 Jul 2014 09:13:49 +0900
Message-Id: <1404260029-11525-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404260029-11525-1-git-send-email-minchan@kernel.org>
References: <1404260029-11525-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalidate dirty/writeback page and file/swap I/O for reclaiming
are asynchronous so that when page writeback is completed,
it will be rotated back into LRU tail for freeing in next reclaim.

But it would make unnecessary CPU overhead and more aging
with higher priority of reclaim than necessary thing.

This patch makes such pages instant release when I/O complete
without LRU movement so that we could reduce reclaim events.

This patch wakes up one waiting PG_writeback and then clear
PG_reclaim bit because the page could be released during
rotating so it makes slighly race with Readahead logic but
the chance would be small and no huge side-effect even though
that happens, I belive.

Test result is as follows,

On 1G, 12 CPU kvm guest, build kernel 5 times and result was

allocstall
vanilla: records: 5 avg: 4733.80 std: 913.55(19.30%) max: 6442.00 min: 3719.00
improve: records: 5 avg: 1514.20 std: 441.69(29.17%) max: 1974.00 min: 863.00

pgrotated
vanilla: records: 5 avg: 873313.80 std: 40999.20(4.69%) max: 954722.00 min: 845903.00
improve: records: 5 avg: 28406.40 std: 3296.02(11.60%) max: 34552.00 min: 25047.00

Most of field in vmstat are not changed too much but things I can notice
is allocstall and pgrotated. We could save allocstall(ie, direct relcaim)
and pgrotated very much.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/filemap.c | 17 +++++++++++------
 mm/swap.c    | 21 +++++++++++++++++++++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c2f30ed8e95f..6e09de6cf510 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -752,23 +752,28 @@ EXPORT_SYMBOL(unlock_page);
  */
 void end_page_writeback(struct page *page)
 {
+	if (!test_clear_page_writeback(page))
+		BUG();
+
+	smp_mb__after_atomic();
+	wake_up_page(page, PG_writeback);
+
 	/*
 	 * TestClearPageReclaim could be used here but it is an atomic
 	 * operation and overkill in this particular case. Failing to
 	 * shuffle a page marked for immediate reclaim is too mild to
 	 * justify taking an atomic operation penalty at the end of
 	 * ever page writeback.
+	 *
+	 * Clearing PG_reclaim after waking up waiter is slightly racy.
+	 * Readahead might see PageReclaim as PageReadahead marker
+	 * so readahead logic might be broken temporally but it isn't
+	 * matter enough to care.
 	 */
 	if (PageReclaim(page)) {
 		ClearPageReclaim(page);
 		rotate_reclaimable_page(page);
 	}
-
-	if (!test_clear_page_writeback(page))
-		BUG();
-
-	smp_mb__after_atomic();
-	wake_up_page(page, PG_writeback);
 }
 EXPORT_SYMBOL(end_page_writeback);
 
diff --git a/mm/swap.c b/mm/swap.c
index 3074210f245d..d61b8783ccc3 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -443,6 +443,27 @@ static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec,
 
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		enum lru_list lru = page_lru_base_type(page);
+		struct address_space *mapping;
+
+		if (!trylock_page(page))
+			goto move_tail;
+
+		mapping = page_mapping(page);
+		if (!mapping)
+			goto unlock;
+
+		/*
+		 * If it is successful, aotmic_remove_mapping
+		 * makes page->count one so the page will be
+		 * released when caller release his refcount.
+		 */
+		if (atomic_remove_mapping(mapping, page)) {
+			unlock_page(page);
+			return;
+		}
+unlock:
+		unlock_page(page);
+move_tail:
 		list_move_tail(&page->lru, &lruvec->lists[lru]);
 		(*pgmoved)++;
 	}
-- 
2.0.0

