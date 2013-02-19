Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab3BSSzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:55:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab3BSSzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:55:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 81/81] mm: fix pageblock bitmap allocation
Date: Tue, 19 Feb 2013 15:49:44 -0300
Message-Id: <1361299784-8830-82-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 007bf3b..0ed96c7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4272,10 +4272,11 @@ static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
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
@@ -4285,17 +4286,19 @@ static unsigned long __init usemap_size(unsigned long zonesize)
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
@@ -4414,7 +4417,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 			continue;
 
 		set_pageblock_order();
-		setup_usemap(pgdat, zone, size);
+		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);
-- 
1.7.9.5

