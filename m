Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab3JOUf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:35:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:9130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933733Ab3JOUfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:35:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,502,1378882800"; 
   d="scan'208";a="375184960"
Subject: [RFC][PATCH 1/8] mm: pcp: rename percpu pageset functions
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, cl@gentwo.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 15 Oct 2013 13:35:38 -0700
References: <20131015203536.1475C2BE@viggo.jf.intel.com>
In-Reply-To: <20131015203536.1475C2BE@viggo.jf.intel.com>
Message-Id: <20131015203538.35606A47@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The per-cpu-pageset code has two distinct ways of being set up:
 1. The boot-time code (the defaults that everybody runs with)
    calculates a batch size, then sets pcp->high to 6x that
    batch size.
 2. The percpu_pagelist_fraction sysctl code takes a pcp->high
    value in from userspace and sets pcp->batch value to 1/4
    of the ->high value.

The crummy part is that those are called pageset_set_batch() and
pageset_set_high(), respectively.  Those names make it sound
awfully like high *OR* batch is being set, when actually both
are being set.

This patch renames those two setup functions to be more clear in
what they are doing:
 1. pageset_setup_from_batch_size(batch)
 2. pageset_setup_from_high_mark(high)

The "max(1UL, 1 * batch)" construct was from Christoph Lameter in
commit 2caaad41.  I'm not quite sure what the purpose of the
"1 * batch" is.  Considering that 'batch' is unsigned, the only
value the max() could be correcting is 0.  Just make the check a
plain old if() so that it is a bit less obtuse.

Note: pageset_setup_from_high_mark() does not survive this
series.  I change it here for clarity and parity with its twin
even though I eventually kill it.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/mm/page_alloc.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~rename-pageset-functions mm/page_alloc.c
--- linux.git/mm/page_alloc.c~rename-pageset-functions	2013-10-15 09:57:05.870612107 -0700
+++ linux.git-davehans/mm/page_alloc.c	2013-10-15 09:57:05.875612329 -0700
@@ -4136,10 +4136,18 @@ static void pageset_update(struct per_cp
 	pcp->batch = batch;
 }
 
-/* a companion to pageset_set_high() */
-static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
+/*
+ * Set the batch size for hot per_cpu_pagelist, and derive
+ * the high water mark from the batch size.
+ */
+static void pageset_setup_from_batch_size(struct per_cpu_pageset *p,
+					unsigned long batch)
 {
-	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
+	unsigned long high;
+	high = 6 * batch;
+	if (!batch)
+		batch = 1;
+	pageset_update(&p->pcp, high, batch);
 }
 
 static void pageset_init(struct per_cpu_pageset *p)
@@ -4158,15 +4166,15 @@ static void pageset_init(struct per_cpu_
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	pageset_init(p);
-	pageset_set_batch(p, batch);
+	pageset_setup_from_batch_size(p, batch);
 }
 
 /*
- * pageset_set_high() sets the high water mark for hot per_cpu_pagelist
- * to the value high for the pageset p.
+ * Set the high water mark for the per_cpu_pagelist, and derive
+ * the batch size from this high mark.
  */
-static void pageset_set_high(struct per_cpu_pageset *p,
-				unsigned long high)
+static void pageset_setup_from_high_mark(struct per_cpu_pageset *p,
+					unsigned long high)
 {
 	unsigned long batch = max(1UL, high / 4);
 	if ((high / 4) > (PAGE_SHIFT * 8))
@@ -4179,11 +4187,11 @@ static void __meminit pageset_set_high_a
 		struct per_cpu_pageset *pcp)
 {
 	if (percpu_pagelist_fraction)
-		pageset_set_high(pcp,
+		pageset_setup_from_high_mark(pcp,
 			(zone->managed_pages /
 				percpu_pagelist_fraction));
 	else
-		pageset_set_batch(pcp, zone_batchsize(zone));
+		pageset_setup_from_batch_size(pcp, zone_batchsize(zone));
 }
 
 static void __meminit zone_pageset_init(struct zone *zone, int cpu)
@@ -5781,8 +5789,9 @@ int percpu_pagelist_fraction_sysctl_hand
 		unsigned long  high;
 		high = zone->managed_pages / percpu_pagelist_fraction;
 		for_each_possible_cpu(cpu)
-			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
-					 high);
+			pageset_setup_from_high_mark(
+					per_cpu_ptr(zone->pageset, cpu),
+					high);
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
_
