Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaHNLQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:16:06 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35651 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaHNLQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:16:04 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [RFC PATCH 1/3] arm: smp: Introduce a special IPI signalled using FIQ
Date: Thu, 14 Aug 2014 12:15:49 +0100
Message-Id: <1408014951-24820-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408014951-24820-1-git-send-email-daniel.thompson@linaro.org>
References: <53EC9404.5010908@linaro.org>
 <1408014951-24820-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cross CPU signalling based on FIQ is especially useful for kgdb since
it makes stopping all the CPUs during breakpointing more robust (some
of the other architectures already roundup the CPUs using NMIs).

The approach taken provides infrastructure that can be called (or not) by
the driver's FIQ handler depending upon it requirements. In other words
nothing is added here that prevents the driver from accessing "bare metal"
performance.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/hardirq.h |  2 +-
 arch/arm/include/asm/smp.h     | 11 +++++++++++
 arch/arm/kernel/smp.c          | 44 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index fe3ea77..5df33e3 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	8
+#define NR_IPI	9
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 2ec765c..6a969f8 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -20,6 +20,9 @@
 
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
+/* bitmap of IPIs that must be signalled using FIQ */
+#define SMP_IPI_FIQ_MASK 0x0100
+
 struct seq_file;
 
 /*
@@ -87,6 +90,14 @@ extern void arch_send_wakeup_ipi_mask(const struct cpumask *mask);
 
 extern int register_ipi_completion(struct completion *completion, int cpu);
 
+#ifdef CONFIG_FIQ
+extern void send_fiq_ipi_mask(const struct cpumask *);
+extern int __init register_fiq_ipi_notifier(struct notifier_block *nb);
+void handle_IPI_FIQ(struct pt_regs *regs);
+#else
+#define register_fiq_ipi_notifier(nb)
+#endif
+
 struct smp_operations {
 #ifdef CONFIG_SMP
 	/*
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9388a3d..71557bc 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -72,6 +72,7 @@ enum ipi_msg_type {
 	IPI_CPU_STOP,
 	IPI_IRQ_WORK,
 	IPI_COMPLETION,
+	IPI_FIQ,
 };
 
 static DECLARE_COMPLETION(cpu_running);
@@ -451,6 +452,7 @@ static const char *ipi_types[NR_IPI] __tracepoint_string = {
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
 	S(IPI_IRQ_WORK, "IRQ work interrupts"),
 	S(IPI_COMPLETION, "completion interrupts"),
+	S(IPI_FIQ, "FIQ interrupts"),
 };
 
 static void smp_cross_call(const struct cpumask *target, unsigned int ipinr)
@@ -552,6 +554,42 @@ static void ipi_complete(unsigned int cpu)
 	complete(per_cpu(cpu_completion, cpu));
 }
 
+#ifdef CONFIG_FIQ
+static ATOMIC_NOTIFIER_HEAD(fiq_ipi_chain);
+
+/*
+ * Caller must ensure a FIQ handler that can clear the IPI is installed
+ * before calling this function. This is normally achieved by calling
+ * handle_IPI_FIQ() from the FIQ handler.
+ */
+void send_fiq_ipi_mask(const struct cpumask *mask)
+{
+	smp_cross_call(mask, IPI_FIQ);
+}
+
+int __init register_fiq_ipi_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&fiq_ipi_chain, nb);
+}
+
+void handle_IPI_FIQ(struct pt_regs *regs)
+{
+	unsigned int cpu = smp_processor_id();
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	/* Make sure the FIQ mask matches our assumptions */
+	BUILD_BUG_ON(SMP_IPI_FIQ_MASK ^ (1 << IPI_FIQ));
+
+	__inc_irq_stat(cpu, ipi_irqs[IPI_FIQ]);
+
+	nmi_enter();
+	atomic_notifier_call_chain(&fiq_ipi_chain, IPI_FIQ, NULL);
+	nmi_exit();
+
+	set_irq_regs(old_regs);
+}
+#endif
+
 /*
  * Main handler for inter-processor interrupts
  */
@@ -618,6 +656,12 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		irq_exit();
 		break;
 
+#ifdef CONFIG_FIQ
+	case IPI_FIQ:
+		pr_crit("CPU%u: IPI FIQ delivered via IRQ vector\n", cpu);
+		break;
+#endif
+
 	default:
 		printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%x\n",
 		       cpu, ipinr);
-- 
1.9.3

