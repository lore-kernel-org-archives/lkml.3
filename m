Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3AQNZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:25:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34788 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab3AQNZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:25:07 -0500
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
Subject: [PATCH 7/7] cputime: Safely read cputime of full dynticks CPUs
Date: Thu, 17 Jan 2013 14:24:35 +0100
Message-Id: <1358429075-3430-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
References: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While remotely reading the cputime of a task running in a
full dynticks CPU, the values stored in utime/stime fields
of struct task_struct may be stale. Its values may be those
of the last kernel <-> user transition time snapshot and
we need to add the tickless time spent since this snapshot.

To fix this, flush the cputime of the dynticks CPUs on
kernel <-> user transition and record the time / context
where we did this. Then on top of this snapshot and the current
time, perform the fixup on the reader side from task_times()
accessors.

TODO: add support for guest time as well.

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
 arch/s390/kernel/vtime.c  |    6 +-
 include/linux/hardirq.h   |    4 +-
 include/linux/init_task.h |   11 ++++
 include/linux/sched.h     |   16 +++++
 include/linux/vtime.h     |   41 ++++++--------
 kernel/fork.c             |   14 +++++
 kernel/sched/cputime.c    |  135 +++++++++++++++++++++++++++++++++++++++++----
 kernel/softirq.c          |    6 +-
 8 files changed, 190 insertions(+), 43 deletions(-)

diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index e84b8b6..ce9cc5a 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -127,7 +127,7 @@ void vtime_account_user(struct task_struct *tsk)
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void vtime_account(struct task_struct *tsk)
+void vtime_account_irq_enter(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
@@ -145,10 +145,10 @@ void vtime_account(struct task_struct *tsk)
 
 	virt_timer_forward(system);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
+EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 
 void vtime_account_system(struct task_struct *tsk)
-__attribute__((alias("vtime_account")));
+__attribute__((alias("vtime_account_irq_enter")));
 EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void __kprobes vtime_stop_cpu(void)
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 624ef3f..7105d5c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -153,7 +153,7 @@ extern void rcu_nmi_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		vtime_account_irq_enter(current);	\
+		account_irq_enter_time(current);	\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
@@ -169,7 +169,7 @@ extern void irq_enter(void);
 #define __irq_exit()					\
 	do {						\
 		trace_hardirq_exit();			\
-		vtime_account_irq_exit(current);	\
+		account_irq_exit_time(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 	} while (0)
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6d087c5..cc898b8 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,6 +10,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/seqlock.h>
 #include <net/net_namespace.h>
 
 #ifdef CONFIG_SMP
@@ -141,6 +142,15 @@ extern struct task_group root_task_group;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+# define INIT_VTIME(tsk)						\
+	.vtime_seqlock = __SEQLOCK_UNLOCKED(tsk.vtime_seqlock),	\
+	.vtime_snap = 0,				\
+	.vtime_snap_whence = VTIME_SYS,
+#else
+# define INIT_VTIME(tsk)
+#endif
+
 #define INIT_TASK_COMM "swapper"
 
 /*
@@ -210,6 +220,7 @@ extern struct task_group root_task_group;
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ							\
+	INIT_VTIME(tsk)							\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e682d58..11b491c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1368,6 +1368,15 @@ struct task_struct {
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	struct cputime prev_cputime;
 #endif
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+	seqlock_t vtime_seqlock;
+	unsigned long long vtime_snap;
+	enum {
+		VTIME_SLEEPING = 0,
+		VTIME_USER,
+		VTIME_SYS,
+	} vtime_snap_whence;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
@@ -1792,6 +1801,12 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern void task_cputime(struct task_struct *t,
+			 cputime_t *utime, cputime_t *stime);
+extern void task_cputime_scaled(struct task_struct *t,
+				cputime_t *utimescaled, cputime_t *stimescaled);
+#else
 static inline void task_cputime(struct task_struct *t,
 				cputime_t *utime, cputime_t *stime)
 {
@@ -1810,6 +1825,7 @@ static inline void task_cputime_scaled(struct task_struct *t,
 	if (stimescaled)
 		*stimescaled = t->stimescaled;
 }
+#endif
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 5368af9..4a60dbd 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -9,34 +9,37 @@ extern void vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account_user(struct task_struct *tsk);
-extern void vtime_account(struct task_struct *tsk);
+extern void vtime_account_irq_enter(struct task_struct *tsk);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-extern bool vtime_accounting_enabled(void);
-#else
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 static inline bool vtime_accounting_enabled(void) { return true; }
 #endif
 
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
+
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
 static inline void vtime_account_user(struct task_struct *tsk) { }
-static inline void vtime_account(struct task_struct *tsk) { }
+static inline void vtime_account_irq_enter(struct task_struct *tsk) { }
 static inline bool vtime_accounting_enabled(void) { return false; }
 #endif
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
-static inline void vtime_user_enter(struct task_struct *tsk)
-{
-	vtime_account_system(tsk);
-}
+extern void arch_vtime_task_switch(struct task_struct *tsk);
+extern void vtime_account_irq_exit(struct task_struct *tsk);
+extern bool vtime_accounting_enabled(void);
+extern void vtime_user_enter(struct task_struct *tsk);
 static inline void vtime_user_exit(struct task_struct *tsk)
 {
 	vtime_account_user(tsk);
 }
 #else
+static inline void vtime_account_irq_exit(struct task_struct *tsk)
+{
+	/* On hard|softirq exit we always account to hard|softirq cputime */
+	vtime_account_system(tsk);
+}
 static inline void vtime_user_enter(struct task_struct *tsk) { }
 static inline void vtime_user_exit(struct task_struct *tsk) { }
 #endif
@@ -47,25 +50,15 @@ extern void irqtime_account_irq(struct task_struct *tsk);
 static inline void irqtime_account_irq(struct task_struct *tsk) { }
 #endif
 
-static inline void vtime_account_irq_enter(struct task_struct *tsk)
+static inline void account_irq_enter_time(struct task_struct *tsk)
 {
-	/*
-	 * Hardirq can interrupt idle task anytime. So we need vtime_account()
-	 * that performs the idle check in CONFIG_VIRT_CPU_ACCOUNTING.
-	 * Softirq can also interrupt idle task directly if it calls
-	 * local_bh_enable(). Such case probably don't exist but we never know.
-	 * Ksoftirqd is not concerned because idle time is flushed on context
-	 * switch. Softirqs in the end of hardirqs are also not a problem because
-	 * the idle time is flushed on hardirq time already.
-	 */
-	vtime_account(tsk);
+	vtime_account_irq_enter(tsk);
 	irqtime_account_irq(tsk);
 }
 
-static inline void vtime_account_irq_exit(struct task_struct *tsk)
+static inline void account_irq_exit_time(struct task_struct *tsk)
 {
-	/* On hard|softirq exit we always account to hard|softirq cputime */
-	vtime_account_system(tsk);
+	vtime_account_irq_exit(tsk);
 	irqtime_account_irq(tsk);
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 65ca6d2..4b3f683 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1233,6 +1233,20 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+	seqlock_init(&p->vtime_seqlock);
+	/*
+	 * TODO:
+	 * When the task is scheduled in, vtime_snap gets $NOW as
+	 * a snapshot and whence becomes VTIME_SYSTEM such that remote
+	 * readers can add up nohz cputime by computing the delta.
+	 * But idle tasks don't start from schedule(). We'll need to
+	 * provide a special treatment for them.
+	 */
+	p->vtime_snap = 0;
+	p->vtime_snap_whence = VTIME_SLEEPING;
+#endif
+
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 0745410..63e7a94 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -501,7 +501,7 @@ void vtime_task_switch(struct task_struct *prev)
  * vtime_account().
  */
 #ifndef __ARCH_HAS_VTIME_ACCOUNT
-void vtime_account(struct task_struct *tsk)
+void vtime_account_irq_enter(struct task_struct *tsk)
 {
 	if (!in_interrupt()) {
 		/*
@@ -522,7 +522,7 @@ void vtime_account(struct task_struct *tsk)
 	}
 	vtime_account_system(tsk);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
+EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
 
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
@@ -606,36 +606,61 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-static DEFINE_PER_CPU(unsigned long long, cputime_snap);
-
-static cputime_t get_vtime_delta(void)
+static cputime_t get_vtime_delta(struct task_struct *tsk)
 {
 	unsigned long long delta;
 
-	delta = sched_clock() - __this_cpu_read(cputime_snap);
-	__this_cpu_add(cputime_snap, delta);
+	delta = sched_clock() - tsk->vtime_snap;
+	tsk->vtime_snap += delta;
 
 	/* CHECKME: always safe to convert nsecs to cputime? */
 	return nsecs_to_cputime(delta);
 }
 
-void vtime_account_system(struct task_struct *tsk)
+static void __vtime_account_system(struct task_struct *tsk)
 {
-	cputime_t delta_cpu = get_vtime_delta();
+	cputime_t delta_cpu = get_vtime_delta(tsk);
 
 	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
 }
 
+void vtime_account_system(struct task_struct *tsk)
+{
+	write_seqlock(&tsk->vtime_seqlock);
+	__vtime_account_system(tsk);
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_account_irq_exit(struct task_struct *tsk)
+{
+	write_seqlock(&tsk->vtime_seqlock);
+	if (context_tracking_in_user())
+		tsk->vtime_snap_whence = VTIME_USER;
+	__vtime_account_system(tsk);
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
 void vtime_account_user(struct task_struct *tsk)
 {
-	cputime_t delta_cpu = get_vtime_delta();
+	cputime_t delta_cpu = get_vtime_delta(tsk);
 
+	write_seqlock(&tsk->vtime_seqlock);
+	tsk->vtime_snap_whence = VTIME_SYS;
 	account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_user_enter(struct task_struct *tsk)
+{
+	write_seqlock(&tsk->vtime_seqlock);
+	tsk->vtime_snap_whence = VTIME_USER;
+	__vtime_account_system(tsk);
+	write_sequnlock(&tsk->vtime_seqlock);
 }
 
 void vtime_account_idle(struct task_struct *tsk)
 {
-	cputime_t delta_cpu = get_vtime_delta();
+	cputime_t delta_cpu = get_vtime_delta(tsk);
 
 	account_idle_time(delta_cpu);
 }
@@ -644,4 +669,92 @@ bool vtime_accounting_enabled(void)
 {
 	return context_tracking_active();
 }
+
+void arch_vtime_task_switch(struct task_struct *prev)
+{
+	write_seqlock(&prev->vtime_seqlock);
+	prev->vtime_snap_whence = VTIME_SLEEPING;
+	write_sequnlock(&prev->vtime_seqlock);
+
+	write_seqlock(&current->vtime_seqlock);
+	current->vtime_snap_whence = VTIME_SYS;
+	current->vtime_snap = sched_clock();
+	write_sequnlock(&current->vtime_seqlock);
+}
+
+/*
+ * Fetch cputime raw values from fields of task_struct and
+ * add up the pending nohz execution time since the last
+ * cputime snapshot.
+ */
+static void
+fetch_task_cputime(struct task_struct *t,
+		   cputime_t *u_dst, cputime_t *s_dst,
+		   cputime_t *u_src, cputime_t *s_src,
+		   cputime_t *udelta, cputime_t *sdelta)
+{
+	unsigned long flags;
+	unsigned int seq;
+	unsigned long long clock, delta;
+
+	do {
+		*udelta = 0;
+		*sdelta = 0;
+
+		seq = read_seqbegin_irqsave(&t->vtime_seqlock, flags);
+
+		if (u_dst)
+			*u_dst = *u_src;
+		if (s_dst)
+			*s_dst = *s_src;
+
+		/* Task is sleeping, nothing to add */
+		if (t->vtime_snap_whence == VTIME_SLEEPING ||
+		    is_idle_task(t))
+			continue;
+
+		clock = sched_clock();
+		if (clock < t->vtime_snap)
+			continue;
+
+		delta = clock - t->vtime_snap;
+
+		/*
+		 * Task runs either in user or kernel space, add pending nohz time to
+		 * the right place.
+		 */
+		if (t->vtime_snap_whence == VTIME_USER) {
+			*udelta = delta;
+		} else {
+			if (t->vtime_snap_whence == VTIME_SYS)
+				*sdelta = delta;
+		}
+	} while (read_seqretry_irqrestore(&t->vtime_seqlock, seq, flags));
+}
+
+
+void task_cputime(struct task_struct *t, cputime_t *utime, cputime_t *stime)
+{
+	cputime_t udelta, sdelta;
+
+	fetch_task_cputime(t, utime, stime, &t->utime,
+			   &t->stime, &udelta, &sdelta);
+	if (utime)
+		*utime += udelta;
+	if (stime)
+		*stime += sdelta;
+}
+
+void task_cputime_scaled(struct task_struct *t,
+			 cputime_t *utimescaled, cputime_t *stimescaled)
+{
+	cputime_t udelta, sdelta;
+
+	fetch_task_cputime(t, utimescaled, stimescaled,
+			   &t->utimescaled, &t->stimescaled, &udelta, &sdelta);
+	if (utimescaled)
+		*utimescaled += cputime_to_scaled(udelta);
+	if (stimescaled)
+		*stimescaled += cputime_to_scaled(sdelta);
+}
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index ed567ba..f5cc25f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -221,7 +221,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	vtime_account_irq_enter(current);
+	account_irq_enter_time(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -272,7 +272,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	vtime_account_irq_exit(current);
+	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -341,7 +341,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	vtime_account_irq_exit(current);
+	account_irq_exit_time(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
-- 
1.7.5.4

