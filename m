Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3IYXSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:18:33 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46621 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3IYXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:18:29 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 03/40] mm: Introduce and initialize zone memory regions
To: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 04:44:16 +0530
Message-ID: <20130925231413.26184.31267.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-8256-0000-0000-00000961DD44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory region boundaries don't necessarily fit on zone boundaries. So we need
to maintain a zone-level mapping of the absolute memory region boundaries.

"Node Memory Regions" will be used to capture the absolute region boundaries.
Add "Zone Memory Regions" to track the subsets of the absolute memory regions
that fall within the zone boundaries.

Eg:

	|<----------------------Node---------------------->|
	 __________________________________________________
	|      Node mem reg 0 	 |      Node mem reg 1     |  (Absolute region
	|________________________|_________________________|   boundaries)

	 __________________________________________________
	|    ZONE_DMA   |	    ZONE_NORMAL		   |
	|               |                                  |
	|<--- ZMR 0 --->|<-ZMR0->|<-------- ZMR 1 -------->|
	|_______________|________|_________________________|


In the above figure,

ZONE_DMA will have only 1 zone memory region (say, Zone mem reg 0) which is a
subset of Node mem reg 0 (ie., the portion of Node mem reg 0 that intersects
with ZONE_DMA).

ZONE_NORMAL will have 2 zone memory regions (say, Zone mem reg 0 and
Zone mem reg 1) which are subsets of Node mem reg 0 and Node mem reg 1
respectively, that intersect with ZONE_NORMAL's range.

Most of the MM algorithms (like page allocation etc) work within a zone,
hence such a zone-level mapping of the absolute region boundaries will be
very useful in influencing the MM decisions at those places.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |   11 +++++++++
 mm/page_alloc.c        |   62 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d3288b0..3c1dc97 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -36,6 +36,7 @@
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
 #define MAX_NR_NODE_REGIONS	512
+#define MAX_NR_ZONE_REGIONS	MAX_NR_NODE_REGIONS
 
 enum {
 	MIGRATE_UNMOVABLE,
@@ -313,6 +314,13 @@ enum zone_type {
 
 #ifndef __GENERATING_BOUNDS_H
 
+struct zone_mem_region {
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+	unsigned long present_pages;
+	unsigned long spanned_pages;
+};
+
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -369,6 +377,9 @@ struct zone {
 #endif
 	struct free_area	free_area[MAX_ORDER];
 
+	struct zone_mem_region	zone_regions[MAX_NR_ZONE_REGIONS];
+	int 			nr_zone_regions;
+
 #ifndef CONFIG_SPARSEMEM
 	/*
 	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 26835c4..10a1cc8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4885,6 +4885,66 @@ static void __meminit init_node_memory_regions(struct pglist_data *pgdat)
 	pgdat->nr_node_regions = idx;
 }
 
+static void __meminit init_zone_memory_regions(struct pglist_data *pgdat)
+{
+	unsigned long start_pfn, end_pfn, absent;
+	unsigned long z_start_pfn, z_end_pfn;
+	int i, j, idx, nid = pgdat->node_id;
+	struct node_mem_region *node_region;
+	struct zone_mem_region *zone_region;
+	struct zone *z;
+
+	for (i = 0, j = 0; i < pgdat->nr_zones; i++) {
+		z = &pgdat->node_zones[i];
+		z_start_pfn = z->zone_start_pfn;
+		z_end_pfn = z->zone_start_pfn + z->spanned_pages;
+		idx = 0;
+
+		for ( ; j < pgdat->nr_node_regions; j++) {
+			node_region = &pgdat->node_regions[j];
+
+			/*
+			 * Skip node memory regions that don't intersect with
+			 * this zone.
+			 */
+			if (node_region->end_pfn <= z_start_pfn)
+				continue; /* Move to next higher node region */
+
+			if (node_region->start_pfn >= z_end_pfn)
+				break; /* Move to next higher zone */
+
+			start_pfn = max(z_start_pfn, node_region->start_pfn);
+			end_pfn = min(z_end_pfn, node_region->end_pfn);
+
+			zone_region = &z->zone_regions[idx];
+			zone_region->start_pfn = start_pfn;
+			zone_region->end_pfn = end_pfn;
+			zone_region->spanned_pages = end_pfn - start_pfn;
+
+			absent = __absent_pages_in_range(nid, start_pfn,
+						         end_pfn);
+			zone_region->present_pages =
+					zone_region->spanned_pages - absent;
+
+			idx++;
+		}
+
+		z->nr_zone_regions = idx;
+
+		/*
+		 * Revisit the last visited node memory region, in case it
+		 * spans multiple zones.
+		 */
+		j--;
+	}
+}
+
+static void __meminit init_memory_regions(struct pglist_data *pgdat)
+{
+	init_node_memory_regions(pgdat);
+	init_zone_memory_regions(pgdat);
+}
+
 void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
@@ -4913,7 +4973,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 
 	free_area_init_core(pgdat, start_pfn, end_pfn,
 			    zones_size, zholes_size);
-	init_node_memory_regions(pgdat);
+	init_memory_regions(pgdat);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP

