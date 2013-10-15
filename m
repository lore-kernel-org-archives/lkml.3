Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab3JOUgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:36:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:42542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab3JOUgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:36:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,502,1378882800"; 
   d="scan'208";a="419637253"
Subject: [RFC][PATCH 3/8] mm: pcp: separate pageset update code from sysctl code
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, cl@gentwo.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 15 Oct 2013 13:35:42 -0700
References: <20131015203536.1475C2BE@viggo.jf.intel.com>
In-Reply-To: <20131015203536.1475C2BE@viggo.jf.intel.com>
Message-Id: <20131015203542.BE22E81D@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This begins the work of moving the percpu pageset sysctl code
out of page_alloc.c.  update_all_zone_pageset_limits() is the
now the only interface that the sysctl code *really* needs out
of page_alloc.c.

This helps make it very clear what the interactions are between
the actual sysctl code and the core page alloc code.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/mm/page_alloc.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~separate-pageset-code-from-sysctl mm/page_alloc.c
--- linux.git/mm/page_alloc.c~separate-pageset-code-from-sysctl	2013-10-15 09:57:06.415636275 -0700
+++ linux.git-davehans/mm/page_alloc.c	2013-10-15 09:57:06.421636541 -0700
@@ -5768,6 +5768,19 @@ int lowmem_reserve_ratio_sysctl_handler(
 	return 0;
 }
 
+void update_all_zone_pageset_limits(void)
+{
+	struct zone *zone;
+	unsigned int cpu;
+
+	mutex_lock(&pcp_batch_high_lock);
+	for_each_populated_zone(zone)
+		for_each_possible_cpu(cpu)
+			pageset_set_high_and_batch(zone,
+					per_cpu_ptr(zone->pageset, cpu));
+	mutex_unlock(&pcp_batch_high_lock);
+}
+
 /*
  * percpu_pagelist_fraction - changes the pcp->high for each zone on each
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu
@@ -5776,20 +5789,12 @@ int lowmem_reserve_ratio_sysctl_handler(
 int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	struct zone *zone;
-	unsigned int cpu;
-	int ret;
-
-	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	int ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (!write || (ret < 0))
 		return ret;
 
-	mutex_lock(&pcp_batch_high_lock);
-	for_each_populated_zone(zone)
-		for_each_possible_cpu(cpu)
-			pageset_set_high_and_batch(zone,
-					per_cpu_ptr(zone->pageset, cpu));
-	mutex_unlock(&pcp_batch_high_lock);
+	update_all_zone_pageset_limits();
+
 	return 0;
 }
 
_
