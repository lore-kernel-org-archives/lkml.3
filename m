Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3DLBOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46991 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3DLBOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:21 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 03/25] mm/memory_hotplug: factor out zone+pgdat growth.
Date: Thu, 11 Apr 2013 18:13:35 -0700
Message-Id: <1365729237-29711-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-5518-0000-0000-00000D761CED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new function grow_pgdat_and_zone() which handles locking +
growth of a zone & the pgdat which it is associated with.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/memory_hotplug.h |  3 +++
 mm/memory_hotplug.c            | 17 +++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index b6a3be7..cd393014 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -78,6 +78,9 @@ static inline void zone_seqlock_init(struct zone *zone)
 {
 	seqlock_init(&zone->span_seqlock);
 }
+extern void grow_pgdat_and_zone(struct zone *zone, unsigned long start_pfn,
+				unsigned long end_pfn);
+
 extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 46de32a..8f4d8d3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -390,13 +390,22 @@ static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 					pgdat->node_start_pfn;
 }
 
+void grow_pgdat_and_zone(struct zone *zone, unsigned long start_pfn,
+		unsigned long end_pfn)
+{
+	unsigned long flags;
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	grow_zone_span(zone, start_pfn, end_pfn);
+	grow_pgdat_span(zone->zone_pgdat, start_pfn, end_pfn);
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+}
+
 static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nr_pages = PAGES_PER_SECTION;
 	int nid = pgdat->node_id;
 	int zone_type;
-	unsigned long flags;
 	int ret;
 
 	zone_type = zone - pgdat->node_zones;
@@ -404,11 +413,7 @@ static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 	if (ret)
 		return ret;
 
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
-	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
-			phys_start_pfn + nr_pages);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+	grow_pgdat_and_zone(zone, phys_start_pfn, phys_start_pfn + nr_pages);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;
-- 
1.8.2.1

