Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3JYQmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:42:54 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46280 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3JYQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:42:53 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH] mm: get rid of unnecessary overhead of trace_mm_page_alloc_extfrag()
Date: Fri, 25 Oct 2013 12:42:47 -0400
Message-Id: <1382719367-11537-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

In general, every tracepoint should be zero overhead if it is disabled.
However, trace_mm_page_alloc_extfrag() is one of exception. It evaluate
"new_type == start_migratetype" even if tracepoint is disabled.

However, the code can be moved into tracepoint's TP_fast_assign() and
TP_fast_assign exist exactly such purpose. This patch does it.

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/trace/events/kmem.h |   10 ++++------
 mm/page_alloc.c             |    5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index d0c6134..aece134 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -267,14 +267,12 @@ DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu_drain,
 TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
-			int alloc_order, int fallback_order,
-			int alloc_migratetype, int fallback_migratetype,
-			int change_ownership),
+		int alloc_order, int fallback_order,
+		int alloc_migratetype, int fallback_migratetype, int new_migratetype),
 
 	TP_ARGS(page,
 		alloc_order, fallback_order,
-		alloc_migratetype, fallback_migratetype,
-		change_ownership),
+		alloc_migratetype, fallback_migratetype, new_migratetype),
 
 	TP_STRUCT__entry(
 		__field(	struct page *,	page			)
@@ -291,7 +289,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->fallback_order		= fallback_order;
 		__entry->alloc_migratetype	= alloc_migratetype;
 		__entry->fallback_migratetype	= fallback_migratetype;
-		__entry->change_ownership	= change_ownership;
+		__entry->change_ownership	= (new_migratetype == alloc_migratetype);
 	),
 
 	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4414c9d..58e67ea 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1103,9 +1103,8 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			       is_migrate_cma(migratetype)
 			     ? migratetype : start_migratetype);
 
-			trace_mm_page_alloc_extfrag(page, order,
-				current_order, start_migratetype, migratetype,
-				new_type == start_migratetype);
+			trace_mm_page_alloc_extfrag(page, order, current_order,
+				start_migratetype, migratetype, new_type);
 
 			return page;
 		}
-- 
1.7.1

