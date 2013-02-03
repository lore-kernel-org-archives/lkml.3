Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3BCPRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:17:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34236 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab3BCOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:45 -0500
Message-Id: <20130203144647.879496757@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Laura Abbott <lauraa@codeaurora.org>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 043/128] mm: use aligned zone start for pfn_to_bitidx calculation
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laura Abbott <lauraa@codeaurora.org>

commit c060f943d0929f3e429c5d9522290584f6281d6e upstream.

The current calculation in pfn_to_bitidx assumes that (pfn -
zone->zone_start_pfn) >> pageblock_order will return the same bit for
all pfn in a pageblock.  If zone_start_pfn is not aligned to
pageblock_nr_pages, this may not always be correct.

Consider the following with pageblock order = 10, zone start 2MB:

  pfn     | pfn - zone start | (pfn - zone start) >> page block order
  ----------------------------------------------------------------
  0x26000 | 0x25e00	   |  0x97
  0x26100 | 0x25f00	   |  0x97
  0x26200 | 0x26000	   |  0x98
  0x26300 | 0x26100	   |  0x98

This means that calling {get,set}_pageblock_migratetype on a single page
will not set the migratetype for the full block.  Fix this by rounding
down zone_start_pfn when doing the bitidx calculation.

For our use case, the effects of this bug were mostly tied to the fact
that CMA allocations would either take a long time or fail to happen.
Depending on the driver using CMA, this could result in anything from
visual glitches to application failures.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bc6cc0e..c957805 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5604,7 +5604,7 @@ static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - zone->zone_start_pfn;
+	pfn = pfn - round_down(zone->zone_start_pfn, pageblock_nr_pages);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }


