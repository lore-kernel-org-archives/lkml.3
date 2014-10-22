Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaJVGIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:08:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50505 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaJVGIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:08:04 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 6/7] sched: cfs: cpu frequency scaling based on task placement
Date: Tue, 21 Oct 2014 23:07:30 -0700
Message-Id: <1413958051-7103-7-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{en,de}queue_task_fair are updated to track which cpus will have changed
utilization values as function of task queueing. The affected cpus are
passed on to arch_eval_cpu_freq for further machine-specific processing
based on a selectable policy.

arch_scale_cpu_freq is called from run_rebalance_domains as a way to
kick off the scaling process (via wake_up_process), so as to prevent
re-entering the {en,de}queue code.

All of the call sites in this patch are up for discussion. Does it make
sense to track which cpus have updated statistics in enqueue_fair_task?
I chose this because I wanted to gather statistics for all cpus affected
in the event CONFIG_FAIR_GROUP_SCHED is enabled. As agreed at LPC14 the
next version of this patch will focus on the simpler case of not using
scheduler cgroups, which should remove a good chunk of this code,
including the cpumask stuff.

Also discussed at LPC14 is that fact that load_balance is a very
interesting place to do this as frequency can be considered in concert
with task placement. Please put forth any ideas on a sensible way to do
this.

Is run_rebalance_domains a logical place to change cpu frequency? What
other call sites make sense?

Even for platforms that can target a cpu frequency without sleeping
(x86, some ARM platforms with PM microcontrollers) it is currently
necessary to always kick the frequency target work out into a kthread.
This is because of the rw_sem usage in the cpufreq core which might
sleep. Replacing that lock type is probably a good idea.

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 kernel/sched/fair.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1af6f6d..3619f63 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3999,6 +3999,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	struct cpumask update_cpus;
+
+	cpumask_clear(&update_cpus);
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -4028,12 +4031,27 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		/* track cpus that need to be re-evaluated */
+		cpumask_set_cpu(cpu_of(rq_of(cfs_rq)), &update_cpus);
 	}
 
+	/* !CONFIG_FAIR_GROUP_SCHED */
 	if (!se) {
 		update_rq_runnable_avg(rq, rq->nr_running);
 		add_nr_running(rq, 1);
+
+		/*
+		 * FIXME for !CONFIG_FAIR_GROUP_SCHED it might be nice to
+		 * typedef update_cpus into an int and skip all of the cpumask
+		 * stuff
+		 */
+		cpumask_set_cpu(cpu_of(rq), &update_cpus);
 	}
+
+	if (energy_aware())
+		if (!cpumask_empty(&update_cpus))
+			arch_eval_cpu_freq(&update_cpus);
+
 	hrtick_update(rq);
 }
 
@@ -4049,6 +4067,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 	int task_sleep = flags & DEQUEUE_SLEEP;
+	struct cpumask update_cpus;
+
+	cpumask_clear(&update_cpus);
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
@@ -4089,12 +4110,27 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		/* track runqueues/cpus that need to be re-evaluated */
+		cpumask_set_cpu(cpu_of(rq_of(cfs_rq)), &update_cpus);
 	}
 
+	/* !CONFIG_FAIR_GROUP_SCHED */
 	if (!se) {
 		sub_nr_running(rq, 1);
 		update_rq_runnable_avg(rq, 1);
+
+		/*
+		 * FIXME for !CONFIG_FAIR_GROUP_SCHED it might be nice to
+		 * typedef update_cpus into an int and skip all of the cpumask
+		 * stuff
+		 */
+		cpumask_set_cpu(cpu_of(rq), &update_cpus);
 	}
+
+	if (energy_aware())
+		if (!cpumask_empty(&update_cpus))
+			arch_eval_cpu_freq(&update_cpus);
+
 	hrtick_update(rq);
 }
 
@@ -7536,6 +7572,9 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 * stopped.
 	 */
 	nohz_idle_balance(this_rq, idle);
+
+	if (energy_aware())
+		arch_scale_cpu_freq();
 }
 
 /*
-- 
1.8.3.2

