Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3IYX1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:27:02 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33745 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab3IYX07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:26:59 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 39/40] mm: Add intelligence in kmempowerd to ignore
 regions unsuitable for evacuation
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
Date: Thu, 26 Sep 2013 04:52:42 +0530
Message-ID: <20130925232240.26184.54998.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-1618-0000-0000-000004B0A2BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance kmempowerd to determine situations where evacuating a region would prove
to be too costly or counter-productive, and ignore those regions for region
evacuation.

For example, if the region has a significant number of used pages (say more than
32), then evacuation will involve more work and might not be justifiable. Also,
compacting region 0 would be pointless, since that is the target of all our
compaction runs. Add these checks in the region-evacuator.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |    2 ++
 mm/compaction.c        |   25 +++++++++++++++++++++++--
 mm/internal.h          |    2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 257afdf..f383cc8d4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -84,6 +84,8 @@ static inline int get_pageblock_migratetype(struct page *page)
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
+#define MAX_MEMPWR_MIGRATE_PAGES	32
+
 struct mem_region_list {
 	struct list_head	*page_block;
 	unsigned long		nr_free;
diff --git a/mm/compaction.c b/mm/compaction.c
index b56be89..41585b0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1297,9 +1297,26 @@ void queue_mempower_work(struct pglist_data *pgdat, struct zone *zone,
 	queue_kthread_work(&pgdat->mempower_worker, &mpwork->work);
 }
 
+int should_evacuate_region(struct zone *z, struct zone_mem_region *region)
+{
+	unsigned long pages_in_use;
+
+	/* Don't try to evacuate region 0, since its the target of migration */
+	if (region == z->zone_regions)
+		return 0;
+
+	pages_in_use = region->present_pages - region->nr_free;
+
+	if (pages_in_use > 0 && pages_in_use <= MAX_MEMPWR_MIGRATE_PAGES)
+		return 1;
+
+	return 0;
+}
+
 static void kmempowerd(struct kthread_work *work)
 {
 	struct mempower_work *mpwork;
+	struct zone_mem_region *zmr;
 	struct zone *zone;
 	unsigned long flags;
 	int region_id;
@@ -1315,8 +1332,12 @@ repeat:
 	if (bitmap_empty(mpwork_mask, nr_zone_region_bits))
 		return;
 
-	for_each_set_bit(region_id, mpwork_mask, nr_zone_region_bits)
-		evacuate_mem_region(zone, &zone->zone_regions[region_id]);
+	for_each_set_bit(region_id, mpwork_mask, nr_zone_region_bits) {
+		zmr = &zone->zone_regions[region_id];
+
+		if (should_evacuate_region(zone, zmr))
+			evacuate_mem_region(zone, zmr);
+	}
 
 	spin_lock_irqsave(&mpwork->lock, flags);
 
diff --git a/mm/internal.h b/mm/internal.h
index 3fbc9f6..5b4658c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -184,6 +184,8 @@ int compact_range(struct compact_control *cc, struct aggression_control *ac,
 void queue_mempower_work(struct pglist_data *pgdat, struct zone *zone,
 			 int region_id);
 
+int should_evacuate_region(struct zone *z, struct zone_mem_region *region);
+
 #endif
 
 /*

