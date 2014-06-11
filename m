Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaFKJwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:52:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:34132 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaFKJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:52:13 -0400
Message-ID: <1402480330.32126.14.camel@tkhai>
Subject: [PATCH 1/2] sched: Rework migrate_tasks()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>
Date: Wed, 11 Jun 2014 13:52:10 +0400
In-Reply-To: <20140611093417.27807.2288.stgit@tkhai>
References: <20140611093417.27807.2288.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently migrate_tasks() skips throttled tasks,
because they are not pickable by pick_next_task().

These tasks stay on dead cpu even after they
becomes unthrottled. They are not schedulable
till user manually changes their affinity or till
cpu becomes alive again.

But for user this looks completely untransparent:
task hangs, but it's not obvious what he has to do,
because kernel does not report any problem.

This situation may easily be triggered intentionally.
Playing with extremely small cpu.cfs_quota_us causes
it almost in 100% cases. In usual life it's very rare,
but still possible for some unhappy user.

This patch changes migrate_tasks() to iterate throw
all of the threads in the system under tasklist_lock
is locked. This may a little worsen the performance,
but:

1)it guarantees all of tasks will migrate;

2)migrate_tasks() is not performance critical,
  it just must do what it has to do.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   75 ++++++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 55 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d0d1565..da7f4c5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4795,78 +4795,43 @@ static void calc_load_migrate(struct rq *rq)
 		atomic_long_add(delta, &calc_load_tasks);
 }
 
-static void put_prev_task_fake(struct rq *rq, struct task_struct *prev)
-{
-}
-
-static const struct sched_class fake_sched_class = {
-	.put_prev_task = put_prev_task_fake,
-};
-
-static struct task_struct fake_task = {
-	/*
-	 * Avoid pull_{rt,dl}_task()
-	 */
-	.prio = MAX_PRIO + 1,
-	.sched_class = &fake_sched_class,
-};
-
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
  *
- * Called with rq->lock held even though we'er in stop_machine() and
- * there's no concurrency possible, we hold the required locks anyway
- * because of lock validation efforts.
+ * Called from stop_machine(), and there's no concurrency possible, but
+ * we hold the required locks anyway because of lock validation efforts.
  */
 static void migrate_tasks(unsigned int dead_cpu)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
-	struct task_struct *next, *stop = rq->stop;
+	struct task_struct *g, *p;
 	int dest_cpu;
 
-	/*
-	 * Fudge the rq selection such that the below task selection loop
-	 * doesn't get stuck on the currently eligible stop task.
-	 *
-	 * We're currently inside stop_machine() and the rq is either stuck
-	 * in the stop_machine_cpu_stop() loop, or we're executing this code,
-	 * either way we should never end up calling schedule() until we're
-	 * done here.
-	 */
-	rq->stop = NULL;
-
-	/*
-	 * put_prev_task() and pick_next_task() sched
-	 * class method both need to have an up-to-date
-	 * value of rq->clock[_task]
-	 */
-	update_rq_clock(rq);
-
-	for ( ; ; ) {
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
 		/*
-		 * There's this thread running, bail when that's the only
-		 * remaining thread.
+		 * We're inside stop_machine() and nobody can manage tasks
+		 * in parallel. So, this unlocked check is correct.
 		 */
-		if (rq->nr_running == 1)
-			break;
+		if (!p->on_rq || task_cpu(p) != dead_cpu)
+			continue;
 
-		next = pick_next_task(rq, &fake_task);
-		BUG_ON(!next);
-		next->sched_class->put_prev_task(rq, next);
+		if (p == rq->stop)
+			continue;
 
 		/* Find suitable destination for @next, with force if needed. */
-		dest_cpu = select_fallback_rq(dead_cpu, next);
+		raw_spin_lock(&rq->lock);
+		dest_cpu = select_fallback_rq(dead_cpu, p);
 		raw_spin_unlock(&rq->lock);
 
-		__migrate_task(next, dead_cpu, dest_cpu);
+		WARN_ON(!__migrate_task(p, dead_cpu, dest_cpu));
 
-		raw_spin_lock(&rq->lock);
-	}
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
 
-	rq->stop = stop;
+	BUG_ON(rq->nr_running != 1); /* the migration thread */
 }
-
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
@@ -5107,16 +5072,16 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
+		BUG_ON(current != rq->stop);
 		sched_ttwu_pending();
 		/* Update our root-domain */
-		raw_spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock(&rq->lock);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
+		raw_spin_unlock(&rq->lock);
 		migrate_tasks(cpu);
-		BUG_ON(rq->nr_running != 1); /* the migration thread */
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 	case CPU_DEAD:



