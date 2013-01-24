Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3AXDgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:36:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44376 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3AXDbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 54/74] mm: use aligned zone start for pfn_to_bitidx calculation
Date: Thu, 24 Jan 2013 01:27:06 -0200
Message-Id: <1358998046-613-55-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9bd526c..007bf3b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5405,7 +5405,7 @@ static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - zone->zone_start_pfn;
+	pfn = pfn - round_down(zone->zone_start_pfn, pageblock_nr_pages);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }
-- 
1.7.9.5

