Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3HMM1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:27:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52452 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab3HMM1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:27:06 -0400
Date: Tue, 13 Aug 2013 14:26:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130813122652.GA24092@twins.programming.kicks-ass.net>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
 <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
 <20130812175830.GB18691@gmail.com>
 <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
 <20130813103056.GA2170@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813103056.GA2170@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:30:56PM +0200, Ingo Molnar wrote:

> But we could perhaps do something else and push the overhead into 
> resched_task(): instead of using atomics we could use the resched IPI to 
> set the local preempt_count(). That way preempt_count() will only ever be 
> updated CPU-locally and we could merge need_resched into preempt_count() 
> just fine.
> 
> [ Some care has to be taken with polling-idle threads: those could simply
>   use another signalling mechanism, another field in task struct, no need
>   to abuse need_resched for that. ]
> 
> We could still _read_ the preempt count non-destructively from other CPUs, 
> to avoid having to send a resched IPI for already marked tasks. [ OTOH it 
> might be faster to never do that and assume that an IPI has to be sent in 
> 99.9% of the cases - that would have to be re-measured. ]
> 
> Using this method we could have a really lightweight, minimal, percpu 
> based preempt count mechanism in all the default fastpath cases, both for 
> nested and for non-nested preempt_enable()s.

Indeed, however we need to keep TIF_NEED_RESCHED as is, and simply
transfer it to preempt_count() on the IPI. Every NEED_RESCHED already
causes the IPI, except indeed the 'polling' idle threads. Those we need
to also teach to transfer.

The reason is that the reschedule IPI is slightly over-used and we
wouldn't want to unconditionally cause a reschedule.

The below again boots to wanting to mount a root filesystem and is only
tested with kvm -smp 4, CONFIG_PREEMPT=y.

So we're now down to something like:

  decl fs:preempt_count
  cmpl PREEMPT_NEED_RESCHED,fs:preempt_count
  jnz 1f
  call preempt_schedule
1f:



---
 arch/x86/include/asm/thread_info.h |  9 ++++----
 arch/x86/kernel/asm-offsets.c      |  2 +-
 arch/x86/kernel/entry_64.S         |  4 +---
 include/linux/hardirq.h            |  4 ++--
 include/linux/preempt.h            | 11 ++++++----
 include/linux/sched.h              |  2 +-
 include/linux/thread_info.h        |  1 +
 include/trace/events/sched.h       |  2 +-
 init/main.c                        |  7 ++++---
 kernel/context_tracking.c          |  3 +--
 kernel/cpu/idle.c                  |  3 +++
 kernel/sched/core.c                | 43 ++++++++++++++++++++++++++------------
 kernel/softirq.c                   |  8 +++----
 kernel/timer.c                     |  9 ++++----
 lib/smp_processor_id.c             |  3 +--
 15 files changed, 67 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2781119..232d512 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -28,8 +28,7 @@ struct thread_info {
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable,
-						   <0 => BUG */
+	int			saved_preempt_count;
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
@@ -49,7 +48,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.saved_preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
@@ -100,8 +99,8 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
-#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
@@ -112,6 +111,7 @@ struct thread_info {
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
 #define _TIF_NOHZ		(1 << TIF_NOHZ)
+#define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
@@ -155,6 +155,7 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
 #define PREEMPT_ACTIVE		0x10000000
+#define PREEMPT_NEED_RESCHED	0x20000000
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2861082..46d889f 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,7 +32,7 @@ void common(void) {
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
-	OFFSET(TI_preempt_count, thread_info, preempt_count);
+//	OFFSET(TI_preempt_count, thread_info, preempt_count);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1b69951..011b6d3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1118,10 +1118,8 @@ ENTRY(native_iret)
 	/* Returning to kernel space. Check if we need preemption */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
-	cmpl $0,TI_preempt_count(%rcx)
+	cmpl $PREEMPT_NEED_RESCHED,PER_CPU_VAR(__preempt_count_var)
 	jnz  retint_restore_args
-	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
-	jnc  retint_restore_args
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
 	call preempt_schedule_irq
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 05bcc09..5d7f83c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -107,14 +107,14 @@
  * used in the general case to determine whether sleeping is possible.
  * Do not use in_atomic() in driver code.
  */
-#define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != 0)
+#define in_atomic()	((preempt_count() & ~(PREEMPT_ACTIVE|PREEMPT_NEED_RESCHED)) != 0)
 
 /*
  * Check whether we were atomic before we did preempt_disable():
  * (used by the scheduler, *after* releasing the kernel lock)
  */
 #define in_atomic_preempt_off() \
-		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
+		((preempt_count() & ~(PREEMPT_ACTIVE|PREEMPT_NEED_RESCHED)) != PREEMPT_CHECK_OFFSET)
 
 #ifdef CONFIG_PREEMPT_COUNT
 # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index f5d4723..724ee32 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -6,7 +6,8 @@
  * preempt_count (used for kernel preemption, interrupt count, etc.)
  */
 
-#include <linux/thread_info.h>
+#include <linux/thread_info.h> /* for PREEMPT_NEED_RESCHED */
+#include <asm/percpu.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 
@@ -21,7 +22,9 @@
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
-#define preempt_count()	(current_thread_info()->preempt_count)
+DECLARE_PER_CPU(int, __preempt_count_var);
+
+#define preempt_count() __raw_get_cpu_var(__preempt_count_var)
 
 #ifdef CONFIG_PREEMPT
 
@@ -29,7 +32,7 @@ asmlinkage void preempt_schedule(void);
 
 #define preempt_check_resched() \
 do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+	if (unlikely(preempt_count() == PREEMPT_NEED_RESCHED)) \
 		preempt_schedule(); \
 } while (0)
 
@@ -39,7 +42,7 @@ void preempt_schedule_context(void);
 
 #define preempt_check_resched_context() \
 do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+	if (unlikely(preempt_count() == PREEMPT_NEED_RESCHED)) \
 		preempt_schedule_context(); \
 } while (0)
 #else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f79ced7..6d2ee58 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2405,7 +2405,7 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 
 static inline int need_resched(void)
 {
-	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
+	return preempt_count() & PREEMPT_NEED_RESCHED;
 }
 
 /*
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e7e0473..477c301 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -104,6 +104,7 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 #define test_thread_flag(flag) \
 	test_ti_thread_flag(current_thread_info(), flag)
 
+#define test_need_resched()	test_thread_flag(TIF_NEED_RESCHED)
 #define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
 #define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
 
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e5586ca..816e2d6 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -103,7 +103,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+	if (task_thread_info(p)->saved_preempt_count & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
diff --git a/init/main.c b/init/main.c
index d03d2ec..6948f23 100644
--- a/init/main.c
+++ b/init/main.c
@@ -677,7 +677,7 @@ static int __init_or_module do_one_initcall_debug(initcall_t fn)
 
 int __init_or_module do_one_initcall(initcall_t fn)
 {
-	int count = preempt_count();
+	int count = preempt_count() & PREEMPT_MASK;
 	int ret;
 	char msgbuf[64];
 
@@ -688,9 +688,10 @@ int __init_or_module do_one_initcall(initcall_t fn)
 
 	msgbuf[0] = 0;
 
-	if (preempt_count() != count) {
+	if ((preempt_count() & PREEMPT_MASK) != count) {
 		sprintf(msgbuf, "preemption imbalance ");
-		preempt_count() = count;
+		preempt_count() &= ~PREEMPT_MASK;
+		preempt_count() |= count;
 	}
 	if (irqs_disabled()) {
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 383f823..6d113d8 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -87,10 +87,9 @@ void user_enter(void)
  */
 void __sched notrace preempt_schedule_context(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_ctx;
 
-	if (likely(ti->preempt_count || irqs_disabled()))
+	if (likely(preempt_count() || irqs_disabled()))
 		return;
 
 	/*
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index e695c0a..7a1afab 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -106,6 +106,9 @@ static void cpu_idle_loop(void)
 				current_set_polling();
 			}
 			arch_cpu_idle_exit();
+
+			if (test_need_resched())
+				preempt_count() |= PREEMPT_NEED_RESCHED;
 		}
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 54957a6..e52e468 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -89,6 +89,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
+DEFINE_PER_CPU(int, __preempt_count_var) = INIT_PREEMPT_COUNT;
+
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
@@ -526,8 +528,10 @@ void resched_task(struct task_struct *p)
 	set_tsk_need_resched(p);
 
 	cpu = task_cpu(p);
-	if (cpu == smp_processor_id())
+	if (cpu == smp_processor_id()) {
+		preempt_count() |= PREEMPT_NEED_RESCHED;
 		return;
+	}
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
@@ -994,7 +998,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+			!(task_thread_info(p)->saved_preempt_count & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1411,6 +1415,9 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
+	if (test_need_resched())
+		preempt_count() |= PREEMPT_NEED_RESCHED;
+
 	if (llist_empty(&this_rq()->wake_list)
 			&& !tick_nohz_full_cpu(smp_processor_id())
 			&& !got_nohz_idle_kick())
@@ -1728,7 +1735,7 @@ void sched_fork(struct task_struct *p)
 #endif
 #ifdef CONFIG_PREEMPT_COUNT
 	/* Want to start with kernel preemption disabled. */
-	task_thread_info(p)->preempt_count = 1;
+	task_thread_info(p)->saved_preempt_count = 1;
 #endif
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
@@ -2013,6 +2020,16 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 #endif
 
+#ifdef CONFIG_PREEMPT_COUNT
+	/*
+	 * If it weren't for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count() of all tasks was equal here and this wouldn't be
+	 * needed at all -- try and move PREEMPT_ACTIVE into TI_flags?
+	 */
+	task_thread_info(prev)->saved_preempt_count = preempt_count();
+	preempt_count() = task_thread_info(next)->saved_preempt_count;
+#endif
+
 	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
 	switch_to(prev, next, prev);
@@ -2241,7 +2258,7 @@ void __kprobes add_preempt_count(int val)
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
 #endif
-	if (preempt_count() == val)
+	if ((preempt_count() & ~PREEMPT_NEED_RESCHED) == val)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 EXPORT_SYMBOL(add_preempt_count);
@@ -2252,7 +2269,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+	if (DEBUG_LOCKS_WARN_ON(val > (preempt_count() & ~PREEMPT_NEED_RESCHED)))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
@@ -2262,7 +2279,7 @@ void __kprobes sub_preempt_count(int val)
 		return;
 #endif
 
-	if (preempt_count() == val)
+	if ((preempt_count() & ~PREEMPT_NEED_RESCHED) == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 	preempt_count() -= val;
 }
@@ -2433,6 +2450,7 @@ static void __sched __schedule(void)
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);
+	preempt_count() &= ~PREEMPT_NEED_RESCHED;
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
@@ -2515,13 +2533,11 @@ void __sched schedule_preempt_disabled(void)
  */
 asmlinkage void __sched notrace preempt_schedule(void)
 {
-	struct thread_info *ti = current_thread_info();
-
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
 	 * we do not want to preempt the current task. Just return..
 	 */
-	if (likely(ti->preempt_count || irqs_disabled()))
+	if (likely((preempt_count() & ~PREEMPT_NEED_RESCHED) || irqs_disabled()))
 		return;
 
 	do {
@@ -2546,11 +2562,10 @@ EXPORT_SYMBOL(preempt_schedule);
  */
 asmlinkage void __sched preempt_schedule_irq(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_state;
 
 	/* Catch callers which need to be fixed */
-	BUG_ON(ti->preempt_count || !irqs_disabled());
+	BUG_ON((preempt_count() & ~PREEMPT_NEED_RESCHED) || !irqs_disabled());
 
 	prev_state = exception_enter();
 
@@ -4217,7 +4232,8 @@ void init_idle(struct task_struct *idle, int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-	task_thread_info(idle)->preempt_count = 0;
+	task_thread_info(idle)->saved_preempt_count = 0;
+	per_cpu(__preempt_count_var, cpu) = 0;
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:
@@ -6562,7 +6578,8 @@ void __init sched_init(void)
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
-	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
+	int nested = (preempt_count() & ~(PREEMPT_ACTIVE|PREEMPT_NEED_RESCHED)) +
+		     rcu_preempt_depth();
 
 	return (nested == preempt_offset);
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index be3d351..87ede78 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -114,7 +114,7 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
-	if (preempt_count() == cnt)
+	if ((preempt_count() & ~PREEMPT_NEED_RESCHED) == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 #else /* !CONFIG_TRACE_IRQFLAGS */
@@ -243,20 +243,20 @@ asmlinkage void __do_softirq(void)
 	do {
 		if (pending & 1) {
 			unsigned int vec_nr = h - softirq_vec;
-			int prev_count = preempt_count();
+			int prev_count = preempt_count() & ~PREEMPT_NEED_RESCHED;
 
 			kstat_incr_softirqs_this_cpu(vec_nr);
 
 			trace_softirq_entry(vec_nr);
 			h->action(h);
 			trace_softirq_exit(vec_nr);
-			if (unlikely(prev_count != preempt_count())) {
+			if (unlikely(prev_count != (preempt_count() & ~PREEMPT_NEED_RESCHED))) {
 				printk(KERN_ERR "huh, entered softirq %u %s %p"
 				       "with preempt_count %08x,"
 				       " exited with %08x?\n", vec_nr,
 				       softirq_to_name[vec_nr], h->action,
 				       prev_count, preempt_count());
-				preempt_count() = prev_count;
+				preempt_count() = prev_count | (preempt_count() & PREEMPT_NEED_RESCHED);
 			}
 
 			rcu_bh_qs(cpu);
diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..4c6be29 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1092,7 +1092,7 @@ static int cascade(struct tvec_base *base, struct tvec *tv, int index)
 static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 			  unsigned long data)
 {
-	int preempt_count = preempt_count();
+	int count = preempt_count() & PREEMPT_MASK;
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1119,16 +1119,17 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 
 	lock_map_release(&lockdep_map);
 
-	if (preempt_count != preempt_count()) {
+	if (count != (preempt_count() & PREEMPT_MASK)) {
 		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
-			  fn, preempt_count, preempt_count());
+			  fn, count, preempt_count());
 		/*
 		 * Restore the preempt count. That gives us a decent
 		 * chance to survive and extract information. If the
 		 * callback kept a lock held, bad luck, but not worse
 		 * than the BUG() we had.
 		 */
-		preempt_count() = preempt_count;
+		preempt_count() &= ~PREEMPT_MASK;
+		preempt_count() |= count;
 	}
 }
 
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4c0d0e5..04abe53 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -9,10 +9,9 @@
 
 notrace unsigned int debug_smp_processor_id(void)
 {
-	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
 
-	if (likely(preempt_count))
+	if (likely(preempt_count()))
 		goto out;
 
 	if (irqs_disabled())
