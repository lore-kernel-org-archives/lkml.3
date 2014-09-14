Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaINL7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 07:59:46 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52802 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaINL7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 07:59:31 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 3.17-rc4 v6 6/6] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Sun, 14 Sep 2014 12:57:15 +0100
Message-Id: <1410695835-10496-7-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org>
References: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous changes have introduced a replacement default FIQ handler and
an implementation of arch_trigger_all_cpu_backtrace for ARM but these
are currently independant.

This patch plumbs together these features making it possible, on platforms
that support it, to trigger backtrace using FIQ.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/smp.h | 3 +++
 arch/arm/kernel/fiq.c      | 8 ++++----
 arch/arm/kernel/smp.c      | 4 +++-
 arch/arm/kernel/traps.c    | 3 +++
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 2ec765c..0580270 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -18,6 +18,8 @@
 # error "<asm/smp.h> included in non-SMP build"
 #endif
 
+#define SMP_IPI_FIQ_MASK 0x0100
+
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 struct seq_file;
@@ -85,6 +87,7 @@ extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 extern void arch_send_wakeup_ipi_mask(const struct cpumask *mask);
 
+extern void ipi_cpu_backtrace(struct pt_regs *regs);
 extern int register_ipi_completion(struct completion *completion, int cpu);
 
 struct smp_operations {
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 1743049..b37752a 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -52,8 +52,8 @@
 		(unsigned)&vector_fiq_offset;		\
 	})
 
-static unsigned long no_fiq_insn;
-static struct pt_regs def_fiq_regs;
+static unsigned long dfl_fiq_insn;
+static struct pt_regs dfl_fiq_regs;
 
 /* Default reacquire function
  * - we always relinquish FIQ control
@@ -65,7 +65,7 @@ static int fiq_def_op(void *ref, int relinquish)
 		/* Restore default handler and registers */
 		local_fiq_disable();
 		set_fiq_regs(&dfl_fiq_regs);
-		set_fiq_handler(&no_fiq_insn, sizeof(no_fiq_insn));
+		set_fiq_handler(&dfl_fiq_insn, sizeof(dfl_fiq_insn));
 		local_fiq_enable();
 
 		/* FIXME: notify irq controller to standard enable FIQs */
@@ -158,7 +158,7 @@ EXPORT_SYMBOL(disable_fiq);
 void __init init_FIQ(int start)
 {
 	unsigned offset = FIQ_OFFSET;
-	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
+	dfl_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
 	get_fiq_regs(&dfl_fiq_regs);
 	fiq_start = start;
 }
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 94959f9..7a79d11 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -543,7 +543,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 		cpu_relax();
 }
 
-static void ipi_cpu_backtrace(struct pt_regs *regs)
+void ipi_cpu_backtrace(struct pt_regs *regs)
 {
 	int cpu = smp_processor_id();
 
@@ -584,6 +584,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	BUILD_BUG_ON(SMP_IPI_FIQ_MASK != BIT(IPI_CPU_BACKTRACE));
+
 	if ((unsigned)ipinr < NR_IPI) {
 		trace_ipi_entry(ipi_types[ipinr]);
 		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 92c4ea1..40b1de7 100644
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

