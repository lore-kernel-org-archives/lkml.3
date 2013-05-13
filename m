Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3EMTOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:14:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46813 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab3EMTOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:14:04 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 06/11] mm/page_alloc: when handling percpu_pagelist_fraction, don't unneedly recalulate high
Date: Mon, 13 May 2013 12:08:18 -0700
Message-Id: <1368472103-3427-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-7182-0000-0000-000006AB069E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply moves calculation of the new 'high' value outside the
for_each_possible_cpu() loop, as it does not depend on the cpu.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5a00195..3583281 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5573,7 +5573,6 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
  * can have before it gets flushed back to buddy allocator.
  */
-
 int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
@@ -5587,12 +5586,11 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 
 	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
-		for_each_possible_cpu(cpu) {
-			unsigned long  high;
-			high = zone->managed_pages / percpu_pagelist_fraction;
+		unsigned long  high;
+		high = zone->managed_pages / percpu_pagelist_fraction;
+		for_each_possible_cpu(cpu)
 			setup_pagelist_highmark(
-				per_cpu_ptr(zone->pageset, cpu), high);
-		}
+					per_cpu_ptr(zone->pageset, cpu), high);
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
-- 
1.8.2.2

