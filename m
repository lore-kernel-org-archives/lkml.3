Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaK0ULS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:11:18 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40060 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaK0ULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:11:14 -0500
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
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.18-rc4 v11 5/6] ARM: add basic support for on-demand backtrace of other CPUs
Date: Thu, 27 Nov 2014 20:10:23 +0000
Message-Id: <1417119024-22844-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic infrastructure for triggering a backtrace of other CPUs
via an IPI, preferably at FIQ level.  It is intended that this shall
be used for cases where we have detected that something has already
failed in the kernel.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/irq.h |  5 ++++
 arch/arm/kernel/smp.c      | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

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
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 13396d3d600e..14c594a12bef 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -72,8 +72,12 @@ enum ipi_msg_type {
 	IPI_CPU_STOP,
 	IPI_IRQ_WORK,
 	IPI_COMPLETION,
+	IPI_CPU_BACKTRACE,
 };
 
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+
 static DECLARE_COMPLETION(cpu_running);
 
 static struct smp_operations smp_ops;
@@ -535,6 +539,21 @@ static void ipi_cpu_stop(unsigned int cpu)
 		cpu_relax();
 }
 
+static void ipi_cpu_backtrace(struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+
+		arch_spin_lock(&lock);
+		printk(KERN_WARNING "FIQ backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		arch_spin_unlock(&lock);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+	}
+}
+
 static DEFINE_PER_CPU(struct completion *, cpu_completion);
 
 int register_ipi_completion(struct completion *completion, int cpu)
@@ -614,6 +633,12 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		irq_exit();
 		break;
 
+	case IPI_CPU_BACKTRACE:
+		irq_enter();
+		ipi_cpu_backtrace(regs);
+		irq_exit();
+		break;
+
 	default:
 		printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%x\n",
 		       cpu, ipinr);
@@ -708,3 +733,40 @@ static int __init register_cpufreq_notifier(void)
 core_initcall(register_cpufreq_notifier);
 
 #endif
+
+void arch_trigger_all_cpu_backtrace(bool include_self)
+{
+	static unsigned long backtrace_flag;
+	int i, cpu = get_cpu();
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
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
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
+
+		mdelay(1);
+	}
+
+	clear_bit(0, &backtrace_flag);
+	smp_mb__after_atomic();
+	put_cpu();
+}
-- 
1.9.3

