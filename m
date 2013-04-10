Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936991Ab3DJSYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:24:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38141 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935479Ab3DJSYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:24:16 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 03/11] mm/page_alloc: insert memory barriers to allow async update of pcp batch and high
Date: Wed, 10 Apr 2013 11:23:31 -0700
Message-Id: <1365618219-17154-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041018-7182-0000-0000-0000062D9864
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce pageset_update() to perform a safe transision from one set of
pcp->{batch,high} to a new set using memory barriers.

This ensures that batch is always set to a safe value (1) prior to
updating high, and ensure that high is fully updated before setting the
real value of batch. It avoids ->batch ever rising above ->high.

Suggested by Gilad Ben-Yossef <gilad@benyossef.com> in these threads:

	https://lkml.org/lkml/2013/4/9/23
	https://lkml.org/lkml/2013/4/10/49

Also reproduces his proposed comment.

Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d259599..f2929df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4007,12 +4007,37 @@ static int __meminit zone_batchsize(struct zone *zone)
 #endif
 }
 
+/*
+ * pcp->high and pcp->batch values are related and dependent on one another:
+ * ->batch must never be higher then ->high.
+ * The following function updates them in a safe manner without read side
+ * locking.
+ *
+ * Any new users of pcp->batch and pcp->high should ensure they can cope with
+ * those fields changing asynchronously (acording the the above rule).
+ *
+ * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
+ * outside of boot time (or some other assurance that no concurrent updaters
+ * exist).
+ */
+static void pageset_update(struct per_cpu_pages *pcp, unsigned long high,
+		unsigned long batch)
+{
+       /* start with a fail safe value for batch */
+	pcp->batch = 1;
+	smp_wmb();
+
+       /* Update high, then batch, in order */
+	pcp->high = high;
+	smp_wmb();
+
+	pcp->batch = batch;
+}
+
 /* a companion to setup_pagelist_highmark() */
 static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 {
-	struct per_cpu_pages *pcp = &p->pcp;
-	pcp->high = 6 * batch;
-	pcp->batch = max(1UL, 1 * batch);
+	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
 }
 
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
@@ -4036,13 +4061,11 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 static void setup_pagelist_highmark(struct per_cpu_pageset *p,
 				unsigned long high)
 {
-	struct per_cpu_pages *pcp;
+	unsigned long batch = max(1UL, high / 4);
+	if ((high / 4) > (PAGE_SHIFT * 8))
+		batch = PAGE_SHIFT * 8;
 
-	pcp = &p->pcp;
-	pcp->high = high;
-	pcp->batch = max(1UL, high/4);
-	if ((high/4) > (PAGE_SHIFT * 8))
-		pcp->batch = PAGE_SHIFT * 8;
+	pageset_update(&p->pcp, high, batch);
 }
 
 static void __meminit setup_zone_pageset(struct zone *zone)
-- 
1.8.2.1

