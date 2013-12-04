Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3LDQTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:19:40 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60541 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab3LDQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:19:38 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>, Kirill Tkhai <tkhai@yandex.ru>,
        Al Viro <viro@zeniv.linux.org.uk>, Jiang Liu <jiang.liu@huawei.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 16/19] smp, sparc: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:07 +0800
Message-Id: <1386173591-28514-17-git-send-email-liuj97@gmail.com>
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/sparc/include/asm/smp_32.h |  4 +---
 arch/sparc/kernel/entry.S       | 10 ++--------
 arch/sparc/kernel/leon_smp.c    | 31 +++++++------------------------
 arch/sparc/kernel/smp_32.c      | 14 ++------------
 arch/sparc/kernel/sun4d_smp.c   | 31 +++++++------------------------
 arch/sparc/kernel/sun4m_smp.c   | 11 ++---------
 6 files changed, 21 insertions(+), 80 deletions(-)

diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index 3c8917f..6aec01a 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -48,7 +48,6 @@ void smp_callin(void);
 void smp_store_cpu_info(int);
 
 void smp_resched_interrupt(void);
-void smp_call_function_single_interrupt(void);
 void smp_call_function_interrupt(void);
 
 struct seq_file;
@@ -60,8 +59,7 @@ struct sparc32_ipi_ops {
 			   unsigned long arg2, unsigned long arg3,
 			   unsigned long arg4);
 	void (*resched)(int cpu);
-	void (*single)(int cpu);
-	void (*mask_one)(int cpu);
+	void (*func_call)(int cpu);
 };
 extern const struct sparc32_ipi_ops *sparc32_ipi_ops;
 
diff --git a/arch/sparc/kernel/entry.S b/arch/sparc/kernel/entry.S
index 33c02b1..98bacfb 100644
--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -263,7 +263,7 @@ smp4m_ticker:
 	 * on some level other than 15 which is the NMI and only used
 	 * for cross calls.  That has a separate entry point below.
 	 *
-	 * IPIs are sent on Level 12, 13 and 14. See IRQ_IPI_*.
+	 * IPIs are sent on Level 13 and 14. See IRQ_IPI_*.
 	 */
 maybe_smp4m_msg:
 	GET_PROCESSOR4M_ID(o3)
@@ -287,14 +287,8 @@ maybe_smp4m_msg:
 	wr	%l4, PSR_ET, %psr
 	WRITE_PAUSE
 	srl	%o3, 28, %o2		! shift for simpler checks below
-maybe_smp4m_msg_check_single:
-	andcc	%o2, 0x1, %g0
-	beq,a	maybe_smp4m_msg_check_mask
-	 andcc	%o2, 0x2, %g0
-	call	smp_call_function_single_interrupt
-	 nop
-	andcc	%o2, 0x2, %g0
 maybe_smp4m_msg_check_mask:
+	andcc	%o2, 0x2, %g0
 	beq,a	maybe_smp4m_msg_check_resched
 	 andcc	%o2, 0x4, %g0
 	call	smp_call_function_interrupt
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 6edf955..396b71d 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -271,8 +271,7 @@ void leon_irq_rotate(int cpu)
 }
 
 struct leon_ipi_work {
-	int single;
-	int msk;
+	int func_call;
 	int resched;
 };
 
@@ -308,7 +307,7 @@ static void __init leon_ipi_init(void)
 
 	for_each_possible_cpu(cpu) {
 		work = &per_cpu(leon_ipi_work, cpu);
-		work->single = work->msk = work->resched = 0;
+		work->func_call = work->resched = 0;
 	}
 }
 
@@ -319,23 +318,12 @@ static void leon_send_ipi(int cpu, int level)
 	LEON3_BYPASS_STORE_PA(&leon3_irqctrl_regs->force[cpu], mask);
 }
 
-static void leon_ipi_single(int cpu)
+static void leon_ipi_func_call(int cpu)
 {
 	struct leon_ipi_work *work = &per_cpu(leon_ipi_work, cpu);
 
 	/* Mark work */
-	work->single = 1;
-
-	/* Generate IRQ on the CPU */
-	leon_send_ipi(cpu, leon_ipi_irq);
-}
-
-static void leon_ipi_mask_one(int cpu)
-{
-	struct leon_ipi_work *work = &per_cpu(leon_ipi_work, cpu);
-
-	/* Mark work */
-	work->msk = 1;
+	work->func_call = 1;
 
 	/* Generate IRQ on the CPU */
 	leon_send_ipi(cpu, leon_ipi_irq);
@@ -356,12 +344,8 @@ void leonsmp_ipi_interrupt(void)
 {
 	struct leon_ipi_work *work = &__get_cpu_var(leon_ipi_work);
 
-	if (work->single) {
-		work->single = 0;
-		smp_call_function_single_interrupt();
-	}
-	if (work->msk) {
-		work->msk = 0;
+	if (work->func_call) {
+		work->func_call = 0;
 		smp_call_function_interrupt();
 	}
 	if (work->resched) {
@@ -467,8 +451,7 @@ void leon_cross_call_irq(void)
 static const struct sparc32_ipi_ops leon_ipi_ops = {
 	.cross_call = leon_cross_call,
 	.resched    = leon_ipi_resched,
-	.single     = leon_ipi_single,
-	.mask_one   = leon_ipi_mask_one,
+	.func_call   = leon_ipi_func_call,
 };
 
 void __init leon_init_smp(void)
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index a102bfb..0530d67 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -138,17 +138,15 @@ void smp_send_stop(void)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	/* trigger one IPI single call on one CPU */
-	sparc32_ipi_ops->single(cpu);
+	sparc32_ipi_ops->func_call(cpu);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	int cpu;
 
-	/* trigger IPI mask call on each CPU */
 	for_each_cpu(cpu, mask)
-		sparc32_ipi_ops->mask_one(cpu);
+		sparc32_ipi_ops->func_call(cpu);
 }
 
 void smp_resched_interrupt(void)
@@ -160,14 +158,6 @@ void smp_resched_interrupt(void)
 	/* re-schedule routine called by interrupt return code. */
 }
 
-void smp_call_function_single_interrupt(void)
-{
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	local_cpu_data().irq_call_count++;
-	irq_exit();
-}
-
 void smp_call_function_interrupt(void)
 {
 	irq_enter();
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index d5c3195..72f3797 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -181,8 +181,7 @@ void __init smp4d_smp_done(void)
 
 /* Memory structure giving interrupt handler information about IPI generated */
 struct sun4d_ipi_work {
-	int single;
-	int msk;
+	int func_call;
 	int resched;
 };
 
@@ -198,7 +197,7 @@ static void __init smp4d_ipi_init(void)
 
 	for_each_possible_cpu(cpu) {
 		work = &per_cpu(sun4d_ipi_work, cpu);
-		work->single = work->msk = work->resched = 0;
+		work->func_call = work->resched = 0;
 	}
 }
 
@@ -206,12 +205,8 @@ void sun4d_ipi_interrupt(void)
 {
 	struct sun4d_ipi_work *work = &__get_cpu_var(sun4d_ipi_work);
 
-	if (work->single) {
-		work->single = 0;
-		smp_call_function_single_interrupt();
-	}
-	if (work->msk) {
-		work->msk = 0;
+	if (work->func_call) {
+		work->func_call = 0;
 		smp_call_function_interrupt();
 	}
 	if (work->resched) {
@@ -233,23 +228,12 @@ static void sun4d_send_ipi(int cpu, int level)
 	cc_set_igen(IGEN_MESSAGE(0, cpu << 3, 6 + ((level >> 1) & 7), 1 << (level - 1)));
 }
 
-static void sun4d_ipi_single(int cpu)
-{
-	struct sun4d_ipi_work *work = &per_cpu(sun4d_ipi_work, cpu);
-
-	/* Mark work */
-	work->single = 1;
-
-	/* Generate IRQ on the CPU */
-	sun4d_send_ipi(cpu, SUN4D_IPI_IRQ);
-}
-
-static void sun4d_ipi_mask_one(int cpu)
+static void sun4d_ipi_func_call(int cpu)
 {
 	struct sun4d_ipi_work *work = &per_cpu(sun4d_ipi_work, cpu);
 
 	/* Mark work */
-	work->msk = 1;
+	work->func_call = 1;
 
 	/* Generate IRQ on the CPU */
 	sun4d_send_ipi(cpu, SUN4D_IPI_IRQ);
@@ -392,8 +376,7 @@ void smp4d_percpu_timer_interrupt(struct pt_regs *regs)
 static const struct sparc32_ipi_ops sun4d_ipi_ops = {
 	.cross_call = sun4d_cross_call,
 	.resched    = sun4d_ipi_resched,
-	.single     = sun4d_ipi_single,
-	.mask_one   = sun4d_ipi_mask_one,
+	.func_call   = sun4d_ipi_func_call,
 };
 
 void __init sun4d_init_smp(void)
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index d3408e7..d4b7d01 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -20,7 +20,6 @@
 #include "irq.h"
 #include "kernel.h"
 
-#define IRQ_IPI_SINGLE		12
 #define IRQ_IPI_MASK		13
 #define IRQ_IPI_RESCHED		14
 #define IRQ_CROSS_CALL		15
@@ -145,12 +144,7 @@ static void sun4m_ipi_resched(int cpu)
 	sun4m_send_ipi(cpu, IRQ_IPI_RESCHED);
 }
 
-static void sun4m_ipi_single(int cpu)
-{
-	sun4m_send_ipi(cpu, IRQ_IPI_SINGLE);
-}
-
-static void sun4m_ipi_mask_one(int cpu)
+static void sun4m_ipi_func_call(int cpu)
 {
 	sun4m_send_ipi(cpu, IRQ_IPI_MASK);
 }
@@ -262,8 +256,7 @@ void smp4m_percpu_timer_interrupt(struct pt_regs *regs)
 static const struct sparc32_ipi_ops sun4m_ipi_ops = {
 	.cross_call = sun4m_cross_call,
 	.resched    = sun4m_ipi_resched,
-	.single     = sun4m_ipi_single,
-	.mask_one   = sun4m_ipi_mask_one,
+	.func_call   = sun4m_ipi_func_call,
 };
 
 void __init sun4m_init_smp(void)
-- 
1.8.1.2

