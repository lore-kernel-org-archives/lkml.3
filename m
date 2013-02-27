Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab3B0AbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:31:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab3B0AIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:08:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/86] mm: fix pageblock bitmap allocation
Date: Tue, 26 Feb 2013 16:07:12 -0800
Message-Id: <20130226235913.357870242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4216,10 +4216,11 @@ static void __meminit calculate_node_tot
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
@@ -4229,17 +4230,19 @@ static unsigned long __init usemap_size(
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
@@ -4367,7 +4370,7 @@ static void __paginginit free_area_init_
 			continue;
 
 		set_pageblock_order(pageblock_default_order());
-		setup_usemap(pgdat, zone, size);
+		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);


