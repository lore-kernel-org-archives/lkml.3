Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaGZO73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:59:29 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:38835 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaGZO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:59:27 -0400
X-Yandex-Uniq: bcaf63a8-edfd-402c-bdd4-050fce3049a4
Authentication-Results: smtp4o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Sat, 26 Jul 2014 18:59:21 +0400
Message-ID: <20140726145912.6308.32554.stgit@localhost>
In-Reply-To: <20140726145508.6308.69121.stgit@localhost>
References: <20140726145508.6308.69121.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is new on_rq state for the cases when task is migrating
from one src_rq to another dst_rq, and there is no necessity
to have both RQs locked at the same time.

We will use the state this way:

	raw_spin_lock(&src_rq->lock);
	dequeue_task(src_rq, p, 0);
	p->on_rq = ONRQ_MIGRATING;
	set_task_cpu(p, dst_cpu);
	raw_spin_unlock(&src_rq->lock);

	raw_spin_lock(&dst_rq->lock);
	p->on_rq = ONRQ_QUEUED;
	enqueue_task(dst_rq, p, 0);
	raw_spin_unlock(&dst_rq->lock);

The profit is that double_rq_lock() is not needed now,
and this may reduce the latencies in some situations.

The logic of try_to_wake_up() remained the same as it
was. Its behaviour changes in a small subset of cases
(when preempted task in ~TASK_RUNNING state is queued
on rq and we are migrating it to another).

We add a loop in the beginning of set_cpus_allowed_ptr.
It's like a handmade spinlock, which is similar
to situation we had before. We used to spin on rq->lock,
now we spin on "again:" label. Of course, it's worse
than arch-dependent spinlock, but we have to have it
here. The function is synchronic, and users used to be
sure that task is using new allowed cpu mask after we
returned. It seems there won't be any signify performance
losses.

I try to seek performance-critical places where we use
set_cpus_allowed_ptr(). Maybe update_migrate_disable()
in RT patch. But it's called the way where the state
ONRQ_MIGRATING is not possible. So, this everything
looks fine for me.

v2: cpu_relax() in set_cpus_allowed_ptr(),
    on_rq check in switched_from_fair(),
    fixed wrong "unlikely" braces,
    task_migrating() primitive,
    commentaries.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c  |   38 +++++++++++++++++++++++++++++++-------
 kernel/sched/fair.c  |    2 +-
 kernel/sched/sched.h |    6 ++++++
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 205f99a..772f791 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1214,7 +1214,7 @@ static int migration_cpu_stop(void *data);
 unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
 	unsigned long flags;
-	int running, queued;
+	int running, on_rq;
 	unsigned long ncsw;
 	struct rq *rq;
 
@@ -1252,7 +1252,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		queued = task_queued(p);
+		on_rq = p->on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
@@ -1284,7 +1284,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * running right now), it's preempted, and we should
 		 * yield - it could be a while.
 		 */
-		if (unlikely(queued)) {
+		if (unlikely(on_rq)) {
 			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1491,10 +1491,18 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
-	check_preempt_curr(rq, p, wake_flags);
 	trace_sched_wakeup(p, true);
 
 	p->state = TASK_RUNNING;
+
+	/*
+	 * We've changed the state, other actions will be done
+	 * in the place, where the migration has started.
+	 */
+	if (task_migrating(p))
+		return;
+
+	check_preempt_curr(rq, p, wake_flags);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
@@ -1537,9 +1545,15 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	int ret = 0;
 
 	rq = __task_rq_lock(p);
-	if (task_queued(p)) {
+	/*
+	 * Task is queued or it is migrating. In the second case
+	 * it will be queued by migration code with TASK_RUNNING
+	 * state, which we set in ttwu_do_wakeup().
+	 */
+	if (p->on_rq) {
 		/* check_preempt_curr() may use rq clock */
-		update_rq_clock(rq);
+		if (task_queued(p))
+			update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
 		ret = 1;
 	}
@@ -1678,7 +1692,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (task_queued(p) && ttwu_remote(p, wake_flags))
+	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
 
 #ifdef CONFIG_SMP
@@ -1693,6 +1707,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	 */
 	smp_rmb();
 
+	BUG_ON(p->on_rq);
+
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
@@ -4623,8 +4639,16 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	struct rq *rq;
 	unsigned int dest_cpu;
 	int ret = 0;
+again:
+	while (unlikely(task_migrating(p)))
+		cpu_relax();
 
 	rq = task_rq_lock(p, &flags);
+	/* Check again with rq locked */
+	if (unlikely(task_migrating(p))) {
+		task_rq_unlock(rq, p, &flags);
+		goto again;
+	}
 
 	if (cpumask_equal(&p->cpus_allowed, new_mask))
 		goto out;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dd90fff..a8f8ca0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7493,7 +7493,7 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	 * have normalized the vruntime, if it's !queued, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!task_queued(p) && p->state != TASK_RUNNING) {
+	if (!p->on_rq && p->state != TASK_RUNNING) {
 		/*
 		 * Fix up our vruntime so that the current sleep doesn't
 		 * cause 'unlimited' sleep bonus.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e5a9b6d..f6773d7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -17,6 +17,7 @@ struct rq;
 
 /* .on_rq states of struct task_struct: */
 #define ONRQ_QUEUED	1
+#define ONRQ_MIGRATING	2
 
 extern __read_mostly int scheduler_running;
 
@@ -950,6 +951,11 @@ static inline int task_queued(struct task_struct *p)
 	return p->on_rq == ONRQ_QUEUED;
 }
 
+static inline int task_migrating(struct task_struct *p)
+{
+	return p->on_rq == ONRQ_MIGRATING;
+}
+
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif

