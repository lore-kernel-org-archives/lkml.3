Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbaHHOhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:37:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33154 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756978AbaHHOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:37:12 -0400
Message-Id: <20140808143710.343996554@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 08 Aug 2014 10:32:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 4/4] ARM64: add IPI tracepoints
References: <20140808143254.145903999@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ARM64-add-IPI-tracepoints.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

The strings used to list IPIs in /proc/interrupts are reused for tracing
purposes.

While at it, the code is slightly cleaned up so the ipi_types array
indices are no longer offset by IPI_RESCHEDULE whose value is 0 anyway.

Link: http://lkml.kernel.org/p/1406318733-26754-5-git-send-email-nicolas.pitre@linaro.org

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm64/kernel/smp.c | 65 +++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 40f38f46c8e0..a89c66f3b4c5 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -50,6 +50,9 @@
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ipi.h>
+
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
@@ -307,8 +310,6 @@ void __init smp_prepare_boot_cpu(void)
 	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
 }
 
-static void (*smp_cross_call)(const struct cpumask *, unsigned int);
-
 /*
  * Enumerate the possible CPU set from the device tree and build the
  * cpu logical map array containing MPIDR values related to logical
@@ -463,32 +464,15 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
+static void (*__smp_cross_call)(const struct cpumask *, unsigned int);
 
 void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 {
-	smp_cross_call = fn;
+	__smp_cross_call = fn;
 }
 
-void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-{
-	smp_cross_call(mask, IPI_CALL_FUNC);
-}
-
-void arch_send_call_function_single_ipi(int cpu)
-{
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
-}
-
-#ifdef CONFIG_IRQ_WORK
-void arch_irq_work_raise(void)
-{
-	if (smp_cross_call)
-		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
-}
-#endif
-
-static const char *ipi_types[NR_IPI] = {
-#define S(x,s)	[x - IPI_RESCHEDULE] = s
+static const char *ipi_types[NR_IPI] __tracepoint_string = {
+#define S(x,s)	[x] = s
 	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
 	S(IPI_CALL_FUNC, "Function call interrupts"),
 	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
@@ -497,12 +481,18 @@ static const char *ipi_types[NR_IPI] = {
 	S(IPI_IRQ_WORK, "IRQ work interrupts"),
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
 
 	for (i = 0; i < NR_IPI; i++) {
-		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i + IPI_RESCHEDULE,
+		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i,
 			   prec >= 4 ? " " : "");
 		for_each_online_cpu(cpu)
 			seq_printf(p, "%10u ",
@@ -522,6 +512,24 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
 	return sum;
 }
 
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	smp_cross_call(mask, IPI_CALL_FUNC);
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
+	if (__smp_cross_call)
+		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
+}
+#endif
+
 static DEFINE_RAW_SPINLOCK(stop_lock);
 
 /*
@@ -553,8 +561,10 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	if (ipinr >= IPI_RESCHEDULE && ipinr < IPI_RESCHEDULE + NR_IPI)
-		__inc_irq_stat(cpu, ipi_irqs[ipinr - IPI_RESCHEDULE]);
+	if ((unsigned)ipinr < NR_IPI) {
+		trace_ipi_entry(ipi_types[ipinr]);
+		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
+	}
 
 	switch (ipinr) {
 	case IPI_RESCHEDULE:
@@ -599,6 +609,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		pr_crit("CPU%u: Unknown IPI message 0x%x\n", cpu, ipinr);
 		break;
 	}
+
+	if ((unsigned)ipinr < NR_IPI)
+		trace_ipi_exit(ipi_types[ipinr]);
 	set_irq_regs(old_regs);
 }
 
-- 
2.0.1


