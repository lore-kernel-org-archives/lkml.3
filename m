Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbaGWWSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:18:38 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:54032 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbaGWWSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:18:36 -0400
Date: Wed, 23 Jul 2014 18:18:34 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
In-Reply-To: <1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
Message-ID: <alpine.LFD.2.11.1407231807070.6061@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org> <1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@Russell: Can I have your ACK on this patch before I send the series 
upstream?  Here's the revised version accounting for the changes the 
discussion in this thread brought about

Author: Nicolas Pitre <nicolas.pitre@linaro.org>
Date:   Fri Jul 18 00:07:05 2014 -0400

    ARM: add IPI tracepoints
    
    The strings used to list IPIs in /proc/interrupts are reused for tracing
    purposes.
    
    While at it, prevent a negative ipinr from escaping the range check
    in handle_IPI().
    
    Signed-off-by: Nicolas Pitre <nico@linaro.org>
    Acked-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 7c4fada440..9388a3d479 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -47,6 +47,9 @@
 #include <asm/mach/arch.h>
 #include <asm/mpu.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ipi.h>
+
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
@@ -430,38 +433,15 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-static void (*smp_cross_call)(const struct cpumask *, unsigned int);
+static void (*__smp_cross_call)(const struct cpumask *, unsigned int);
 
 void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 {
-	if (!smp_cross_call)
-		smp_cross_call = fn;
-}
-
-void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-{
-	smp_cross_call(mask, IPI_CALL_FUNC);
-}
-
-void arch_send_wakeup_ipi_mask(const struct cpumask *mask)
-{
-	smp_cross_call(mask, IPI_WAKEUP);
-}
-
-void arch_send_call_function_single_ipi(int cpu)
-{
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	if (!__smp_cross_call)
+		__smp_cross_call = fn;
 }
 
-#ifdef CONFIG_IRQ_WORK
-void arch_irq_work_raise(void)
-{
-	if (is_smp())
-		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
-}
-#endif
-
-static const char *ipi_types[NR_IPI] = {
+static const char *ipi_types[NR_IPI] __tracepoint_string = {
 #define S(x,s)	[x] = s
 	S(IPI_WAKEUP, "CPU wakeup interrupts"),
 	S(IPI_TIMER, "Timer broadcast interrupts"),
@@ -473,6 +453,12 @@ static const char *ipi_types[NR_IPI] = {
 	S(IPI_COMPLETION, "completion interrupts"),
 };
 
+static void smp_cross_call(const struct cpumask *target, unsigned int ipinr)
+{
+	trace_ipi_raise(target, ipi_types[ipinr]);
+	__smp_cross_call(target, ipinr);
+}
+
 void show_ipi_list(struct seq_file *p, int prec)
 {
 	unsigned int cpu, i;
@@ -499,6 +485,29 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
 	return sum;
 }
 
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	smp_cross_call(mask, IPI_CALL_FUNC);
+}
+
+void arch_send_wakeup_ipi_mask(const struct cpumask *mask)
+{
+	smp_cross_call(mask, IPI_WAKEUP);
+}
+
+void arch_send_call_function_single_ipi(int cpu)
+{
+	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+}
+
+#ifdef CONFIG_IRQ_WORK
+void arch_irq_work_raise(void)
+{
+	if (is_smp())
+		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
+}
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 void tick_broadcast(const struct cpumask *mask)
 {
@@ -556,8 +565,10 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	if (ipinr < NR_IPI)
+	if ((unsigned)ipinr < NR_IPI) {
+		trace_ipi_entry(ipi_types[ipinr]);
 		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
+	}
 
 	switch (ipinr) {
 	case IPI_WAKEUP:
@@ -612,6 +623,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		       cpu, ipinr);
 		break;
 	}
+
+	if ((unsigned)ipinr < NR_IPI)
+		trace_ipi_exit(ipi_types[ipinr]);
 	set_irq_regs(old_regs);
 }
 
