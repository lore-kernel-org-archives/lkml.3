Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3LTROJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:14:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35496 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3LTROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:14:06 -0500
Date: Fri, 20 Dec 2013 18:13:43 +0100
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
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131220171343.GL2480@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123353.180539582@infradead.org>
 <20131218165508.GB30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218165508.GB30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 05:55:08PM +0100, Peter Zijlstra wrote:

> If the purpose is to fail hotplug because taking out the CPU would end
> up in over-subscription, then we need a DOWN_PREPARE handler.

Juri just said (on IRC) that that was indeed the intended purpose.

---
Subject: sched, deadline: Fix hotplug admission control
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu Dec 19 11:54:45 CET 2013

The current hotplug admission control is broken because:

  CPU_DYING -> migration_call() -> migrate_tasks() -> __migrate_task()

cannot fail and hard assumes it _will_ move all tasks off of the dying
cpu, failing this will break hotplug.

The much simpler solution is a DOWN_PREPARE handler that fails when
removing one CPU gets us below the total allocated bandwidth.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |   68 ++++++++++++++++------------------------------------
 1 file changed, 21 insertions(+), 47 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1886,9 +1886,9 @@ inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
-static inline int __dl_span_weight(struct rq *rq)
+static inline int dl_bw_cpus(int i)
 {
-	return cpumask_weight(rq->rd->span);
+	return cpumask_weight(cpu_rq(i)->rd->span);
 }
 #else
 inline struct dl_bw *dl_bw_of(int i)
@@ -1896,7 +1896,7 @@ inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->dl.dl_bw;
 }
 
-static inline int __dl_span_weight(struct rq *rq)
+static inline int dl_bw_cpus(int i)
 {
 	return 1;
 }
@@ -1937,7 +1937,7 @@ static int dl_overflow(struct task_struc
 	u64 period = attr->sched_period;
 	u64 runtime = attr->sched_runtime;
 	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
-	int cpus = __dl_span_weight(task_rq(p));
+	int cpus = dl_bw_cpus(task_cpu(p));
 	int err = -1;
 
 	if (new_bw == p->dl.dl_bw)
@@ -4523,42 +4523,6 @@ int set_cpus_allowed_ptr(struct task_str
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
 /*
- * When dealing with a -deadline task, we have to check if moving it to
- * a new CPU is possible or not. In fact, this is only true iff there
- * is enough bandwidth available on such CPU, otherwise we want the
- * whole migration procedure to fail over.
- */
-static inline
-bool set_task_cpu_dl(struct task_struct *p, unsigned int cpu)
-{
-	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
-	struct dl_bw *cpu_b = dl_bw_of(cpu);
-	int ret = 1;
-	u64 bw;
-
-	if (dl_b == cpu_b)
-		return 1;
-
-	raw_spin_lock(&dl_b->lock);
-	raw_spin_lock(&cpu_b->lock);
-
-	bw = cpu_b->bw * cpumask_weight(cpu_rq(cpu)->rd->span);
-	if (dl_bandwidth_enabled() &&
-	    bw < cpu_b->total_bw + p->dl.dl_bw) {
-		ret = 0;
-		goto unlock;
-	}
-	dl_b->total_bw -= p->dl.dl_bw;
-	cpu_b->total_bw += p->dl.dl_bw;
-
-unlock:
-	raw_spin_unlock(&cpu_b->lock);
-	raw_spin_unlock(&dl_b->lock);
-
-	return ret;
-}
-
-/*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
  * this because either it can't run here any more (set_cpus_allowed()
  * away from this CPU, or CPU going down), or because we're
@@ -4590,13 +4554,6 @@ static int __migrate_task(struct task_st
 		goto fail;
 
 	/*
-	 * If p is -deadline, proceed only if there is enough
-	 * bandwidth available on dest_cpu
-	 */
-	if (unlikely(dl_task(p)) && !set_task_cpu_dl(p, dest_cpu))
-		goto fail;
-
-	/*
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
@@ -4985,6 +4942,23 @@ migration_call(struct notifier_block *nf
 	unsigned long flags;
 	struct rq *rq = cpu_rq(cpu);
 
+	switch (action) {
+	case CPU_DOWN_PREPARE: /* explicitly allow suspend */
+		{
+			struct dl_bw *dl_b = dl_bw_of(cpu);
+			int cpus = dl_bw_cpus(cpu);
+			bool overflow;
+
+			raw_spin_lock_irqsave(&dl_b->lock, flags);
+			overflow = __dl_overflow(dl_b, cpus-1, 0, 0);
+			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+			if (overflow)
+				return notifier_from_errno(-EBUSY);
+		}
+		break;
+	}
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
