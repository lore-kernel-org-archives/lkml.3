Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab3LDQQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:16:50 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39607 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3LDQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:16:48 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 09/19] smp, m32r: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:00 +0800
Message-Id: <1386173591-28514-10-git-send-email-liuj97@gmail.com>
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
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org
Cc: linux-m32r-ja@ml.linux-m32r.org
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/m32r/include/asm/smp.h | 1 -
 arch/m32r/kernel/smp.c      | 9 +--------
 arch/m32r/kernel/traps.c    | 3 +--
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/m32r/include/asm/smp.h b/arch/m32r/include/asm/smp.h
index c689b82..3a502d4 100644
--- a/arch/m32r/include/asm/smp.h
+++ b/arch/m32r/include/asm/smp.h
@@ -98,7 +98,6 @@ extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 #define LOCAL_TIMER_IPI		(M32R_IRQ_IPI3-M32R_IRQ_IPI0)
 #define INVALIDATE_CACHE_IPI	(M32R_IRQ_IPI4-M32R_IRQ_IPI0)
 #define CPU_BOOT_IPI		(M32R_IRQ_IPI5-M32R_IRQ_IPI0)
-#define CALL_FUNC_SINGLE_IPI	(M32R_IRQ_IPI6-M32R_IRQ_IPI0)
 
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index ce7aea3..c6d0bb9 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -542,7 +542,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_SINGLE_IPI, 0);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_IPI, 0);
 }
 
 /*==========================================================================*
@@ -569,13 +569,6 @@ void smp_call_function_interrupt(void)
 	irq_exit();
 }
 
-void smp_call_function_single_interrupt(void)
-{
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	irq_exit();
-}
-
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Timer Routines                                                            */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index a7a424f..f5d911d 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -39,7 +39,6 @@ extern void smp_invalidate_interrupt(void);
 extern void smp_call_function_interrupt(void);
 extern void smp_ipi_timer_interrupt(void);
 extern void smp_flush_cache_all_interrupt(void);
-extern void smp_call_function_single_interrupt(void);
 
 /*
  * for Boot AP function
@@ -104,7 +103,7 @@ static void set_eit_vector_entries(void)
 	eit_vector[187] = (unsigned long)smp_ipi_timer_interrupt;
 	eit_vector[188] = (unsigned long)smp_flush_cache_all_interrupt;
 	eit_vector[189] = 0;	/* CPU_BOOT_IPI */
-	eit_vector[190] = (unsigned long)smp_call_function_single_interrupt;
+	eit_vector[190] = 0;
 	eit_vector[191] = 0;
 #endif
 	_flush_cache_copyback_all();
-- 
1.8.1.2

