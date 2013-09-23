Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3IWTY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:24:28 -0400
Received: from a9-97.smtp-out.amazonses.com ([54.240.9.97]:53977 "EHLO
	a9-97.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab3IWTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:24:26 -0400
Message-ID: <000001414c47a1ab-17a7541e-54ac-4c15-8a02-66c83c358cbd-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 23 Sep 2013 19:24:25 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [pchecks v1 3/4] Use raw_cpu_ops for refresh_cpu_vm_stats()
References: <20130923191256.584672290@linux.com>
X-SES-Outgoing: 2013.09.23-54.240.9.97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not care about races for the expiration logic in
refresh_cpu_vm_stats(). Draining is a rare act after all.
No need to create too much overhead for that.

Use raw_cpu_ops there.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c	2013-09-23 10:20:31.742262228 -0500
+++ linux/mm/vmstat.c	2013-09-23 10:20:31.738262268 -0500
@@ -439,6 +439,10 @@ static inline void fold_diff(int *diff)
  * statistics in the remote zone struct as well as the global cachelines
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
+ *
+ * Note that we have to use raw_cpu ops here. The thread is pinned
+ * to a specific processor but the preempt checking logic does not
+ * know about this.
  */
 static void refresh_cpu_vm_stats(void)
 {
@@ -459,7 +463,7 @@ static void refresh_cpu_vm_stats(void)
 				global_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
-				__this_cpu_write(p->expire, 3);
+				raw_cpu_write(p->expire, 3);
 #endif
 			}
 		}
@@ -472,23 +476,23 @@ static void refresh_cpu_vm_stats(void)
 		 * Check if there are pages remaining in this pageset
 		 * if not then there is nothing to expire.
 		 */
-		if (!__this_cpu_read(p->expire) ||
-			       !__this_cpu_read(p->pcp.count))
+		if (!raw_cpu_read(p->expire) ||
+			       !raw_cpu_read(p->pcp.count))
 			continue;
 
 		/*
 		 * We never drain zones local to this processor.
 		 */
 		if (zone_to_nid(zone) == numa_node_id()) {
-			__this_cpu_write(p->expire, 0);
+			raw_cpu_write(p->expire, 0);
 			continue;
 		}
 
 
-		if (__this_cpu_dec_return(p->expire))
+		if (raw_cpu_dec_return(p->expire))
 			continue;
 
-		if (__this_cpu_read(p->pcp.count))
+		if (raw_cpu_read(p->pcp.count))
 			drain_zone_pages(zone, __this_cpu_ptr(&p->pcp));
 #endif
 	}

