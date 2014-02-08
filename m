Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBHSfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:35:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:51487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaBHSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:35:05 -0500
Date: Sat, 8 Feb 2014 19:35:00 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.10-rt15
Message-ID: <20140208183500.GA4803@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.10-rt15 patch set.

Changes since v3.12.10-rt14
- In the NO_HZ_FULL mode there might come a onetime backtrace from
  kernel/time/tick-sched.c:191. This should not appear anymore because
  this irq_work callback (and only this no_hz check callback) is now called
  from hardirq context. Mike said that it caused two of his 64 CPUs to spin
  for five minutes doing nothing but only on this on special machine.
  His 32way box did not share similar problems.

- Nicholas Mc Guire's locallock cleanups caused a build faile for the
  RT_BASE configuation and he sent a fix for this.

- Ulrich Obergfell reported a dead lock condition if cpu_chill() is used
  from softirq context because the softirq is used for wakeup of
  cpu_chill(). Steven sent a patch where cpu_chill() uses a hrtimer so
  the wake happens in hardirq context.

Known issues:

      - bcache is disabled.

The delta patch against v3.12.10-rt14 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.10-rt14-rt15.patch.xz

The RT patch against 3.12.10 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.10-rt15.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.10-rt15.tar.xz

Sebastian

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b3b1441..5ac241b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -423,7 +423,7 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifdef CONFIG_IRQ_WORK
+#if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
 
 /*
  * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 269af58..dbb51a6 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -43,10 +43,12 @@ void __irq_entry deferred_pcr_work_irq(int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 void arch_irq_work_raise(void)
 {
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
+#endif
 
 const struct pcr_ops *pcr_ops;
 EXPORT_SYMBOL_GPL(pcr_ops);
diff --git a/include/linux/delay.h b/include/linux/delay.h
index e23a7c0..37caab3 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -53,7 +53,7 @@ static inline void ssleep(unsigned int seconds)
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
-# define cpu_chill()	msleep(1)
+extern void cpu_chill(void);
 #else
 # define cpu_chill()	cpu_relax()
 #endif
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..60c19ee 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,6 +16,7 @@
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 #define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+#define IRQ_WORK_HARD_IRQ	8UL /* Run hard IRQ context, even on RT */
 
 struct irq_work {
 	unsigned long flags;
diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index 32c684b..21653e9 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -36,6 +36,22 @@ struct local_irq_lock {
 			spin_lock_init(&per_cpu(lvar, __cpu).lock);	\
 	} while (0)
 
+/*
+ * spin_lock|trylock|unlock_local flavour that does not migrate disable
+ * used for __local_lock|trylock|unlock where get_local_var/put_local_var
+ * already takes care of the migrate_disable/enable
+ * for CONFIG_PREEMPT_BASE map to the normal spin_* calls.
+ */
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define spin_lock_local(lock)			rt_spin_lock(lock)
+# define spin_trylock_local(lock)		rt_spin_trylock(lock)
+# define spin_unlock_local(lock)		rt_spin_unlock(lock)
+#else
+# define spin_lock_local(lock)			spin_lock(lock)
+# define spin_trylock_local(lock)		spin_trylock(lock)
+# define spin_unlock_local(lock)		spin_unlock(lock)
+#endif
+
 static inline void __local_lock(struct local_irq_lock *lv)
 {
 	if (lv->owner != current) {
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 4f91114..ac6f08b 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -36,10 +36,6 @@ extern int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock);
 extern void __lockfunc __rt_spin_lock(struct rt_mutex *lock);
 extern void __lockfunc __rt_spin_unlock(struct rt_mutex *lock);
 
-#define spin_lock_local(lock)			rt_spin_lock(lock)
-#define spin_trylock_local(lock)		rt_spin_trylock(lock)
-#define spin_unlock_local(lock)			rt_spin_unlock(lock)
-
 #define spin_lock(lock)				\
 	do {					\
 		migrate_disable();		\
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 7aa442e..5c26d2c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1890,6 +1890,21 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * Sleep for 1 ms in hope whoever holds what we want will let it go.
+ */
+void cpu_chill(void)
+{
+	struct timespec tu = {
+		.tv_nsec = NSEC_PER_MSEC,
+	};
+
+	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+}
+EXPORT_SYMBOL(cpu_chill);
+#endif
+
 /*
  * Functions related to boot-time initialization:
  */
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f6e4377..35d21f9 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -20,6 +20,9 @@
 
 
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
+#ifdef CONFIG_PREEMPT_RT_FULL
+static DEFINE_PER_CPU(struct llist_head, hirq_work_list);
+#endif
 static DEFINE_PER_CPU(int, irq_work_raised);
 
 /*
@@ -48,7 +51,11 @@ static bool irq_work_claim(struct irq_work *work)
 	return true;
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+void arch_irq_work_raise(void)
+#else
 void __weak arch_irq_work_raise(void)
+#endif
 {
 	/*
 	 * Lame architectures will get the timer tick callback
@@ -70,8 +77,12 @@ void irq_work_queue(struct irq_work *work)
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (work->flags & IRQ_WORK_HARD_IRQ)
+		llist_add(&work->llnode, &__get_cpu_var(hirq_work_list));
+	else
+#endif
+		llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
 	 * work interrupt (if supported by the arch), otherwise, just wait
@@ -115,7 +126,12 @@ static void __irq_work_run(void)
 	__this_cpu_write(irq_work_raised, 0);
 	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (in_irq())
+		this_list = &__get_cpu_var(hirq_work_list);
+	else
+#endif
+		this_list = &__get_cpu_var(irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4675aab..a236875 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -221,6 +221,7 @@ static void nohz_full_kick_work_func(struct irq_work *work)
 
 static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 	.func = nohz_full_kick_work_func,
+	.flags = IRQ_WORK_HARD_IRQ,
 };
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index 426d114..cc34e42 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1425,7 +1425,7 @@ void update_process_times(int user_tick)
 	scheduler_tick();
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
-#if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
+#if defined(CONFIG_IRQ_WORK)
 	if (in_irq())
 		irq_work_run();
 #endif
diff --git a/localversion-rt b/localversion-rt
index 08b3e75..18777ec 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt14
+-rt15
