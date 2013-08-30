Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3H3NXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:23:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50839 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3H3NXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:23:11 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 17/35] mm: Add aggressive bias to prefer lower regions
 during page allocation
To: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, dave@sr71.net,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 18:49:05 +0530
Message-ID: <20130830131902.4947.17975.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-9332-0000-0000-00000141D616
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While allocating pages from buddy freelists, there could be situations
in which we have a ready freepage of the required order in a *higher*
numbered memory region, and there also exists a freepage of a higher
page order in a *lower* numbered memory region.

To make the consolidation logic more aggressive, try to split up the
higher order buddy page of a lower numbered region and allocate it,
rather than allocating pages from a higher numbered region.

This ensures that we spill over to a new region only when we truly
don't have enough contiguous memory in any lower numbered region to
satisfy that allocation request.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e711b9..0cc2a3e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1210,8 +1210,9 @@ static inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
 {
-	unsigned int current_order;
-	struct free_area * area;
+	unsigned int current_order, alloc_order;
+	struct free_area *area, *other_area;
+	int alloc_region, other_region;
 	struct page *page;
 
 	/* Find a page of the appropriate size in the preferred list */
@@ -1220,17 +1221,40 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		if (list_empty(&area->free_list[migratetype].list))
 			continue;
 
-		page = list_entry(area->free_list[migratetype].list.next,
-							struct page, lru);
-		rmqueue_del_from_freelist(page, &area->free_list[migratetype],
-					  current_order);
-		rmv_page_order(page);
-		area->nr_free--;
-		expand(zone, page, order, current_order, area, migratetype);
-		return page;
+		alloc_order = current_order;
+		alloc_region = area->free_list[migratetype].next_region -
+				area->free_list[migratetype].mr_list;
+		current_order++;
+		goto try_others;
 	}
 
 	return NULL;
+
+try_others:
+	/* Try to aggressively prefer lower numbered regions for allocations */
+	for ( ; current_order < MAX_ORDER; ++current_order) {
+		other_area = &(zone->free_area[current_order]);
+		if (list_empty(&other_area->free_list[migratetype].list))
+			continue;
+
+		other_region = other_area->free_list[migratetype].next_region -
+				other_area->free_list[migratetype].mr_list;
+
+		if (other_region < alloc_region) {
+			alloc_region = other_region;
+			alloc_order = current_order;
+		}
+	}
+
+	area = &(zone->free_area[alloc_order]);
+	page = list_entry(area->free_list[migratetype].list.next, struct page,
+			  lru);
+	rmqueue_del_from_freelist(page, &area->free_list[migratetype],
+				  alloc_order);
+	rmv_page_order(page);
+	area->nr_free--;
+	expand(zone, page, order, alloc_order, area, migratetype);
+	return page;
 }
 
 

