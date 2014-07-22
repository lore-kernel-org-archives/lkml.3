Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaGVLa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:30:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:55853 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaGVLaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:30:23 -0400
Message-ID: <1406028616.3526.20.camel@tkhai>
Subject: [PATCH 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>
Date: Tue, 22 Jul 2014 15:30:16 +0400
In-Reply-To: <20140722102425.29682.24086.stgit@tkhai>
References: <20140722102425.29682.24086.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is new on_rq state for the cases when task is migrating
from one src_rq to another dst_rq, and locks of the both RQs
are unlocked.

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

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c  |   25 ++++++++++++++++++-------
 kernel/sched/sched.h |    1 +
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 205f99a..78388b0 100644
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
@@ -1491,10 +1491,14 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
-	check_preempt_curr(rq, p, wake_flags);
 	trace_sched_wakeup(p, true);
 
 	p->state = TASK_RUNNING;
+
+	if (!task_queued(p))
+		return;
+
+	check_preempt_curr(rq, p, wake_flags);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
@@ -1537,7 +1541,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	int ret = 0;
 
 	rq = __task_rq_lock(p);
-	if (task_queued(p)) {
+	if (p->on_rq) {
 		/* check_preempt_curr() may use rq clock */
 		update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
@@ -1678,7 +1682,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (task_queued(p) && ttwu_remote(p, wake_flags))
+	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
 
 #ifdef CONFIG_SMP
@@ -1693,6 +1697,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	 */
 	smp_rmb();
 
+	BUG_ON(p->on_rq);
+
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
@@ -4623,9 +4629,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	struct rq *rq;
 	unsigned int dest_cpu;
 	int ret = 0;
-
+again:
 	rq = task_rq_lock(p, &flags);
 
+	if (unlikely(p->on_rq) == ONRQ_MIGRATING) {
+		task_rq_unlock(rq, p, &flags);
+		goto again;
+	}
+
 	if (cpumask_equal(&p->cpus_allowed, new_mask))
 		goto out;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e5a9b6d..9b00e9b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -17,6 +17,7 @@ struct rq;
 
 /* .on_rq states of struct task_struct: */
 #define ONRQ_QUEUED	1
+#define ONRQ_MIGRATING	2
 
 extern __read_mostly int scheduler_running;
 



