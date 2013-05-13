Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3EMTJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:09:25 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42873 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3EMTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:09:07 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 09/11] mm/page_alloc: factor zone_pageset_init() out of setup_zone_pageset()
Date: Mon, 13 May 2013 12:08:21 -0700
Message-Id: <1368472103-3427-10-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-3620-0000-0000-000002757322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 53c62c5..0c3cdbb6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4102,22 +4102,25 @@ static void setup_pagelist_highmark(struct per_cpu_pageset *p,
 	pageset_update(&p->pcp, high, batch);
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
1.8.2.2

