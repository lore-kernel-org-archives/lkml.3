Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3GVSvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:51:54 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47037 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab3GVSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:51:51 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mm: Fix the value of fallback_migratetype in
 alloc_extfrag tracepoint
To: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org,
        cody@linux.vnet.ibm.com
Cc: rostedt@goodmis.org, jiang.liu@huawei.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 00:18:12 +0530
Message-ID: <20130722184812.9573.16042.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130722184805.9573.78514.stgit@srivatsabhat.in.ibm.com>
References: <20130722184805.9573.78514.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072218-9264-0000-0000-0000042CA950
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, the value of fallback_migratetype that is printed
using the mm_page_alloc_extfrag tracepoint, is the value of the migratetype
*after* it has been set to the preferred migratetype (if the ownership was
changed). Obviously that wouldn't have been the original intent. (We already
have a separate 'change_ownership' field to tell whether the ownership of the
pageblock was changed from the fallback_migratetype to the preferred type.)

The intent of the fallback_migratetype field is to show the migratetype
from which we borrowed pages in order to satisfy the allocation request.
So fix the code to print that value correctly.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/trace/events/kmem.h |   10 +++++++---
 mm/page_alloc.c             |    5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 6bc943e..d0c6134 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -268,11 +268,13 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
 			int alloc_order, int fallback_order,
-			int alloc_migratetype, int fallback_migratetype),
+			int alloc_migratetype, int fallback_migratetype,
+			int change_ownership),
 
 	TP_ARGS(page,
 		alloc_order, fallback_order,
-		alloc_migratetype, fallback_migratetype),
+		alloc_migratetype, fallback_migratetype,
+		change_ownership),
 
 	TP_STRUCT__entry(
 		__field(	struct page *,	page			)
@@ -280,6 +282,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__field(	int,		fallback_order		)
 		__field(	int,		alloc_migratetype	)
 		__field(	int,		fallback_migratetype	)
+		__field(	int,		change_ownership	)
 	),
 
 	TP_fast_assign(
@@ -288,6 +291,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->fallback_order		= fallback_order;
 		__entry->alloc_migratetype	= alloc_migratetype;
 		__entry->fallback_migratetype	= fallback_migratetype;
+		__entry->change_ownership	= change_ownership;
 	),
 
 	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
@@ -299,7 +303,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->alloc_migratetype,
 		__entry->fallback_migratetype,
 		__entry->fallback_order < pageblock_order,
-		__entry->alloc_migratetype == __entry->fallback_migratetype)
+		__entry->change_ownership)
 );
 
 #endif /* _TRACE_KMEM_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 027d417..af5571d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1101,8 +1101,9 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			       is_migrate_cma(migratetype)
 			     ? migratetype : start_migratetype);
 
-			trace_mm_page_alloc_extfrag(page, order, current_order,
-				start_migratetype, new_type);
+			trace_mm_page_alloc_extfrag(page, order,
+				current_order, start_migratetype, migratetype,
+				new_type == start_migratetype);
 
 			return page;
 		}

