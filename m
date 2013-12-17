Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LQMqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:46:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41652 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3LQMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:08 -0500
Message-Id: <20131217123353.385762483@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Dec 2013 13:27:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 12/13] sched, deadline: Fixup the smp-affinity mask tests
References: <20131217122720.950475833@infradead.org>
Content-Disposition: inline; filename=peterz-frob-smp-affinity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now deadline tasks are not allowed to set smp affinity; however
the current tests are wrong, cure this.

The test in __sched_setscheduler() also uses an on-stack cpumask_t
which is a no-no.

Change both tests to use cpumask_subset() such that we test the root
domain span to be a subset of the cpus_allowed mask. This way we're
sure the tasks can always run on all CPUs they can be balanced over,
and have no effective affinity constraints.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  |   44 +++++++++---------------------------
 kernel/sched/rt.c    |   62 +++++++++++++++++++++++++++++++++++++--------------
 kernel/sched/sched.h |    2 +
 3 files changed, 58 insertions(+), 50 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3384,23 +3384,14 @@ static int __sched_setscheduler(struct t
 #ifdef CONFIG_SMP
 		if (dl_bandwidth_enabled() && dl_policy(policy)) {
 			cpumask_t *span = rq->rd->span;
-			cpumask_t act_affinity;
-
-			/*
-			 * cpus_allowed mask is statically initialized with
-			 * CPU_MASK_ALL, span is instead dynamic. Here we
-			 * compute the "dynamic" affinity of a task.
-			 */
-			cpumask_and(&act_affinity, &p->cpus_allowed,
-				    cpu_active_mask);
 
 			/*
 			 * Don't allow tasks with an affinity mask smaller than
 			 * the entire root_domain to become SCHED_DEADLINE. We
 			 * will also fail if there's no bandwidth available.
 			 */
-			if (!cpumask_equal(&act_affinity, span) ||
-			    		   rq->rd->dl_bw.bw == 0) {
+			if (!cpumask_subset(span, &p->cpus_allowed) ||
+			    rq->rd->dl_bw.bw == 0) {
 				__task_rq_unlock(rq);
 				raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 				return -EPERM;
@@ -3421,8 +3412,7 @@ static int __sched_setscheduler(struct t
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) &&
-	    dl_overflow(p, policy, attr)) {
+	if ((dl_policy(policy) || dl_task(p)) && dl_overflow(p, policy, attr)) {
 		task_rq_unlock(rq, p, &flags);
 		return -EBUSY;
 	}
@@ -3861,6 +3851,10 @@ long sched_setaffinity(pid_t pid, const
 	if (retval)
 		goto out_unlock;
 
+
+	cpuset_cpus_allowed(p, cpus_allowed);
+	cpumask_and(new_mask, in_mask, cpus_allowed);
+
 	/*
 	 * Since bandwidth control happens on root_domain basis,
 	 * if admission test is enabled, we only admit -deadline
@@ -3871,16 +3865,12 @@ long sched_setaffinity(pid_t pid, const
 	if (task_has_dl_policy(p)) {
 		const struct cpumask *span = task_rq(p)->rd->span;
 
-		if (dl_bandwidth_enabled() &&
-		    !cpumask_equal(in_mask, span)) {
+		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
 			retval = -EBUSY;
 			goto out_unlock;
 		}
 	}
 #endif
-
-	cpuset_cpus_allowed(p, cpus_allowed);
-	cpumask_and(new_mask, in_mask, cpus_allowed);
 again:
 	retval = set_cpus_allowed_ptr(p, new_mask);
 
@@ -4536,7 +4526,7 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  * When dealing with a -deadline task, we have to check if moving it to
  * a new CPU is possible or not. In fact, this is only true iff there
  * is enough bandwidth available on such CPU, otherwise we want the
- * whole migration progedure to fail over.
+ * whole migration procedure to fail over.
  */
 static inline
 bool set_task_cpu_dl(struct task_struct *p, unsigned int cpu)


