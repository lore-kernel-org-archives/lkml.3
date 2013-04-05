Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162848Ab3DEUe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:34:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52188 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162735Ab3DEUeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:34:24 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/3] mm/page_alloc: convert zone_pcp_update() to use on_each_cpu() instead of stop_machine()
Date: Fri,  5 Apr 2013 13:33:49 -0700
Message-Id: <1365194030-28939-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040520-4834-0000-0000-0000058169AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No off-cpu users of the percpu pagesets exist.

zone_pcp_update()'s goal is to adjust the ->high and ->mark members of a
percpu pageset based on a zone's ->managed_pages. We don't need to drain
the entire percpu pageset just to modify these fields. Avoid calling
setup_pageset() (and the draining required to call it) and instead just
set the fields' values.

This does change the behavior of zone_pcp_update() as the percpu
pagesets will not be drained when zone_pcp_update() is called (they will
end up being shrunk, not completely drained, later when a 0-order page
is freed in free_hot_cold_page()).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5877cf0..48f2faa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5987,32 +5987,22 @@ void free_contig_range(unsigned long pfn, unsigned nr_pages)
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static int __meminit __zone_pcp_update(void *data)
+static void __meminit __zone_pcp_update(void *data)
 {
 	struct zone *zone = data;
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
+	unsigned long batch = zone_batchsize(zone);
+	struct per_cpu_pageset *pset =
+		per_cpu_ptr(zone->pageset, smp_processor_id());
+	pageset_set_batch(pset, batch);
 }
 
+/*
+ * The zone indicated has a new number of managed_pages; batch sizes and percpu
+ * page high values need to be recalulated.
+ */
 void __meminit zone_pcp_update(struct zone *zone)
 {
-	stop_machine(__zone_pcp_update, zone, NULL);
+	on_each_cpu(__zone_pcp_update, zone, true);
 }
 #endif
 
-- 
1.8.2

