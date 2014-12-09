Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaLIHxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:53:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42884 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLIHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:53:53 -0500
X-AuditID: cbfee61a-f79c06d000004e71-52-5486aa8e3c5a
From: Weijie Yang <weijie.yang@samsung.com>
To: iamjoonsoo.kim@lge.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>, vbabka@suse.cz,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/3] mm: page_alloc: remove redundant
 set_freepage_migratetype() calls
Date: Tue, 09 Dec 2014 15:51:49 +0800
Message-id: <000301d01385$45554a60$cfffdf20$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAThOXndSR1bMOBR/Grhkzhgg6a2Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgG7/qrYQg4sfWCzmrF/DZrF6k6/F
	yu5mNovLu+awWdxb85/VYvK7Z4wWy76+Z7f4e2U9i8Xsxj5Giycn/rM4cHkcfvOe2WPnrLvs
	HptWdbJ5bPo0id2j6+0VJo8TM36zeLzfd5XN48yCI+wem09Xe3zeJBfAFcVlk5Kak1mWWqRv
	l8CVser1I/aCbbwVD6a4NzC2cncxcnBICJhI/Jhf38XICWSKSVy4t56ti5GLQ0hgEaPEpNPX
	mSGcP4wSVx/2MIFUsQloS9zt38gKYosISEmc+n6CEaSIWWARk8S53udgRcICERKv571jBrFZ
	BFQlXq7aB9bAK2An0bByPhOELSjxY/I9FpArmAXUJaZMyQUJMwvIS2xe85YZ4jh1iUd/dSFW
	6Uls7mhggSgRl9h45BbLBEaBWUgGzUIYNAvJoFlIOhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECI6hZ1I7GFc2WBxiFOBgVOLh1bRsCxFiTSwrrsw9xCjBwawkwqu0FCjEm5JYWZVa
	lB9fVJqTWnyIUZqDRUmcV8keKCWQnliSmp2aWpBaBJNl4uCUamA8++KJE6vV+9i63J87XW/l
	iV45zfzamfn4pDcmby/7T518LD8k7PeTDb15m79o+UbaMOk8m3164Wuv9Yf4Fvj4rlLSO+6w
	Yflt75VLJU1e2TBbmcpyrVp9fHq+dc4G1szdrOXX9x9eordZUSKu9u80jakes5z0jESfVesw
	veQIWDdLad4O4a5nSizFGYmGWsxFxYkAtFRT+50CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The freepage_migratetype is a temporary cached value which represents
the free page's pageblock migratetype. Now we use it in two scenarios:

1. Use it as a cached value in page freeing path. This cached value
is temporary and non-100% update, which help us decide which pcp
freelist and buddy freelist the page should go rather than using
get_pfnblock_migratetype() to save some instructions.
When there is race between page isolation and free path, we need use
additional method to get a accurate value to put the free pages to
the correct freelist and get a precise free pages statistics.

2. Use it in page alloc path to update NR_FREE_CMA_PAGES statistics.

This patch aims at the scenario 1 and removes two redundant
set_freepage_migratetype() calls, which will make sense in the hot path.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 616a2c9..99af01a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -775,7 +775,6 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	set_freepage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
 }
@@ -1024,7 +1023,6 @@ int move_freepages(struct zone *zone,
 		order = page_order(page);
 		list_move(&page->lru,
 			  &zone->free_area[order].free_list[migratetype]);
-		set_freepage_migratetype(page, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
-- 
1.7.10.4


