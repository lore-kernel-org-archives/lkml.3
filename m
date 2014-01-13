Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaAMPzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:55:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaAMPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:55:48 -0500
Date: Mon, 13 Jan 2014 07:55:18 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-de212f18e92c952533d57c5510d2790199c75734@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131220171343.GL2480@laptop.programming.kicks-ass.net>
References: <20131220171343.GL2480@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Fix hotplug admission control
Git-Commit-ID: de212f18e92c952533d57c5510d2790199c75734
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:55:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de212f18e92c952533d57c5510d2790199c75734
Gitweb:     http://git.kernel.org/tip/de212f18e92c952533d57c5510d2790199c75734
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 19 Dec 2013 11:54:45 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:25 +0100

sched/deadline: Fix hotplug admission control

The current hotplug admission control is broken because:

  CPU_DYING -> migration_call() -> migrate_tasks() -> __migrate_task()

cannot fail and hard assumes it _will_ move all tasks off of the dying
cpu, failing this will break hotplug.

The much simpler solution is a DOWN_PREPARE handler that fails when
removing one CPU gets us below the total allocated bandwidth.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131220171343.GL2480@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 83 +++++++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 51 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1d33eb8..a549d9a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1887,9 +1887,15 @@ inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
-static inline int __dl_span_weight(struct rq *rq)
+static inline int dl_bw_cpus(int i)
 {
-	return cpumask_weight(rq->rd->span);
+	struct root_domain *rd = cpu_rq(i)->rd;
+	int cpus = 0;
+
+	for_each_cpu_and(i, rd->span, cpu_active_mask)
+		cpus++;
+
+	return cpus;
 }
 #else
 inline struct dl_bw *dl_bw_of(int i)
@@ -1897,7 +1903,7 @@ inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->dl.dl_bw;
 }
 
-static inline int __dl_span_weight(struct rq *rq)
+static inline int dl_bw_cpus(int i)
 {
 	return 1;
 }
@@ -1938,8 +1944,7 @@ static int dl_overflow(struct task_struct *p, int policy,
 	u64 period = attr->sched_period;
 	u64 runtime = attr->sched_runtime;
 	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
-	int cpus = __dl_span_weight(task_rq(p));
-	int err = -1;
+	int cpus, err = -1;
 
 	if (new_bw == p->dl.dl_bw)
 		return 0;
@@ -1950,6 +1955,7 @@ static int dl_overflow(struct task_struct *p, int policy,
 	 * allocated bandwidth of the container.
 	 */
 	raw_spin_lock(&dl_b->lock);
+	cpus = dl_bw_cpus(task_cpu(p));
 	if (dl_policy(policy) && !task_has_dl_policy(p) &&
 	    !__dl_overflow(dl_b, cpus, 0, new_bw)) {
 		__dl_add(dl_b, new_bw);
@@ -4522,42 +4528,6 @@ out:
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
@@ -4589,13 +4559,6 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
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
@@ -5052,13 +5015,31 @@ static int sched_cpu_active(struct notifier_block *nfb,
 static int sched_cpu_inactive(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
+	unsigned long flags;
+	long cpu = (long)hcpu;
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		set_cpu_active((long)hcpu, false);
+		set_cpu_active(cpu, false);
+
+		/* explicitly allow suspend */
+		if (!(action & CPU_TASKS_FROZEN)) {
+			struct dl_bw *dl_b = dl_bw_of(cpu);
+			bool overflow;
+			int cpus;
+
+			raw_spin_lock_irqsave(&dl_b->lock, flags);
+			cpus = dl_bw_cpus(cpu);
+			overflow = __dl_overflow(dl_b, cpus, 0, 0);
+			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+			if (overflow)
+				return notifier_from_errno(-EBUSY);
+		}
 		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_DONE;
 }
 
 static int __init migration_init(void)
