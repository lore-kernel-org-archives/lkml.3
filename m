Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3IYQjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:39:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3IYQi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:38:59 -0400
Date: Wed, 25 Sep 2013 09:38:19 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-nc03imb0etuefmzybzj7sprf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, bitbucket@online.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, bitbucket@online.de, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, idle: Fix the idle polling state logic
Git-Commit-ID: ea8117478918a4734586d35ff530721b682425be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:38:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea8117478918a4734586d35ff530721b682425be
Gitweb:     http://git.kernel.org/tip/ea8117478918a4734586d35ff530721b682425be
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Sep 2013 12:43:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 13:53:10 +0200

sched, idle: Fix the idle polling state logic

Mike reported that commit 7d1a9417 ("x86: Use generic idle loop")
regressed several workloads and caused excessive reschedule
interrupts.

The patch in question failed to notice that the x86 code had an
inverted sense of the polling state versus the new generic code (x86:
default polling, generic: default !polling).

Fix the two prominent x86 mwait based idle drivers and introduce a few
new generic polling helpers (fixing the wrong smp_mb__after_clear_bit
usage).

Also switch the idle routines to using tif_need_resched() which is an
immediate TIF_NEED_RESCHED test as opposed to need_resched which will
end up being slightly different.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: lenb@kernel.org
Cc: tglx@linutronix.de
Link: http://lkml.kernel.org/n/tip-nc03imb0etuefmzybzj7sprf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/process.c     |  6 ++--
 drivers/acpi/processor_idle.c | 46 ++++++-------------------
 drivers/idle/intel_idle.c     |  2 +-
 include/linux/sched.h         | 78 +++++++++++++++++++++++++++++++++++++++----
 include/linux/thread_info.h   |  2 ++
 kernel/cpu/idle.c             |  9 +++--
 6 files changed, 91 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c83516b..3fb8d95 100644
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
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f98dd00..c7414a5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -119,17 +119,10 @@ static struct dmi_system_id processor_power_dmi_table[] = {
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
+	if (!tif_need_resched()) {
 		safe_halt();
 		local_irq_disable();
 	}
-	current_thread_info()->status |= TS_POLLING;
 }
 
 #ifdef ARCH_APICTIMER_STOPS_ON_C3
@@ -737,6 +730,11 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
+			return -EINVAL;
+	}
+
 	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 
@@ -790,18 +788,9 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
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
@@ -819,9 +808,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	sched_clock_idle_wakeup_event(0);
 
-	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
-
 	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
@@ -858,18 +844,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
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
@@ -915,9 +892,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	sched_clock_idle_wakeup_event(0);
 
-	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
-
 	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index fa6964d..f116d66 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -359,7 +359,7 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	if (!need_resched()) {
+	if (!current_set_polling_and_test()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b5344de..e783ec5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2479,34 +2479,98 @@ static inline int tsk_is_polling(struct task_struct *p)
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
+	return unlikely(tif_need_resched());
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
+	return unlikely(tif_need_resched());
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
+	return unlikely(tif_need_resched());
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
+	return unlikely(tif_need_resched());
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
+	return unlikely(tif_need_resched());
+}
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	return unlikely(tif_need_resched());
+}
 #endif
 
 /*
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index a629e4b..fddbe20 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -118,6 +118,8 @@ static inline __deprecated void set_need_resched(void)
 	 */
 }
 
+#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
+
 #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
 /*
  * An arch can define its own version of set_restore_sigmask() to get the
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index e695c0a..c261409 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -44,7 +44,7 @@ static inline int cpu_idle_poll(void)
 	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
-	while (!need_resched())
+	while (!tif_need_resched())
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
 		}
@@ -129,7 +128,7 @@ void cpu_startup_entry(enum cpuhp_state state)
 	 */
 	boot_init_stack_canary();
 #endif
-	current_set_polling();
+	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
