Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3LTVoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:44:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41816 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3LTVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:44:36 -0500
Date: Fri, 20 Dec 2013 22:44:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131220214413.GF7959@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123353.180539582@infradead.org>
 <20131218165508.GB30183@twins.programming.kicks-ass.net>
 <20131220171343.GL2480@laptop.programming.kicks-ass.net>
 <20131220123707.44fb7192@gandalf.local.home>
 <20131220174200.GX16438@laptop.programming.kicks-ass.net>
 <20131220132323.524cf2b1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220132323.524cf2b1@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 01:23:23PM -0500, Steven Rostedt wrote:
> I'm saying what stops this?

oh duh, yes.

So the below is a bit cumbersome in having to use rd->span &
cpu_active_mask because it appears rd->online is too late again.

So I think this will avoid the problem by being consistent with the cpu
count. At worst it will reject a new task that could've fit, but that's
a safe mistake to make.

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1886,9 +1886,15 @@ inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
-static inline int __dl_span_weight(struct rq *rq)
+static inline int dl_bw_cpus(int i)
 {
-	return cpumask_weight(rq->rd->span);
+	struct root_domain *rd = cpu_rq(i)->rd;
+	int cpus = 0;
+
+	for_each_cpu_and(rd->span, cpu_active_mask)
+		cpus++;
+
+	return cpus;
 }
 #else
 inline struct dl_bw *dl_bw_of(int i)
@@ -1896,7 +1902,7 @@ inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->dl.dl_bw;
 }
 
-static inline int __dl_span_weight(struct rq *rq)
+static inline int dl_bw_cpus(int i)
 {
 	return 1;
 }
@@ -1937,8 +1943,7 @@ static int dl_overflow(struct task_struc
 	u64 period = attr->sched_period;
 	u64 runtime = attr->sched_runtime;
 	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
-	int cpus = __dl_span_weight(task_rq(p));
-	int err = -1;
+	int cpus, err = -1;
 
 	if (new_bw == p->dl.dl_bw)
 		return 0;
@@ -1949,6 +1954,7 @@ static int dl_overflow(struct task_struc
 	 * allocated bandwidth of the container.
 	 */
 	raw_spin_lock(&dl_b->lock);
+	cpus = dl_bw_cpus(task_cpu(p));
 	if (dl_policy(policy) && !task_has_dl_policy(p) &&
 	    !__dl_overflow(dl_b, cpus, 0, new_bw)) {
 		__dl_add(dl_b, new_bw);
@@ -4523,42 +4529,6 @@ int set_cpus_allowed_ptr(struct task_str
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
@@ -4590,13 +4560,6 @@ static int __migrate_task(struct task_st
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
@@ -4986,7 +4949,6 @@ migration_call(struct notifier_block *nf
 	struct rq *rq = cpu_rq(cpu);
 
 	switch (action & ~CPU_TASKS_FROZEN) {
-
 	case CPU_UP_PREPARE:
 		rq->calc_load_update = calc_load_update;
 		break;
@@ -5056,10 +5018,28 @@ static int sched_cpu_inactive(struct not
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
 		set_cpu_active((long)hcpu, false);
-		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
+		break;
 	}
+
+	switch (action) {
+	case CPU_DOWN_PREPARE: /* explicitly allow suspend */
+		{
+			struct dl_bw *dl_b = dl_bw_of(cpu);
+			bool overflow;
+			int cpus;
+
+			raw_spin_lock_irqsave(&dl_b->lock, flags);
+		       	cpus = dl_bw_cpus(cpu);
+			overflow = __dl_overflow(dl_b, cpus, 0, 0);
+			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+			if (overflow)
+				return notifier_from_errno(-EBUSY);
+		}
+		break;
+	}
+
+	return NOTIFY_OK;
 }
 
 static int __init migration_init(void)
