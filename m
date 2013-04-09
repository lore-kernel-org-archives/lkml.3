Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936727Ab3DIX3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:29:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53127 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936654Ab3DIX2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:28:49 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 03/10] mm/page_alloc: insert memory barriers to allow async update of pcp batch and high
Date: Tue,  9 Apr 2013 16:28:12 -0700
Message-Id: <1365550099-6795-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040923-7182-0000-0000-00000629C6D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pageset_set_batch() and setup_pagelist_highmark(), ensure that batch
is always set to a safe value (1) prior to updating high, and ensure
that high is fully updated before setting the real value of batch.

Suggested by Gilad Ben-Yossef <gilad@benyossef.com> in this thread:

	https://lkml.org/lkml/2013/4/9/23

Also reproduces his proposed comment.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d259599..a07bd4c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4007,11 +4007,26 @@ static int __meminit zone_batchsize(struct zone *zone)
 #endif
 }
 
+static void pageset_update_prep(struct per_cpu_pages *pcp)
+{
+	/*
+	 * We're about to mess with PCP in an non atomic fashion.  Put an
+	 * intermediate safe value of batch and make sure it is visible before
+	 * any other change
+	 */
+	pcp->batch = 1;
+	smp_wmb();
+}
+
 /* a companion to setup_pagelist_highmark() */
 static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp = &p->pcp;
+	pageset_update_prep(pcp);
+
 	pcp->high = 6 * batch;
+	smp_wmb();
+
 	pcp->batch = max(1UL, 1 * batch);
 }
 
@@ -4039,7 +4054,11 @@ static void setup_pagelist_highmark(struct per_cpu_pageset *p,
 	struct per_cpu_pages *pcp;
 
 	pcp = &p->pcp;
+	pageset_update_prep(pcp);
+
 	pcp->high = high;
+	smp_wmb();
+
 	pcp->batch = max(1UL, high/4);
 	if ((high/4) > (PAGE_SHIFT * 8))
 		pcp->batch = PAGE_SHIFT * 8;
-- 
1.8.2

