Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3HaFRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:17:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3HaFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:06 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_L7ybCg9nkwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=TSmBbVhw9CAA:10 a=oGMlB6cnAAAA:8 a=DuDAYCGPSkso0xDyukYA:9 a=jeBq3FmKZ4MA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051703.080790826@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 16/18 v2] rcu/irq/x86: Mark functions that are RCU unsafe
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0016-rcu-irq-x86-Mark-functions-that-are-RCU-unsafe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Some callbacks of the function tracer use rcu_read_lock(). This means that
there's places that can not be traced because RCU is not tracking the CPU
for various reasons (like NO_HZ_FULL and coming back from userspace).

Thes functions need to be marked so that callbacks that use RCU do not
trace them.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/apic/apic.c |    2 ++
 arch/x86/kernel/irq.c       |    1 +
 arch/x86/kernel/irq_work.c  |    3 +++
 arch/x86/kernel/smp.c       |    8 ++++++++
 kernel/softirq.c            |    2 ++
 5 files changed, 16 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index eca89c5..91af16b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -931,6 +931,7 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 
 	set_irq_regs(old_regs);
 }
+FTRACE_UNSAFE_RCU(smp_apic_timer_interrupt);
 
 void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
 {
@@ -952,6 +953,7 @@ void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
 
 	set_irq_regs(old_regs);
 }
+FTRACE_UNSAFE_RCU(smp_trace_apic_timer_interrupt);
 
 int setup_profiling_timer(unsigned int multiplier)
 {
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3a8185c..fccd0d1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -203,6 +203,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 	return 1;
 }
+FTRACE_UNSAFE_RCU(do_IRQ);
 
 /*
  * Handler for X86_PLATFORM_IPI_VECTOR.
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 636a55e..a2199c2 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
+#include <linux/ftrace.h>
 #include <asm/apic.h>
 #include <asm/trace/irq_vectors.h>
 
@@ -28,6 +29,7 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
 	__smp_irq_work_interrupt();
 	exiting_irq();
 }
+FTRACE_UNSAFE_RCU(smp_irq_work_interrupt);
 
 void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 {
@@ -37,6 +39,7 @@ void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 	trace_irq_work_exit(IRQ_WORK_VECTOR);
 	exiting_irq();
 }
+FTRACE_UNSAFE_RCU(smp_trace_irq_work_interrupt);
 
 void arch_irq_work_raise(void)
 {
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index cdaa347..3d702ef 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/ftrace.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -175,6 +176,7 @@ asmlinkage void smp_reboot_interrupt(void)
 	stop_this_cpu(NULL);
 	irq_exit();
 }
+FTRACE_UNSAFE_RCU(smp_reboot_interrupt);
 
 static void native_stop_other_cpus(int wait)
 {
@@ -264,6 +266,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
 }
+FTRACE_UNSAFE_RCU(smp_reschedule_interrupt);
 
 static inline void smp_entering_irq(void)
 {
@@ -288,6 +291,7 @@ void smp_trace_reschedule_interrupt(struct pt_regs *regs)
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
 }
+FTRACE_UNSAFE_RCU(smp_trace_reschedule_interrupt);
 
 static inline void __smp_call_function_interrupt(void)
 {
@@ -301,6 +305,7 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	__smp_call_function_interrupt();
 	exiting_irq();
 }
+FTRACE_UNSAFE_RCU(smp_call_function_interrupt);
 
 void smp_trace_call_function_interrupt(struct pt_regs *regs)
 {
@@ -310,6 +315,7 @@ void smp_trace_call_function_interrupt(struct pt_regs *regs)
 	trace_call_function_exit(CALL_FUNCTION_VECTOR);
 	exiting_irq();
 }
+FTRACE_UNSAFE_RCU(smp_trace_call_function_interrupt);
 
 static inline void __smp_call_function_single_interrupt(void)
 {
@@ -323,6 +329,7 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	__smp_call_function_single_interrupt();
 	exiting_irq();
 }
+FTRACE_UNSAFE_RCU(smp_call_function_single_interrupt);
 
 void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
 {
@@ -332,6 +339,7 @@ void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
 	exiting_irq();
 }
+FTRACE_UNSAFE_RCU(smp_trace_call_function_single_interrupt);
 
 static int __init nonmi_ipi_setup(char *str)
 {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index be3d351..7960e70 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -325,6 +325,7 @@ void irq_enter(void)
 
 	__irq_enter();
 }
+FTRACE_UNSAFE_RCU(irq_enter);
 
 static inline void invoke_softirq(void)
 {
@@ -367,6 +368,7 @@ void irq_exit(void)
 	tick_irq_exit();
 	rcu_irq_exit();
 }
+FTRACE_UNSAFE_RCU(irq_exit);
 
 /*
  * This function must run with irqs disabled!
-- 
1.7.10.4


