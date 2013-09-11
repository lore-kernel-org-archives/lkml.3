Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3IKQJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:09:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54208 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3IKQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:08:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 06/25] smp, blackfin: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:10 +0800
Message-Id: <1378915649-16395-7-git-send-email-liuj97@gmail.com>
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
 arch/blackfin/mach-common/smp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 82f301c..463f432 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -53,7 +53,6 @@ enum ipi_message_type {
 	BFIN_IPI_TIMER,
 	BFIN_IPI_RESCHEDULE,
 	BFIN_IPI_CALL_FUNC,
-	BFIN_IPI_CALL_FUNC_SINGLE,
 	BFIN_IPI_CPU_STOP,
 };
 
@@ -162,10 +161,6 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 				generic_smp_call_function_interrupt();
 				break;
 
-			case BFIN_IPI_CALL_FUNC_SINGLE:
-				generic_smp_call_function_single_interrupt();
-				break;
-
 			case BFIN_IPI_CPU_STOP:
 				ipi_cpu_stop(cpu);
 				break;
@@ -206,7 +201,7 @@ void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi(cpumask_of(cpu), BFIN_IPI_CALL_FUNC_SINGLE);
+	send_ipi(cpumask_of(cpu), BFIN_IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-- 
1.8.1.2

