Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965902Ab3FUF6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:58:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602Ab3FUF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:58:02 -0400
Date: Thu, 20 Jun 2013 22:57:42 -0700
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-eddc0e922a3530e0f22cef170229bcae3a7d5e31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <51C3238D.9040706@hds.com>
References: <51C3238D.9040706@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86, trace: Introduce entering/exiting_irq()
Git-Commit-ID: eddc0e922a3530e0f22cef170229bcae3a7d5e31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 22:57:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eddc0e922a3530e0f22cef170229bcae3a7d5e31
Gitweb:     http://git.kernel.org/tip/eddc0e922a3530e0f22cef170229bcae3a7d5e31
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Thu, 20 Jun 2013 11:45:17 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 22:25:01 -0700

x86, trace: Introduce entering/exiting_irq()

When implementing tracepoints in interrupt handers, if the tracepoints are
simply added in the performance sensitive path of interrupt handers,
it may cause potential performance problem due to the time penalty.

To solve the problem, an idea is to prepare non-trace/trace irq handers and
switch their IDTs at the enabling/disabling time.

So, let's introduce entering_irq()/exiting_irq() for pre/post-
processing of each irq handler.

A way to use them is as follows.

Non-trace irq handler:
smp_irq_handler()
{
	entering_irq();		/* pre-processing of this handler */
	__smp_irq_handler();	/*
				 * common logic between non-trace and trace handlers
				 * in a vector.
				 */
	exiting_irq();		/* post-processing of this handler */

}

Trace irq_handler:
smp_trace_irq_handler()
{
	entering_irq();		/* pre-processing of this handler */
	trace_irq_entry();	/* tracepoint for irq entry */
	__smp_irq_handler();	/*
				 * common logic between non-trace and trace handlers
				 * in a vector.
				 */
	trace_irq_exit();	/* tracepoint for irq exit */
	exiting_irq();		/* post-processing of this handler */

}

If tracepoints can place outside entering_irq()/exiting_irq() as follows,
it looks cleaner.

smp_trace_irq_handler()
{
	trace_irq_entry();
	smp_irq_handler();
	trace_irq_exit();
}

But it doesn't work.
The problem is with irq_enter/exit() being called. They must be called before
trace_irq_enter/exit(),  because of the rcu_irq_enter() must be called before
any tracepoints are used, as tracepoints use  rcu to synchronize.

As a possible alternative, we may be able to call irq_enter() first as follows
if irq_enter() can nest.

smp_trace_irq_hander()
{
	irq_entry();
	trace_irq_entry();
	smp_irq_handler();
	trace_irq_exit();
	irq_exit();
}

But it doesn't work, either.
If irq_enter() is nested, it may have a time penalty because it has to check if it
was already called or not. The time penalty is not desired in performance sensitive
paths even if it is tiny.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/51C3238D.9040706@hds.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/apic.h              | 27 ++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c              | 33 +++++++++++++++++-------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c | 14 +++++++------
 arch/x86/kernel/cpu/mcheck/threshold.c   | 14 +++++++------
 arch/x86/kernel/irq.c                    | 18 ++++++++--------
 arch/x86/kernel/irq_work.c               | 14 +++++++++++--
 arch/x86/kernel/smp.c                    | 35 ++++++++++++++++++++++++--------
 7 files changed, 109 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3388034..f8119b5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -12,6 +12,7 @@
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/msr.h>
+#include <asm/idle.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -687,5 +688,31 @@ extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
 #endif /* CONFIG_X86_LOCAL_APIC */
+extern void irq_enter(void);
+extern void irq_exit(void);
+
+static inline void entering_irq(void)
+{
+	irq_enter();
+	exit_idle();
+}
+
+static inline void entering_ack_irq(void)
+{
+	ack_APIC_irq();
+	entering_irq();
+}
+
+static inline void exiting_irq(void)
+{
+	irq_exit();
+}
+
+static inline void exiting_ack_irq(void)
+{
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
 
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 904611b..59ee76f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -919,17 +919,14 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.
-	 */
-	ack_APIC_irq();
-	/*
+	 *
 	 * update_process_times() expects us to have done irq_enter().
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	irq_enter();
-	exit_idle();
+	entering_ack_irq();
 	local_apic_timer_interrupt();
-	irq_exit();
+	exiting_irq();
 
 	set_irq_regs(old_regs);
 }
@@ -1907,12 +1904,10 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-void smp_spurious_interrupt(struct pt_regs *regs)
+static inline void __smp_spurious_interrupt(void)
 {
 	u32 v;
 
-	irq_enter();
-	exit_idle();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1927,13 +1922,19 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
-	irq_exit();
+}
+
+void smp_spurious_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	__smp_spurious_interrupt();
+	exiting_irq();
 }
 
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-void smp_error_interrupt(struct pt_regs *regs)
+static inline void __smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v0, v1;
 	u32 i = 0;
@@ -1948,8 +1949,6 @@ void smp_error_interrupt(struct pt_regs *regs)
 		"Illegal register address",	/* APIC Error Bit 7 */
 	};
 
-	irq_enter();
-	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1970,7 +1969,13 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
-	irq_exit();
+}
+
+void smp_error_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	__smp_error_interrupt(regs);
+	exiting_irq();
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 47a1870..f6b35f2 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -378,15 +378,17 @@ static void unexpected_thermal_interrupt(void)
 
 static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
 
-asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+static inline void __smp_thermal_interrupt(void)
 {
-	irq_enter();
-	exit_idle();
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
-	irq_exit();
-	/* Ack only at the end to avoid potential reentry */
-	ack_APIC_irq();
+}
+
+asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	__smp_thermal_interrupt();
+	exiting_ack_irq();
 }
 
 /* Thermal monitoring depends on APIC, ACPI and clock modulation */
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index aa578ca..610cd98 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -17,13 +17,15 @@ static void default_threshold_interrupt(void)
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
 
-asmlinkage void smp_threshold_interrupt(void)
+static inline void __smp_threshold_interrupt(void)
 {
-	irq_enter();
-	exit_idle();
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
-	irq_exit();
-	/* Ack only at the end to avoid potential reentry */
-	ack_APIC_irq();
+}
+
+asmlinkage void smp_threshold_interrupt(void)
+{
+	entering_irq();
+	__smp_threshold_interrupt();
+	exiting_ack_irq();
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index ac0631d..e3b8df1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -204,23 +204,21 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 /*
  * Handler for X86_PLATFORM_IPI_VECTOR.
  */
-void smp_x86_platform_ipi(struct pt_regs *regs)
+void __smp_x86_platform_ipi(void)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	ack_APIC_irq();
-
-	irq_enter();
-
-	exit_idle();
-
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
+}
 
-	irq_exit();
+void smp_x86_platform_ipi(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	entering_ack_irq();
+	__smp_x86_platform_ipi();
+	exiting_irq();
 	set_irq_regs(old_regs);
 }
 
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..074d46f 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -9,13 +9,23 @@
 #include <linux/hardirq.h>
 #include <asm/apic.h>
 
-void smp_irq_work_interrupt(struct pt_regs *regs)
+static inline void irq_work_entering_irq(void)
 {
 	irq_enter();
 	ack_APIC_irq();
+}
+
+static inline void __smp_irq_work_interrupt(void)
+{
 	inc_irq_stat(apic_irq_work_irqs);
 	irq_work_run();
-	irq_exit();
+}
+
+void smp_irq_work_interrupt(struct pt_regs *regs)
+{
+	irq_work_entering_irq();
+	__smp_irq_work_interrupt();
+	exiting_irq();
 }
 
 void arch_irq_work_raise(void)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..d858375 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -249,32 +249,51 @@ finish:
 /*
  * Reschedule call back.
  */
-void smp_reschedule_interrupt(struct pt_regs *regs)
+static inline void __smp_reschedule_interrupt(void)
 {
-	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
 	scheduler_ipi();
+}
+
+void smp_reschedule_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	__smp_reschedule_interrupt();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
 }
 
-void smp_call_function_interrupt(struct pt_regs *regs)
+static inline void call_function_entering_irq(void)
 {
 	ack_APIC_irq();
 	irq_enter();
+}
+
+static inline void __smp_call_function_interrupt(void)
+{
 	generic_smp_call_function_interrupt();
 	inc_irq_stat(irq_call_count);
-	irq_exit();
 }
 
-void smp_call_function_single_interrupt(struct pt_regs *regs)
+void smp_call_function_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	__smp_call_function_interrupt();
+	exiting_irq();
+}
+
+static inline void __smp_call_function_single_interrupt(void)
 {
-	ack_APIC_irq();
-	irq_enter();
 	generic_smp_call_function_single_interrupt();
 	inc_irq_stat(irq_call_count);
-	irq_exit();
+}
+
+void smp_call_function_single_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	__smp_call_function_single_interrupt();
+	exiting_irq();
 }
 
 static int __init nonmi_ipi_setup(char *str)
