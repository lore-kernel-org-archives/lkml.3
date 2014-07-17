Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbaGQP0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:26:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:27059 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933804AbaGQP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:26:38 -0400
Date: Thu, 17 Jul 2014 11:26:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.2.60-rt89
Message-ID: <20140717112636.5cbac13c@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.60-rt89 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt
  Head SHA1: 28dbf3f4acae4140e2b56cfa507f3fe623052269


Or to build 3.2.60-rt89 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.60.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.60-rt89.patch.xz



You can also build from 3.2.60-rt88 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.60-rt88-rt89.patch.xz



Enjoy,

-- Steve


Changes from v3.2.60-rt88:

---

Steven Rostedt (1):
      sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq()

Steven Rostedt (Red Hat) (1):
      Linux 3.2.60-rt89

Thomas Gleixner (1):
      workqueue: Prevent deadlock/stall on RT

Zhao Hongjiang (1):
      hrtimer:fix the miss of hrtimer_peek_ahead_timers in nort code

----
 kernel/hrtimer.c   |  6 +++++-
 kernel/sched.c     | 16 +++++-----------
 kernel/workqueue.c | 41 +++++++++++++++++++++++++++++++++++------
 localversion-rt    |  2 +-
 4 files changed, 46 insertions(+), 19 deletions(-)
---------------------------
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2bd88f06a6d0..928473aa0aec 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1452,7 +1452,11 @@ static int hrtimer_rt_defer(struct hrtimer *timer)
 
 #else
 
-static inline void hrtimer_rt_run_pending(void) { }
+static inline void hrtimer_rt_run_pending(void)
+{
+	hrtimer_peek_ahead_timers();
+}
+
 static inline int hrtimer_rt_defer(struct hrtimer *timer) { return 0; }
 
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 9942f012908d..7fb61d32d771 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2572,12 +2572,6 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
 				task_pid_nr(p), p->comm, cpu);
 	}
-	/*
-	 * Clear PF_THREAD_BOUND, otherwise we wreckage
-	 * migrate_disable/enable. See optimization for
-	 * PF_THREAD_BOUND tasks there.
-	 */
-	p->flags &= ~PF_THREAD_BOUND;
 	return dest_cpu;
 }
 
@@ -4801,9 +4795,8 @@ need_resched:
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state || tsk_is_pi_blocked(tsk))
+	if (!tsk->state)
 		return;
-
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -4813,6 +4806,10 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	if (tsk->flags & PF_WQ_WORKER && !tsk->saved_state)
 		wq_worker_sleeping(tsk);
 
+
+	if (tsk_is_pi_blocked(tsk))
+		return;
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
@@ -4823,9 +4820,6 @@ static inline void sched_submit_work(struct task_struct *tsk)
 
 static inline void sched_update_worker(struct task_struct *tsk)
 {
-	if (tsk_is_pi_blocked(tsk))
-		return;
-
 	if (tsk->flags & PF_WQ_WORKER)
 		wq_worker_running(tsk);
 }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 62ebed73dfa2..505b50dff3b5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -319,6 +319,31 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 	     (cpu) < WORK_CPU_NONE;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, (wq)))
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+static inline void rt_lock_idle_list(struct global_cwq *gcwq)
+{
+	preempt_disable();
+}
+static inline void rt_unlock_idle_list(struct global_cwq *gcwq)
+{
+	preempt_enable();
+}
+static inline void sched_lock_idle_list(struct global_cwq *gcwq) { }
+static inline void sched_unlock_idle_list(struct global_cwq *gcwq) { }
+#else
+static inline void rt_lock_idle_list(struct global_cwq *gcwq) { }
+static inline void rt_unlock_idle_list(struct global_cwq *gcwq) { }
+static inline void sched_lock_idle_list(struct global_cwq *gcwq)
+{
+	spin_lock_irq(&gcwq->lock);
+}
+static inline void sched_unlock_idle_list(struct global_cwq *gcwq)
+{
+	spin_unlock_irq(&gcwq->lock);
+}
+#endif
+
+
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
 static struct debug_obj_descr work_debug_descr;
@@ -655,10 +680,16 @@ static struct worker *first_worker(struct global_cwq *gcwq)
  */
 static void wake_up_worker(struct global_cwq *gcwq)
 {
-	struct worker *worker = first_worker(gcwq);
+	struct worker *worker;
+
+	rt_lock_idle_list(gcwq);
+
+	worker = first_worker(gcwq);
 
 	if (likely(worker))
 		wake_up_process(worker->task);
+
+	rt_unlock_idle_list(gcwq);
 }
 
 /**
@@ -701,7 +732,6 @@ void wq_worker_sleeping(struct task_struct *task)
 
 	cpu = smp_processor_id();
 	gcwq = get_gcwq(cpu);
-	spin_lock_irq(&gcwq->lock);
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
 	 * worklist not empty test sequence is in insert_work().
@@ -709,11 +739,10 @@ void wq_worker_sleeping(struct task_struct *task)
 	 */
 	if (atomic_dec_and_test(get_gcwq_nr_running(cpu)) &&
 	    !list_empty(&gcwq->worklist)) {
-		worker = first_worker(gcwq);
-		if (worker)
-			wake_up_process(worker->task);
+		sched_lock_idle_list(gcwq);
+		wake_up_worker(gcwq);
+		sched_unlock_idle_list(gcwq);
 	}
-	spin_unlock_irq(&gcwq->lock);
 }
 
 /**
diff --git a/localversion-rt b/localversion-rt
index 666227d921a3..d2a40223e4b7 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt88
+-rt89
