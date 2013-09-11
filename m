Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3IKQKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:10:05 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60720 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3IKQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:10:00 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 14/25] smp, parisc: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:18 +0800
Message-Id: <1378915649-16395-15-git-send-email-liuj97@gmail.com>
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
 arch/parisc/kernel/smp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 8a252f2..2b96602 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -72,7 +72,6 @@ enum ipi_message_type {
 	IPI_NOP=0,
 	IPI_RESCHEDULE=1,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_START,
 	IPI_CPU_STOP,
 	IPI_CPU_TEST
@@ -164,11 +163,6 @@ ipi_interrupt(int irq, void *dev_id)
 				generic_smp_call_function_interrupt();
 				break;
 
-			case IPI_CALL_FUNC_SINGLE:
-				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC_SINGLE\n", this_cpu);
-				generic_smp_call_function_single_interrupt();
-				break;
-
 			case IPI_CPU_START:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_CPU_START\n", this_cpu);
 				break;
@@ -260,7 +254,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+	send_IPI_single(cpu, IPI_CALL_FUNC);
 }
 
 /*
-- 
1.8.1.2

