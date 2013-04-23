Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3DWXo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:44:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab3DWXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:44:25 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DfMNWbEOgJYA:10 a=VwQbUJbxAAAA:8 a=I0mWzmDI8jOlddOmeVwA:9 a=QEXdDO2ut3YA:10 a=MXRhohyDEtcT6VAb:21 a=0KW0OSrnTSX0Yvo5:21 a=b0fal1DdfJ2c0RgP:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366760662.9609.176.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.4.41-rt55-feat1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 23 Apr 2013 19:44:22 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.41-rt55-feat1 feature release.

This release contains the backport of the softirq routines being called
directly by the thread that raised the softirq, making the softirq run
at the priority of its caller. Special thanks goes out to Sebastian
Andrzej Siewior for doing this backport.

This release is a separate branch from the normal stable-rt as it
includes features that do not fit under the "stable fixes" requirement
for the main stable-rt branch. These features are extremely helpful for
those that require them but still want to run on a specific kernel.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.4-rt-features
  Head SHA1: 37f0203d401b4ef15e030a46505cc2dea3907711


Or to build 3.4.41-rt55-feat1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.41.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.41-rt55.patch.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/features/patch-3.4.41-rt55-feat1.patch.xz

Broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/features/patches-3.4.41-rt55-feat1.tar.xz




Enjoy,

-- Steve


Changes from 3.4.41-rt55:

---

Steven Rostedt (Red Hat) (1):
      Linux 3.4.41-rt55-feat1

Thomas Gleixner (7):
      softirq: Make serving softirqs a task flag
      softirq: Split handling function
      softirq: Split softirq locks
      softirq: Adapt NOHZ softirq pending check to new RT scheme
      softirq: Add more debugging
      softirq: Fix nohz pending issue for real
      net: Use local_bh_disable in netif_rx_ni()

----
 include/linux/sched.h |    2 +
 kernel/softirq.c      |  403 +++++++++++++++++++++++++++++++------------------
 localversion-rt-feat  |    1 +
 net/core/dev.c        |    6 +-
 4 files changed, 257 insertions(+), 155 deletions(-)
---------------------------
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7a750f5..81efe03 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1650,6 +1650,7 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RT_BASE
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
+	unsigned int softirqs_raised;
 #endif
 #ifdef CONFIG_PREEMPT_RT_FULL
 # if defined CONFIG_HIGHMEM || defined CONFIG_X86_32
@@ -1878,6 +1879,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
+#define PF_IN_SOFTIRQ	0x00004000	/* Task is serving softirq */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 34fe1db..3f67aff 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -65,45 +65,70 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 
 #ifdef CONFIG_NO_HZ
 # ifdef CONFIG_PREEMPT_RT_FULL
+
+struct softirq_runner {
+	struct task_struct *runner[NR_SOFTIRQS];
+};
+
+static DEFINE_PER_CPU(struct softirq_runner, softirq_runners);
+
+static inline void softirq_set_runner(unsigned int sirq)
+{
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+
+	sr->runner[sirq] = current;
+}
+
+static inline void softirq_clr_runner(unsigned int sirq)
+{
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+
+	sr->runner[sirq] = NULL;
+}
+
 /*
- * On preempt-rt a softirq might be blocked on a lock. There might be
- * no other runnable task on this CPU because the lock owner runs on
- * some other CPU. So we have to go into idle with the pending bit
- * set. Therefor we need to check this otherwise we warn about false
- * positives which confuses users and defeats the whole purpose of
- * this test.
+ * On preempt-rt a softirq running context might be blocked on a
+ * lock. There might be no other runnable task on this CPU because the
+ * lock owner runs on some other CPU. So we have to go into idle with
+ * the pending bit set. Therefor we need to check this otherwise we
+ * warn about false positives which confuses users and defeats the
+ * whole purpose of this test.
  *
  * This code is called with interrupts disabled.
  */
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+	u32 warnpending = local_softirq_pending();
+	int i;
 
 	if (rate_limit >= 10)
 		return;
 
-	if (pending) {
-		struct task_struct *tsk;
+	for (i = 0; i < NR_SOFTIRQS; i++) {
+		struct task_struct *tsk = sr->runner[i];
 
-		tsk = __get_cpu_var(ksoftirqd);
 		/*
 		 * The wakeup code in rtmutex.c wakes up the task
 		 * _before_ it sets pi_blocked_on to NULL under
 		 * tsk->pi_lock. So we need to check for both: state
 		 * and pi_blocked_on.
 		 */
-		raw_spin_lock(&tsk->pi_lock);
-
-		if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
-			warnpending = 1;
-
-		raw_spin_unlock(&tsk->pi_lock);
+		if (tsk) {
+			raw_spin_lock(&tsk->pi_lock);
+			if (tsk->pi_blocked_on || tsk->state == TASK_RUNNING) {
+				/* Clear all bits pending in that task */
+				warnpending &= ~(tsk->softirqs_raised);
+				warnpending &= ~(1 << i);
+			}
+			raw_spin_unlock(&tsk->pi_lock);
+		}
 	}
 
 	if (warnpending) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       pending);
+		       warnpending);
 		rate_limit++;
 	}
 }
@@ -122,6 +147,10 @@ void softirq_check_pending_idle(void)
 	}
 }
 # endif
+
+#else /* !NO_HZ */
+static inline void softirq_set_runner(unsigned int sirq) { }
+static inline void softirq_clr_runner(unsigned int sirq) { }
 #endif
 
 /*
@@ -139,36 +168,39 @@ static void wakeup_softirqd(void)
 		wake_up_process(tsk);
 }
 
-static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
+static void handle_softirq(unsigned int vec_nr, int cpu, int need_rcu_bh_qs)
 {
-	struct softirq_action *h = softirq_vec;
+	struct softirq_action *h = softirq_vec + vec_nr;
 	unsigned int prev_count = preempt_count();
 
-	local_irq_enable();
-	for ( ; pending; h++, pending >>= 1) {
-		unsigned int vec_nr = h - softirq_vec;
+	kstat_incr_softirqs_this_cpu(vec_nr);
+	trace_softirq_entry(vec_nr);
+	h->action(h);
+	trace_softirq_exit(vec_nr);
 
-		if (!(pending & 1))
-			continue;
+	if (unlikely(prev_count != preempt_count())) {
+		pr_err("softirq %u %s %p preempt count leak: %08x -> %08x\n",
+		       vec_nr, softirq_to_name[vec_nr], h->action,
+		       prev_count, (unsigned int) preempt_count());
+		preempt_count() = prev_count;
+	}
+	if (need_rcu_bh_qs)
+		rcu_bh_qs(cpu);
+}
 
-		kstat_incr_softirqs_this_cpu(vec_nr);
-		trace_softirq_entry(vec_nr);
-		h->action(h);
-		trace_softirq_exit(vec_nr);
-		if (unlikely(prev_count != preempt_count())) {
-			printk(KERN_ERR
- "huh, entered softirq %u %s %p with preempt_count %08x exited with %08x?\n",
-			       vec_nr, softirq_to_name[vec_nr], h->action,
-			       prev_count, (unsigned int) preempt_count());
-			preempt_count() = prev_count;
-		}
-		if (need_rcu_bh_qs)
-			rcu_bh_qs(cpu);
+#ifndef CONFIG_PREEMPT_RT_FULL
+static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
+{
+	unsigned int vec_nr;
+
+	local_irq_enable();
+	for (vec_nr = 0; pending; vec_nr++, pending >>= 1) {
+		if (pending & 1)
+			handle_softirq(vec_nr, cpu, need_rcu_bh_qs);
 	}
 	local_irq_disable();
 }
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * preempt_count and SOFTIRQ_OFFSET usage:
  * - preempt_count is changed by SOFTIRQ_OFFSET on entering or leaving
@@ -372,29 +404,115 @@ asmlinkage void do_softirq(void)
 
 #endif
 
+/*
+ * This function must run with irqs disabled!
+ */
+void raise_softirq_irqoff(unsigned int nr)
+{
+	__raise_softirq_irqoff(nr);
+
+	/*
+	 * If we're in an interrupt or softirq, we're done
+	 * (this also catches softirq-disabled code). We will
+	 * actually run the softirq once we return from
+	 * the irq or softirq.
+	 *
+	 * Otherwise we wake up ksoftirqd to make sure we
+	 * schedule the softirq soon.
+	 */
+	if (!in_interrupt())
+		wakeup_softirqd();
+}
+
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+}
+
 static inline void local_bh_disable_nort(void) { local_bh_disable(); }
 static inline void _local_bh_enable_nort(void) { _local_bh_enable(); }
 static inline void ksoftirqd_set_sched_params(void) { }
 static inline void ksoftirqd_clr_sched_params(void) { }
 
+static inline int ksoftirqd_softirq_pending(void)
+{
+	return local_softirq_pending();
+}
+
 #else /* !PREEMPT_RT_FULL */
 
 /*
- * On RT we serialize softirq execution with a cpu local lock
+ * On RT we serialize softirq execution with a cpu local lock per softirq
  */
-static DEFINE_LOCAL_IRQ_LOCK(local_softirq_lock);
-static DEFINE_PER_CPU(struct task_struct *, local_softirq_runner);
+static DEFINE_PER_CPU(struct local_irq_lock [NR_SOFTIRQS], local_softirq_locks);
 
-static void __do_softirq_common(int need_rcu_bh_qs);
+void __init softirq_early_init(void)
+{
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQS; i++)
+		local_irq_lock_init(local_softirq_locks[i]);
+}
 
-void __do_softirq(void)
+static void lock_softirq(int which)
 {
-	__do_softirq_common(0);
+	__local_lock(&__get_cpu_var(local_softirq_locks[which]));
 }
 
-void __init softirq_early_init(void)
+static void unlock_softirq(int which)
 {
-	local_irq_lock_init(local_softirq_lock);
+	__local_unlock(&__get_cpu_var(local_softirq_locks[which]));
+}
+
+static void do_single_softirq(int which, int need_rcu_bh_qs)
+{
+	account_system_vtime(current);
+	current->flags |= PF_IN_SOFTIRQ;
+	lockdep_softirq_enter();
+	local_irq_enable();
+	handle_softirq(which, smp_processor_id(), need_rcu_bh_qs);
+	local_irq_disable();
+	lockdep_softirq_exit();
+	current->flags &= ~PF_IN_SOFTIRQ;
+	account_system_vtime(current);
+}
+
+/*
+ * Called with interrupts disabled. Process softirqs which were raised
+ * in current context (or on behalf of ksoftirqd).
+ */
+static void do_current_softirqs(int need_rcu_bh_qs)
+{
+	while (current->softirqs_raised) {
+		int i = __ffs(current->softirqs_raised);
+		unsigned int pending, mask = (1U << i);
+
+		current->softirqs_raised &= ~mask;
+		local_irq_enable();
+
+		/*
+		 * If the lock is contended, we boost the owner to
+		 * process the softirq or leave the critical section
+		 * now.
+		 */
+		lock_softirq(i);
+		local_irq_disable();
+		softirq_set_runner(i);
+		/*
+		 * Check with the local_softirq_pending() bits,
+		 * whether we need to process this still or if someone
+		 * else took care of it.
+		 */
+		pending = local_softirq_pending();
+		if (pending & mask) {
+			set_softirq_pending(pending & ~mask);
+			do_single_softirq(i, need_rcu_bh_qs);
+		}
+		softirq_clr_runner(i);
+		unlock_softirq(i);
+		WARN_ON(current->softirq_nestcnt != 1);
+	}
 }
 
 void local_bh_disable(void)
@@ -409,17 +527,11 @@ void local_bh_enable(void)
 	if (WARN_ON(current->softirq_nestcnt == 0))
 		return;
 
-	if ((current->softirq_nestcnt == 1) &&
-	    local_softirq_pending() &&
-	    local_trylock(local_softirq_lock)) {
+	local_irq_disable();
+	if (current->softirq_nestcnt == 1 && current->softirqs_raised)
+		do_current_softirqs(1);
+	local_irq_enable();
 
-		local_irq_disable();
-		if (local_softirq_pending())
-			__do_softirq();
-		local_irq_enable();
-		local_unlock(local_softirq_lock);
-		WARN_ON(current->softirq_nestcnt != 1);
-	}
 	current->softirq_nestcnt--;
 	migrate_enable();
 }
@@ -438,56 +550,14 @@ void _local_bh_enable(void)
 }
 EXPORT_SYMBOL(_local_bh_enable);
 
-/* For tracing */
-int notrace __in_softirq(void)
-{
-	if (__get_cpu_var(local_softirq_lock).owner == current)
-		return __get_cpu_var(local_softirq_lock).nestcnt;
-	return 0;
-}
-
 int in_serving_softirq(void)
 {
-	int res;
-
-	preempt_disable();
-	res = __get_cpu_var(local_softirq_runner) == current;
-	preempt_enable();
-	return res;
+	return current->flags & PF_IN_SOFTIRQ;
 }
 EXPORT_SYMBOL(in_serving_softirq);
 
-/*
- * Called with bh and local interrupts disabled. For full RT cpu must
- * be pinned.
- */
-static void __do_softirq_common(int need_rcu_bh_qs)
-{
-	u32 pending = local_softirq_pending();
-	int cpu = smp_processor_id();
-
-	current->softirq_nestcnt++;
-
-	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
-
-	__get_cpu_var(local_softirq_runner) = current;
-
-	lockdep_softirq_enter();
-
-	handle_pending_softirqs(pending, cpu, need_rcu_bh_qs);
-
-	pending = local_softirq_pending();
-	if (pending)
-		wakeup_softirqd();
-
-	lockdep_softirq_exit();
-	__get_cpu_var(local_softirq_runner) = NULL;
-
-	current->softirq_nestcnt--;
-}
-
-static int __thread_do_softirq(int cpu)
+/* Called with preemption disabled */
+static int ksoftirqd_do_softirq(int cpu)
 {
 	/*
 	 * Prevent the current cpu from going offline.
@@ -498,45 +568,92 @@ static int __thread_do_softirq(int cpu)
 	 */
 	pin_current_cpu();
 	/*
-	 * If called from ksoftirqd (cpu >= 0) we need to check
-	 * whether we are on the wrong cpu due to cpu offlining. If
-	 * called via thread_do_softirq() no action required.
+	 * We need to check whether we are on the wrong cpu due to cpu
+	 * offlining.
 	 */
-	if (cpu >= 0 && cpu_is_offline(cpu)) {
+	if (cpu_is_offline(cpu)) {
 		unpin_current_cpu();
 		return -1;
 	}
 	preempt_enable();
-	local_lock(local_softirq_lock);
 	local_irq_disable();
-	/*
-	 * We cannot switch stacks on RT as we want to be able to
-	 * schedule!
-	 */
-	if (local_softirq_pending())
-		__do_softirq_common(cpu >= 0);
-	local_unlock(local_softirq_lock);
-	unpin_current_cpu();
-	preempt_disable();
+	current->softirq_nestcnt++;
+	do_current_softirqs(1);
+	current->softirq_nestcnt--;
 	local_irq_enable();
+
+	preempt_disable();
+	unpin_current_cpu();
 	return 0;
 }
 
 /*
- * Called from netif_rx_ni(). Preemption enabled.
+ * Called from netif_rx_ni(). Preemption enabled, but migration
+ * disabled. So the cpu can't go away under us.
  */
 void thread_do_softirq(void)
 {
-	if (!in_serving_softirq()) {
-		preempt_disable();
-		__thread_do_softirq(-1);
-		preempt_enable();
+	if (!in_serving_softirq() && current->softirqs_raised) {
+		current->softirq_nestcnt++;
+		do_current_softirqs(0);
+		current->softirq_nestcnt--;
 	}
 }
 
-static int ksoftirqd_do_softirq(int cpu)
+static void do_raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+
+	/*
+	 * If we are not in a hard interrupt and inside a bh disabled
+	 * region, we simply raise the flag on current. local_bh_enable()
+	 * will make sure that the softirq is executed. Otherwise we
+	 * delegate it to ksoftirqd.
+	 */
+	if (!in_irq() && current->softirq_nestcnt)
+		current->softirqs_raised |= (1U << nr);
+	else if (__this_cpu_read(ksoftirqd))
+		__this_cpu_read(ksoftirqd)->softirqs_raised |= (1U << nr);
+}
+
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	do_raise_softirq_irqoff(nr);
+	if (!in_irq() && !current->softirq_nestcnt)
+		wakeup_softirqd();
+}
+
+/*
+ * This function must run with irqs disabled!
+ */
+void raise_softirq_irqoff(unsigned int nr)
 {
-	return __thread_do_softirq(cpu);
+	do_raise_softirq_irqoff(nr);
+
+	/*
+	 * If we're in an hard interrupt we let irq return code deal
+	 * with the wakeup of ksoftirqd.
+	 */
+	if (in_irq())
+		return;
+
+	/*
+	 * If we are in thread context but outside of a bh disabled
+	 * region, we need to wake ksoftirqd as well.
+	 *
+	 * CHECKME: Some of the places which do that could be wrapped
+	 * into local_bh_disable/enable pairs. Though it's unclear
+	 * whether this is worth the effort. To find those places just
+	 * raise a WARN() if the condition is met.
+	 */
+	if (!current->softirq_nestcnt)
+		wakeup_softirqd();
+}
+
+static inline int ksoftirqd_softirq_pending(void)
+{
+	return current->softirqs_raised;
 }
 
 static inline void local_bh_disable_nort(void) { }
@@ -547,6 +664,10 @@ static inline void ksoftirqd_set_sched_params(void)
 	struct sched_param param = { .sched_priority = 1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
+	/* Take over all pending softirqs when starting */
+	local_irq_disable();
+	current->softirqs_raised = local_softirq_pending();
+	local_irq_enable();
 }
 
 static inline void ksoftirqd_clr_sched_params(void)
@@ -593,8 +714,14 @@ static inline void invoke_softirq(void)
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
-#else
+#else /* PREEMPT_RT_FULL */
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (__this_cpu_read(ksoftirqd) &&
+	    __this_cpu_read(ksoftirqd)->softirqs_raised)
 		wakeup_softirqd();
+	local_irq_restore(flags);
 #endif
 }
 
@@ -618,26 +745,6 @@ void irq_exit(void)
 	sched_preempt_enable_no_resched();
 }
 
-/*
- * This function must run with irqs disabled!
- */
-inline void raise_softirq_irqoff(unsigned int nr)
-{
-	__raise_softirq_irqoff(nr);
-
-	/*
-	 * If we're in an interrupt or softirq, we're done
-	 * (this also catches softirq-disabled code). We will
-	 * actually run the softirq once we return from
-	 * the irq or softirq.
-	 *
-	 * Otherwise we wake up ksoftirqd to make sure we
-	 * schedule the softirq soon.
-	 */
-	if (!in_interrupt())
-		wakeup_softirqd();
-}
-
 void raise_softirq(unsigned int nr)
 {
 	unsigned long flags;
@@ -647,12 +754,6 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
-void __raise_softirq_irqoff(unsigned int nr)
-{
-	trace_softirq_raise(nr);
-	or_softirq_pending(1UL << nr);
-}
-
 void open_softirq(int nr, void (*action)(struct softirq_action *))
 {
 	softirq_vec[nr].action = action;
@@ -1104,12 +1205,12 @@ static int run_ksoftirqd(void * __bind_cpu)
 
 	while (!kthread_should_stop()) {
 		preempt_disable();
-		if (!local_softirq_pending())
+		if (!ksoftirqd_softirq_pending())
 			schedule_preempt_disabled();
 
 		__set_current_state(TASK_RUNNING);
 
-		while (local_softirq_pending()) {
+		while (ksoftirqd_softirq_pending()) {
 			if (ksoftirqd_do_softirq((long) __bind_cpu))
 				goto wait_to_die;
 			sched_preempt_enable_no_resched();
diff --git a/localversion-rt-feat b/localversion-rt-feat
new file mode 100644
index 0000000..14ee171
--- /dev/null
+++ b/localversion-rt-feat
@@ -0,0 +1 @@
+-feat1
diff --git a/net/core/dev.c b/net/core/dev.c
index 35fe1a0..1342a4d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2964,11 +2964,9 @@ int netif_rx_ni(struct sk_buff *skb)
 {
 	int err;
 
-	migrate_disable();
+	local_bh_disable();
 	err = netif_rx(skb);
-	if (local_softirq_pending())
-		thread_do_softirq();
-	migrate_enable();
+	local_bh_enable();
 
 	return err;
 }


