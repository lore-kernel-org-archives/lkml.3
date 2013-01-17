Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3AQN0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:26:00 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36742 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3AQNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:25:02 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/7] cputime: Allow dynamic switch between tick/virtual based cputime accounting
Date: Thu, 17 Jan 2013 14:24:33 +0100
Message-Id: <1358429075-3430-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
References: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to dynamically switch between tick and virtual based
cputime accounting. This way we can provide a kind of "on-demand"
virtual based cputime accounting. In this mode, the kernel relies
on the context tracking subsystem to dynamically probe on kernel
boundaries.

This is in preparation for being able to stop the timer tick in
more places than just the idle state. Doing so will depend on
CONFIG_VIRT_CPU_ACCOUNTING_GEN which makes it possible to account
the cputime without the tick by hooking on kernel/user boundaries.

Depending whether the tick is stopped or not, we can switch between
tick and vtime based accounting anytime in order to minimize the
overhead associated to user hooks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/vtime.h    |    8 ++++++++
 kernel/sched/cputime.c   |   24 ++++++++++++++++--------
 kernel/time/tick-sched.c |    5 ++++-
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 21ef703..5368af9 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -10,12 +10,20 @@ extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account_user(struct task_struct *tsk);
 extern void vtime_account(struct task_struct *tsk);
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern bool vtime_accounting_enabled(void);
 #else
+static inline bool vtime_accounting_enabled(void) { return true; }
+#endif
+
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
 static inline void vtime_account_user(struct task_struct *tsk) { }
 static inline void vtime_account(struct task_struct *tsk) { }
+static inline bool vtime_accounting_enabled(void) { return false; }
 #endif
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 1c964ec..0dfc280 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -317,8 +317,6 @@ out:
 	rcu_read_unlock();
 }
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * Account a tick to a process and cpustat
@@ -383,11 +381,12 @@ static void irqtime_account_idle_ticks(int ticks)
 		irqtime_account_process_tick(current, 0, rq);
 }
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
-static void irqtime_account_idle_ticks(int ticks) {}
-static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+static inline void irqtime_account_idle_ticks(int ticks) {}
+static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /*
  * Account a single tick of cpu time.
  * @p: the process that the cpu time gets accounted to
@@ -398,6 +397,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
+	if (vtime_accounting_enabled()) {
+		vtime_account_user(p);
+		return;
+	}
+
 	if (sched_clock_irqtime) {
 		irqtime_account_process_tick(p, user_tick, rq);
 		return;
@@ -439,8 +443,7 @@ void account_idle_ticks(unsigned long ticks)
 
 	account_idle_time(jiffies_to_cputime(ticks));
 }
-
-#endif
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 /*
  * Use precise platform statistics if available:
@@ -520,7 +523,7 @@ void vtime_account(struct task_struct *tsk)
 EXPORT_SYMBOL_GPL(vtime_account);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
 
-#else
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
 static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
 {
@@ -599,7 +602,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	thread_group_cputime(p, &cputime);
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
-#endif
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static DEFINE_PER_CPU(unsigned long long, cputime_snap);
@@ -635,4 +638,9 @@ void vtime_account_idle(struct task_struct *tsk)
 
 	account_idle_time(delta_cpu);
 }
+
+bool vtime_accounting_enabled(void)
+{
+	return context_tracking_active();
+}
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d58e552..46dfb6d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -631,8 +631,11 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	unsigned long ticks;
+
+	if (vtime_accounting_enabled())
+		return;
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
-- 
1.7.5.4

