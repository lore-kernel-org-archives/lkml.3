Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaLWOiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:38:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbaLWOiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:38:09 -0500
Date: Tue, 23 Dec 2014 06:37:25 -0800
From: tip-bot for Alex Thorlton <tipbot@zytor.com>
Message-ID: <tip-b74e6278fd6db5848163ccdc6e9d8eb6efdee9bd@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        gbeshers@sgi.com, athorlton@sgi.com, rja@sgi.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, hpa@zytor.com
Reply-To: gbeshers@sgi.com, mingo@kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, peterz@infradead.org,
        hpa@zytor.com, athorlton@sgi.com, rja@sgi.com
In-Reply-To: <1418928270-148543-1-git-send-email-athorlton@sgi.com>
References: <1418928270-148543-1-git-send-email-athorlton@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix KMALLOC_MAX_SIZE overflow during cpumask allocation
Git-Commit-ID: b74e6278fd6db5848163ccdc6e9d8eb6efdee9bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b74e6278fd6db5848163ccdc6e9d8eb6efdee9bd
Gitweb:     http://git.kernel.org/tip/b74e6278fd6db5848163ccdc6e9d8eb6efdee9bd
Author:     Alex Thorlton <athorlton@sgi.com>
AuthorDate: Thu, 18 Dec 2014 12:44:30 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Dec 2014 11:43:48 +0100

sched: Fix KMALLOC_MAX_SIZE overflow during cpumask allocation

When allocating space for load_balance_mask, in sched_init, when
CPUMASK_OFFSTACK is set, we've managed to spill over
KMALLOC_MAX_SIZE on our 6144 core machine.  The patch below
breaks up the allocations so that they don't overflow the max
alloc size.  It also allocates the masks on the the node from
which they'll most commonly be accessed, to minimize remote
accesses on NUMA machines.

Suggested-by: George Beshers <gbeshers@sgi.com>
Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: George Beshers <gbeshers@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418928270-148543-1-git-send-email-athorlton@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b7..c0accc0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7113,9 +7113,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size += num_possible_cpus() * cpumask_size();
-#endif
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
@@ -7135,13 +7132,13 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
+	}
 #ifdef CONFIG_CPUMASK_OFFSTACK
-		for_each_possible_cpu(i) {
-			per_cpu(load_balance_mask, i) = (void *)ptr;
-			ptr += cpumask_size();
-		}
-#endif /* CONFIG_CPUMASK_OFFSTACK */
+	for_each_possible_cpu(i) {
+		per_cpu(load_balance_mask, i) = (cpumask_var_t)kzalloc_node(
+			cpumask_size(), GFP_KERNEL, cpu_to_node(i));
 	}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
 
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
