Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3LSUKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:10:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3LSUKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:10:16 -0500
Date: Thu, 19 Dec 2013 12:09:24 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-16824255394f55adf31b9a96a9965d8c15bdac4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        arjan@linux.intel.com, rui.zhang@intel.com, peterz@infradead.org,
        bitbucket@online.de, rafael.j.wysocki@intel.com, lenb@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, peterz@infradead.org, rui.zhang@intel.com,
        bitbucket@online.de, rafael.j.wysocki@intel.com, lenb@kernel.org,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <20131212141654.616820819@infradead.org>
References: <20131212141654.616820819@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/idle] x86, acpi, idle:
  Restructure the mwait idle routines
Git-Commit-ID: 16824255394f55adf31b9a96a9965d8c15bdac4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 19 Dec 2013 12:09:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16824255394f55adf31b9a96a9965d8c15bdac4c
Gitweb:     http://git.kernel.org/tip/16824255394f55adf31b9a96a9965d8c15bdac4c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 12 Dec 2013 15:08:36 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Dec 2013 11:54:44 -0800

x86, acpi, idle: Restructure the mwait idle routines

People seem to delight in writing wrong and broken mwait idle routines;
collapse the lot.

This leaves mwait_play_dead() the sole remaining user of __mwait() and
new __mwait() users are probably doing it wrong.

Also remove __sti_mwait() as its unused.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Jun Pan <jacob.jun.pan@linux.intel.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Acked-by: Rafael Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131212141654.616820819@infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/mwait.h       | 40 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h   | 23 ----------------------
 arch/x86/kernel/acpi/cstate.c      | 23 ----------------------
 drivers/acpi/acpi_pad.c            |  5 +----
 drivers/acpi/processor_idle.c      | 15 --------------
 drivers/idle/intel_idle.c          | 11 +----------
 drivers/thermal/intel_powerclamp.c |  4 +---
 7 files changed, 43 insertions(+), 78 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 2f366d0..361b02e 100644
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
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..24821f5 100644
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
 
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index d2b7f27..e69182f 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -150,29 +150,6 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
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
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index fc6008f..509452a 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -193,10 +193,7 @@ static int power_saving_thread(void *data)
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 			stop_critical_timings();
 
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			smp_mb();
-			if (!need_resched())
-				__mwait(power_saving_mwait_eax, 1);
+			mwait_idle_with_hints(power_saving_mwait_eax, 1);
 
 			start_critical_timings();
 			if (lapic_marked_unstable)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 644516d..f90c56c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -727,11 +727,6 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 
@@ -785,11 +780,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
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
@@ -841,11 +831,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		}
 	}
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	acpi_unlazy_tlb(smp_processor_id());
 
 	/* Tell the scheduler that we are going deep-idle: */
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f80b700..efec405 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -375,16 +375,7 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	if (!current_set_polling_and_test()) {
-
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(eax, ecx);
-	}
+	mwait_idle_with_hints(eax, ecx);
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 8f181b3..e8275f2 100644
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
