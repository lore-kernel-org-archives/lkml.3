Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbbAWFeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:34:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:44071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbbAWFeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:34:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444041862"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [Resend Patch v4 02/16] smp, ARM: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:41 +0800
Message-Id: <1421991416-20297-3-git-send-email-jiang.liu@linux.intel.com>
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

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/arm/include/asm/hardirq.h |    2 +-
 arch/arm/kernel/smp.c          |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index fe3ea776dc34..3d7351c844aa 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	8
+#define NR_IPI	7
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 86ef244c5a24..2bab642eb0b1 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -68,7 +68,6 @@ enum ipi_msg_type {
 	IPI_TIMER,
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 	IPI_IRQ_WORK,
 	IPI_COMPLETION,
@@ -452,7 +451,6 @@ static const char *ipi_types[NR_IPI] __tracepoint_string = {
 	S(IPI_TIMER, "Timer broadcast interrupts"),
 	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
 	S(IPI_CALL_FUNC, "Function call interrupts"),
-	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
 	S(IPI_IRQ_WORK, "IRQ work interrupts"),
 	S(IPI_COMPLETION, "completion interrupts"),
@@ -502,7 +500,7 @@ void arch_send_wakeup_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 #ifdef CONFIG_IRQ_WORK
@@ -597,12 +595,6 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
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

