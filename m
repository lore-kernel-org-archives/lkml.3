Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936812Ab3DIX3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:29:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34104 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936672Ab3DIX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:28:59 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 08/10] mm/page_alloc: factor zone_pageset_init() out of setup_zone_pageset()
Date: Tue,  9 Apr 2013 16:28:17 -0700
Message-Id: <1365550099-6795-9-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040923-3620-0000-0000-000001F68377
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e52e67..c663e62 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4069,22 +4069,25 @@ static void setup_pagelist_highmark(struct per_cpu_pageset *p,
 		pcp->batch = PAGE_SHIFT * 8;
 }
 
+static void __meminit zone_pageset_init(struct zone *zone, int cpu)
+{
+	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
+
+	pageset_init(pcp);
+	if (percpu_pagelist_fraction)
+		setup_pagelist_highmark(pcp,
+			(zone->managed_pages /
+				percpu_pagelist_fraction));
+	else
+		pageset_set_batch(pcp, zone_batchsize(zone));
+}
+
 static void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
-
 	zone->pageset = alloc_percpu(struct per_cpu_pageset);
-
-	for_each_possible_cpu(cpu) {
-		struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
-
-		setup_pageset(pcp, zone_batchsize(zone));
-
-		if (percpu_pagelist_fraction)
-			setup_pagelist_highmark(pcp,
-				(zone->managed_pages /
-					percpu_pagelist_fraction));
-	}
+	for_each_possible_cpu(cpu)
+		zone_pageset_init(zone, cpu);
 }
 
 /*
-- 
1.8.2

