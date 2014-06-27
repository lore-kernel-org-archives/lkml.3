Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaF0IOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:14:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaF0IOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:14:44 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/5] mm: pagemap: Avoid unnecessary overhead when tracepoints are deactivated
Date: Fri, 27 Jun 2014 09:14:36 +0100
Message-Id: <1403856880-12597-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403856880-12597-1-git-send-email-mgorman@suse.de>
References: <1403856880-12597-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LRU insertion and activate tracepoints take PFN as a parameter forcing
the overhead to the caller.  Move the overhead to the tracepoint fast-assign
method to ensure the cost is only incurred when the tracepoint is active.

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
index 9e8e347..d10be45 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -501,7 +501,7 @@ static void __activate_page(struct page *page, struct lruvec *lruvec,
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(page, lruvec, lru);
-		trace_mm_lru_activate(page, page_to_pfn(page));
+		trace_mm_lru_activate(page);
 
 		__count_vm_event(PGACTIVATE);
 		update_page_reclaim_stat(lruvec, file, 1);
@@ -996,7 +996,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, lru);
 	update_page_reclaim_stat(lruvec, file, active);
-	trace_mm_lru_insertion(page, page_to_pfn(page), lru, trace_pagemap_flags(page));
+	trace_mm_lru_insertion(page, lru);
 }
 
 /*
-- 
1.8.4.5

