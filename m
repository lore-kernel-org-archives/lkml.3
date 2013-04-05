Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162867Ab3DEUeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:34:31 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43063 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162735Ab3DEUe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:34:28 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use on_each_cpu() to set percpu pageset fields.
Date: Fri,  5 Apr 2013 13:33:50 -0700
Message-Id: <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040520-7182-0000-0000-0000061C4448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In free_hot_cold_page(), we rely on pcp->batch remaining stable.
Updating it without being on the cpu owning the percpu pageset
potentially destroys this stability.

Change for_each_cpu() to on_each_cpu() to fix.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 48f2faa..507db31 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5475,30 +5475,31 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
+static void _zone_set_pageset_highmark(void *data)
+{
+	struct zone *zone = data;
+	unsigned long  high;
+	high = zone->managed_pages / percpu_pagelist_fraction;
+	setup_pagelist_highmark(
+			per_cpu_ptr(zone->pageset, smp_processor_id()), high);
+}
+
 /*
  * percpu_pagelist_fraction - changes the pcp->high for each zone on each
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
  * can have before it gets flushed back to buddy allocator.
  */
-
 int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
-	unsigned int cpu;
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (!write || (ret < 0))
 		return ret;
-	for_each_populated_zone(zone) {
-		for_each_possible_cpu(cpu) {
-			unsigned long  high;
-			high = zone->managed_pages / percpu_pagelist_fraction;
-			setup_pagelist_highmark(
-				per_cpu_ptr(zone->pageset, cpu), high);
-		}
-	}
+	for_each_populated_zone(zone)
+		on_each_cpu(_zone_set_pageset_highmark, zone, true);
 	return 0;
 }
 
-- 
1.8.2

