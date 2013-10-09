Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab3JIRdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:33:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3JIRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:33:10 -0400
Date: Wed, 9 Oct 2013 10:32:32 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b32e86b4301e345611f0446265f782a229faadf6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-53-git-send-email-mgorman@suse.de>
References: <1381141781-10992-53-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Add debugging
Git-Commit-ID: b32e86b4301e345611f0446265f782a229faadf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:32:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b32e86b4301e345611f0446265f782a229faadf6
Gitweb:     http://git.kernel.org/tip/b32e86b4301e345611f0446265f782a229faadf6
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 11:29:30 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:04 +0200

sched/numa: Add debugging

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1381141781-10992-53-git-send-email-mgorman@suse.de
---
 include/linux/sched.h |  6 ++++++
 kernel/sched/debug.c  | 60 +++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/fair.c   |  5 ++++-
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f638510..1127a46 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1366,6 +1366,7 @@ struct task_struct {
 	unsigned long *numa_faults_buffer;
 
 	int numa_preferred_nid;
+	unsigned long numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
 
 	struct rcu_head rcu;
@@ -2661,6 +2662,11 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return task_thread_info(p)->cpu;
 }
 
+static inline int task_node(const struct task_struct *p)
+{
+	return cpu_to_node(task_cpu(p));
+}
+
 extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
 
 #else
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1965599..e6ba5e3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
+#include <linux/mempolicy.h>
 
 #include "sched.h"
 
@@ -137,6 +138,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_NUMA_BALANCING
+	SEQ_printf(m, " %d", cpu_to_node(task_cpu(p)));
+#endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
 #endif
@@ -159,7 +163,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (!p->on_rq || task_cpu(p) != rq_cpu)
+		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
@@ -345,7 +349,7 @@ static void sched_debug_header(struct seq_file *m)
 	cpu_clk = local_clock();
 	local_irq_restore(flags);
 
-	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.11, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
@@ -488,6 +492,56 @@ static int __init init_sched_debug_procfs(void)
 
 __initcall(init_sched_debug_procfs);
 
+#define __P(F) \
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)F)
+#define P(F) \
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)p->F)
+#define __PN(F) \
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)F))
+#define PN(F) \
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
+
+
+static void sched_show_numa(struct task_struct *p, struct seq_file *m)
+{
+#ifdef CONFIG_NUMA_BALANCING
+	struct mempolicy *pol;
+	int node, i;
+
+	if (p->mm)
+		P(mm->numa_scan_seq);
+
+	task_lock(p);
+	pol = p->mempolicy;
+	if (pol && !(pol->flags & MPOL_F_MORON))
+		pol = NULL;
+	mpol_get(pol);
+	task_unlock(p);
+
+	SEQ_printf(m, "numa_migrations, %ld\n", xchg(&p->numa_pages_migrated, 0));
+
+	for_each_online_node(node) {
+		for (i = 0; i < 2; i++) {
+			unsigned long nr_faults = -1;
+			int cpu_current, home_node;
+
+			if (p->numa_faults)
+				nr_faults = p->numa_faults[2*node + i];
+
+			cpu_current = !i ? (task_node(p) == node) :
+				(pol && node_isset(node, pol->v.nodes));
+
+			home_node = (p->numa_preferred_nid == node);
+
+			SEQ_printf(m, "numa_faults, %d, %d, %d, %d, %ld\n",
+				i, node, cpu_current, home_node, nr_faults);
+		}
+	}
+
+	mpol_put(pol);
+#endif
+}
+
 void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
@@ -591,6 +645,8 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 		SEQ_printf(m, "%-45s:%21Ld\n",
 			   "clock-delta", (long long)(t1-t0));
 	}
+
+	sched_show_numa(p, m);
 }
 
 void proc_sched_set_task(struct task_struct *p)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1473499..2876a37 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1137,7 +1137,7 @@ static int task_numa_migrate(struct task_struct *p)
 		.p = p,
 
 		.src_cpu = task_cpu(p),
-		.src_nid = cpu_to_node(task_cpu(p)),
+		.src_nid = task_node(p),
 
 		.imbalance_pct = 112,
 
@@ -1515,6 +1515,9 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 	if (p->numa_migrate_retry && time_after(jiffies, p->numa_migrate_retry))
 		numa_migrate_preferred(p);
 
+	if (migrated)
+		p->numa_pages_migrated += pages;
+
 	p->numa_faults_buffer[task_faults_idx(node, priv)] += pages;
 }
 
