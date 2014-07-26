Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaGZO7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:59:50 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:39017 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaGZO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:59:47 -0400
X-Yandex-Uniq: 449052d7-ae01-4aad-8b1a-fa6de2409268
Authentication-Results: smtp19.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 4/5] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Sat, 26 Jul 2014 18:59:43 +0400
Message-ID: <20140726145937.6308.18974.stgit@localhost>
In-Reply-To: <20140726145508.6308.69121.stgit@localhost>
References: <20140726145508.6308.69121.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bad situation:

double_lock_balance() drops busiest_rq lock. The busiest_rq is *busiest*,
and a lot of tasks and context switches there. We are dropping the lock
and waiting for it again.

Let's just detach the task and once finally unlock it!

Warning: this admits unlocked using of can_migrate_task(), throttled_lb_pair(),
and task_hot(). I added comments about that.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   54 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a8f8ca0..a1b74f2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3297,6 +3297,8 @@ static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
  * Ensure that neither of the group entities corresponding to src_cpu or
  * dest_cpu are members of a throttled hierarchy when performing group
  * load-balance operations.
+ *
+ * Note: RQs are not locked.
  */
 static inline int throttled_lb_pair(struct task_group *tg,
 				    int src_cpu, int dest_cpu)
@@ -5127,7 +5129,9 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 }
 
 /*
- * Is this task likely cache-hot:
+ * Is this task likely cache-hot?
+ *
+ * Note: env->dst_rq is unlocked, but rcu_read_lock() is held.
  */
 static int task_hot(struct task_struct *p, struct lb_env *env)
 {
@@ -5247,6 +5251,8 @@ static inline bool migrate_degrades_locality(struct task_struct *p,
 
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
+ *
+ * Note: env->dest_rq is not locked.
  */
 static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
@@ -5336,13 +5342,13 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 }
 
 /*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * detach_one_task tries to dequeue exactly one task from env->src_rq, as
  * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
+ * Returns a task if successful and NULL otherwise.
  *
- * Called with both runqueues locked.
+ * Called with env->src_rq locked.
  */
-static int move_one_task(struct lb_env *env)
+static struct task_struct *detach_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 
@@ -5350,16 +5356,20 @@ static int move_one_task(struct lb_env *env)
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
@@ -6913,6 +6923,7 @@ static int active_load_balance_cpu_stop(void *data)
 	int target_cpu = busiest_rq->push_cpu;
 	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
+	struct task_struct *p = NULL;
 
 	raw_spin_lock_irq(&busiest_rq->lock);
 
@@ -6932,9 +6943,6 @@ static int active_load_balance_cpu_stop(void *data)
 	 */
 	BUG_ON(busiest_rq == target_rq);
 
-	/* move a task from busiest_rq to target_rq */
-	double_lock_balance(busiest_rq, target_rq);
-
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
@@ -6955,16 +6963,28 @@ static int active_load_balance_cpu_stop(void *data)
 
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
 

