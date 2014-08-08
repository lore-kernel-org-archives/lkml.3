Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbaHHOhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:37:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54149 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751321AbaHHOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:37:12 -0400
Message-Id: <20140808143710.208630679@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 08 Aug 2014 10:32:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3/4] ARM: add IPI tracepoints
References: <20140808143254.145903999@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ARM-add-IPI-tracepoints.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

The strings used to list IPIs in /proc/interrupts are reused for tracing
purposes.

While at it, prevent a negative ipinr from escaping the range check
in handle_IPI().

Link: http://lkml.kernel.org/p/1406318733-26754-4-git-send-email-nicolas.pitre@linaro.org

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/smp.c | 70 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 7c4fada440f0..9388a3d479e1 100644
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
 
-- 
2.0.1


