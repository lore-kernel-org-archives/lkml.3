Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3KGJBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:01:37 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55454 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3KGJBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:01:30 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, shaojie.sun@linaro.org,
        broonie@linaro.org
Subject: [PATCH V3] ARM: trace: Add tracepoint for the Inter Processor Interrupt
Date: Thu,  7 Nov 2013 10:01:27 +0100
Message-Id: <1383814887-15415-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Inter Processor Interrupt is used on ARM to tell another processor to do
a specific action. This is mainly used to emulate a timer interrupt on an idle
cpu, force a cpu to reschedule or run a function on another processor context.

Add a tracepoint when raising an IPI and in the entry/exit handler functions.

When a cpu raises an IPI, the targeted cpus is an interesting information, the
cpumask conversion in hexa is added in the trace using the cpumask_scnprintf
function.

Tested-on Vexpress TC2 (5 processors).
Tested-on u8500 (2 processors).

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/include/asm/smp.h   |    9 ++++
 arch/arm/kernel/smp.c        |   34 +++++++------
 arch/arm64/include/asm/smp.h |    7 +++
 arch/arm64/kernel/smp.c      |   21 ++++++--
 include/trace/events/ipi.h   |  112 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 164 insertions(+), 19 deletions(-)
 create mode 100644 include/trace/events/ipi.h

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index a8cae71c..788706c 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -18,6 +18,15 @@
 # error "<asm/smp.h> included in non-SMP build"
 #endif
 
+enum ipi_msg_type {
+	IPI_WAKEUP,
+	IPI_TIMER,
+	IPI_RESCHEDULE,
+	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
+	IPI_CPU_STOP,
+};
+
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 struct seq_file;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 72024ea..9ca8ce8 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -46,6 +46,9 @@
 #include <asm/mach/arch.h>
 #include <asm/mpu.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ipi.h>
+
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
@@ -59,15 +62,6 @@ struct secondary_data secondary_data;
  */
 volatile int pen_release = -1;
 
-enum ipi_msg_type {
-	IPI_WAKEUP,
-	IPI_TIMER,
-	IPI_RESCHEDULE,
-	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
-	IPI_CPU_STOP,
-};
-
 static DECLARE_COMPLETION(cpu_running);
 
 static struct smp_operations smp_ops;
@@ -433,19 +427,25 @@ void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 		smp_cross_call = fn;
 }
 
+static void ipi_raise(const struct cpumask *mask, int ipinr)
+{
+	trace_ipi_raise(mask, ipinr);
+	smp_cross_call(mask, ipinr);
+}
+
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
-	smp_cross_call(mask, IPI_CALL_FUNC);
+	ipi_raise(mask, IPI_CALL_FUNC);
 }
 
 void arch_send_wakeup_ipi_mask(const struct cpumask *mask)
 {
-	smp_cross_call(mask, IPI_WAKEUP);
+	ipi_raise(mask, IPI_WAKEUP);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	ipi_raise(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
 static const char *ipi_types[NR_IPI] = {
@@ -487,7 +487,7 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 void tick_broadcast(const struct cpumask *mask)
 {
-	smp_cross_call(mask, IPI_TIMER);
+	ipi_raise(mask, IPI_TIMER);
 }
 #endif
 
@@ -528,6 +528,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	trace_ipi_handler_entry(ipinr);
+
 	if (ipinr < NR_IPI)
 		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
 
@@ -571,11 +573,13 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		break;
 	}
 	set_irq_regs(old_regs);
+
+	trace_ipi_handler_exit(ipinr);
 }
 
 void smp_send_reschedule(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_RESCHEDULE);
+	ipi_raise(cpumask_of(cpu), IPI_RESCHEDULE);
 }
 
 void smp_send_stop(void)
@@ -586,7 +590,7 @@ void smp_send_stop(void)
 	cpumask_copy(&mask, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
 	if (!cpumask_empty(&mask))
-		smp_cross_call(&mask, IPI_CPU_STOP);
+		ipi_raise(&mask, IPI_CPU_STOP);
 
 	/* Wait up to one second for other CPUs to stop */
 	timeout = USEC_PER_SEC;
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 4b8023c..7ebaa3a 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -24,6 +24,13 @@
 # error "<asm/smp.h> included in non-SMP build"
 #endif
 
+enum ipi_msg_type {
+	IPI_RESCHEDULE,
+	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
+	IPI_CPU_STOP,
+};
+
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 struct seq_file;
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 78db90d..c987b9f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -48,6 +48,9 @@
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ipi.h>
+
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
@@ -426,14 +429,20 @@ void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 	smp_cross_call = fn;
 }
 
+static void ipi_raise(const struct cpumask *mask, int ipinr)
+{
+	trace_ipi_raise(mask, ipinr);
+	smp_cross_call(mask, ipinr);
+}
+
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
-	smp_cross_call(mask, IPI_CALL_FUNC);
+	ipi_raise(mask, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	ipi_raise(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
 static const char *ipi_types[NR_IPI] = {
@@ -501,6 +510,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	trace_ipi_handler_entry(ipinr);
+
 	if (ipinr >= IPI_RESCHEDULE && ipinr < IPI_RESCHEDULE + NR_IPI)
 		__inc_irq_stat(cpu, ipi_irqs[ipinr - IPI_RESCHEDULE]);
 
@@ -532,11 +543,13 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		break;
 	}
 	set_irq_regs(old_regs);
+
+	trace_ipi_handler_exit(ipinr);
 }
 
 void smp_send_reschedule(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_RESCHEDULE);
+	ipi_raise(cpumask_of(cpu), IPI_RESCHEDULE);
 }
 
 void smp_send_stop(void)
@@ -549,7 +562,7 @@ void smp_send_stop(void)
 		cpumask_copy(&mask, cpu_online_mask);
 		cpu_clear(smp_processor_id(), mask);
 
-		smp_cross_call(&mask, IPI_CPU_STOP);
+		ipi_raise(&mask, IPI_CPU_STOP);
 	}
 
 	/* Wait up to one second for other CPUs to stop */
diff --git a/include/trace/events/ipi.h b/include/trace/events/ipi.h
new file mode 100644
index 0000000..fa22d4f
--- /dev/null
+++ b/include/trace/events/ipi.h
@@ -0,0 +1,112 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ipi
+
+#if !defined(_TRACE_IPI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IPI_H
+
+#include <linux/tracepoint.h>
+
+#define ipi_name(ipinr) { IPI_##ipinr, #ipinr }
+#define show_ipi_name(val)				\
+	__print_symbolic(val,				\
+			 ipi_name(WAKEUP),		\
+			 ipi_name(TIMER),		\
+			 ipi_name(RESCHEDULE),		\
+			 ipi_name(CALL_FUNC),		\
+			 ipi_name(CALL_FUNC_SINGLE),	\
+			 ipi_name(CPU_STOP))
+
+#define show_cpumask(srcp)				\
+	({						\
+		char *buf = __get_dynamic_array(buf);	\
+		cpumask_scnprintf(buf, NR_CPUS, srcp);	\
+		buf;					\
+	})
+
+DECLARE_EVENT_CLASS(ipi,
+
+    TP_PROTO(int ipinr),
+
+    TP_ARGS(ipinr),
+
+    TP_STRUCT__entry(
+	    __field(int, ipinr)
+    ),
+
+    TP_fast_assign(
+	    __entry->ipinr = ipinr;
+    ),
+
+    TP_printk("ipi=%d, name=%s", __entry->ipinr,
+	      show_ipi_name(__entry->ipinr))
+);
+
+/**
+ * ipi_handle_entry - called right before the IPI handler
+ * @ipinr: the IPI number
+ *
+ * The @ipinr value must be valid and the action name associated with
+ * the IPI value is given in the trace.
+ */
+DEFINE_EVENT_CONDITION(ipi, ipi_handler_entry,
+
+    TP_PROTO(int ipinr),
+
+    TP_ARGS(ipinr),
+
+    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0)
+);
+
+/**
+ * ipi_handle_exit - called right after the IPI handler
+ * @ipinr: the IPI number
+ *
+ * The @ipinr value must be valid and the action name associated with
+ * the IPI value is given in the trace.
+ */
+DEFINE_EVENT_CONDITION(ipi, ipi_handler_exit,
+
+    TP_PROTO(int ipinr),
+
+    TP_ARGS(ipinr),
+
+    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0)
+);
+
+/**
+ * ipi_raise - called when a smp cross call is made
+ * @ipinr: the IPI number
+ * @cpumask: the recipients for the IPI
+ *
+ * The @ipinr value must be valid and the action name associated with
+ * the IPI value is given in the trace as well as the cpumask of the
+ * targeted cpus.
+ */
+TRACE_EVENT_CONDITION(ipi_raise,
+
+    TP_PROTO(const struct cpumask *cpumask, int ipinr),
+
+    TP_ARGS(cpumask, ipinr),
+
+    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0),
+
+    TP_STRUCT__entry(
+	    __field(int, ipinr)
+	    __field(const struct cpumask *, cpumask)
+	    __dynamic_array(char, buf, NR_CPUS)
+    ),
+
+    TP_fast_assign(
+	    __entry->ipinr = ipinr;
+	    __entry->cpumask = cpumask;
+    ),
+
+    TP_printk("ipi=%d, cpumask=0x%s, name=%s", __entry->ipinr,
+	      show_cpumask(__entry->cpumask),
+	      show_ipi_name(__entry->ipinr))
+);
+
+#endif /* _TRACE_IPI_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

