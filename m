Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaISLrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:47:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaISLrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:47:04 -0400
Date: Fri, 19 Sep 2014 04:46:14 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-a15b12ac36ad4e7b856a4ae54937ae26a51aebad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1410519814.3569.7.camel@tkhai>
References: <1410519814.3569.7.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Do not stop cpu in set_cpus_allowed_ptr()
  if task is not running
Git-Commit-ID: a15b12ac36ad4e7b856a4ae54937ae26a51aebad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a15b12ac36ad4e7b856a4ae54937ae26a51aebad
Gitweb:     http://git.kernel.org/tip/a15b12ac36ad4e7b856a4ae54937ae26a51aebad
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 12 Sep 2014 15:03:34 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:21 +0200

sched: Do not stop cpu in set_cpus_allowed_ptr() if task is not running

If a task is queued but not running on it rq, we can simply migrate
it without migration thread and switching of context.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410519814.3569.7.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5536397..4b1ddeb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4629,6 +4629,33 @@ void init_idle(struct task_struct *idle, int cpu)
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
@@ -4685,14 +4712,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
 
@@ -4735,19 +4763,8 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
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
