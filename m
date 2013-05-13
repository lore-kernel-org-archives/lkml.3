Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3EMTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:09:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36528 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab3EMTJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:09:14 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 10/11] mm/page_alloc: in zone_pcp_update(), uze zone_pageset_init()
Date: Mon, 13 May 2013 12:08:22 -0700
Message-Id: <1368472103-3427-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-7182-0000-0000-000006AB01F0
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
index 0c3cdbb6..251fb5f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6096,11 +6096,9 @@ void free_contig_range(unsigned long pfn, unsigned nr_pages)
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
1.8.2.2

