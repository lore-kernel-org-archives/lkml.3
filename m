Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3BDWu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:50:57 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:58232 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3BDWuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:50:55 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and trace
 irq handlers
Thread-Topic: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
Thread-Index: Ac4DKfj9nhV66AyvSzikmHjqFbN/2g==
Date: Mon, 4 Feb 2013 22:50:12 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C5B@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-04_16:2013-02-04,2013-02-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302040186
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

Currently, irq vector handlers for tracing are just
copied non-trace handlers by simply inserting tracepoints.

It is difficult to manage the codes.

[Solution]

This patch shares common codes between non-trace and trace handlers
as follows to make them manageable and readable.

Non-trace irq handler:
smp_irq_handler()
{
	entering_irq(); /* pre-processing of this handler */
	__smp_irq_handler(); /*
                          * common logic between non-trace and trace handlers
                          * in a vector.
                          */
	exiting_irq(); /* post-processing of this handler */

}

Trace irq_handler:
smp_trace_irq_handler()
{
	entering_irq(); /* pre-processing of this handler */
	trace_irq_entry(); /* tracepoint for irq entry */
	__smp_irq_handler(); /*
                          * common logic between non-trace and trace handlers
                          * in a vector.
                          */
	trace_irq_exit(); /* tracepoint for irq exit */
	exiting_irq(); /* post-processing of this handler */

}

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/apic.h              |   27 ++++++++
 arch/x86/kernel/apic/apic.c              |  103 ++++++++----------------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   24 +++----
 arch/x86/kernel/cpu/mcheck/threshold.c   |   24 +++----
 arch/x86/kernel/irq.c                    |   34 +++-------
 arch/x86/kernel/irq_work.c               |   22 ++++--
 arch/x86/kernel/smp.c                    |   54 ++++++++++------
 7 files changed, 137 insertions(+), 151 deletions(-)

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
index 89f3f4d..c146cbc 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -922,17 +922,14 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
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
@@ -944,19 +941,16 @@ void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
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
 	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
 	local_apic_timer_interrupt();
 	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
-	irq_exit();
+	exiting_irq();
 
 	set_irq_regs(old_regs);
 }
@@ -1935,12 +1929,10 @@ int __init APIC_init_uniprocessor(void)
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
@@ -1955,38 +1947,28 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
-	irq_exit();
 }
 
-void smp_trace_spurious_interrupt(struct pt_regs *regs)
+void smp_spurious_interrupt(struct pt_regs *regs)
 {
-	u32 v;
+	entering_irq();
+	__smp_spurious_interrupt();
+	exiting_irq();
+}
 
-	irq_enter();
-	exit_idle();
+void smp_trace_spurious_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
 	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
-	/*
-	 * Check if this really is a spurious interrupt and ACK it
-	 * if it is a vectored one.  Just in case...
-	 * Spurious interrupts should not be ACKed.
-	 */
-	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
-	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
-		ack_APIC_irq();
-
-	inc_irq_stat(irq_spurious_count);
-
-	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	pr_info("spurious APIC interrupt on CPU#%d, "
-		"should never happen.\n", smp_processor_id());
+	__smp_spurious_interrupt();
 	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
-	irq_exit();
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
@@ -2001,8 +1983,6 @@ void smp_error_interrupt(struct pt_regs *regs)
 		"Illegal register address",	/* APIC Error Bit 7 */
 	};
 
-	irq_enter();
-	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -2023,49 +2003,22 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
-	irq_exit();
 }
 
-void smp_trace_error_interrupt(struct pt_regs *regs)
+void smp_error_interrupt(struct pt_regs *regs)
 {
-	u32 v0, v1;
-	u32 i = 0;
-	static const char * const error_interrupt_reason[] = {
-		"Send CS error",		/* APIC Error Bit 0 */
-		"Receive CS error",		/* APIC Error Bit 1 */
-		"Send accept error",		/* APIC Error Bit 2 */
-		"Receive accept error",		/* APIC Error Bit 3 */
-		"Redirectable IPI",		/* APIC Error Bit 4 */
-		"Send illegal vector",		/* APIC Error Bit 5 */
-		"Received illegal vector",	/* APIC Error Bit 6 */
-		"Illegal register address",	/* APIC Error Bit 7 */
-	};
+	entering_irq();
+	__smp_error_interrupt(regs);
+	exiting_irq();
+}
 
-	irq_enter();
-	exit_idle();
+void smp_trace_error_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
 	trace_error_apic_entry(ERROR_APIC_VECTOR);
-	/* First tickle the hardware, only then report what went on. -- REW */
-	v0 = apic_read(APIC_ESR);
-	apic_write(APIC_ESR, 0);
-	v1 = apic_read(APIC_ESR);
-	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
-
-	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
-		    smp_processor_id(), v0 , v1);
-
-	v1 = v1 & 0xff;
-	while (v1) {
-		if (v1 & 0x1)
-			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
-		i++;
-		v1 >>= 1;
-	}
-
-	apic_printk(APIC_DEBUG, KERN_CONT "\n");
-
+	__smp_error_interrupt(regs);
 	trace_error_apic_exit(ERROR_APIC_VECTOR);
-	irq_exit();
+	exiting_irq();
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e7aa7fc..2f3a799 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -379,28 +379,26 @@ static void unexpected_thermal_interrupt(void)
 
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
 
 asmlinkage void smp_trace_thermal_interrupt(struct pt_regs *regs)
 {
-	irq_enter();
-	exit_idle();
+	entering_irq();
 	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
-	inc_irq_stat(irq_thermal_count);
-	smp_thermal_vector();
+	__smp_thermal_interrupt();
 	trace_thermal_apic_exit(THERMAL_APIC_VECTOR);
-	irq_exit();
-	/* Ack only at the end to avoid potential reentry */
-	ack_APIC_irq();
+	exiting_ack_irq();
 }
 
 /* Thermal monitoring depends on APIC, ACPI and clock modulation */
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index 0cbef99..fe6b1c8 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -18,26 +18,24 @@ static void default_threshold_interrupt(void)
 
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
 
 asmlinkage void smp_trace_threshold_interrupt(void)
 {
-	irq_enter();
-	exit_idle();
+	entering_irq();
 	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
-	inc_irq_stat(irq_threshold_count);
-	mce_threshold_vector();
+	__smp_threshold_interrupt();
 	trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR);
-	irq_exit();
-	/* Ack only at the end to avoid potential reentry */
-	ack_APIC_irq();
+	exiting_ack_irq();
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 216bec1..ae836cd 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -209,23 +209,21 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
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
 
@@ -233,21 +231,11 @@ void smp_trace_x86_platform_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	ack_APIC_irq();
-
-	irq_enter();
-
-	exit_idle();
-
+	entering_ack_irq();
 	trace_x86_platform_ipi_entry(X86_PLATFORM_IPI_VECTOR);
-	inc_irq_stat(x86_platform_ipis);
-
-	if (x86_platform_ipi_callback)
-		x86_platform_ipi_callback();
-
+	__smp_x86_platform_ipi();
 	trace_x86_platform_ipi_exit(X86_PLATFORM_IPI_VECTOR);
-	irq_exit();
-
+	exiting_irq();
 	set_irq_regs(old_regs);
 }
 
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 09e6262..636a55e 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -10,24 +10,32 @@
 #include <asm/apic.h>
 #include <asm/trace/irq_vectors.h>
 
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
 
 void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 {
-	irq_enter();
-	ack_APIC_irq();
+	irq_work_entering_irq();
 	trace_irq_work_entry(IRQ_WORK_VECTOR);
-	inc_irq_stat(apic_irq_work_irqs);
-	irq_work_run();
+	__smp_irq_work_interrupt();
 	trace_irq_work_exit(IRQ_WORK_VECTOR);
-	irq_exit();
+	exiting_irq();
 }
 
 void arch_irq_work_raise(void)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index aad58af..f4fe0b8 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -250,11 +250,16 @@ finish:
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
@@ -264,52 +269,61 @@ void smp_trace_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	trace_reschedule_entry(RESCHEDULE_VECTOR);
-	inc_irq_stat(irq_resched_count);
-	scheduler_ipi();
+	__smp_reschedule_interrupt();
 	trace_reschedule_exit(RESCHEDULE_VECTOR);
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
+}
+
+void smp_call_function_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	__smp_call_function_interrupt();
+	exiting_irq();
 }
 
 void smp_trace_call_function_interrupt(struct pt_regs *regs)
 {
-	ack_APIC_irq();
-	irq_enter();
+	call_function_entering_irq();
 	trace_call_function_entry(CALL_FUNCTION_VECTOR);
-	generic_smp_call_function_interrupt();
-	inc_irq_stat(irq_call_count);
+	__smp_call_function_interrupt();
 	trace_call_function_exit(CALL_FUNCTION_VECTOR);
-	irq_exit();
+	exiting_irq();
 }
 
-void smp_call_function_single_interrupt(struct pt_regs *regs)
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
 
 void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
 {
-	ack_APIC_irq();
-	irq_enter();
+	call_function_entering_irq();
 	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
-	generic_smp_call_function_single_interrupt();
-	inc_irq_stat(irq_call_count);
+	__smp_call_function_single_interrupt();
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
-	irq_exit();
+	exiting_irq();
 }
 
 static int __init nonmi_ipi_setup(char *str)
-- 1.7.1


