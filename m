Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab3AOXOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:14:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:47630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059Ab3AOWyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 05/71] mm: use aligned zone start for pfn_to_bitidx calculation
Date: Tue, 15 Jan 2013 14:54:02 -0800
Message-Id: <20130115225340.782366320@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5492,7 +5492,7 @@ static inline int pfn_to_bitidx(struct z
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - zone->zone_start_pfn;
+	pfn = pfn - round_down(zone->zone_start_pfn, pageblock_nr_pages);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }


