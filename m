Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaAQOc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:32:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:32:27 -0500
Date: Fri, 17 Jan 2014 14:32:21 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Improve documentation of page_order
Message-ID: <20140117143221.GA24851@suse.de>
References: <520B0B75.4030708@huawei.com>
 <20130814085711.GK2296@suse.de>
 <20130814155205.GA2706@gmail.com>
 <20130814132602.814a88e991e29c5b93bbe22c@linux-foundation.org>
 <20130814222241.GQ2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130814222241.GQ2296@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Developers occasionally try and optimise PFN scanners by using page_order
but miss that in general it requires zone->lock. This has happened twice for
compaction.c and rejected both times.  This patch clarifies the documentation
of page_order and adds a note to compaction.c why page_order is not used.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 5 ++++-
 mm/internal.h   | 8 +++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f58bcd0..f91d26b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -522,7 +522,10 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		if (!isolation_suitable(cc, page))
 			goto next_pageblock;
 
-		/* Skip if free */
+		/*
+		 * Skip if free. page_order cannot be used without zone->lock
+		 * as nothing prevents parallel allocations or buddy merging.
+		 */
 		if (PageBuddy(page))
 			continue;
 
diff --git a/mm/internal.h b/mm/internal.h
index 684f7aa..09cd8be 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -144,9 +144,11 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 #endif
 
 /*
- * function for dealing with page's order in buddy system.
- * zone->lock is already acquired when we use these.
- * So, we don't need atomic page->flags operations here.
+ * This functions returns the order of a free page in the buddy system.
+ * In general, page_zone(page)->lock must be held by the caller to prevent
+ * the page being allocated in parallel and returning garbage as the order.
+ * If the caller does not hold page_zone(page), they must guarantee that
+ * the page cannot be allocated or merged in parallel.
  */
 static inline unsigned long page_order(struct page *page)
 {
