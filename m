Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaEPGPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbaEPGPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:15:20 -0400
Date: Fri, 16 May 2014 02:14:50 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chegu_vinod@hp.com, mingo@kernel.org,
        umgwanakikbuti@gmail.com
Subject: [PATCH RFC] sched,numa: move tasks to preferred_node at wakeup time
Message-ID: <20140516021450.473361ea@annuminas.surriel.com>
In-Reply-To: <20140516001332.67f91af2@annuminas.surriel.com>
References: <20140516001332.67f91af2@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not have performance numbers in yet, but with this patch on
top of all the previous ones, I see RMA/LMA ratios (as reported
by numatop) drop well below 1 for a SPECjbb2013, most of the time.

In other words, we actually manage to run the processes where
their memory is most of the time. Sometimes tasks get moved away
from their memory for a bit, but I suspect this patch is a move
in the right direction.

With luck I will have performance numbers this afternoon (EST).

---8<---

Subject: sched,numa: move tasks to preferred_node at wakeup time

If a task is caught running off-node at wakeup time, check if it can
be moved to its preferred node without creating a load imbalance.

This is only done when the system has already decided not to do an
affine wakeup.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0381b11..bb5b048 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4178,6 +4178,79 @@ static int wake_wide(struct task_struct *p)
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+static int numa_balance_on_wake(struct task_struct *p, int prev_cpu)
+{
+	long load, src_load, dst_load;
+	int cur_node = cpu_to_node(prev_cpu);
+	struct numa_group *numa_group = ACCESS_ONCE(p->numa_group);
+	struct sched_domain *sd;
+	struct task_numa_env env = {
+		.p = p,
+		.best_task = NULL,
+		.best_imp = 0,
+		.best_cpu = -1
+	};
+
+	if (!sched_feat(NUMA))
+		return prev_cpu;
+
+	if (p->numa_preferred_nid == -1)
+		return prev_cpu;
+
+	if (p->numa_preferred_nid == cur_node);
+		return prev_cpu;
+
+	if (numa_group && node_isset(cur_node, numa_group->active_nodes))
+		return prev_cpu;
+
+	sd = rcu_dereference(per_cpu(sd_numa, env.src_cpu));
+	if (sd)
+		env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
+
+	/*
+	 * Cpusets can break the scheduler domain tree into smaller
+	 * balance domains, some of which do not cross NUMA boundaries.
+	 * Tasks that are "trapped" in such domains cannot be migrated
+	 * elsewhere, so there is no point in (re)trying.
+	 */
+	if (unlikely(!sd)) {
+		p->numa_preferred_nid = cur_node;
+		return prev_cpu;
+	}
+
+	/*
+	 * Only allow p to move back to its preferred nid if
+	 * that does not create an imbalance that would cause
+	 * the load balancer to move a task around later.
+	 */
+	env.src_nid = cur_node;
+	env.dst_nid = p->numa_preferred_nid;
+
+	update_numa_stats(&env.src_stats, env.src_nid);
+	update_numa_stats(&env.dst_stats, env.dst_nid);
+
+	dst_load = env.dst_stats.load;
+	src_load = env.src_stats.load;
+
+	/* XXX missing power terms */
+	load = task_h_load(p);
+	dst_load += load;
+	src_load -= load;
+
+	if (load_too_imbalanced(env.src_stats.load, env.dst_stats.load,
+				src_load, dst_load, &env))
+		return prev_cpu;
+
+	return cpumask_first(cpumask_of_node(p->numa_preferred_nid));
+}
+#else
+static int numa_balance_on_wake(struct task_struct *p, int prev_cpu)
+{
+	return prev_cpu;
+}
+#endif
+
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
@@ -4440,6 +4513,8 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 
 	if (affine_sd && cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 		prev_cpu = cpu;
+	else if (sd_flag & SD_WAKE_AFFINE)
+		prev_cpu = numa_balance_on_wake(p, prev_cpu);
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		new_cpu = select_idle_sibling(p, prev_cpu);
