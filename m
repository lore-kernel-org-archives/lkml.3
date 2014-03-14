Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaCNGh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:37:56 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51646 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaCNGh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:37:29 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-df-5322a3a5cb5d
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 4/6] mm: add stat about lazyfree pages
Date: Fri, 14 Mar 2014 15:37:48 +0900
Message-Id: <1394779070-8545-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394779070-8545-1-git-send-email-minchan@kernel.org>
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new vmstat for lazyfree pages so that admin
could check how many of lazyfree pages remains each zone
and how many of lazyfree pages purged until now.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/mm.h            | 4 ++++
 include/linux/mmzone.h        | 1 +
 include/linux/vm_event_item.h | 1 +
 mm/page_alloc.c               | 5 ++++-
 mm/vmscan.c                   | 1 +
 mm/vmstat.c                   | 2 ++
 6 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9b048cabce27..498613946991 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -975,6 +975,8 @@ static inline void SetPageLazyFree(struct page *page)
 
 	page->mapping = (void *)((unsigned long)page->mapping |
 			PAGE_MAPPING_LZFREE);
+
+	__inc_zone_page_state(page, NR_LAZYFREE_PAGES);
 }
 
 static inline void ClearPageLazyFree(struct page *page)
@@ -984,6 +986,8 @@ static inline void ClearPageLazyFree(struct page *page)
 
 	page->mapping = (void *)((unsigned long)page->mapping &
 				~PAGE_MAPPING_LZFREE);
+
+	__dec_zone_page_state(page, NR_LAZYFREE_PAGES);
 }
 
 static inline int PageLazyFree(struct page *page)
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5f2052c83154..7366ec56ea73 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -113,6 +113,7 @@ enum zone_stat_item {
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
+	NR_LAZYFREE_PAGES,	/* freeable pages at memory pressure */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 3a712e2e7d76..6b5b870895da 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -25,6 +25,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
+		PGLAZYFREE,
 		FOR_ALL_ZONES(PGREFILL),
 		FOR_ALL_ZONES(PGSTEAL_KSWAPD),
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3bac76ae4b30..596f24ecf397 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -731,8 +731,11 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
-	if (PageAnon(page))
+	if (PageAnon(page)) {
+		if (PageLazyFree(page))
+			__dec_zone_page_state(page, NR_LAZYFREE_PAGES);
 		page->mapping = NULL;
+	}
 	for (i = 0; i < (1 << order); i++)
 		bad += free_pages_check(page + i);
 	if (bad)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0ab38faebe98..98a1c3ffcaab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -832,6 +832,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 				if (!page_freeze_refs(page, 1))
 					goto keep_locked;
 				unlock_page(page);
+				count_vm_event(PGLAZYFREE);
 				goto free_it;
 			}
 		}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index def5dd2fbe61..4235aeb9b96e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -742,6 +742,7 @@ const char * const vmstat_text[] = {
 	"nr_active_file",
 	"nr_unevictable",
 	"nr_mlock",
+	"nr_lazyfree_pages",
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
@@ -789,6 +790,7 @@ const char * const vmstat_text[] = {
 
 	"pgfault",
 	"pgmajfault",
+	"pglazyfree",
 
 	TEXTS_FOR_ZONES("pgrefill")
 	TEXTS_FOR_ZONES("pgsteal_kswapd")
-- 
1.9.0

