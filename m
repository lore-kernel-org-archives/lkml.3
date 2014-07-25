Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935302AbaGYUH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:07:57 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13726 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935250AbaGYUHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:07:37 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 4/5] ARM64: add IPI tracepoints
Date: Fri, 25 Jul 2014 16:05:32 -0400
Message-id: <1406318733-26754-5-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The strings used to list IPIs in /proc/interrupts are reused for tracing
purposes.

While at it, the code is slightly cleaned up so the ipi_types array
indices are no longer offset by IPI_RESCHEDULE whose value is 0 anyway.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/smp.c | 65 +++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 40f38f46c8..a89c66f3b4 100644
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
1.8.4.108.g55ea5f6

