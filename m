Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbbAWFed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:34:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:16257 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbbAWFe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:34:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444041895"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Brown <broonie@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [Resend Patch v4 03/16] smp, ARM64: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:42 +0800
Message-Id: <1421991416-20297-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/hardirq.h |    2 +-
 arch/arm64/kernel/smp.c          |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index e8a3268a891c..6aae421f4d73 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -20,7 +20,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	6
+#define NR_IPI	5
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 7ae6ee085261..328b8ce4b007 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -65,7 +65,6 @@ struct secondary_data secondary_data;
 enum ipi_msg_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 	IPI_TIMER,
 	IPI_IRQ_WORK,
@@ -483,7 +482,6 @@ static const char *ipi_types[NR_IPI] __tracepoint_string = {
 #define S(x,s)	[x] = s
 	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
 	S(IPI_CALL_FUNC, "Function call interrupts"),
-	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
 	S(IPI_TIMER, "Timer broadcast interrupts"),
 	S(IPI_IRQ_WORK, "IRQ work interrupts"),
@@ -527,7 +525,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 #ifdef CONFIG_IRQ_WORK
@@ -585,12 +583,6 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		irq_exit();
 		break;
 
-	case IPI_CALL_FUNC_SINGLE:
-		irq_enter();
-		generic_smp_call_function_single_interrupt();
-		irq_exit();
-		break;
-
 	case IPI_CPU_STOP:
 		irq_enter();
 		ipi_cpu_stop(cpu);
-- 
1.7.10.4

