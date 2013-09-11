Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3IKQIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:08:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47323 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab3IKQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:08:17 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 03/25] smp, ARC: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:07 +0800
Message-Id: <1378915649-16395-4-git-send-email-liuj97@gmail.com>
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
 arch/arc/kernel/smp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index bca3052..f6a0373 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -210,7 +210,6 @@ enum ipi_msg_type {
 	IPI_NOP = 0,
 	IPI_RESCHEDULE = 1,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP
 };
 
@@ -254,7 +253,7 @@ void smp_send_stop(void)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	ipi_send_msg(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	ipi_send_msg(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
@@ -286,10 +285,6 @@ static inline void __do_IPI(unsigned long *ops, struct ipi_data *ipi, int cpu)
 			generic_smp_call_function_interrupt();
 			break;
 
-		case IPI_CALL_FUNC_SINGLE:
-			generic_smp_call_function_single_interrupt();
-			break;
-
 		case IPI_CPU_STOP:
 			ipi_cpu_stop(cpu);
 			break;
-- 
1.8.1.2

