Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3IYXWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:22:21 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47308 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab3IYXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:22:18 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 18/40] mm: Provide a mechanism to delete pages from
 buddy freelists in bulk
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
Date: Thu, 26 Sep 2013 04:48:06 +0530
Message-ID: <20130925231804.26184.66311.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-9574-0000-0000-000009CD0B7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the buddy allocator releases excess free memory to the region
allocator, it does it at a region granularity - that is, it releases
all the freepages of that region to the region allocator, at once.
So, in order to make this efficient, we need a way to delete all those
pages from the buddy freelists in one shot. Add this support, and also
take care to update the nr-free statistics properly.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3a2cda..d96746e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -854,6 +854,61 @@ page_found:
 	}
 }
 
+/*
+ * Delete all freepages belonging to the region 'region_id' from 'free_list'
+ * and move them to 'list'. Using suitable list-manipulation tricks, we move
+ * the pages between the lists in one shot.
+ */
+static void del_from_freelist_bulk(struct list_head *list,
+				   struct free_list *free_list, int order,
+				   int region_id)
+{
+	struct mem_region_list *region, *prev_region;
+	unsigned long nr_pages = 0;
+	struct free_area *area;
+	struct list_head *cur;
+	struct page *page;
+	int prev_region_id;
+
+	region = &free_list->mr_list[region_id];
+
+	/*
+	 * Perform bulk movement of all pages of the region to the new list,
+	 * except the page pointed to by region->pageblock.
+	 */
+	prev_region_id = find_prev_region(region_id, free_list);
+	if (prev_region_id < 0) {
+		/* This is the first region on the list */
+		list_cut_position(list, &free_list->list,
+				  region->page_block->prev);
+	} else {
+		prev_region = &free_list->mr_list[prev_region_id];
+		list_cut_position(list, prev_region->page_block,
+				  region->page_block->prev);
+	}
+
+	list_for_each(cur, list)
+		nr_pages++;
+
+	region->nr_free -= nr_pages;
+
+	/*
+	 * Now delete the page pointed to by region->page_block using
+	 * del_from_freelist(), so that it sets up the region related
+	 * data-structures of the freelist properly.
+	 */
+	page = list_entry(region->page_block, struct page, lru);
+	del_from_freelist(page, free_list, order);
+
+	list_add_tail(&page->lru, list);
+
+	area = &(page_zone(page)->free_area[order]);
+	area->nr_free -= nr_pages + 1;
+
+	/* Fix up the zone region stats, since del_from_freelist() altered it */
+	region->zone_region->nr_free += 1 << order;
+}
+
 /**
  * Move a given page from one freelist to another.
  */

