Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3IYXST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:18:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:56285 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3IYXSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:18:17 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 02/40] mm: Initialize node memory regions during boot
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
Date: Thu, 26 Sep 2013 04:44:03 +0530
Message-ID: <20130925231358.26184.34871.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-9574-0000-0000-000009CD095C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the node's memory-regions structures with the information about
the region-boundaries, at boot time.

Based-on-patch-by: Ankita Garg <gargankita@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mm.h |    4 ++++
 mm/page_alloc.c    |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b6e55e..223be46 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -620,6 +620,10 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define LAST_NID_MASK		((1UL << LAST_NID_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
+/* Hard-code memory region size to be 512 MB for now. */
+#define MEM_REGION_SHIFT	(29 - PAGE_SHIFT)
+#define MEM_REGION_SIZE		(1UL << MEM_REGION_SHIFT)
+
 static inline enum zone_type page_zonenum(const struct page *page)
 {
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ee638f..26835c4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4858,6 +4858,33 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
+static void __meminit init_node_memory_regions(struct pglist_data *pgdat)
+{
+	int nid = pgdat->node_id;
+	unsigned long start_pfn = pgdat->node_start_pfn;
+	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
+	struct node_mem_region *region;
+	unsigned long i, absent;
+	int idx;
+
+	for (i = start_pfn, idx = 0; i < end_pfn;
+				i += region->spanned_pages, idx++) {
+
+		region = &pgdat->node_regions[idx];
+		region->pgdat = pgdat;
+		region->start_pfn = i;
+		region->spanned_pages = min(MEM_REGION_SIZE, end_pfn - i);
+		region->end_pfn = region->start_pfn + region->spanned_pages;
+
+		absent = __absent_pages_in_range(nid, region->start_pfn,
+						 region->end_pfn);
+
+		region->present_pages = region->spanned_pages - absent;
+	}
+
+	pgdat->nr_node_regions = idx;
+}
+
 void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
@@ -4886,6 +4913,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 
 	free_area_init_core(pgdat, start_pfn, end_pfn,
 			    zones_size, zholes_size);
+	init_node_memory_regions(pgdat);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP

