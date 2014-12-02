Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaLBRSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:18:08 -0500
Received: from relay1.sgi.com ([192.48.180.66]:60423 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaLBRSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:18:06 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, George Beshers <gbeshers@sgi.com>,
        Russ Anderson <rja@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] Fix KMALLOC_MAX_SIZE overflow during cpumask allocation
Date: Tue,  2 Dec 2014 11:17:44 -0600
Message-Id: <1417540664-51393-1-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating space for load_balance_mask, in sched_init, when
CPUMASK_OFFSTACK is set, we've managed to spill over KMALLOC_MAX_SIZE on our
6144 core machine.  The patch below breaks up the allocations so that they don't
overflow the max alloc size.  It also allocates the masks on the the node from
which they'll most commonly be accessed, to minimize remote accesses on NUMA
machines.

Any input is appreciated!

- Alex

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Suggested-by: George Beshers <gbeshers@sgi.com>
Cc: George Beshers <gbeshers@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org

---
 kernel/sched/core.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4499950..8f06655 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6981,9 +6981,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size += num_possible_cpus() * cpumask_size();
-#endif
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
@@ -7003,12 +7000,10 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
-#ifdef CONFIG_CPUMASK_OFFSTACK
-		for_each_possible_cpu(i) {
-			per_cpu(load_balance_mask, i) = (void *)ptr;
-			ptr += cpumask_size();
-		}
-#endif /* CONFIG_CPUMASK_OFFSTACK */
+	}
+	for_each_possible_cpu(i) {
+		per_cpu(load_balance_mask, i) = kzalloc_node(
+			cpumask_size(), GFP_KERNEL, cpu_to_node(i));
 	}
 
 	init_rt_bandwidth(&def_rt_bandwidth,
-- 
1.7.12.4

