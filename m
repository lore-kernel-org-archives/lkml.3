Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaIVSg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:36:26 -0400
Received: from forward6l.mail.yandex.net ([84.201.143.139]:41009 "EHLO
	forward6l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaIVSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:36:21 -0400
X-Yandex-Uniq: 96738d0f-1f05-4bc0-9ac3-accf02822811
Authentication-Results: smtp13.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 2/6] sched: Do not pick a task which is switching on
 other cpu
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:36:18 +0400
Message-ID: <20140922183618.11015.95007.stgit@localhost>
In-Reply-To: <20140922183612.11015.64200.stgit@localhost>
References: <20140922183612.11015.64200.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Architectures, which define __ARCH_WANT_UNLOCKED_CTXSW,
may pull a task when it's in the middle of schedule().

CPU1(task1 calls schedule)            CPU2
...                                   schedule()
...                                      idle_balance()
...                                         load_balance()
...                                            ...
schedule()                                     ...
   prepare_lock_switch()                       ...
      raw_spin_unlock(&rq1->lock)              ...
      ...                                      raw_spin_lock(&rq1->lock)
      ...                                         detach_tasks();
      ...                                            can_migrate_task(task1)
      ...                                         attach_tasks(); <--- move task1 to rq2
      ...                                      raw_spin_unlock(&rq1->lock)
      ...                                context_switch() <--- switch to task1's stack
      ...                                ...
   (using task1's stack)                 (using task1's stack)
   ...                                   ...
   context_switch()                      ...


Parallel use of a single stack is not a good idea.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: <stable@vger.kernel.org> # Should this go to stable?
---
 kernel/sched/core.c     |   11 +++--------
 kernel/sched/deadline.c |    7 ++++++-
 kernel/sched/fair.c     |    3 +++
 kernel/sched/rt.c       |    7 ++++++-
 kernel/sched/sched.h    |   16 ++++++++++++++++
 5 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2a93b87..5b864e9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1700,15 +1700,10 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 
 #ifdef CONFIG_SMP
 	/*
-	 * If the owning (remote) cpu is still in the middle of schedule() with
-	 * this task as prev, wait until its done referencing the task.
+	 * Note, that p is dequeued at the moment. But it still
+	 * may be "prev" in the middle of schedule() on other cpu.
 	 */
-	while (p->on_cpu)
-		cpu_relax();
-	/*
-	 * Pairs with the smp_wmb() in finish_lock_switch().
-	 */
-	smp_rmb();
+	cpu_relax__while_on_cpu(p);
 
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aaa5abb..ea0ba33 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1364,7 +1364,9 @@ static int push_dl_task(struct rq *rq)
 		next_task = task;
 		goto retry;
 	}
-
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+	cpu_relax__while_on_cpu(next_task);
+#endif
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, later_rq->cpu);
 	activate_task(later_rq, next_task, 0);
@@ -1451,6 +1453,9 @@ static int pull_dl_task(struct rq *this_rq)
 
 			ret = 1;
 
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+			cpu_relax__while_on_cpu(p);
+#endif
 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 420bc98..80c5064 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5298,6 +5298,9 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+		cpu_relax__while_on_cpu(p);
+#endif
 		return 1;
 	}
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2e6a774..de356b0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1734,7 +1734,9 @@ static int push_rt_task(struct rq *rq)
 		next_task = task;
 		goto retry;
 	}
-
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+	cpu_relax__while_on_cpu(next_task);
+#endif
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
@@ -1823,6 +1825,9 @@ static int pull_rt_task(struct rq *this_rq)
 
 			ret = 1;
 
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+			cpu_relax__while_on_cpu(p);
+#endif
 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bc6aad..9c07d72 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1034,6 +1034,22 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
+ * If the owning (remote) cpu is still in the middle of schedule() with
+ * this task as prev, wait until its done referencing the task.
+ */
+static inline void cpu_relax__while_on_cpu(struct task_struct *p)
+{
+#ifdef CONFIG_SMP
+	while (p->on_cpu)
+		cpu_relax();
+	/*
+	 * Pairs with the smp_wmb() in finish_lock_switch().
+	 */
+	smp_rmb();
+#endif
+}
+
+/*
  * wake flags
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakeup */

