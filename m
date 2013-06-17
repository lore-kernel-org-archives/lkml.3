Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3FQRhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:37:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3FQRhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:37:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 80/84] mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
Date: Mon, 17 Jun 2013 10:31:24 -0700
Message-Id: <1371490288-23167-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

commit 026b08147923142e925a7d0aaa39038055ae0156 upstream.

The watermark check consists of two sub-checks.  The first one is:

	if (free_pages <= min + lowmem_reserve)
		return false;

The check assures that there is minimal amount of RAM in the zone.  If
CMA is used then the free_pages is reduced by the number of free pages
in CMA prior to the over-mentioned check.

	if (!(alloc_flags & ALLOC_CMA))
		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);

This prevents the zone from being drained from pages available for
non-movable allocations.

The second check prevents the zone from getting too fragmented.

	for (o = 0; o < order; o++) {
		free_pages -= z->free_area[o].nr_free << o;
		min >>= 1;
		if (free_pages <= min)
			return false;
	}

The field z->free_area[o].nr_free is equal to the number of free pages
including free CMA pages.  Therefore the CMA pages are subtracted twice.
This may cause a false positive fail of __zone_watermark_ok() if the CMA
area gets strongly fragmented.  In such a case there are many 0-order
free pages located in CMA.  Those pages are subtracted twice therefore
they will quickly drain free_pages during the check against
fragmentation.  The test fails even though there are many free non-cma
pages in the zone.

This patch fixes this issue by subtracting CMA pages only for a purpose of
(free_pages <= min + lowmem_reserve) check.

Laura said:

  We were observing allocation failures of higher order pages (order 5 =
  128K typically) under tight memory conditions resulting in driver
  failure.  The output from the page allocation failure showed plenty of
  free pages of the appropriate order/type/zone and mostly CMA pages in
  the lower orders.

  For full disclosure, we still observed some page allocation failures
  even after applying the patch but the number was drastically reduced and
  those failures were attributed to fragmentation/other system issues.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Laura Abbott <lauraa@codeaurora.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb791f0..7d77c57 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1616,6 +1616,7 @@ static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 	long min = mark;
 	long lowmem_reserve = z->lowmem_reserve[classzone_idx];
 	int o;
+	long free_cma = 0;
 
 	free_pages -= (1 << order) - 1;
 	if (alloc_flags & ALLOC_HIGH)
@@ -1625,9 +1626,10 @@ static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
-		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
+		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
-	if (free_pages <= min + lowmem_reserve)
+
+	if (free_pages - free_cma <= min + lowmem_reserve)
 		return false;
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
-- 
1.8.1.2

