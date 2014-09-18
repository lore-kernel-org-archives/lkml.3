Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaIRBuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:50:51 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:47742 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaIRBut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:50:49 -0400
Date: Wed, 17 Sep 2014 21:50:46 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] X86: add IPI tracepoints
Message-ID: <alpine.LFD.2.11.1409172135250.8647@knanqh.ubzr>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On X86 there are already tracepoints for IRQ vectors through which IPIs
are handled.  However this is highly X86 specific, and the IPI signaling
is not currently traced.

This is an attempt at adding generic IPI tracepoints to X86.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---

This is a resent.  This patch was part of a larger series that got 
merged during the last merge window.

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index be8e1bde07..d193609bea 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -31,6 +31,16 @@
 #include <asm/apic.h>
 #include <asm/nmi.h>
 #include <asm/trace/irq_vectors.h>
+
+#define CREATE_TRACE_POINTS
+/*
+ * Those were defined in <asm/trace/irq_vectors.h> and cause problems
+ * when including <trace/events/ipi.h>.
+ */
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#include <trace/events/ipi.h>
+
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -124,11 +134,13 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
+	trace_ipi_raise(cpumask_of(cpu), tracepoint_string("RESCHEDULE"));
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
+	trace_ipi_raise(cpumask_of(cpu), tracepoint_string("CALL_FUNCTION_SINGLE"));
 	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
@@ -136,6 +148,8 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 {
 	cpumask_var_t allbutself;
 
+	trace_ipi_raise(mask, tracepoint_string("CALL_FUNCTION"));
+
 	if (!alloc_cpumask_var(&allbutself, GFP_ATOMIC)) {
 		apic->send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 		return;
@@ -252,8 +266,10 @@ finish:
  */
 static inline void __smp_reschedule_interrupt(void)
 {
+	trace_ipi_entry(tracepoint_string("RESCHEDULE"));
 	inc_irq_stat(irq_resched_count);
 	scheduler_ipi();
+	trace_ipi_exit(tracepoint_string("RESCHEDULE"));
 }
 
 __visible void smp_reschedule_interrupt(struct pt_regs *regs)
@@ -291,8 +307,10 @@ __visible void smp_trace_reschedule_interrupt(struct pt_regs *regs)
 
 static inline void __smp_call_function_interrupt(void)
 {
+	trace_ipi_entry(tracepoint_string("CALL_FUNCTION"));
 	generic_smp_call_function_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_ipi_exit(tracepoint_string("CALL_FUNCTION"));
 }
 
 __visible void smp_call_function_interrupt(struct pt_regs *regs)
@@ -313,8 +331,10 @@ __visible void smp_trace_call_function_interrupt(struct pt_regs *regs)
 
 static inline void __smp_call_function_single_interrupt(void)
 {
+	trace_ipi_entry(tracepoint_string("CALL_FUNCTION_SINGLE"));
 	generic_smp_call_function_single_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_ipi_exit(tracepoint_string("CALL_FUNCTION_SINGLE"));
 }
 
 __visible void smp_call_function_single_interrupt(struct pt_regs *regs)
