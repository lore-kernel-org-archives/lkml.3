Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3IKLGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:06:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3IKLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:06:49 -0400
Date: Wed, 11 Sep 2013 13:06:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/7] sched: Add NEED_RESCHED to the preempt_count
Message-ID: <20130911110635.GT26785@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910132011.116593485@infradead.org>
 <522FCE9D.4010707@amacapital.net>
 <20130911082530.GN31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911082530.GN31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:25:30AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 10, 2013 at 06:59:57PM -0700, Andy Lutomirski wrote:

> > It looks like the intel_idle code can get confused if TIF_NEED_RESCHED
> > is set but the preempt resched bit is not -- the need_resched call
> > between monitor and mwait won't notice TIF_NEED_RESCHED.
> > 
> > Is this condition possible?
> 
> Ah indeed, I'll have to go find all idle loops out there it seems. Now
> if only they were easy to spot :/
> 
> I was hoping the generic idle thing was good enough, apparently not
> quite. Thanks for spotting that.

OK, and the reason I didn't notice is that the entire TS_POLLING thing
is completely wrecked so we'll get the interrupt anyway.

The below might fix it.. it boots, but then it already did so that
doesn't say much.

Mike does it fix the funny you saw?

---
Subject: sched, idle: Fix the idle polling state logic
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Sep 11 12:43:13 CEST 2013

Mike reported that commit 7d1a9417 ("x86: Use generic idle loop")
regressed several workloads and caused excessive reschedule
interrupts.

The patch in question failed to notice that the x86 code had an
inverted sense of the polling state versus the new generic code (x86:
default polling, generic: default !polling).

Fix the two prominent x86 mwait based idle drivers and introduce a few
new generic polling helpers (fixing the wrong smp_mb__after_clear_bit
usage).

Also switch the idle routines to using test_need_resched() which is an
immediate TIF_NEED_RESCHED test as opposed to need_resched which will
end up being slightly different.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/process.c     |    6 +--
 drivers/acpi/processor_idle.c |   46 +++++-------------------
 drivers/idle/intel_idle.c     |    2 -
 include/linux/sched.h         |   78 ++++++++++++++++++++++++++++++++++++++----
 kernel/cpu/idle.c             |    9 ++--
 5 files changed, 89 insertions(+), 52 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -391,9 +391,9 @@ static void amd_e400_idle(void)
 		 * The switch back from broadcast mode needs to be
 		 * called with interrupts disabled.
 		 */
-		 local_irq_disable();
-		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
-		 local_irq_enable();
+		local_irq_disable();
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		local_irq_enable();
 	} else
 		default_idle();
 }
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -119,17 +119,10 @@ static struct dmi_system_id processor_po
  */
 static void acpi_safe_halt(void)
 {
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-	if (!need_resched()) {
+	if (!test_need_resched()) {
 		safe_halt();
 		local_irq_disable();
 	}
-	current_thread_info()->status |= TS_POLLING;
 }
 
 #ifdef ARCH_APICTIMER_STOPS_ON_C3
@@ -737,6 +730,11 @@ static int acpi_idle_enter_c1(struct cpu
 	if (unlikely(!pr))
 		return -EINVAL;
 
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
+			return -EINVAL;
+	}
+
 	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 
@@ -790,18 +788,9 @@ static int acpi_idle_enter_simple(struct
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method != ACPI_CSTATE_FFH) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
-
-		if (unlikely(need_resched())) {
-			current_thread_info()->status |= TS_POLLING;
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
 			return -EINVAL;
-		}
 	}
 
 	/*
@@ -819,9 +808,6 @@ static int acpi_idle_enter_simple(struct
 
 	sched_clock_idle_wakeup_event(0);
 
-	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
-
 	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
@@ -858,18 +844,9 @@ static int acpi_idle_enter_bm(struct cpu
 		}
 	}
 
-	if (cx->entry_method != ACPI_CSTATE_FFH) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
-
-		if (unlikely(need_resched())) {
-			current_thread_info()->status |= TS_POLLING;
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
 			return -EINVAL;
-		}
 	}
 
 	acpi_unlazy_tlb(smp_processor_id());
@@ -915,9 +892,6 @@ static int acpi_idle_enter_bm(struct cpu
 
 	sched_clock_idle_wakeup_event(0);
 
-	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
-
 	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -359,7 +359,7 @@ static int intel_idle(struct cpuidle_dev
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	if (!need_resched()) {
+	if (!current_set_polling_and_test()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2471,34 +2471,98 @@ static inline int tsk_is_polling(struct
 {
 	return task_thread_info(p)->status & TS_POLLING;
 }
-static inline void current_set_polling(void)
+static inline void __current_set_polling(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 }
 
-static inline void current_clr_polling(void)
+static inline bool __must_check current_set_polling_and_test(void)
+{
+	__current_set_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 */
+	smp_mb();
+
+	return unlikely(test_need_resched());
+}
+
+static inline void __current_clr_polling(void)
 {
 	current_thread_info()->status &= ~TS_POLLING;
-	smp_mb__after_clear_bit();
+}
+
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	__current_clr_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 */
+	smp_mb();
+
+	return unlikely(test_need_resched());
 }
 #elif defined(TIF_POLLING_NRFLAG)
 static inline int tsk_is_polling(struct task_struct *p)
 {
 	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
 }
-static inline void current_set_polling(void)
+
+static inline void __current_set_polling(void)
 {
 	set_thread_flag(TIF_POLLING_NRFLAG);
 }
 
-static inline void current_clr_polling(void)
+static inline bool __must_check current_set_polling_and_test(void)
+{
+	__current_set_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 *
+	 * XXX: assumes set/clear bit are identical barrier wise.
+	 */
+	smp_mb__after_clear_bit();
+
+	return unlikely(test_need_resched());
+}
+
+static inline void __current_clr_polling(void)
 {
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 }
+
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	__current_clr_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 */
+	smp_mb__after_clear_bit();
+
+	return unlikely(test_need_resched());
+}
+
 #else
 static inline int tsk_is_polling(struct task_struct *p) { return 0; }
-static inline void current_set_polling(void) { }
-static inline void current_clr_polling(void) { }
+static inline void __current_set_polling(void) { }
+static inline void __current_clr_polling(void) { }
+
+static inline bool __must_check current_set_polling_and_test(void)
+{
+	return unlikely(test_need_resched);
+}
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	return unlikely(test_need_resched);
+}
 #endif
 
 /*
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -44,7 +44,7 @@ static inline int cpu_idle_poll(void)
 	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
-	while (!need_resched())
+	while (!test_need_resched())
 		cpu_relax();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	rcu_idle_exit();
@@ -92,8 +92,7 @@ static void cpu_idle_loop(void)
 			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
 				cpu_idle_poll();
 			} else {
-				current_clr_polling();
-				if (!need_resched()) {
+				if (!current_clr_polling_and_test()) {
 					stop_critical_timings();
 					rcu_idle_enter();
 					arch_cpu_idle();
@@ -103,7 +102,7 @@ static void cpu_idle_loop(void)
 				} else {
 					local_irq_enable();
 				}
-				current_set_polling();
+				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
 			/*
@@ -136,7 +135,7 @@ void cpu_startup_entry(enum cpuhp_state
 	 */
 	boot_init_stack_canary();
 #endif
-	current_set_polling();
+	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
