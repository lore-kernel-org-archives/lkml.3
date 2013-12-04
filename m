Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3LDQPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:15:54 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44319 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3LDQPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:15:51 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Steven Miao <realmz6@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 06/19] smp, blackfin: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:12:57 +0800
Message-Id: <1386173591-28514-7-git-send-email-liuj97@gmail.com>
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
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/blackfin/mach-common/smp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 2bbae07..ba6c30d 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -53,7 +53,6 @@ enum ipi_message_type {
 	BFIN_IPI_TIMER,
 	BFIN_IPI_RESCHEDULE,
 	BFIN_IPI_CALL_FUNC,
-	BFIN_IPI_CALL_FUNC_SINGLE,
 	BFIN_IPI_CPU_STOP,
 };
 
@@ -162,9 +161,6 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 			case BFIN_IPI_CALL_FUNC:
 				generic_smp_call_function_interrupt();
 				break;
-			case BFIN_IPI_CALL_FUNC_SINGLE:
-				generic_smp_call_function_single_interrupt();
-				break;
 			case BFIN_IPI_CPU_STOP:
 				ipi_cpu_stop(cpu);
 				break;
@@ -210,7 +206,7 @@ void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi(cpumask_of(cpu), BFIN_IPI_CALL_FUNC_SINGLE);
+	send_ipi(cpumask_of(cpu), BFIN_IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-- 
1.8.1.2

