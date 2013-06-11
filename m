Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3FKWNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:13:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56874 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3FKWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:13:46 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Valdis.Kletnieks@vt.edu, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] mm/page_alloc: don't re-init pageset in zone_pcp_update()
Date: Tue, 11 Jun 2013 15:12:59 -0700
Message-Id: <1370988779-7586-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061122-5518-0000-0000-00000F8EB82D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor pageset_set_high_and_batch() (which contains all needed logic too
set a pageset's ->high and ->batch inrespective of system state) out of
zone_pageset_init(), which avoids us calling pageset_init(), and
unsafely blowing away a pageset at runtime (leaked pages and
potentially some funky allocations would be the result) when memory
hotplug is triggered.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---

Unless memory hotplug is being triggered on boot, this should *not* be cause of Valdis
Kletnieks' reported bug in -next:
         "next-20130607 BUG: Bad page state in process systemd pfn:127643"

---

 mm/page_alloc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18102e1..f62c7ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4111,11 +4111,9 @@ static void pageset_set_high(struct per_cpu_pageset *p,
 	pageset_update(&p->pcp, high, batch);
 }
 
-static void __meminit zone_pageset_init(struct zone *zone, int cpu)
+static void __meminit pageset_set_high_and_batch(struct zone *zone,
+		struct per_cpu_pageset *pcp)
 {
-	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
-
-	pageset_init(pcp);
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
 			(zone->managed_pages /
@@ -4124,6 +4122,14 @@ static void __meminit zone_pageset_init(struct zone *zone, int cpu)
 		pageset_set_batch(pcp, zone_batchsize(zone));
 }
 
+static void __meminit zone_pageset_init(struct zone *zone, int cpu)
+{
+	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
+
+	pageset_init(pcp);
+	pageset_set_high_and_batch(zone, pcp);
+}
+
 static void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
@@ -6173,7 +6179,8 @@ void __meminit zone_pcp_update(struct zone *zone)
 	unsigned cpu;
 	mutex_lock(&pcp_batch_high_lock);
 	for_each_possible_cpu(cpu)
-		zone_pageset_init(zone, cpu);
+		pageset_set_high_and_batch(zone,
+				per_cpu_ptr(zone->pageset, cpu));
 	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
-- 
1.8.3

