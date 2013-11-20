Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3KTK6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:58:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3KTK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:58:46 -0500
Date: Wed, 20 Nov 2013 11:58:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
Message-ID: <20131120105837.GH3694@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
 <20131119090859.GC3694@twins.programming.kicks-ass.net>
 <20131119113153.GD3694@twins.programming.kicks-ass.net>
 <528B7433.7020507@linux.intel.com>
 <20131119145143.GK10022@twins.programming.kicks-ass.net>
 <20131119151338.GF3694@twins.programming.kicks-ass.net>
 <20131119130630.487da962@ultegra>
 <20131120102803.GO10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120102803.GO10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:28:03AM +0100, Peter Zijlstra wrote:
> On Tue, Nov 19, 2013 at 01:06:30PM -0800, Jacob Pan wrote:
> > I applied this patch on top of upstream kernel (801a760) and found out
> > my machine completely failed to enter idle when nothing is running.
> > turbostate shows 100% C0. ftrace shows kernel coming in and out of idle
> > frequently.
> > 
> > Both ACPI idle and intel_idle behaves the same way. I have to do the
> > following change to allow entering C-states again.

> That doesn't make any sense; current_set_polling_and_test() returns the
> same thing need_resched() does.
> 
> But you're right, intel_idle resides 100% in C0 and acpi_idle has 100%
> C1 residency... most weird.

So pretty silly actually; you cannot do a store (any store) in between
monitor and mwait.

The below version seems to work properly again with both acpi_idle and
intel_idle.

Now to go make that preempt_disable_no_resched cleanup compile.. :-)

---
Subject: x86, acpi, idle: Restructure the mwait idle routines
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 19 Nov 2013 12:31:53 +0100

People seem to delight in writing wrong and broken mwait idle routines;
collapse the lot.

This leaves mwait_play_dead() the sole remaining user of __mwait() and
new __mwait() users are probably doing it wrong.

Also remove __sti_mwait() as its unused.

Cc: arjan@linux.intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com
Cc: lenb@kernel.org
Cc: shaohua.li@intel.com
Cc: rui.zhang@intel.com
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/mwait.h       |   40 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h   |   23 ---------------------
 arch/x86/kernel/acpi/cstate.c      |   23 ---------------------
 drivers/acpi/acpi_pad.c            |    5 ----
 drivers/acpi/processor_idle.c      |   15 -------------
 drivers/idle/intel_idle.c          |    8 -------
 drivers/thermal/intel_powerclamp.c |    4 ---
 7 files changed, 43 insertions(+), 75 deletions(-)

--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_MWAIT_H
 #define _ASM_X86_MWAIT_H
 
+#include <linux/sched.h>
+
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
 #define MWAIT_SUBSTATE_SIZE		4
@@ -13,4 +15,42 @@
 
 #define MWAIT_ECX_INTERRUPT_BREAK	0x1
 
+static inline void __monitor(const void *eax, unsigned long ecx,
+			     unsigned long edx)
+{
+	/* "monitor %eax, %ecx, %edx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc8;"
+		     :: "a" (eax), "c" (ecx), "d"(edx));
+}
+
+static inline void __mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax, %ecx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+}
+
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
+{
+	if (!current_set_polling_and_test()) {
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		if (!need_resched())
+			__mwait(eax, ecx);
+	}
+	__current_clr_polling();
+}
+
 #endif /* _ASM_X86_MWAIT_H */
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -700,29 +700,6 @@ static inline void sync_core(void)
 #endif
 }
 
-static inline void __monitor(const void *eax, unsigned long ecx,
-			     unsigned long edx)
-{
-	/* "monitor %eax, %ecx, %edx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc8;"
-		     :: "a" (eax), "c" (ecx), "d"(edx));
-}
-
-static inline void __mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax, %ecx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
-
-static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
-{
-	trace_hardirqs_on();
-	/* "mwait %eax, %ecx;" */
-	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_amd_e400_c1e_mask(void);
 
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -150,29 +150,6 @@ int acpi_processor_ffh_cstate_probe(unsi
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-	if (!need_resched()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(ax, cx);
-	}
-}
-
 void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
 {
 	unsigned int cpu = smp_processor_id();
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -193,10 +193,7 @@ static int power_saving_thread(void *dat
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 			stop_critical_timings();
 
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			smp_mb();
-			if (!need_resched())
-				__mwait(power_saving_mwait_eax, 1);
+			mwait_idle_with_hints(power_saving_mwait_eax, 1);
 
 			start_critical_timings();
 			if (lapic_marked_unstable)
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -727,11 +727,6 @@ static int acpi_idle_enter_c1(struct cpu
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 
@@ -785,11 +780,6 @@ static int acpi_idle_enter_simple(struct
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	/*
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
@@ -841,11 +831,6 @@ static int acpi_idle_enter_bm(struct cpu
 		}
 	}
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	acpi_unlazy_tlb(smp_processor_id());
 
 	/* Tell the scheduler that we are going deep-idle: */
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -359,13 +359,7 @@ static int intel_idle(struct cpuidle_dev
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	if (!current_set_polling_and_test()) {
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(eax, ecx);
-	}
+	mwait_idle_with_hints(eax, ecx);
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -438,9 +438,7 @@ static int clamp_thread(void *arg)
 			 */
 			local_touch_nmi();
 			stop_critical_timings();
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			cpu_relax(); /* allow HT sibling to run */
-			__mwait(eax, ecx);
+			mwait_idle_with_hints(eax, ecx);
 			start_critical_timings();
 			atomic_inc(&idle_wakeup_counter);
 		}
