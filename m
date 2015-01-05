Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbbAEOzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:55:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52865 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbAEOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:55:17 -0500
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
Subject: [PATCH 3.19-rc2 v13 4/5] ARM: Add support for on-demand backtrace of other CPUs
Date: Mon,  5 Jan 2015 14:54:58 +0000
Message-Id: <1420469699-25350-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duplicate the x86 code to trigger a backtrace using an NMI and hook
it up to IPI on ARM. Where it is possible for the hardware to do so the
IPI will be delivered at FIQ level.

Also provide are a few small items of plumbing to hook up the new code.

Note that the code copied from x86 has been deliberately modified as
little as possible (to make extracting out the common code easier in
future).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/hardirq.h |   2 +-
 arch/arm/include/asm/irq.h     |   5 ++
 arch/arm/include/asm/smp.h     |   3 +
 arch/arm/kernel/smp.c          | 151 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/traps.c        |   3 +
 5 files changed, 163 insertions(+), 1 deletion(-)

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
index 5e6052e18850..12667eb68198 100644
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
@@ -705,3 +716,143 @@ static int __init register_cpufreq_notifier(void)
 core_initcall(register_cpufreq_notifier);
 
 #endif
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+static  cpumask_t printtrace_mask;
+
+#define NMI_BUF_SIZE		4096
+
+struct nmi_seq_buf {
+	unsigned char		buffer[NMI_BUF_SIZE];
+	struct seq_buf		seq;
+};
+
+/* Safe printing in NMI context */
+static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
+
+/* "in progress" flag of arch_trigger_all_cpu_backtrace */
+static unsigned long backtrace_flag;
+
+/*
+ * It is not safe to call printk() directly from NMI handlers.
+ * It may be fine if the NMI detected a lock up and we have no choice
+ * but to do so, but doing a NMI on all other CPUs to get a back trace
+ * can be done with a sysrq-l. We don't want that to lock up, which
+ * can happen if the NMI interrupts a printk in progress.
+ *
+ * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
+ * the content into a per cpu seq_buf buffer. Then when the NMIs are
+ * all done, we can safely dump the contents of the seq_buf to a printk()
+ * from a non NMI context.
+ */
+static int nmi_vprintk(const char *fmt, va_list args)
+{
+	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
+	unsigned int len = seq_buf_used(&s->seq);
+
+	seq_buf_vprintf(&s->seq, fmt, args);
+	return seq_buf_used(&s->seq) - len;
+}
+
+void ipi_cpu_backtrace(struct pt_regs *regs)
+{
+	int cpu;
+
+	cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		printk_func_t printk_func_save = this_cpu_read(printk_func);
+
+		/* Replace printk to write into the NMI seq */
+		this_cpu_write(printk_func, nmi_vprintk);
+		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		this_cpu_write(printk_func, printk_func_save);
+
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+	}
+}
+
+static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
+{
+	const char *buf = s->buffer + start;
+
+	printk("%.*s", (end - start) + 1, buf);
+}
+
+void arch_trigger_all_cpu_backtrace(bool include_self)
+{
+	struct nmi_seq_buf *s;
+	int len;
+	int cpu;
+	int i;
+	int this_cpu = get_cpu();
+
+	if (test_and_set_bit(0, &backtrace_flag)) {
+		/*
+		 * If there is already a trigger_all_cpu_backtrace() in progress
+		 * (backtrace_flag == 1), don't output double cpu dump infos.
+		 */
+		put_cpu();
+		return;
+	}
+
+	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
+	if (!include_self)
+		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
+
+	cpumask_copy(&printtrace_mask, to_cpumask(backtrace_mask));
+	/*
+	 * Set up per_cpu seq_buf buffers that the NMIs running on the other
+	 * CPUs will write to.
+	 */
+	for_each_cpu(cpu, to_cpumask(backtrace_mask)) {
+		s = &per_cpu(nmi_print_seq, cpu);
+		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
+	}
+
+	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+		pr_info("Sending NMI to %s CPUs:\n",
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
+	/*
+	 * Now that all the NMIs have triggered, we can dump out their
+	 * back traces safely to the console.
+	 */
+	for_each_cpu(cpu, &printtrace_mask) {
+		int last_i = 0;
+
+		s = &per_cpu(nmi_print_seq, cpu);
+		len = seq_buf_used(&s->seq);
+		if (!len)
+			continue;
+
+		/* Print line by line. */
+		for (i = 0; i < len; i++) {
+			if (s->buffer[i] == '\n') {
+				print_seq_line(s, last_i, i);
+				last_i = i + 1;
+			}
+		}
+		/* Check if there was a partial line. */
+		if (last_i < len) {
+			print_seq_line(s, last_i, len - 1);
+			pr_cont("\n");
+		}
+	}
+
+	clear_bit(0, &backtrace_flag);
+	smp_mb__after_atomic();
+	put_cpu();
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

