Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab3LDQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:18:32 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45972 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab3LDQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:18:30 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 14/19] smp, sh: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:05 +0800
Message-Id: <1386173591-28514-15-git-send-email-liuj97@gmail.com>
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
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/sh/include/asm/smp.h | 1 -
 arch/sh/kernel/smp.c      | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
index 78b0d0f4..93ce87b 100644
--- a/arch/sh/include/asm/smp.h
+++ b/arch/sh/include/asm/smp.h
@@ -25,7 +25,6 @@ extern int __cpu_logical_map[NR_CPUS];
 enum {
 	SMP_MSG_FUNCTION,
 	SMP_MSG_RESCHEDULE,
-	SMP_MSG_FUNCTION_SINGLE,
 	SMP_MSG_TIMER,
 
 	SMP_MSG_NR,	/* must be last */
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 86a7936..c944d5d 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -282,7 +282,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	mp_ops->send_ipi(cpu, SMP_MSG_FUNCTION_SINGLE);
+	mp_ops->send_ipi(cpu, SMP_MSG_FUNCTION);
 }
 
 void smp_timer_broadcast(const struct cpumask *mask)
@@ -309,9 +309,6 @@ void smp_message_recv(unsigned int msg)
 	case SMP_MSG_RESCHEDULE:
 		scheduler_ipi();
 		break;
-	case SMP_MSG_FUNCTION_SINGLE:
-		generic_smp_call_function_single_interrupt();
-		break;
 	case SMP_MSG_TIMER:
 		ipi_timer();
 		break;
-- 
1.8.1.2

