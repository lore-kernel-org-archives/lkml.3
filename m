Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaG3Vm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:42:56 -0400
Received: from forward3l.mail.yandex.net ([84.201.143.136]:40917 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaG3Vmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:42:53 -0400
X-Yandex-Uniq: 3d7871d2-c1cb-44a5-adc6-5c32a6fcf4bf
Authentication-Results: smtp13.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Thu, 31 Jul 2014 01:42:49 +0400
Message-ID: <20140730214249.27604.39410.stgit@localhost>
In-Reply-To: <20140730213219.27604.11218.stgit@localhost>
References: <20140730213219.27604.11218.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new state which will be used to indicate that
a task is in a process of migrating between two RQs. It
allows to get rid of double_rq_lock(), which we used to
use to change rq of a queued task before.

Let's consider the example. To move a task between src_rq
and dst_rq we will do the following:

	raw_spin_lock(&src_rq->lock);
	/* p is a task which is queued on src_rq */
	p = ...;

	dequeue_task(src_rq, p, 0);
	p->on_rq = ONRQ_MIGRATING;
	set_task_cpu(p, dst_cpu);
	raw_spin_unlock(&src_rq->lock);

	/*
	 * Both of RQs are unlocked here.
	 * Task p is dequeued from src_rq
	 * but its on_rq is not zero.
	 */

	raw_spin_lock(&dst_rq->lock);
	p->on_rq = ONRQ_QUEUED;
	enqueue_task(dst_rq, p, 0);
	raw_spin_unlock(&dst_rq->lock);

When p->on_rq is ONRQ_MIGRATING, task is considered
as "migrating", and other parallel scheduler actions
with it are not available for parallel caller. The
parallel caller spins till migration is completed.

The unavailable actions are changing of cpu affinity,
changing of priority etc, in other words all the
functionality which used to require task_rq(p)->lock
before (and related to the task).

To implement ONRQ_MIGRATING support we primarily are
using the following fact. Most of scheduler users
(from which we are protecting a migrating task) use
task_rq_lock() and __task_rq_lock() to get the lock
of task_rq(p). These primitives know that task's cpu
may change, and they are spining while the lock of
the right RQ is not held. We add one more condition
into them, so they will be also spinning until the
migration is finished.
---
 kernel/sched/core.c  |   14 +++++++++++---
 kernel/sched/sched.h |    6 ++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26aa7bc..75b0517 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -331,9 +331,13 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	lockdep_assert_held(&p->pi_lock);
 
 	for (;;) {
+		while (unlikely(task_migrating(p)))
+			cpu_relax();
+
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) &&
+			   !task_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -349,10 +353,14 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	struct rq *rq;
 
 	for (;;) {
+		while (unlikely(task_migrating(p)))
+			cpu_relax();
+
 		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) &&
+			   !task_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
@@ -1678,7 +1686,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (task_queued(p) && ttwu_remote(p, wake_flags))
+	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2c83b6e..ac7c1c8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -17,6 +17,7 @@ struct rq;
 
 /* task_struct::on_rq states: */
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

