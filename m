Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3IYXWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:22:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42122 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3IYXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:22:08 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 17/40] mm: Add a mechanism to add pages to buddy
 freelists in bulk
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
Date: Thu, 26 Sep 2013 04:47:50 +0530
Message-ID: <20130925231748.26184.78290.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-1618-0000-0000-000004B0A1AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the buddy page allocator requests the region allocator for memory,
it gets all the freepages belonging to an entire region at once. So, in
order to make it efficient, we need a way to add all those pages to the
buddy freelists in one shot. Add this support, and also take care to
update the nr-free statistics properly.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 876c231..c3a2cda 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -693,6 +693,52 @@ out:
 	set_region_bit(region_id, free_list);
 }
 
+/*
+ * Add all the freepages contained in 'list' to the buddy freelist
+ * 'free_list'. Using suitable list-manipulation tricks, we move the
+ * pages between the lists in one shot.
+ */
+static void add_to_freelist_bulk(struct list_head *list,
+				 struct free_list *free_list, int order,
+				 int region_id)
+{
+	struct list_head *cur, *position;
+	struct mem_region_list *region;
+	unsigned long nr_pages = 0;
+	struct free_area *area;
+	struct page *page;
+
+	if (list_empty(list))
+		return;
+
+	page = list_first_entry(list, struct page, lru);
+	list_del(&page->lru);
+
+	/*
+	 * Add one page using add_to_freelist() so that it sets up the
+	 * region related data-structures of the freelist properly.
+	 */
+	add_to_freelist(page, free_list, order);
+
+	/* Now add the rest of the pages in bulk */
+	list_for_each(cur, list)
+		nr_pages++;
+
+	position = free_list->mr_list[region_id].page_block;
+	list_splice_tail(list, position);
+
+
+	/* Update the statistics */
+	region = &free_list->mr_list[region_id];
+	region->nr_free += nr_pages;
+
+	area = &(page_zone(page)->free_area[order]);
+	area->nr_free += nr_pages + 1;
+
+	/* Fix up the zone region stats, since add_to_freelist() altered it */
+	region->zone_region->nr_free -= 1 << order;
+}
+
 /**
  * __rmqueue_smallest() *always* deletes elements from the head of the
  * list. Use this knowledge to keep page allocation fast, despite being

