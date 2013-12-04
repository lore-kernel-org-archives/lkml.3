Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3LDQPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:15:40 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64577 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab3LDQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:15:36 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Javi Merino <javi.merino@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH v3 05/19] smp, ARM64: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:12:56 +0800
Message-Id: <1386173591-28514-6-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one intterupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/hardirq.h |  2 +-
 arch/arm64/kernel/smp.c          | 10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index 990c051..3be64c8 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -20,7 +20,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	4
+#define NR_IPI	3
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index a0c2ca6..ea3e9ab 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -59,7 +59,6 @@ struct secondary_data secondary_data;
 enum ipi_msg_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
@@ -438,14 +437,13 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 static const char *ipi_types[NR_IPI] = {
 #define S(x,s)	[x - IPI_RESCHEDULE] = s
 	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
 	S(IPI_CALL_FUNC, "Function call interrupts"),
-	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
 };
 
@@ -520,12 +518,6 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
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
1.8.1.2

