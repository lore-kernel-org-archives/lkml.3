Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3CDD73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:59:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700Ab3CDDoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:06 -0500
Message-Id: <20130304033714.452150027@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [ 070/153] mm: fix pageblock bitmap allocation
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7c45512df987c5619db041b5c9b80d281e26d3db upstream.

Commit c060f943d092 ("mm: use aligned zone start for pfn_to_bitidx
calculation") fixed out calculation of the index into the pageblock
bitmap when a !SPARSEMEM zome was not aligned to pageblock_nr_pages.

However, the _allocation_ of that bitmap had never taken this alignment
requirement into accout, so depending on the exact size and alignment of
the zone, the use of that index could then access past the allocation,
resulting in some very subtle memory corruption.

This was reported (and bisected) by Ingo Molnar: one of his random
config builds would hang with certain very specific kernel command line
options.

In the meantime, commit c060f943d092 has been marked for stable, so this
fix needs to be back-ported to the stable kernels that backported the
commit to use the right alignment.

Bisected-and-tested-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4253,10 +4253,11 @@ static void __meminit calculate_node_tot
  * round what is now in bits to nearest long in bits, then return it in
  * bytes.
  */
-static unsigned long __init usemap_size(unsigned long zonesize)
+static unsigned long __init usemap_size(unsigned long zone_start_pfn, unsigned long zonesize)
 {
 	unsigned long usemapsize;
 
+	zonesize += zone_start_pfn & (pageblock_nr_pages-1);
 	usemapsize = roundup(zonesize, pageblock_nr_pages);
 	usemapsize = usemapsize >> pageblock_order;
 	usemapsize *= NR_PAGEBLOCK_BITS;
@@ -4266,17 +4267,19 @@ static unsigned long __init usemap_size(
 }
 
 static void __init setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long zonesize)
+				struct zone *zone,
+				unsigned long zone_start_pfn,
+				unsigned long zonesize)
 {
-	unsigned long usemapsize = usemap_size(zonesize);
+	unsigned long usemapsize = usemap_size(zone_start_pfn, zonesize);
 	zone->pageblock_flags = NULL;
 	if (usemapsize)
 		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat,
 								   usemapsize);
 }
 #else
-static inline void setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long zonesize) {}
+static inline void setup_usemap(struct pglist_data *pgdat, struct zone *zone,
+				unsigned long zone_start_pfn, unsigned long zonesize) {}
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -4401,7 +4404,7 @@ static void __paginginit free_area_init_
 			continue;
 
 		set_pageblock_order();
-		setup_usemap(pgdat, zone, size);
+		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);


