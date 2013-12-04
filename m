Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab3LDQQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:16:10 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44351 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3LDQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:16:07 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 07/19] smp, hexagon: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:12:58 +0800
Message-Id: <1386173591-28514-8-git-send-email-liuj97@gmail.com>
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
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/hexagon/include/asm/smp.h | 1 -
 arch/hexagon/kernel/smp.c      | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/hexagon/include/asm/smp.h b/arch/hexagon/include/asm/smp.h
index 2b9b974..ca171c1 100644
--- a/arch/hexagon/include/asm/smp.h
+++ b/arch/hexagon/include/asm/smp.h
@@ -29,7 +29,6 @@ enum ipi_message_type {
 	IPI_NOP = 0,
 	IPI_RESCHEDULE = 1,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 	IPI_TIMER,
 };
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 9faaa94..ff759f2 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -64,10 +64,6 @@ static inline void __handle_ipi(unsigned long *ops, struct ipi_data *ipi,
 			generic_smp_call_function_interrupt();
 			break;
 
-		case IPI_CALL_FUNC_SINGLE:
-			generic_smp_call_function_single_interrupt();
-			break;
-
 		case IPI_CPU_STOP:
 			/*
 			 * call vmstop()
@@ -248,7 +244,7 @@ void smp_send_stop(void)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	send_ipi(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-- 
1.8.1.2

