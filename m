Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbbAMK1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:27:43 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:37829 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbAMK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:27:37 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.19-rc2 v14 6/7] ARM: Add support for on-demand backtrace of other CPUs
Date: Tue, 13 Jan 2015 10:26:57 +0000
Message-Id: <1421144818-14036-7-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144818-14036-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1421144818-14036-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duplicate the x86 code to trigger a backtrace using an NMI and hook
it up to IPI on ARM. Where it is possible for the hardware to do so the
IPI will be delivered at FIQ level.

Also provide are a few small items of plumbing to hook up the new code.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/Kconfig               |  1 +
 arch/arm/include/asm/hardirq.h |  2 +-
 arch/arm/include/asm/irq.h     |  5 +++
 arch/arm/include/asm/smp.h     |  3 ++
 arch/arm/kernel/smp.c          | 71 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/traps.c        |  3 ++
 6 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97d07ed60a0b..91d62731b52d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -11,6 +11,7 @@ config ARM
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_WANT_NMI_PRINTK
 	select BUILDTIME_EXTABLE_SORT if MMU
 	select CLONE_BACKWARDS
 	select CPU_PM if (SUSPEND || CPU_IDLE)
diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index fe3ea776dc34..5df33e30ae1b 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	8
+#define NR_IPI	9
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm/include/asm/irq.h b/arch/arm/include/asm/irq.h
index 53c15dec7af6..be1d07d59ee9 100644
--- a/arch/arm/include/asm/irq.h
+++ b/arch/arm/include/asm/irq.h
@@ -35,6 +35,11 @@ extern void (*handle_arch_irq)(struct pt_regs *);
 extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
 #endif
 
+#ifdef CONFIG_SMP
+extern void arch_trigger_all_cpu_backtrace(bool);
+#define arch_trigger_all_cpu_backtrace(x) arch_trigger_all_cpu_backtrace(x)
+#endif
+
 #endif
 
 #endif
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 18f5a554134f..b076584ac0fa 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -18,6 +18,8 @@
 # error "<asm/smp.h> included in non-SMP build"
 #endif
 
+#define SMP_IPI_FIQ_MASK 0x0100
+
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 struct seq_file;
@@ -79,6 +81,7 @@ extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 extern void arch_send_wakeup_ipi_mask(const struct cpumask *mask);
 
+extern void ipi_cpu_backtrace(struct pt_regs *regs);
 extern int register_ipi_completion(struct completion *completion, int cpu);
 
 struct smp_operations {
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 5e6052e18850..afb094a1e6d4 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -26,6 +26,7 @@
 #include <linux/completion.h>
 #include <linux/cpufreq.h>
 #include <linux/irq_work.h>
+#include <linux/seq_buf.h>
 
 #include <linux/atomic.h>
 #include <asm/smp.h>
@@ -72,6 +73,7 @@ enum ipi_msg_type {
 	IPI_CPU_STOP,
 	IPI_IRQ_WORK,
 	IPI_COMPLETION,
+	IPI_CPU_BACKTRACE,
 };
 
 static DECLARE_COMPLETION(cpu_running);
@@ -444,6 +446,7 @@ static const char *ipi_types[NR_IPI] __tracepoint_string = {
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
 	S(IPI_IRQ_WORK, "IRQ work interrupts"),
 	S(IPI_COMPLETION, "completion interrupts"),
+	S(IPI_CPU_BACKTRACE, "backtrace interrupts"),
 };
 
 static void smp_cross_call(const struct cpumask *target, unsigned int ipinr)
@@ -558,6 +561,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	BUILD_BUG_ON(SMP_IPI_FIQ_MASK != BIT(IPI_CPU_BACKTRACE));
+
 	if ((unsigned)ipinr < NR_IPI) {
 		trace_ipi_entry(ipi_types[ipinr]);
 		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
@@ -611,6 +616,12 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		irq_exit();
 		break;
 
+	case IPI_CPU_BACKTRACE:
+		irq_enter();
+		ipi_cpu_backtrace(regs);
+		irq_exit();
+		break;
+
 	default:
 		pr_crit("CPU%u: Unknown IPI message 0x%x\n",
 		        cpu, ipinr);
@@ -705,3 +716,63 @@ static int __init register_cpufreq_notifier(void)
 core_initcall(register_cpufreq_notifier);
 
 #endif
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+static  cpumask_t printtrace_mask;
+
+void arch_trigger_all_cpu_backtrace(bool include_self)
+{
+	struct nmi_seq_buf *s;
+	int len;
+	int cpu;
+	int i;
+	int this_cpu = get_cpu();
+
+	if (0 != prepare_nmi_printk(to_cpumask(backtrace_mask))) {
+		/*
+		 * If there is already an nmi printk sequence in
+		 * progress then just give up...
+		 */
+		put_cpu();
+		return;
+	}
+
+	if (!include_self)
+		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
+	cpumask_copy(&printtrace_mask, to_cpumask(backtrace_mask));
+
+	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+		pr_info("Sending FIQ to %s CPUs:\n",
+			(include_self ? "all" : "other"));
+		smp_cross_call(to_cpumask(backtrace_mask), IPI_CPU_BACKTRACE);
+	}
+
+	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
+	for (i = 0; i < 10 * 1000; i++) {
+		if (cpumask_empty(to_cpumask(backtrace_mask)))
+			break;
+		mdelay(1);
+		touch_softlockup_watchdog();
+	}
+
+	complete_nmi_printk(&printtrace_mask);
+	put_cpu();
+}
+
+void ipi_cpu_backtrace(struct pt_regs *regs)
+{
+	int cpu;
+	printk_func_t orig;
+
+	cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		orig = this_cpu_begin_nmi_printk();
+		pr_warn("FIQ backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		this_cpu_end_nmi_printk(orig);
+
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+	}
+}
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b35e220ae1b1..1836415b8a5c 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -483,6 +483,9 @@ asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
 #ifdef CONFIG_ARM_GIC
 	gic_handle_fiq_ipi();
 #endif
+#ifdef CONFIG_SMP
+	ipi_cpu_backtrace(regs);
+#endif
 
 	nmi_exit();
 
-- 
1.9.3

