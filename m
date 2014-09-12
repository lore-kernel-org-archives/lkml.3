Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaILLDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:03:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:34954 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaILLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:03:39 -0400
Message-ID: <1410519814.3569.7.camel@tkhai>
Subject: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task is
 not running
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 12 Sep 2014 15:03:34 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a task is queued but not running on it rq, we can simply migrate
it without migration thread and switching of context.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d4399b4..dbbba26 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4594,6 +4594,33 @@ void init_idle(struct task_struct *idle, int cpu)
 }
 
 #ifdef CONFIG_SMP
+/*
+ * move_queued_task - move a queued task to new rq.
+ *
+ * Returns (locked) new rq. Old rq's lock is released.
+ */
+static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
+{
+	struct rq *rq = task_rq(p);
+
+	lockdep_assert_held(&rq->lock);
+
+	dequeue_task(rq, p, 0);
+	p->on_rq = TASK_ON_RQ_MIGRATING;
+	set_task_cpu(p, new_cpu);
+	raw_spin_unlock(&rq->lock);
+
+	rq = cpu_rq(new_cpu);
+
+	raw_spin_lock(&rq->lock);
+	BUG_ON(task_cpu(p) != new_cpu);
+	p->on_rq = TASK_ON_RQ_QUEUED;
+	enqueue_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+
+	return rq;
+}
+
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
 	if (p->sched_class && p->sched_class->set_cpus_allowed)
@@ -4650,14 +4677,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (task_on_rq_queued(p) || p->state == TASK_WAKING) {
+	if (task_running(rq, p) || p->state == TASK_WAKING) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
-	}
+	} else if (task_on_rq_queued(p))
+		rq = move_queued_task(p, dest_cpu);
 out:
 	task_rq_unlock(rq, p, &flags);
 
@@ -4700,19 +4728,8 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (task_on_rq_queued(p)) {
-		dequeue_task(rq, p, 0);
-		p->on_rq = TASK_ON_RQ_MIGRATING;
-		set_task_cpu(p, dest_cpu);
-		raw_spin_unlock(&rq->lock);
-
-		rq = cpu_rq(dest_cpu);
-		raw_spin_lock(&rq->lock);
-		BUG_ON(task_rq(p) != rq);
-		p->on_rq = TASK_ON_RQ_QUEUED;
-		enqueue_task(rq, p, 0);
-		check_preempt_curr(rq, p, 0);
-	}
+	if (task_on_rq_queued(p))
+		rq = move_queued_task(p, dest_cpu);
 done:
 	ret = 1;
 fail:



