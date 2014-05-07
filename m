Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaEGUwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:52:16 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:52349 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbaEGUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:52:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocXACqaalNXQBiQ/2dsb2JhbABagwaDPahrCgUBmgoCAoEdF3SCUxMcIxgwUiQTiEUB0DSFVoh8EYQ1AQOPG4obAYsAh3uDNjs
Date: Wed, 7 May 2014 22:52:06 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH V2] MM: make vmpressure_win dynamic
Message-Id: <20140507225206.ea7cff02caf1118bb4b5a48d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize vmpressure_win in vmstat using
calculate_normal_threshold() based on each zone/cpu * SWAP_CLUSTER_SIZE

Value refreshed through cpu notifier and exposed in read-only through /sys/kernel

This is untested.

Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: Suggestions by Andrew Morton
  -Expose vmpressure_win 
  -Remove spinlock

 include/linux/swap.h |  4 ++++
 kernel/sysctl.c      | 10 ++++++++++
 mm/vmpressure.c      |  4 +---
 mm/vmstat.c          |  6 ++++++
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3507115..886897d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -354,6 +354,10 @@ extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern unsigned long vm_total_pages;
 
+#ifdef CONFIG_MEMCG
+extern unsigned long vmpressure_win;
+#endif
+
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b58..f347e3e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1202,6 +1202,16 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0444 /* read-only */,
 		.proc_handler   = pdflush_proc_obsolete,
 	},
+#ifdef CONFIG_MEMCG
+	{
+		.procname	= "vmpressure_window",
+		.data		= &vmpressure_win,
+		.maxlen		= sizeof(vmpressure_win),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+	},
+#endif
 	{
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index d4042e7..d738670 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -35,10 +35,8 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
 
 /*
  * These thresholds are used when we account memory pressure through
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 302dd07..ede68fd 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -20,6 +20,7 @@
 #include <linux/writeback.h>
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
+#include <linux/swap.h>
 
 #include "internal.h"
 
@@ -163,11 +164,13 @@ void refresh_zone_stat_thresholds(void)
 	struct zone *zone;
 	int cpu;
 	int threshold;
+	unsigned long new_vmpressure_win = 0;
 
 	for_each_populated_zone(zone) {
 		unsigned long max_drift, tolerate_drift;
 
 		threshold = calculate_normal_threshold(zone);
+		new_vmpressure_win += threshold;
 
 		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
@@ -184,6 +187,9 @@ void refresh_zone_stat_thresholds(void)
 			zone->percpu_drift_mark = high_wmark_pages(zone) +
 					max_drift;
 	}
+#ifdef CONFIG_MEMCG
+	vmpressure_win = new_vmpressure_win * SWAP_CLUSTER_MAX;
+#endif
 }
 
 void set_pgdat_percpu_threshold(pg_data_t *pgdat,
-- 
1.8.4.5

