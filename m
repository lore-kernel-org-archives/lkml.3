Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937214Ab3DJSYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:24:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42647 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934446Ab3DJSYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:24:34 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 10/11] mm/page_alloc: in zone_pcp_update(), uze zone_pageset_init()
Date: Wed, 10 Apr 2013 11:23:38 -0700
Message-Id: <1365618219-17154-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041018-5806-0000-0000-000020ACC207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, zone_pcp_update() called pageset_set_batch() directly,
essentially assuming that percpu_pagelist_fraction == 0. Correct this by
calling zone_pageset_init(), which chooses the appropriate ->batch and
->high calculations.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 749b6e1..5ee5ce9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6032,11 +6032,9 @@ void free_contig_range(unsigned long pfn, unsigned nr_pages)
 void __meminit zone_pcp_update(struct zone *zone)
 {
 	unsigned cpu;
-	unsigned long batch;
 	mutex_lock(&pcp_batch_high_lock);
-	batch = zone_batchsize(zone);
 	for_each_possible_cpu(cpu)
-		pageset_set_batch(per_cpu_ptr(zone->pageset, cpu), batch);
+		zone_pageset_init(zone, cpu);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
-- 
1.8.2.1

