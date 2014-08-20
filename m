Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaHTJsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:48:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:59232 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaHTJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:48:07 -0400
Message-ID: <1408528081.23412.92.camel@tkhai>
Subject: [PATCH v5 4/5] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Nicolas Pitre" <nicolas.pitre@linaro.org>
Date: Wed, 20 Aug 2014 13:48:01 +0400
In-Reply-To: <20140820092458.27076.30955.stgit@tkhai>
References: <20140820092458.27076.30955.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoid double_rq_lock() and use TASK_ON_RQ_MIGRATING for
active_load_balance_cpu_stop(). The advantage is (obviously) not
holding two 'rq->lock's at the same time and thereby increasing
parallelism.

Further note that if there was no task to migrate we will not have
acquired the second rq->lock at all.

The important point to note is that because we acquire dst->lock
immediately after releasing src->lock the potential wait time of
task_rq_lock() callers on TASK_ON_RQ_MIGRATING is not longer than
it would have been in the double rq lock scenario.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   60 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9e6ca0d..7e5cf05 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5138,6 +5138,8 @@ static int task_hot(struct task_struct *p, struct lb_env *env)
 {
 	s64 delta;
 
+	lockdep_assert_held(&env->src_rq->lock);
+
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
@@ -5257,6 +5259,9 @@ static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	int tsk_cache_hot = 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
+
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) throttled_lb_pair, or
@@ -5341,30 +5346,49 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 }
 
 /*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * detach_one_task() -- tries to dequeue exactly one task from env->src_rq, as
  * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
  *
- * Called with both runqueues locked.
+ * Returns a task if successful and NULL otherwise.
  */
-static int move_one_task(struct lb_env *env)
+static struct task_struct *detach_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 
+	lockdep_assert_held(&env->src_rq->lock);
+
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
 		if (!can_migrate_task(p, env))
 			continue;
 
-		move_task(p, env);
+		deactivate_task(env->src_rq, p, 0);
+		p->on_rq = TASK_ON_RQ_MIGRATING;
+		set_task_cpu(p, env->dst_cpu);
+
 		/*
-		 * Right now, this is only the second place move_task()
-		 * is called, so we can safely collect move_task()
-		 * stats here rather than inside move_task().
+		 * Right now, this is only the second place where
+		 * lb_gained[env->idle] is updated (other is move_tasks)
+		 * so we can safely collect stats here rather than
+		 * inside move_tasks().
 		 */
 		schedstat_inc(env->sd, lb_gained[env->idle]);
-		return 1;
+		return p;
 	}
-	return 0;
+	return NULL;
+}
+
+/*
+ * attach_one_task() -- attaches the task returned from detach_one_task() to
+ * its new rq.
+ */
+static void attach_one_task(struct rq *rq, struct task_struct *p)
+{
+	raw_spin_lock(&rq->lock);
+	BUG_ON(task_rq(p) != rq);
+	p->on_rq = TASK_ON_RQ_QUEUED;
+	activate_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
 }
 
 static const unsigned int sched_nr_migrate_break = 32;
@@ -6943,6 +6967,7 @@ static int active_load_balance_cpu_stop(void *data)
 	int target_cpu = busiest_rq->push_cpu;
 	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
+	struct task_struct *p = NULL;
 
 	raw_spin_lock_irq(&busiest_rq->lock);
 
@@ -6962,9 +6987,6 @@ static int active_load_balance_cpu_stop(void *data)
 	 */
 	BUG_ON(busiest_rq == target_rq);
 
-	/* move a task from busiest_rq to target_rq */
-	double_lock_balance(busiest_rq, target_rq);
-
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
@@ -6985,16 +7007,22 @@ static int active_load_balance_cpu_stop(void *data)
 
 		schedstat_inc(sd, alb_count);
 
-		if (move_one_task(&env))
+		p = detach_one_task(&env);
+		if (p)
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);
 	}
 	rcu_read_unlock();
-	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
-	raw_spin_unlock_irq(&busiest_rq->lock);
+	raw_spin_unlock(&busiest_rq->lock);
+
+	if (p)
+		attach_one_task(target_rq, p);
+
+	local_irq_enable();
+
 	return 0;
 }
 



