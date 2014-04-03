Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaDCPkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:40:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaDCPkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:40:43 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Yong-Taek Lee <ytk.lee@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/2] mm/page_alloc: DEBUG_VM checks for free_list placement of CMA and RESERVE pages
Date: Thu,  3 Apr 2014 17:40:18 +0200
Message-Id: <1396539618-31362-2-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396539618-31362-1-git-send-email-vbabka@suse.cz>
References: <533D8015.1000106@suse.cz>
 <1396539618-31362-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the MIGRATE_RESERVE pages, it is important they do not get misplaced
on free_list of other migratetype, otherwise the whole MIGRATE_RESERVE
pageblock might be changed to other migratetype in try_to_steal_freepages().
For MIGRATE_CMA, the pages also must not go to a different free_list, otherwise
they could get allocated as unmovable and result in CMA failure.

This is ensured by setting the freepage_migratetype appropriately when placing
pages on pcp lists, and using the information when releasing them back to
free_list. It is also assumed that CMA and RESERVE pageblocks are created only
in the init phase. This patch adds DEBUG_VM checks to catch any regressions
introduced for this invariant.

Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h | 19 +++++++++++++++++++
 mm/page_alloc.c    |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c1b7414..27a74ba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -280,6 +280,25 @@ static inline int get_freepage_migratetype(struct page *page)
 }
 
 /*
+ * Check that a freepage cannot end up on a wrong free_list for "sensitive"
+ * migratetypes. Return false if it could. Useful for VM_BUG_ON checks.
+ */
+static inline bool check_freepage_migratetype(struct page *page)
+{
+	int pageblock_mt = get_pageblock_migratetype(page);
+	int freepage_mt = get_freepage_migratetype(page);
+
+	/*
+	 * For RESERVE and CMA pageblocks, the freepage_migratetype must
+	 * match their migratetype. For other pageblocks, we don't care.
+	 */
+	if (pageblock_mt != MIGRATE_RESERVE && !is_migrate_cma(pageblock_mt))
+		return true;
+
+	return (freepage_mt == pageblock_mt);
+}
+
+/*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2dbaba1..0ee9f8c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -697,6 +697,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+
+			VM_BUG_ON(!check_freepage_migratetype(page));
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
@@ -1190,6 +1192,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
+		VM_BUG_ON(!check_freepage_migratetype(page));
 
 		/*
 		 * Split buddy pages returned by expand() are received here
-- 
1.8.4.5

