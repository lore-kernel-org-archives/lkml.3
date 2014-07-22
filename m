Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaGVLbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:31:11 -0400
Received: from relay.parallels.com ([195.214.232.42]:55943 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGVLbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:31:08 -0400
Message-ID: <1406028661.3526.28.camel@tkhai>
Subject: [PATCH 5/5] sched/fair: Remove double_lock_balance() from
 load_balance()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>
Date: Tue, 22 Jul 2014 15:31:01 +0400
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


Keep on_rq = ONRQ_MIGRATING, while task is migrating, instead.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   84 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cf2d2eb..ebab2e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4706,9 +4706,9 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/*
-	 * This is possible from callers such as move_task(), in which we
-	 * unconditionally check_prempt_curr() after an enqueue (which may have
-	 * lead to a throttle).  This both saves work and prevents false
+	 * This is possible from callers, in which we unconditionally
+	 * check_prempt_curr() after an enqueue (which may have lead
+	 * to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
 	 */
 	if (unlikely(throttled_hierarchy(cfs_rq_of(pse))))
@@ -5114,20 +5114,22 @@ struct lb_env {
 	unsigned int		loop_max;
 
 	enum fbq_type		fbq_type;
+	struct list_head	tasks;
 };
 
 /*
- * move_task - move a task from one runqueue to another runqueue.
- * Both runqueues must be locked.
+ * detach_task - detach a task from its runqueue for migration.
+ * The runqueue must be locked.
  */
-static void move_task(struct task_struct *p, struct lb_env *env)
+static void detach_task(struct task_struct *p, struct lb_env *env)
 {
 	deactivate_task(env->src_rq, p, 0);
+	list_add(&p->se.group_node, &env->tasks);
+	p->on_rq = ONRQ_MIGRATING;
 	set_task_cpu(p, env->dst_cpu);
-	activate_task(env->dst_rq, p, 0);
-	check_preempt_curr(env->dst_rq, p, 0);
 }
 
+
 /*
  * Is this task likely cache-hot?
  *
@@ -5362,9 +5364,9 @@ static struct task_struct *detach_one_task(struct lb_env *env)
 
 		/*
 		 * Right now, this is only the second place where
-		 * lb_gained[env->idle] is updated (other is move_tasks)
+		 * lb_gained[env->idle] is updated (other is detach_tasks)
 		 * so we can safely collect stats here rather than
-		 * inside move_tasks().
+		 * inside detach_tasks().
 		 */
 		schedstat_inc(env->sd, lb_gained[env->idle]);
 		return p;
@@ -5375,18 +5377,18 @@ static struct task_struct *detach_one_task(struct lb_env *env)
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
- * move_tasks tries to move up to imbalance weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
+ * detach_tasks tries to detach up to imbalance weighted load from busiest_rq,
+ * as part of a balancing operation within domain "sd".
+ * Returns number of detached tasks if successful and 0 otherwise.
  *
- * Called with both runqueues locked.
+ * Called with env->src_rq locked.
  */
-static int move_tasks(struct lb_env *env)
+static int detach_tasks(struct lb_env *env)
 {
 	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
-	int pulled = 0;
+	int detached = 0;
 
 	if (env->imbalance <= 0)
 		return 0;
@@ -5417,14 +5419,15 @@ static int move_tasks(struct lb_env *env)
 		if ((load / 2) > env->imbalance)
 			goto next;
 
-		move_task(p, env);
-		pulled++;
+		detach_task(p, env);
+
+		detached++;
 		env->imbalance -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
 		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
+		 * kernels will stop after the first task is detached to minimize
 		 * the critical section.
 		 */
 		if (env->idle == CPU_NEWLY_IDLE)
@@ -5444,13 +5447,27 @@ static int move_tasks(struct lb_env *env)
 	}
 
 	/*
-	 * Right now, this is one of only two places move_task() is called,
-	 * so we can safely collect move_task() stats here rather than
-	 * inside move_task().
+	 * Right now, this is one of only two places we collect this stat
+	 * so we can safely collect detach_one_task() stats here rather
+	 * than inside detach_one_task().
 	 */
-	schedstat_add(env->sd, lb_gained[env->idle], pulled);
+	schedstat_add(env->sd, lb_gained[env->idle], detached);
+
+	return detached;
+}
+
+static void attach_tasks(struct lb_env *env)
+{
+	struct list_head *tasks = &env->tasks;
+	struct task_struct *p;
+
+	while (!list_empty(tasks)) {
+		p = list_first_entry(tasks, struct task_struct, se.group_node);
+		list_del_init(&p->se.group_node);
+		p->on_rq = ONRQ_QUEUED;
+		activate_task(env->dst_rq, p, 0);
+	}
 
-	return pulled;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -6559,6 +6576,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
 		.fbq_type	= all,
+		.tasks		= LIST_HEAD_INIT(env.tasks),
 	};
 
 	/*
@@ -6608,16 +6626,22 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
-		local_irq_save(flags);
-		double_rq_lock(env.dst_rq, busiest);
+		raw_spin_lock_irqsave(&busiest->lock, flags);
 
 		/*
 		 * cur_ld_moved - load moved in current iteration
 		 * ld_moved     - cumulative load moved across iterations
 		 */
-		cur_ld_moved = move_tasks(&env);
-		ld_moved += cur_ld_moved;
-		double_rq_unlock(env.dst_rq, busiest);
+		cur_ld_moved = detach_tasks(&env);
+		raw_spin_unlock(&busiest->lock);
+
+		if (cur_ld_moved) {
+			raw_spin_lock(&env.dst_rq->lock);
+			attach_tasks(&env);
+			raw_spin_unlock(&env.dst_rq->lock);
+			ld_moved += cur_ld_moved;
+		}
+
 		local_irq_restore(flags);
 
 		/*
@@ -6753,7 +6777,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		 * If we've begun active balancing, start to back off. This
 		 * case may not be covered by the all_pinned logic if there
 		 * is only 1 task on the busy runqueue (because we don't call
-		 * move_tasks).
+		 * detach_tasks).
 		 */
 		if (sd->balance_interval < sd->max_interval)
 			sd->balance_interval *= 2;



