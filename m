Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBNSe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:34:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62050 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaBNSe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:34:27 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-84-52fe61b1710f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yong-Taek Lee <ytk.lee@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH v2] mm/page_alloc: fix freeing of MIGRATE_RESERVE
 migratetype pages
Date: Fri, 14 Feb 2014 19:34:17 +0100
Message-id: <42197912.c6v2hLDCey@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAd2Nif+CDN6tUrJ4+qmPxeLyrjls
	FvfW/Ge1WHvkLrvF5HfPGC0er+d2YPNYsKnUY9OnSewefVtWMXpsPl3t8XmTXABrFJdNSmpO
	Zllqkb5dAlfGjCULGAvmile0TOljbWDcINzFyMkhIWAi8Xv/KWYIW0ziwr31bF2MXBxCAosY
	JebNXckI4bQwSexu/s0KUsUmYCUxsX0VUIKDQ0RAQWLue3OQGmaBtYwSZzsfsoPUCAtESWz5
	/ZgNxGYRUJVYtWETC4jNK6AlceHuR0YQW1TAU2LH9pVsEHFBiR+T74HVMAvIS+zbP5UVwtaS
	WL/zONMERr5ZSMpmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgMH0mtYNx
	ZYPFIUYBDkYlHl4J3X9BQqyJZcWVuYcYJTiYlUR4BcKAQrwpiZVVqUX58UWlOanFhxilOViU
	xHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhjTE1SNhNcnaPfeV3+35LqK/MEPTr+t+9rVkqc4
	mv1MXnCIOdeye4ZRV9WWYsWZ+lMMdqu9YU9hnS7KsPSCq1sul9WZBskc65XKsm9twyMjhVS2
	s7d1eUvm7dzSKvS58n3zHp6NnV2ZzzK6khJ6Rf2z49yyauQ8VSfNc3x4dtWfZf2P5DewKrEU
	ZyQaajEXFScCAEapHrRPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages allocated from MIGRATE_RESERVE migratetype pageblocks
are not freed back to MIGRATE_RESERVE migratetype free
lists in free_pcppages_bulk()->__free_one_page() if we got
to free_pcppages_bulk() through drain_[zone_]pages().
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
v2:
- updated patch description, there is no __zone_pcp_update()
  in newer kernels

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

