Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3IYXZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:25:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58795 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3IYXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:25:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 31/40] mm: Never change migratetypes of pageblocks
 during freepage stealing
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
Date: Thu, 26 Sep 2013 04:50:43 +0530
Message-ID: <20130925232041.26184.31799.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-0260-0000-0000-000003AFFCCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to keep large chunks of memory (of the size of memory regions)
populated by allocations of a single migratetype. This helps in influencing
allocation/reclaim decisions at a per-migratetype basis, which would also
automatically respect memory region boundaries.

For example, if a region is known to contain only MIGRATE_UNMOVABLE pages,
we can skip trying targeted compaction on that region. Similarly, if a region
has only MIGRATE_MOVABLE pages, then the likelihood of successful targeted
evacuation of that region is higher, as opposed to having a few unmovable
pages embedded in a region otherwise containing mostly movable allocations.
Thus, it is beneficial to try and keep memory allocations homogeneous (in
terms of the migratetype) in region-sized chunks of memory.

Changing the migratetypes of pageblocks during freepage stealing comes in the
way of this effort, since it fragments the ownership of memory segments.
So never change the ownership of pageblocks during freepage stealing.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 939f378..fd32533 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1649,14 +1649,16 @@ static void change_pageblock_range(struct page *pageblock_page,
 /*
  * If breaking a large block of pages, move all free pages to the preferred
  * allocation list. If falling back for a reclaimable kernel allocation, be
- * more aggressive about taking ownership of free pages.
+ * more aggressive about borrowing the free pages.
  *
- * On the other hand, never change migration type of MIGRATE_CMA pageblocks
- * nor move CMA pages to different free lists. We don't want unmovable pages
- * to be allocated from MIGRATE_CMA areas.
+ * On the other hand, never move CMA pages to different free lists. We don't
+ * want unmovable pages to be allocated from MIGRATE_CMA areas.
  *
- * Returns the new migratetype of the pageblock (or the same old migratetype
- * if it was unchanged).
+ * Also, we *NEVER* change the pageblock migratetype of any block of memory.
+ * (IOW, we only try to _loan_ the freepages from a fallback list, but never
+ * try to _own_ them.)
+ *
+ * Returns the migratetype of the fallback list.
  */
 static int try_to_steal_freepages(struct zone *zone, struct page *page,
 				  int start_type, int fallback_type)
@@ -1666,28 +1668,10 @@ static int try_to_steal_freepages(struct zone *zone, struct page *page,
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
 
-	/* Take ownership for orders >= pageblock_order */
-	if (current_order >= pageblock_order) {
-		change_pageblock_range(page, current_order, start_type);
-		return start_type;
-	}
-
 	if (current_order >= pageblock_order / 2 ||
 	    start_type == MIGRATE_RECLAIMABLE ||
-	    page_group_by_mobility_disabled) {
-		int pages;
-
-		pages = move_freepages_block(zone, page, start_type);
-
-		/* Claim the whole block if over half of it is free */
-		if (pages >= (1 << (pageblock_order-1)) ||
-				page_group_by_mobility_disabled) {
-
-			set_pageblock_migratetype(page, start_type);
-			return start_type;
-		}
-
-	}
+	    page_group_by_mobility_disabled)
+		move_freepages_block(zone, page, start_type);
 
 	return fallback_type;
 }

