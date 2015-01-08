Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbbAHPnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:43:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbbAHPnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:43:04 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] mm: use correct format specifiers when printing address ranges
Date: Thu,  8 Jan 2015 16:41:37 +0100
Message-Id: <1420731697-12134-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Especially on 32 bit kernels memory node ranges are printed with
32 bit wide addresses only. Use u64 types and %llx specifiers to
print full width of addresses.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 mm/page_alloc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7633c50..4bbe4da 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5059,8 +5059,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n", nid,
-			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);
+	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
+		(u64)start_pfn << PAGE_SHIFT, ((u64)end_pfn << PAGE_SHIFT) - 1);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
@@ -5432,9 +5432,10 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 				arch_zone_highest_possible_pfn[i])
 			pr_cont("empty\n");
 		else
-			pr_cont("[mem %0#10lx-%0#10lx]\n",
-				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
-				(arch_zone_highest_possible_pfn[i]
+			pr_cont("[mem %#018Lx-%#018Lx]\n",
+				(u64)arch_zone_lowest_possible_pfn[i]
+					<< PAGE_SHIFT,
+				((u64)arch_zone_highest_possible_pfn[i]
 					<< PAGE_SHIFT) - 1);
 	}
 
@@ -5442,15 +5443,16 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	pr_info("Movable zone start for each node\n");
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (zone_movable_pfn[i])
-			pr_info("  Node %d: %#010lx\n", i,
-			       zone_movable_pfn[i] << PAGE_SHIFT);
+			pr_info("  Node %d: %#018Lx\n", i,
+			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
 	/* Print out the early node map */
 	pr_info("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		pr_info("  node %3d: [mem %#010lx-%#010lx]\n", nid,
-		       start_pfn << PAGE_SHIFT, (end_pfn << PAGE_SHIFT) - 1);
+		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
+			(u64)start_pfn << PAGE_SHIFT,
+			((u64)end_pfn << PAGE_SHIFT) - 1);
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
-- 
2.1.2

