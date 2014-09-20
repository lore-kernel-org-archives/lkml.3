Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaITQv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:28 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:33482 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaITQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:26 -0400
X-Yandex-Uniq: 06d63116-9ed4-412c-8a97-cd08918b2687
Authentication-Results: smtp19.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 2/7] sched: Fix picking a task switching on other cpu
 (__ARCH_WANT_UNLOCKED_CTXSW)
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:22 +0400
Message-ID: <20140920165122.16299.31150.stgit@localhost>
In-Reply-To: <20140920165116.16299.1381.stgit@localhost>
References: <20140920165116.16299.1381.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

We may pick a task which is in context_switch() on other cpu at the moment.
Parallel using of a single stack by two processes is not a good idea.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: <stable@vger.kernel.org>
---
 kernel/sched/core.c     |   11 +----------
 kernel/sched/deadline.c |    7 ++++++-
 kernel/sched/fair.c     |    3 +++
 kernel/sched/rt.c       |    7 ++++++-
 kernel/sched/sched.h    |   16 ++++++++++++++++
 5 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 55d86e7..c8d754f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1699,16 +1699,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		goto stat;
 
 #ifdef CONFIG_SMP
-	/*
-	 * If the owning (remote) cpu is still in the middle of schedule() with
-	 * this task as prev, wait until its done referencing the task.
-	 */
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
index fa13f94..0ec070e 100644
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
index aa0f73b..e2ef9b7 100644
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

