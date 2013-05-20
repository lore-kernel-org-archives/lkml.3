Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3ETGrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:47:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14949 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3ETGrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:47:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,706,1363104000"; 
   d="scan'208";a="7310738"
Message-ID: <5199C657.60009@cn.fujitsu.com>
Date: Mon, 20 May 2013 14:44:39 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: mm: Remove duplicated call of get_pfn_range_for_nid
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/20 14:45:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/20 14:45:50,
	Serialize complete at 2013/05/20 14:45:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating pages in a node,
for each zone in that node, we will have
  zone_spanned_pages_in_node
    --> get_pfn_range_for_nid
  zone_absent_pages_in_node
    --> get_pfn_range_for_nid

That is to say, we call the get_pfn_range_for_nid to get start_pfn
and end_pfn of the node for MAX_NR_ZONES * 2 times. And this is
totally unnecessary if we call the get_pfn_range_for_nid before
zone_*_pages_in_node add two extra arguments node_start_pfn
and node_end_pfn for zone_*_pages_in_node, then we can remove the
get_pfn_range_in_node in zone_*_pages_in_node.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 98cbdf6..b16cb49 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4366,13 +4366,13 @@ static void __meminit adjust_zone_range_for_zone_movable(int nid,
  */
 static unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *ignored)
 {
-	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* Get the start and end of the node and zone */
-	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
+	/* Get the start and end of the zone */
 	zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
 	zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
 	adjust_zone_range_for_zone_movable(nid, zone_type,
@@ -4427,14 +4427,14 @@ unsigned long __init absent_pages_in_range(unsigned long start_pfn,
 /* Return the number of page frames in holes in a zone on a node */
 static unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *ignored)
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
-	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
 	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
@@ -4447,6 +4447,8 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *zones_size)
 {
 	return zones_size[zone_type];
@@ -4454,6 +4456,8 @@ static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 
 static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 						unsigned long zone_type,
+						unsigned long node_start_pfn,
+						unsigned long node_end_pfn,
 						unsigned long *zholes_size)
 {
 	if (!zholes_size)
@@ -4465,21 +4469,27 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
-		unsigned long *zones_size, unsigned long *zholes_size)
+						unsigned long node_start_pfn,
+						unsigned long node_end_pfn,
+						unsigned long *zones_size,
+						unsigned long *zholes_size)
 {
 	unsigned long realtotalpages, totalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
 		totalpages += zone_spanned_pages_in_node(pgdat->node_id, i,
-								zones_size);
+							 node_start_pfn,
+							 node_end_pfn,
+							 zones_size);
 	pgdat->node_spanned_pages = totalpages;
 
 	realtotalpages = totalpages;
 	for (i = 0; i < MAX_NR_ZONES; i++)
 		realtotalpages -=
 			zone_absent_pages_in_node(pgdat->node_id, i,
-								zholes_size);
+						  node_start_pfn, node_end_pfn,
+						  zholes_size);
 	pgdat->node_present_pages = realtotalpages;
 	printk(KERN_DEBUG "On node %d totalpages: %lu\n", pgdat->node_id,
 							realtotalpages);
@@ -4588,6 +4598,7 @@ static unsigned long __paginginit calc_memmap_size(unsigned long spanned_pages,
  * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
+		unsigned long node_start_pfn, unsigned long node_end_pfn,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -4609,8 +4620,11 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
 
-		size = zone_spanned_pages_in_node(nid, j, zones_size);
+		size = zone_spanned_pages_in_node(nid, j, node_start_pfn,
+						  node_end_pfn, zones_size);
 		realsize = freesize = size - zone_absent_pages_in_node(nid, j,
+								node_start_pfn,
+								node_end_pfn,
 								zholes_size);
 
 		/*
@@ -4724,6 +4738,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long start_pfn, end_pfn;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
@@ -4731,7 +4746,9 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	init_zone_allows_reclaim(nid);
-	calculate_node_totalpages(pgdat, zones_size, zholes_size);
+	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
+				  zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
@@ -4740,7 +4757,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, zones_size, zholes_size);
+	free_area_init_core(pgdat, start_pfn, end_pfn,
+			    zones_size, zholes_size);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-- 
1.7.1
