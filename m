Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab3APA0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:26:46 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55705 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab3APA0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:26:44 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 09/17] mm/page_alloc: use zone_end_pfn() & zone_spans_pfn()
Date: Tue, 15 Jan 2013 16:24:46 -0800
Message-Id: <1358295894-24167-10-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-5518-0000-0000-00000AC4D933
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Change several open coded zone_end_pfn()s and a zone_spans_pfn() in the
page allocator to use the provided helper functions.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5d70ce..f8ed277 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1272,7 +1272,7 @@ void mark_free_pages(struct zone *zone)
 
 	spin_lock_irqsave(&zone->lock, flags);
 
-	max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	max_zone_pfn = zone_end_pfn(zone);
 	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 		if (pfn_valid(pfn)) {
 			struct page *page = pfn_to_page(pfn);
@@ -3775,7 +3775,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 	 * the block.
 	 */
 	start_pfn = zone->zone_start_pfn;
-	end_pfn = start_pfn + zone->spanned_pages;
+	end_pfn = zone_end_pfn(zone);
 	start_pfn = roundup(start_pfn, pageblock_nr_pages);
 	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
@@ -3889,7 +3889,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * pfn out of zone.
 		 */
 		if ((z->zone_start_pfn <= pfn)
-		    && (pfn < z->zone_start_pfn + z->spanned_pages)
+		    && (pfn < zone_end_pfn(z))
 		    && !(pfn & (pageblock_nr_pages - 1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
@@ -4617,7 +4617,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 		 * for the buddy allocator to function correctly.
 		 */
 		start = pgdat->node_start_pfn & ~(MAX_ORDER_NR_PAGES - 1);
-		end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+		end = pgdat_end_pfn(pgdat);
 		end = ALIGN(end, MAX_ORDER_NR_PAGES);
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
@@ -5735,8 +5735,7 @@ bool is_pageblock_removable_nolock(struct page *page)
 
 	zone = page_zone(page);
 	pfn = page_to_pfn(page);
-	if (zone->zone_start_pfn > pfn ||
-			zone->zone_start_pfn + zone->spanned_pages <= pfn)
+	if (!zone_spans_pfn(zone, pfn))
 		return false;
 
 	return !has_unmovable_pages(zone, page, 0, true);
-- 
1.8.0.3

