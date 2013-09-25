Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3IYXYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:24:47 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:60417 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3IYXYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:24:45 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 30/40] mm: Modify move_freepages() to handle pages in
 the region allocator properly
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
Date: Thu, 26 Sep 2013 04:50:27 +0530
Message-ID: <20130925232025.26184.6209.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-9264-0000-0000-0000049A11D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations in which the memory management subsystem needs to move
pages from one migratetype to another, such as when setting up the per-zone
migrate reserves (where freepages are moved from MIGRATE_MOVABLE to
MIGRATE_RESERVE freelists).

But the existing code that does freepage movement is unaware of the region
allocator. In other words, it always assumes that the freepages that it is
moving are always in the buddy page allocator's freelists. But with the
introduction of the region allocator, the freepages could instead reside
in the region allocator as well. So teach move_freepages() to check whether
the pages are in the buddy page allocator's freelists or the region
allocator and handle the two cases appropriately.

The region allocator is designed in such a way that it always allocates
or receives entire memory regions as a single unit. To retain these
semantics during freepage movement, we first move all the pages of that
region from the region allocator to the MIGRATE_MOVABLE buddy freelist
and then move the requested page(s) from MIGRATE_MOVABLE to the required
migratetype.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed5298c..939f378 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1558,7 +1558,7 @@ int move_freepages(struct zone *zone,
 	struct page *page;
 	unsigned long order;
 	struct free_area *area;
-	int pages_moved = 0, old_mt;
+	int pages_moved = 0, old_mt, region_id;
 
 #ifndef CONFIG_HOLES_IN_ZONE
 	/*
@@ -1585,7 +1585,23 @@ int move_freepages(struct zone *zone,
 			continue;
 		}
 
+		/*
+		 * If the page is in the region allocator, we first move the
+		 * region to the MIGRATE_MOVABLE buddy freelists and then move
+		 * that page to the freelist of the requested migratetype.
+		 * This is because the region allocator operates on whole region-
+		 * sized chunks, whereas here we want to move pages in much
+		 * smaller chunks.
+		 */
 		order = page_order(page);
+		if (page_in_region_allocator(page)) {
+			region_id = page_zone_region_id(page);
+			__del_from_region_allocator(zone, order, MIGRATE_MOVABLE,
+						    region_id);
+
+			continue; /* Try this page again from the buddy-list */
+		}
+
 		old_mt = get_freepage_migratetype(page);
 		area = &zone->free_area[order];
 		move_page_freelist(page, &area->free_list[old_mt],

