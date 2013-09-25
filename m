Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3IYXXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:23:11 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42068 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IYXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:23:07 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 22/40] mm: Propagate the sorted-buddy bias for picking
 free regions, to region allocator
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
Date: Thu, 26 Sep 2013 04:48:53 +0530
Message-ID: <20130925231852.26184.31885.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-2000-0000-0000-00000DDDF0A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sorted-buddy page allocator keeps the buddy freelists sorted region-wise,
and tries to pick lower numbered regions while allocating pages. The idea is
to allocate regions in the increasing order of region number.

Propagate the same bias to the region allocator as well. That is, make it
favor lower numbered regions while allocating regions to the page allocator.
To do this efficiently, add a bitmap to represent the regions in the region
allocator, and use bitmap operations to manage these regions and to pick the
lowest numbered free region efficiently.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7c87518..49c8926 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -125,6 +125,7 @@ struct mem_region {
 struct region_allocator {
 	struct mem_region	region[MAX_NR_ZONE_REGIONS];
 	int			next_region;
+	DECLARE_BITMAP(ralloc_mask, MAX_NR_ZONE_REGIONS);
 };
 
 struct pglist_data;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee6c098..d5acea7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -935,7 +935,7 @@ static void add_to_region_allocator(struct zone *z, struct free_list *free_list,
 	struct free_area_region *reg_area;
 	struct list_head *ralloc_list;
 	unsigned long nr_pages;
-	int order;
+	int order, *next_region;
 
 	if (WARN_ON(list_empty(&free_list->list)))
 		return;
@@ -952,6 +952,13 @@ static void add_to_region_allocator(struct zone *z, struct free_list *free_list,
 
 	WARN_ON(reg_area->nr_free != 0);
 	reg_area->nr_free += nr_pages;
+
+	set_bit(region_id, reg_alloc->ralloc_mask);
+	next_region = &reg_alloc->next_region;
+
+	if ((*next_region < 0) ||
+			(*next_region > 0 && region_id < *next_region))
+		*next_region = region_id;
 }
 
 /* Delete freepages from the region allocator and add them to buddy freelists */
@@ -982,6 +989,16 @@ static int del_from_region_allocator(struct zone *zone, unsigned int order,
 	reg_area->nr_free -= nr_pages;
 	WARN_ON(reg_area->nr_free != 0);
 
+	/* Pick a new next_region */
+	clear_bit(next_region, reg_alloc->ralloc_mask);
+	next_region = find_first_bit(reg_alloc->ralloc_mask,
+				     MAX_NR_ZONE_REGIONS);
+
+	if (next_region >= MAX_NR_ZONE_REGIONS)
+		next_region = -1; /* No free regions available */
+
+	reg_alloc->next_region = next_region;
+
 	return 0;
 }
 

