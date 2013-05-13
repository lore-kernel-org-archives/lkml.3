Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3EMTJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:09:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42687 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3EMTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:08:51 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 02/11] mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->high
Date: Mon, 13 May 2013 12:08:14 -0700
Message-Id: <1368472103-3427-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-3620-0000-0000-0000027572BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we are going to rely upon a careful transision between old and
new ->high and ->batch values using memory barriers and will remove
stop_machine(), we need to prevent multiple updaters from interweaving
their memory writes.

Add a simple mutex to protect both update loops.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e556e6..cea883d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -65,6 +65,9 @@
 #include <asm/div64.h>
 #include "internal.h"
 
+/* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
+static DEFINE_MUTEX(pcp_batch_high_lock);
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -5555,6 +5558,8 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (!write || (ret < 0))
 		return ret;
+
+	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
 		for_each_possible_cpu(cpu) {
 			unsigned long  high;
@@ -5563,6 +5568,7 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 				per_cpu_ptr(zone->pageset, cpu), high);
 		}
 	}
+	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
 }
 
@@ -6076,7 +6082,9 @@ static int __meminit __zone_pcp_update(void *data)
 
 void __meminit zone_pcp_update(struct zone *zone)
 {
+	mutex_lock(&pcp_batch_high_lock);
 	stop_machine(__zone_pcp_update, zone, NULL);
+	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
 
-- 
1.8.2.2

