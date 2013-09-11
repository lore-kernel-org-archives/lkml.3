Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3IKQJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:09:38 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59159 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3IKQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:09:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 10/25] smp, metag: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:14 +0800
Message-Id: <1378915649-16395-11-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
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

