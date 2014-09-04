Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaIDQEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:04:12 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:54113 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaIDQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:04:09 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v1 6/6] arm: Implement arch_trigger_all_cpu_backtrace
Date: Thu,  4 Sep 2014 17:03:40 +0100
Message-Id: <1409846620-14542-7-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org>
References: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
 <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <linux@arm.linux.org.uk>

Currently arm does not implement arch_trigger_all_cpu_backtrace because,
on SMP systems, there has never before been a means to route a
non-maskable interrupt to the other CPUs in the system. With the
introduction of IPI FIQ this is no longer the case. This patch
provides an implementation of arch_trigger_all_cpu_backtrace and
the associated KConfig machinary to enable it.

This is mostly Russell's code but since it was shared as an example rather
than a fully fledged patch currently this code is currently
Not-yet-signed-off-by: Russell King <linux@arm.linux.org.uk>

[Fill in headers and Kconfig, checkpatch.pl substitutions: CONFIG_NR_CPUS
for NR_CPUS and pr_warn() for printk(KERN_WARNING, )]
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/Kconfig.debug     | 14 +++++++++++
 arch/arm/include/asm/irq.h |  5 ++++
 arch/arm/include/asm/smp.h |  4 ++++
 arch/arm/kernel/smp.c      | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/traps.c    |  3 +++
 5 files changed, 86 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b11ad54..2fa932d 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1281,4 +1281,18 @@ config DEBUG_SET_MODULE_RONX
 	  against certain classes of kernel exploits.
 	  If in doubt, say "N".
 
+config ARM_BACKTRACE_TRIGGERING
+	bool "Support non-maskable backtrace triggering"
+	depends on SMP
+	select FIQ
+	help
+	  Say Y here if you want to provide support for non-maskable
+	  backtrace triggering. This is used to generate a backtrace
+	  from all CPUs in a non-responsive system. Backtrace requests
+	  can be issued by lockup and hung task detectors, spin lock
+	  debugging or magic sysrq.
+
+	  This option is only effective when the kernel is run on a
+	  platform capable of generating FIQs.
+
 endmenu
diff --git a/arch/arm/include/asm/irq.h b/arch/arm/include/asm/irq.h
index 53c15de..a5cc2ed 100644
--- a/arch/arm/include/asm/irq.h
+++ b/arch/arm/include/asm/irq.h
@@ -35,6 +35,11 @@ extern void (*handle_arch_irq)(struct pt_regs *);
 extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
 #endif
 
+#ifdef CONFIG_ARM_BACKTRACE_TRIGGERING
+void arch_trigger_all_cpu_backtrace(bool);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+#endif
+
 #endif
 
 #endif
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 0e23384..d20bd95 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -90,6 +90,10 @@ extern void arch_send_wakeup_ipi_mask(const struct cpumask *mask);
 
 extern int register_ipi_completion(struct completion *completion, int cpu);
 
+#ifdef CONFIG_ARM_BACKTRACE_TRIGGERING
+extern void ipi_cpu_backtrace(struct pt_regs *regs);
+#endif
+
 struct smp_operations {
 #ifdef CONFIG_SMP
 	/*
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index b2404d0..d1765a6 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -554,6 +554,63 @@ static void ipi_complete(unsigned int cpu)
 	complete(per_cpu(cpu_completion, cpu));
 }
 
+#ifdef CONFIG_ARM_BACKTRACE_TRIGGERING
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, CONFIG_NR_CPUS) __read_mostly;
+
+void ipi_cpu_backtrace(struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+
+		arch_spin_lock(&lock);
+		pr_warn("FIQ backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		arch_spin_unlock(&lock);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+	}
+}
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
+		smp_cross_call(to_cpumask(backtrace_mask), IPI_FIQ);
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
+#endif
+
 /*
  * Main handler for inter-processor interrupts
  */
@@ -623,6 +680,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	case IPI_FIQ:
 		BUILD_BUG_ON(SMP_IPI_FIQ_MASK != BIT(IPI_FIQ));
 		pr_warn("CPU%u: IPI FIQ delivered via IRQ vector\n", cpu);
+#ifdef CONFIG_ARM_BACKTRACE_TRIGGERING
+		ipi_cpu_backtrace(regs);
+#endif
 		break;
 
 	default:
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 2c219c7..b7e1e85 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -484,6 +484,9 @@ asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
 #ifdef CONFIG_ARM_GIC
 	gic_handle_fiq_ipi();
 #endif
+#ifdef CONFIG_ARM_BACKTRACE_TRIGGERING
+	ipi_cpu_backtrace(regs);
+#endif
 
 	nmi_exit();
 
-- 
1.9.3

