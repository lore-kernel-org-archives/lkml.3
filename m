Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3A2JK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:10:58 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35077 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3A2JKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:10:55 -0500
Message-ID: <51079215.1070309@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 17:10:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [RFC PATCH v3 3/3] sched: simplify select_task_rq_fair() with schedule
 balance map
References: <51079178.3070002@linux.vnet.ibm.com>
In-Reply-To: <51079178.3070002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012909-3568-0000-0000-00000316CB96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since schedule balance map provide the approach to get proper sd directly,
simplify the code of select_task_rq_fair() is possible.

The new code is designed to reserve most of the old logical, but get rid
of those 'for' by using the schedule balance map to locate proper sd
directly.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |  135 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 74 insertions(+), 61 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..0935c7d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3302,100 +3302,113 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
+ * select_task_rq_fair()
+ *		select a proper cpu for task to run.
  *
- * Balance, ie. select the least loaded group.
- *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
- *
- * preempt must be disabled.
+ *	p		-- the task we are going to select cpu for
+ *	sd_flag		-- indicate the context, WAKE, EXEC or FORK.
+ *	wake_flag	-- we only care about WF_SYNC currently
  */
 static int
 select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
-	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
+	struct sched_domain *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
+	struct sched_balance_map *sbm = NULL;
+	int type = 0;
 
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
-	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-			want_affine = 1;
-		new_cpu = prev_cpu;
-	}
+	if (sd_flag & SD_BALANCE_EXEC)
+		type = SBM_EXEC_TYPE;
+	else if (sd_flag & SD_BALANCE_FORK)
+		type = SBM_FORK_TYPE;
+	else if (sd_flag & SD_BALANCE_WAKE)
+		type = SBM_WAKE_TYPE;
 
 	rcu_read_lock();
-	for_each_domain(cpu, tmp) {
-		if (!(tmp->flags & SD_LOAD_BALANCE))
-			continue;
 
+	sbm = cpu_rq(cpu)->sbm;
+	if (!sbm)
+		goto unlock;
+
+	if (sd_flag & SD_BALANCE_WAKE) {
 		/*
-		 * If both cpu and prev_cpu are part of this domain,
-		 * cpu is a valid SD_WAKE_AFFINE target.
+		 * Tasks to be waked is special, memory it relied on
+		 * may has already been cached on prev_cpu, and usually
+		 * they require low latency.
+		 *
+		 * So firstly try to locate an idle cpu shared the cache
+		 * with prev_cpu, it has the chance to break the load
+		 * balance, fortunately, select_idle_sibling() will search
+		 * from top to bottom, which help to reduce the chance in
+		 * some cases.
 		 */
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
-			affine_sd = tmp;
-			break;
-		}
+		new_cpu = select_idle_sibling(p, prev_cpu);
+		if (idle_cpu(new_cpu))
+			goto unlock;
 
-		if (tmp->flags & sd_flag)
-			sd = tmp;
-	}
+		/*
+		 * No idle cpu could be found in the topology of prev_cpu,
+		 * try search again in the topology of current cpu if it is
+		 * the affine of prev_cpu.
+		 */
+		if (cpu == prev_cpu || !sbm->affine_map[prev_cpu] ||
+				!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+			goto unlock;
 
-	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
+		new_cpu = select_idle_sibling(p, cpu);
 
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		/*
+		 * Invoke wake_affine() finally since it is no doubt a
+		 * performance killer.
+		 */
+		if (idle_cpu(new_cpu) &&
+				wake_affine(sbm->affine_map[prev_cpu], p, sync))
+			goto unlock;
+
+		/*
+		 * Failed to locate an idle cpu in the topology of both cpu
+		 * and prev_cpu, since the benefit of balance could not be
+		 * estimated, just adopt the prev_cpu.
+		 */
+		new_cpu = prev_cpu;
 		goto unlock;
 	}
 
+	/* Balance path, only for FORK and EXEC. */
+	new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
+	sd = sbm->sd[type][sbm->top_level[type]];
+
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
-		struct sched_group *group;
-		int weight;
-
-		if (!(sd->flags & sd_flag)) {
-			sd = sd->child;
-			continue;
-		}
+		struct sched_group *sg = NULL;
 
 		if (sd_flag & SD_BALANCE_WAKE)
 			load_idx = sd->wake_idx;
 
-		group = find_idlest_group(sd, p, cpu, load_idx);
-		if (!group) {
-			sd = sd->child;
-			continue;
-		}
+		sg = find_idlest_group(sd, p, cpu, load_idx);
+		if (!sg)
+			goto next_sd;
 
-		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
-			/* Now try balancing at a lower domain level of cpu */
-			sd = sd->child;
-			continue;
-		}
+		new_cpu = find_idlest_cpu(sg, p, cpu);
+		if (new_cpu != -1)
+			cpu = new_cpu;
+next_sd:
+		if (!sd->level)
+			break;
 
-		/* Now try balancing at a lower domain level of new_cpu */
-		cpu = new_cpu;
-		weight = sd->span_weight;
-		sd = NULL;
-		for_each_domain(cpu, tmp) {
-			if (weight <= tmp->span_weight)
-				break;
-			if (tmp->flags & sd_flag)
-				sd = tmp;
-		}
-		/* while loop will break here if sd == NULL */
+		sbm = cpu_rq(cpu)->sbm;
+		if (!sbm)
+			break;
+
+		sd = sbm->sd[type][sd->level - 1];
 	}
+
 unlock:
 	rcu_read_unlock();
 
-- 
1.7.4.1

