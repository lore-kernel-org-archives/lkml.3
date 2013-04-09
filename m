Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936739Ab3DIX3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:29:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53140 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936661Ab3DIX2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:28:51 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 04/10] mm/page_alloc: convert zone_pcp_update() to rely on memory barriers instead of stop_machine()
Date: Tue,  9 Apr 2013 16:28:13 -0700
Message-Id: <1365550099-6795-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040923-7182-0000-0000-00000629C6D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_pcp_update()'s goal is to adjust the ->high and ->mark members of a
percpu pageset based on a zone's ->managed_pages. We don't need to drain
the entire percpu pageset just to modify these fields.

This lets us avoid calling setup_pageset() (and the draining required to
call it) and instead allows simply setting the fields' values (with some
attention paid to memory barriers to prevent the relationship between
->batch and ->high from being thrown off).

This does change the behavior of zone_pcp_update() as the percpu
pagesets will not be drained when zone_pcp_update() is called (they will
end up being shrunk, not completely drained, later when a 0-order page
is freed in free_hot_cold_page()).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a07bd4c..4a03c56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6012,33 +6012,18 @@ void free_contig_range(unsigned long pfn, unsigned nr_pages)
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static int __meminit __zone_pcp_update(void *data)
-{
-	struct zone *zone = data;
-	int cpu;
-	unsigned long batch = zone_batchsize(zone), flags;
-
-	for_each_possible_cpu(cpu) {
-		struct per_cpu_pageset *pset;
-		struct per_cpu_pages *pcp;
-
-		pset = per_cpu_ptr(zone->pageset, cpu);
-		pcp = &pset->pcp;
-
-		local_irq_save(flags);
-		if (pcp->count > 0)
-			free_pcppages_bulk(zone, pcp->count, pcp);
-		drain_zonestat(zone, pset);
-		setup_pageset(pset, batch);
-		local_irq_restore(flags);
-	}
-	return 0;
-}
-
+/*
+ * The zone indicated has a new number of managed_pages; batch sizes and percpu
+ * page high values need to be recalulated.
+ */
 void __meminit zone_pcp_update(struct zone *zone)
 {
+	unsigned cpu;
+	unsigned long batch;
 	mutex_lock(&pcp_batch_high_lock);
-	stop_machine(__zone_pcp_update, zone, NULL);
+	batch = zone_batchsize(zone);
+	for_each_possible_cpu(cpu)
+		pageset_set_batch(per_cpu_ptr(zone->pageset, cpu), batch);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
-- 
1.8.2

