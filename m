Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab3FRQSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269Ab3FRQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:06 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 28/48] mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
Date: Tue, 18 Jun 2013 09:17:54 -0700
Message-Id: <20130618161729.952381255@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1626,6 +1626,7 @@ static bool __zone_watermark_ok(struct z
 	long min = mark;
 	long lowmem_reserve = z->lowmem_reserve[classzone_idx];
 	int o;
+	long free_cma = 0;
 
 	free_pages -= (1 << order) - 1;
 	if (alloc_flags & ALLOC_HIGH)
@@ -1635,9 +1636,10 @@ static bool __zone_watermark_ok(struct z
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


