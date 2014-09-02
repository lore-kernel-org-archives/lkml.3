Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaIBNB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:01:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37170 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaIBNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:01:26 -0400
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
Subject: [PATCH v11 04/19] arm: smp: Introduce a special IPI signalled using FIQ
Date: Tue,  2 Sep 2014 14:00:38 +0100
Message-Id: <1409662853-29313-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
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
 arch/arm/include/asm/smp.h     |  7 +++++++
 arch/arm/kernel/smp.c          | 15 +++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

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
index 2ec765c..215c927 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -20,6 +20,9 @@
 
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
+/* bitmap of IPIs that must be signalled using FIQ */
+#define SMP_IPI_FIQ_MASK 0x0100
+
 struct seq_file;
 
 /*
@@ -87,6 +90,10 @@ extern void arch_send_wakeup_ipi_mask(const struct cpumask *mask);
 
 extern int register_ipi_completion(struct completion *completion, int cpu);
 
+#ifdef CONFIG_FIQ
+extern void send_fiq_ipi_mask(const struct cpumask *);
+#endif
+
 struct smp_operations {
 #ifdef CONFIG_SMP
 	/*
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9388a3d..d386c32 100644
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
@@ -552,6 +554,13 @@ static void ipi_complete(unsigned int cpu)
 	complete(per_cpu(cpu_completion, cpu));
 }
 
+#ifdef CONFIG_FIQ
+void send_fiq_ipi_mask(const struct cpumask *mask)
+{
+	smp_cross_call(mask, IPI_FIQ);
+}
+#endif
+
 /*
  * Main handler for inter-processor interrupts
  */
@@ -618,6 +627,12 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
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

