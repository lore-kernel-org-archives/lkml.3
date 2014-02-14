Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBNSI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:08:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27195 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBNSIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:08:25 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-0a-52fe5b97e380
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yong-Taek Lee <ytk.lee@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] mm/page_alloc: fix freeing of MIGRATE_RESERVE migratetype
 pages
Date: Fri, 14 Feb 2014 19:08:18 +0100
Message-id: <1995877.GHAxfnIsTj@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd3p0f+CDFa90LJ4+qmPxeLyrjls
	FvfW/Ge1WHvkLrvF5HfPGC0er+d2YPNYsKnUY9OnSewefVtWMXpsPl3t8XmTXABrFJdNSmpO
	Zllqkb5dAldG887sgoNiFdOuWzYwPhHqYuTkkBAwkTg6fREzhC0mceHeerYuRi4OIYFFjBI7
	b99gBEkICbQwSdy7yA9iswlYSUxsXwUU5+AQEVCQmPveHKSeWWAto8TZzofsIDXCAuES29+1
	MoHYLAKqEv+/zWYDsXkFNCV2/37CCmKLCnhK7Ni+EiouKPFj8j0WEJtZQF5i3/6prBC2lsT6
	nceZJjDyzUJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfoM+kdjKsa
	LA4xCnAwKvHwSuj+CxJiTSwrrsw9xCjBwawkwisQBhTiTUmsrEotyo8vKs1JLT7EKM3BoiTO
	e7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAaPpJoMxzcmBe08muixtNf5uGJpXt3LHdwSU3c/kF
	mSPLjv6TKvqiJ6y4/5HD7Tu85SvMbOQTm8z+La1jaz4m+8bC8JLRm6y2kudGXj/1UgVupvbZ
	PzK7J7M1cd+VU9veehoqz1niy5e0ZaGUp2WLWllwK0+jv59EWcu55pfTl+5f/ry9Tu6aEktx
	RqKhFnNRcSIAPa3foEwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pages allocated from MIGRATE_RESERVE migratetype pageblocks
are not freed back to MIGRATE_RESERVE migratetype free
lists in free_pcppages_bulk() if we got to that function
through drain_[zone_]pages() or __zone_pcp_update().
The freeing through free_hot_cold_page() is okay because
freepage migratetype is set to pageblock migratetype before
calling free_pcppages_bulk().  If pages of MIGRATE_RESERVE
migratetype end up on the free lists of other migratetype
whole Reserved pageblock may be later changed to the other
migratetype in __rmqueue_fallback() and it will be never
changed back to be a Reserved pageblock.  Fix the issue by
preserving freepage migratetype as a pageblock migratetype
(instead of overriding it to the requested migratetype)
for MIGRATE_RESERVE migratetype pages in rmqueue_bulk().

The problem was introduced in v2.6.31 by commit ed0ae21
("page allocator: do not call get_pageblock_migratetype()
more than necessary").

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
---
 include/linux/mmzone.h |    5 +++++
 mm/page_alloc.c        |   10 +++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h	2014-02-14 18:59:08.177837747 +0100
+++ b/include/linux/mmzone.h	2014-02-14 18:59:09.077837731 +0100
@@ -63,6 +63,11 @@ enum {
 	MIGRATE_TYPES
 };
 
+static inline bool is_migrate_reserve(int migratetype)
+{
+	return unlikely(migratetype == MIGRATE_RESERVE);
+}
+
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #else
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2014-02-14 18:59:08.185837746 +0100
+++ b/mm/page_alloc.c	2014-02-14 18:59:09.077837731 +0100
@@ -1174,7 +1174,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
-	int mt = migratetype, i;
+	int mt, i;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -1195,9 +1195,13 @@ static int rmqueue_bulk(struct zone *zon
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
+		mt = get_pageblock_migratetype(page);
 		if (IS_ENABLED(CONFIG_CMA)) {
-			mt = get_pageblock_migratetype(page);
-			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
+			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt) &&
+			    !is_migrate_reserve(mt))
+				mt = migratetype;
+		} else {
+			if (!is_migrate_reserve(mt))
 				mt = migratetype;
 		}
 		set_freepage_migratetype(page, mt);

