Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3EMTI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:08:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41444 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab3EMTIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:08:48 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 01/11] mm/page_alloc: factor out setting of pcp->high and pcp->batch.
Date: Mon, 13 May 2013 12:08:13 -0700
Message-Id: <1368472103-3427-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-5806-0000-0000-0000211D8919
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creates pageset_set_batch() for use in setup_pageset().
pageset_set_batch() imitates the functionality of
setup_pagelist_highmark(), but uses the boot time
(percpu_pagelist_fraction == 0) calculations for determining ->high
based on ->batch.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 98cbdf6..9e556e6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4030,6 +4030,14 @@ static int __meminit zone_batchsize(struct zone *zone)
 #endif
 }
 
+/* a companion to setup_pagelist_highmark() */
+static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
+{
+	struct per_cpu_pages *pcp = &p->pcp;
+	pcp->high = 6 * batch;
+	pcp->batch = max(1UL, 1 * batch);
+}
+
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
@@ -4039,8 +4047,7 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 
 	pcp = &p->pcp;
 	pcp->count = 0;
-	pcp->high = 6 * batch;
-	pcp->batch = max(1UL, 1 * batch);
+	pageset_set_batch(p, batch);
 	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
@@ -4049,7 +4056,6 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
  * setup_pagelist_highmark() sets the high water mark for hot per_cpu_pagelist
  * to the value high for the pageset p.
  */
-
 static void setup_pagelist_highmark(struct per_cpu_pageset *p,
 				unsigned long high)
 {
-- 
1.8.2.2

