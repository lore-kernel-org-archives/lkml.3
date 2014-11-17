Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaKQKly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:41:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:44260 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaKQKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:41:52 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b9-5469d0e01df9
From: Weijie Yang <weijie.yang@samsung.com>
To: iamjoonsoo.kim@lge.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Minchan Kim'" <minchan@kernel.org>, mina86@mina86.com,
        vbabka@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH] mm: page_alloc: store updated page migratetype to avoid
 misusing stale value
Date: Mon, 17 Nov 2014 18:40:10 +0800
Message-id: <000301d00253$0fcd0560$2f671020$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdACUtw5/Dxrht8NQg6/lTkxp4983g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd0HFzJDDLpPqVvMWb+GzWL1Jl+L
	ld3NbBaXd81hs7i35j+rxeR3zxgtFhxvYbVY9vU9u8XfK+tZLGY39jFaPDnxn8WB2+Pwm/fM
	Hjtn3WX32LSqk81j06dJ7B5db68weZyY8ZvFY92fV0we7/ddZfM4s+AIu8fm09UenzfJBXBH
	cdmkpOZklqUW6dslcGU8fr6asWC7cMWvxmPMDYyX+bsYOTkkBEwklh76yAxhi0lcuLeerYuR
	i0NIYDqjxM+z+6CcP4wSp3f8YQepYhPQlrjbv5EVxBYRkJI49f0EI0gRs8BWJoml278ygiSE
	BeIlPn05BdTNwcEioCrR9RSsnlfATuL63e/MELagxI/J91hASpgF1CWmTMkFCTMLyEtsXvOW
	GSQsARR+9FcXYpOexO+2+4wQJeISG4/cYpnAKDALyaBZCINmIRk0C0nHAkaWVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjBkfVMegfjqgaLQ4wCHIxKPLw7sjNDhFgTy4orcw8xSnAwK4nw
	rjgDFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cBYb20Z
	fOXXiSmmJh4HIj7M/WZpcrm87TBXknRR/RdTda5PFbNZ32QyCv/Kd9i8Kb7V/pqixLz0wvWd
	AjnHlj56HGlT0shz5+eCxdu8cz65+RzorT+1SzBqFmvu3Wlx0lfW5PVu/P30XeWyKbmb7xRW
	R/Va1xjdnvG1dnq8scWCF16KDqfvFzYrsRRnJBpqMRcVJwIAMMRGKagCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ad53f92e(fix incorrect isolation behavior by rechecking migratetype)
patch series describe the race between page isolation and free path, and try to
fix the freepage account issues.

However, there is still a little issue: freed page could have stale migratetype
in the free_list. This would cause some bad behavior if we misuse this stale
value later.
Such as: in __test_page_isolated_in_pageblock() we check the buddy page, if the
page's stale migratetype is not MIGRATE_ISOLATE, which will cause unnecessary
page move action.

This patch store the page's updated migratetype after free the page to the
free_list to avoid subsequent misusing stale value, and use a WARN_ON_ONCE
to catch a potential undetected race between isolatation and free path.


Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_alloc.c     |    1 +
 mm/page_isolation.c |   17 +++++------------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 616a2c9..177fca0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -622,6 +622,7 @@ static inline void __free_one_page(struct page *page,
 	}
 
 	list_add(&page->lru, &zone->free_area[order].free_list[migratetype]);
+	set_freepage_migratetype(page, migratetype);
 out:
 	zone->free_area[order].nr_free++;
 }
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c8778f7..0618071 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -223,19 +223,12 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page)) {
 			/*
-			 * If race between isolatation and allocation happens,
-			 * some free pages could be in MIGRATE_MOVABLE list
-			 * although pageblock's migratation type of the page
-			 * is MIGRATE_ISOLATE. Catch it and move the page into
-			 * MIGRATE_ISOLATE list.
+			 * Use a WARN_ON_ONCE to catch a potential undetected
+			 * race between isolatation and free pages, even if
+			 * we try to avoid this issue.
 			 */
-			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
-				struct page *end_page;
-
-				end_page = page + (1 << page_order(page)) - 1;
-				move_freepages(page_zone(page), page, end_page,
-						MIGRATE_ISOLATE);
-			}
+			WARN_ON_ONCE(get_freepage_migratetype(page) !=
+					MIGRATE_ISOLATE);
 			pfn += 1 << page_order(page);
 		}
 		else if (page_count(page) == 0 &&
-- 
1.7.0.4


