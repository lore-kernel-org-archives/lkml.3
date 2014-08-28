Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaH1Sny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:43:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbaH1ShV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:21 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 92/97] mm: pagemap: avoid unnecessary overhead when tracepoints are deactivated
Date: Thu, 28 Aug 2014 19:35:40 +0100
Message-Id: <1409250945-30874-93-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 24b7e5819ad5cbef2b7c7376510862aa8319d240 upstream.

This was formerly the series "Improve sequential read throughput" which
noted some major differences in performance of tiobench since 3.0.
While there are a number of factors, two that dominated were the
introduction of the fair zone allocation policy and changes to CFQ.

The behaviour of fair zone allocation policy makes more sense than
tiobench as a benchmark and CFQ defaults were not changed due to
insufficient benchmarking.

This series is what's left.  It's one functional fix to the fair zone
allocation policy when used on NUMA machines and a reduction of overhead
in general.  tiobench was used for the comparison despite its flaws as
an IO benchmark as in this case we are primarily interested in the
overhead of page allocator and page reclaim activity.

On UMA, it makes little difference to overhead

          3.16.0-rc3   3.16.0-rc3
             vanilla lowercost-v5
User          383.61      386.77
System        403.83      401.74
Elapsed      5411.50     5413.11

On a 4-socket NUMA machine it's a bit more noticable

          3.16.0-rc3   3.16.0-rc3
             vanilla lowercost-v5
User          746.94      802.00
System      65336.22    40852.33
Elapsed     27553.52    27368.46

This patch (of 6):

The LRU insertion and activate tracepoints take PFN as a parameter
forcing the overhead to the caller.  Move the overhead to the tracepoint
fast-assign method to ensure the cost is only incurred when the
tracepoint is active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/trace/events/pagemap.h | 16 +++++++---------
 mm/swap.c                      |  4 ++--
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 1c9fabd..ce0803b 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -28,12 +28,10 @@ TRACE_EVENT(mm_lru_insertion,
 
 	TP_PROTO(
 		struct page *page,
-		unsigned long pfn,
-		int lru,
-		unsigned long flags
+		int lru
 	),
 
-	TP_ARGS(page, pfn, lru, flags),
+	TP_ARGS(page, lru),
 
 	TP_STRUCT__entry(
 		__field(struct page *,	page	)
@@ -44,9 +42,9 @@ TRACE_EVENT(mm_lru_insertion,
 
 	TP_fast_assign(
 		__entry->page	= page;
-		__entry->pfn	= pfn;
+		__entry->pfn	= page_to_pfn(page);
 		__entry->lru	= lru;
-		__entry->flags	= flags;
+		__entry->flags	= trace_pagemap_flags(page);
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
@@ -64,9 +62,9 @@ TRACE_EVENT(mm_lru_insertion,
 
 TRACE_EVENT(mm_lru_activate,
 
-	TP_PROTO(struct page *page, unsigned long pfn),
+	TP_PROTO(struct page *page),
 
-	TP_ARGS(page, pfn),
+	TP_ARGS(page),
 
 	TP_STRUCT__entry(
 		__field(struct page *,	page	)
@@ -75,7 +73,7 @@ TRACE_EVENT(mm_lru_activate,
 
 	TP_fast_assign(
 		__entry->page	= page;
-		__entry->pfn	= pfn;
+		__entry->pfn	= page_to_pfn(page);
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
diff --git a/mm/swap.c b/mm/swap.c
index 845e91f..16e70ce 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -437,7 +437,7 @@ static void __activate_page(struct page *page, struct lruvec *lruvec,
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(page, lruvec, lru);
-		trace_mm_lru_activate(page, page_to_pfn(page));
+		trace_mm_lru_activate(page);
 
 		__count_vm_event(PGACTIVATE);
 		update_page_reclaim_stat(lruvec, file, 1);
@@ -930,7 +930,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, lru);
 	update_page_reclaim_stat(lruvec, file, active);
-	trace_mm_lru_insertion(page, page_to_pfn(page), lru, trace_pagemap_flags(page));
+	trace_mm_lru_insertion(page, lru);
 }
 
 /*
-- 
1.8.4.5

