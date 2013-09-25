Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3IYX1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:27:19 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39012 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3IYX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:27:15 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 40/40] mm: Add triggers in the page-allocator to kick
 off region evacuation
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
Date: Thu, 26 Sep 2013 04:52:58 +0530
Message-ID: <20130925232256.26184.77601.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-7014-0000-0000-000003AB5050
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the entire infrastructure to perform targeted region
evacuation from a dedicated kthread (kmempowerd), modify the page-allocator
to invoke the region-evacuator at opportune points.

At a basic level, the most obvious opportunity to try region-evacuation is
when a page is freed back to the page-allocator. The rationale behind this is
explained below.

The page-allocator already has the intelligence to allocate pages such that
they are consolidated within as few regions as possible. That is, due to the
sorted-buddy design, it will _not_ spill allocations to a new region as long
as there is still memory available in lower-numbered regions to satisfy the
allocation request.

So, the fragmentation happens _after_ they are allocated, i.e., once the
entity starts freeing the memory in a random fashion. This freeing of pages
presents an opportunity to the MM subsystem: if the pages freed belong to
lower-numbered regions, then there is a chance that pages from higher-numbered
regions could be moved to these freshly freed pages, thereby causing further
consolidation of regions.

With this in mind, add the region-evac trigger in the page-freeing path.
Along with that, also add appropriate checks and intelligence necessary to
avoid compaction attempts that don't provide any net benefit. For example,
we can avoid compacting regions in ZONE_DMA, or regions that have mostly only
MIGRATE_UNMOVABLE allocations etc. These checks are done best at the
page-allocator side. Apart from them, also perform the same eligibility checks
that the region-evacuator employs, to avoid useless wakeups of kmempowerd.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4571d30..48b748e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -639,6 +639,29 @@ out:
 static void add_to_region_allocator(struct zone *z, struct free_list *free_list,
 				    int region_id);
 
+static inline int region_is_evac_candidate(struct zone *z,
+					   struct zone_mem_region *region,
+					   int migratetype)
+{
+
+	/* Don't start evacuation too early during boot */
+	if (system_state != SYSTEM_RUNNING)
+		return 0;
+
+	/* Don't bother evacuating regions in ZONE_DMA */
+	if (zone_idx(z) == ZONE_DMA)
+		return 0;
+
+	/*
+	 * Don't try evacuations in regions not containing MOVABLE or
+	 * RECLAIMABLE allocations.
+	 */
+	if (!(migratetype == MIGRATE_MOVABLE ||
+		migratetype == MIGRATE_RECLAIMABLE))
+		return 0;
+
+	return should_evacuate_region(z, region);
+}
 
 static inline int can_return_region(struct mem_region_list *region, int order,
 				    struct free_list *free_list)
@@ -683,7 +706,9 @@ static void add_to_freelist(struct page *page, struct free_list *free_list,
 {
 	struct list_head *prev_region_list, *lru;
 	struct mem_region_list *region;
-	int region_id, prev_region_id;
+	int region_id, prev_region_id, migratetype;
+	struct zone *zone;
+	struct pglist_data *pgdat;
 
 	lru = &page->lru;
 	region_id = page_zone_region_id(page);
@@ -741,8 +766,17 @@ try_return_region:
 	 * Try to return the freepages of a memory region to the region
 	 * allocator, if possible.
 	 */
-	if (can_return_region(region, order, free_list))
+	if (can_return_region(region, order, free_list)) {
 		add_to_region_allocator(page_zone(page), free_list, region_id);
+		return;
+	}
+
+	zone = page_zone(page);
+	migratetype = get_pageblock_migratetype(page);
+	pgdat = NODE_DATA(page_to_nid(page));
+
+	if (region_is_evac_candidate(zone, region->zone_region, migratetype))
+		queue_mempower_work(pgdat, zone, region_id);
 }
 
 /*

