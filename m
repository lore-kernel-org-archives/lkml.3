Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab3LDQRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:17:18 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60082 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787Ab3LDQRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:17:14 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 10/19] smp, metag: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:01 +0800
Message-Id: <1386173591-28514-11-git-send-email-liuj97@gmail.com>
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
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/metag/include/asm/smp.h | 2 --
 arch/metag/kernel/smp.c      | 6 +-----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/metag/include/asm/smp.h b/arch/metag/include/asm/smp.h
index e0373f8..1d7e770 100644
--- a/arch/metag/include/asm/smp.h
+++ b/arch/metag/include/asm/smp.h
@@ -7,13 +7,11 @@
 
 enum ipi_msg_type {
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_RESCHEDULE,
 };
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 asmlinkage void secondary_start_kernel(void);
 
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 7c01131..5b3933b4 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -491,7 +491,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 void show_ipi_list(struct seq_file *p)
@@ -546,10 +546,6 @@ static int do_IPI(struct pt_regs *regs)
 			generic_smp_call_function_interrupt();
 			break;
 
-		case IPI_CALL_FUNC_SINGLE:
-			generic_smp_call_function_single_interrupt();
-			break;
-
 		default:
 			pr_crit("CPU%u: Unknown IPI message 0x%lx\n",
 				cpu, nextmsg);
-- 
1.8.1.2

