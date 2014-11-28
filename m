Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaK1QR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:17:28 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45931 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaK1QQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:16:59 -0500
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
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 3.18-rc4 v12 5/5] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Fri, 28 Nov 2014 16:16:14 +0000
Message-Id: <1417191374-26719-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417191374-26719-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1417191374-26719-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous changes have introduced both a replacement default FIQ handler
and an implementation of arch_trigger_all_cpu_backtrace for ARM but
these are currently independent of each other.

This patch plumbs together these features making it possible, on platforms
that support it, to trigger backtrace using FIQ.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/smp.h | 3 +++
 arch/arm/kernel/smp.c      | 4 +++-
 arch/arm/kernel/traps.c    | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

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
index 14c594a12bef..e923843562d9 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -539,7 +539,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 		cpu_relax();
 }
 
-static void ipi_cpu_backtrace(struct pt_regs *regs)
+void ipi_cpu_backtrace(struct pt_regs *regs)
 {
 	int cpu = smp_processor_id();
 
@@ -580,6 +580,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	BUILD_BUG_ON(SMP_IPI_FIQ_MASK != BIT(IPI_CPU_BACKTRACE));
+
 	if ((unsigned)ipinr < NR_IPI) {
 		trace_ipi_entry(ipi_types[ipinr]);
 		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 4dc45b38e56e..9eb05be9526e 100644
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

