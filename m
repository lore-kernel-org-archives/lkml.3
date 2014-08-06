Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaHFIHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:07:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:51600 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbaHFIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:07:03 -0400
Message-ID: <1407312416.8424.47.camel@tkhai>
Subject: [PATCH v4 5/6] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <peterz@infradead.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>, <tkhai@yandex.ru>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>,
        <nicolas.pitre@linaro.org>
Date: Wed, 6 Aug 2014 12:06:56 +0400
In-Reply-To: <20140806075138.24858.23816.stgit@tkhai>
References: <20140806075138.24858.23816.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bad situation:

double_lock_balance() drops busiest_rq lock. The busiest_rq is *busiest*,
and a lot of tasks and context switches there. We are dropping the lock
and waiting for it again.

Let's just detach the task and once finally unlock it!

Warning: this admits unlocked using of can_migrate_task(), throttled_lb_pair(),
and task_hot(). I've added lockdep asserts to point on this.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   55 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d54b72c..cfeafb1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3297,6 +3297,8 @@ static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
  * Ensure that neither of the group entities corresponding to src_cpu or
  * dest_cpu are members of a throttled hierarchy when performing group
  * load-balance operations.
+ *
+ * Note: RQs may be unlocked.
  */
 static inline int throttled_lb_pair(struct task_group *tg,
 				    int src_cpu, int dest_cpu)
@@ -5133,6 +5135,8 @@ static int task_hot(struct task_struct *p, struct lb_env *env)
 {
 	s64 delta;
 
+	lockdep_assert_held(&env->src_rq->lock);
+
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
@@ -5252,6 +5256,9 @@ static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	int tsk_cache_hot = 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
+
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) throttled_lb_pair, or
@@ -5336,30 +5343,34 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 }
 
 /*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * detach_one_task tries to dequeue exactly one task from env->src_rq, as
  * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
- *
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
+		p->on_rq = ONRQ_MIGRATING;
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
 }
 
 static const unsigned int sched_nr_migrate_break = 32;
@@ -6914,6 +6925,7 @@ static int active_load_balance_cpu_stop(void *data)
 	int target_cpu = busiest_rq->push_cpu;
 	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
+	struct task_struct *p = NULL;
 
 	raw_spin_lock_irq(&busiest_rq->lock);
 
@@ -6933,9 +6945,6 @@ static int active_load_balance_cpu_stop(void *data)
 	 */
 	BUG_ON(busiest_rq == target_rq);
 
-	/* move a task from busiest_rq to target_rq */
-	double_lock_balance(busiest_rq, target_rq);
-
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
@@ -6956,16 +6965,28 @@ static int active_load_balance_cpu_stop(void *data)
 
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
+	if (p) {
+		raw_spin_lock(&target_rq->lock);
+		BUG_ON(task_rq(p) != target_rq);
+		p->on_rq = ONRQ_QUEUED;
+		activate_task(target_rq, p, 0);
+		check_preempt_curr(target_rq, p, 0);
+		raw_spin_unlock(&target_rq->lock);
+	}
+
+	local_irq_enable();
+
 	return 0;
 }
 



