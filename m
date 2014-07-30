Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaG3VnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:43:16 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:43709 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbaG3VnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:43:13 -0400
X-Yandex-Uniq: 9174e88f-4070-4e19-ae3e-9d4dfb646227
Authentication-Results: smtp4h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 5/5] sched/fair: Remove double_lock_balance() from
 load_balance()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Thu, 31 Jul 2014 01:43:08 +0400
Message-ID: <20140730214308.27604.49574.stgit@localhost>
In-Reply-To: <20140730213219.27604.11218.stgit@localhost>
References: <20140730213219.27604.11218.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep on_rq = ONRQ_MIGRATING, while task is migrating, instead.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   99 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 70 insertions(+), 29 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e2ee4b..475d05e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4706,7 +4706,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/*
-	 * This is possible from callers such as move_task(), in which we
+	 * This is possible from callers such as attach_tasks(), in which we
 	 * unconditionally check_prempt_curr() after an enqueue (which may have
 	 * lead to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
@@ -5114,18 +5114,20 @@ struct lb_env {
 	unsigned int		loop_max;
 
 	enum fbq_type		fbq_type;
+	struct list_head	tasks;
 };
 
 /*
- * move_task - move a task from one runqueue to another runqueue.
- * Both runqueues must be locked.
+ * detach_task - detach a task for migration specified in env
  */
-static void move_task(struct task_struct *p, struct lb_env *env)
+static void detach_task(struct task_struct *p, struct lb_env *env)
 {
+	lockdep_assert_held(&env->src_rq->lock);
+
 	deactivate_task(env->src_rq, p, 0);
+	list_add(&p->se.group_node, &env->tasks);
+	p->on_rq = ONRQ_MIGRATING;
 	set_task_cpu(p, env->dst_cpu);
-	activate_task(env->dst_rq, p, 0);
-	check_preempt_curr(env->dst_rq, p, 0);
 }
 
 /*
@@ -5363,9 +5365,9 @@ static struct task_struct *detach_one_task(struct lb_env *env)
 
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
@@ -5376,18 +5378,18 @@ static struct task_struct *detach_one_task(struct lb_env *env)
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
- * move_tasks tries to move up to imbalance weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
+ * detach_tasks tries to detach up to imbalance weighted load from busiest_rq,
+ * as part of a balancing operation within domain "sd".
+ * Returns number of detached tasks if successful and 0 otherwise.
  */
-static int move_tasks(struct lb_env *env)
+static int detach_tasks(struct lb_env *env)
 {
 	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
-	int pulled = 0;
+	int detached = 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
 
 	if (env->imbalance <= 0)
 		return 0;
@@ -5418,14 +5420,15 @@ static int move_tasks(struct lb_env *env)
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
@@ -5445,13 +5448,31 @@ static int move_tasks(struct lb_env *env)
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
 
-	return pulled;
+	return detached;
+}
+
+/* Attach tasks previously detached in detach_tasks() */
+static void attach_tasks(struct lb_env *env)
+{
+	struct list_head *tasks = &env->tasks;
+	struct task_struct *p;
+
+	lockdep_assert_held(&env->dst_rq->lock);
+
+	while (!list_empty(tasks)) {
+		p = list_first_entry(tasks, struct task_struct, se.group_node);
+		BUG_ON(task_rq(p) != env->dst_rq);
+		list_del_init(&p->se.group_node);
+		p->on_rq = ONRQ_QUEUED;
+		activate_task(env->dst_rq, p, 0);
+		check_preempt_curr(env->dst_rq, p, 0);
+	}
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -6561,6 +6582,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
 		.fbq_type	= all,
+		.tasks		= LIST_HEAD_INIT(env.tasks),
 	};
 
 	/*
@@ -6610,16 +6632,35 @@ static int load_balance(int this_cpu, struct rq *this_rq,
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
+
+		/*
+		 * We've detached some tasks from busiest_rq. Every
+		 * task is masked "ONRQ_MIGRATED", so we can safely
+		 * unlock busiest->lock, and we are able to be sure
+		 * that nobody can manipulate the tasks in parallel.
+		 * See task_rq_lock() family for the details.
+		 */
+
+		raw_spin_unlock(&busiest->lock);
+
+		if (cur_ld_moved) {
+			raw_spin_lock(&env.dst_rq->lock);
+			/*
+			 * Attach the tasks to env->dst_rq
+			 * and mask them "ONRQ_QUEUED".
+			 */
+			attach_tasks(&env);
+			raw_spin_unlock(&env.dst_rq->lock);
+			ld_moved += cur_ld_moved;
+		}
+
 		local_irq_restore(flags);
 
 		/*
@@ -6755,7 +6796,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		 * If we've begun active balancing, start to back off. This
 		 * case may not be covered by the all_pinned logic if there
 		 * is only 1 task on the busy runqueue (because we don't call
-		 * move_tasks).
+		 * detach_tasks).
 		 */
 		if (sd->balance_interval < sd->max_interval)
 			sd->balance_interval *= 2;

