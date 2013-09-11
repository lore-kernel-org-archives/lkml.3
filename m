Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3IKQIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:08:17 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53961 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3IKQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:08:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 02/25] smp, alpha: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:06 +0800
Message-Id: <1378915649-16395-3-git-send-email-liuj97@gmail.com>
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
 arch/alpha/kernel/smp.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 9dbbcb3..71d5c7d 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -63,7 +63,6 @@ static struct {
 enum ipi_message_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
@@ -498,7 +497,6 @@ smp_cpus_done(unsigned int max_cpus)
 	       ((bogosum + 2500) / (5000/HZ)) % 100);
 }
 
-
 void
 smp_percpu_timer_interrupt(struct pt_regs *regs)
 {
@@ -533,7 +531,6 @@ setup_profiling_timer(unsigned int multiplier)
 	return -EINVAL;
 }
 
-
 static void
 send_ipi_message(const struct cpumask *to_whom, enum ipi_message_type operation)
 {
@@ -579,10 +576,6 @@ handle_ipi(struct pt_regs *regs)
 			generic_smp_call_function_interrupt();
 			break;
 
-		case IPI_CALL_FUNC_SINGLE:
-			generic_smp_call_function_single_interrupt();
-			break;
-
 		case IPI_CPU_STOP:
 			halt();
 
@@ -633,7 +626,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC);
 }
 
 static void
-- 
1.8.1.2

