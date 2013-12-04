Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3LDQTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:19:05 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41459 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3LDQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:19:00 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bob Picco <bob.picco@oracle.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [RFC PATCH v3 15/19] smp, sparc64: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:06 +0800
Message-Id: <1386173591-28514-16-git-send-email-liuj97@gmail.com>
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
 arch/sparc/include/asm/pil.h  |  5 ++---
 arch/sparc/kernel/smp_64.c    | 11 +----------
 arch/sparc/kernel/ttable_64.S | 12 ++++--------
 arch/sparc/mm/ultra.S         |  5 -----
 4 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/arch/sparc/include/asm/pil.h b/arch/sparc/include/asm/pil.h
index 2669370..5ffb15d 100644
--- a/arch/sparc/include/asm/pil.h
+++ b/arch/sparc/include/asm/pil.h
@@ -22,9 +22,8 @@
 #define PIL_SMP_CAPTURE		3
 #define PIL_SMP_CTX_NEW_VERSION	4
 #define PIL_DEVICE_IRQ		5
-#define PIL_SMP_CALL_FUNC_SNGL	6
-#define PIL_DEFERRED_PCR_WORK	7
-#define PIL_KGDB_CAPTURE	8
+#define PIL_DEFERRED_PCR_WORK	6
+#define PIL_KGDB_CAPTURE	7
 #define PIL_NORMAL_MAX		14
 #define PIL_NMI			15
 
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index b66a533..07d624b 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -811,12 +811,9 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	xcall_deliver((u64) &xcall_call_function, 0, 0, mask);
 }
 
-extern unsigned long xcall_call_function_single;
-
 void arch_send_call_function_single_ipi(int cpu)
 {
-	xcall_deliver((u64) &xcall_call_function_single, 0, 0,
-		      cpumask_of(cpu));
+	xcall_deliver((u64) &xcall_call_function, 0, 0, cpumask_of(cpu));
 }
 
 void __irq_entry smp_call_function_client(int irq, struct pt_regs *regs)
@@ -825,12 +822,6 @@ void __irq_entry smp_call_function_client(int irq, struct pt_regs *regs)
 	generic_smp_call_function_interrupt();
 }
 
-void __irq_entry smp_call_function_single_client(int irq, struct pt_regs *regs)
-{
-	clear_softint(1 << irq);
-	generic_smp_call_function_single_interrupt();
-}
-
 static void tsb_sync(void *info)
 {
 	struct trap_per_cpu *tp = &trap_block[raw_smp_processor_id()];
diff --git a/arch/sparc/kernel/ttable_64.S b/arch/sparc/kernel/ttable_64.S
index c6dfdaa..defa2db 100644
--- a/arch/sparc/kernel/ttable_64.S
+++ b/arch/sparc/kernel/ttable_64.S
@@ -58,17 +58,13 @@ tl0_irq3:	BTRAP(0x43)
 tl0_irq4:	BTRAP(0x44)
 #endif
 tl0_irq5:	TRAP_IRQ(handler_irq, 5)
-#ifdef CONFIG_SMP
-tl0_irq6:	TRAP_IRQ(smp_call_function_single_client, 6)
-#else
-tl0_irq6:	BTRAP(0x46)
-#endif
-tl0_irq7:	TRAP_IRQ(deferred_pcr_work_irq, 7)
+tl0_irq6:	TRAP_IRQ(deferred_pcr_work_irq, 6)
 #if defined(CONFIG_KGDB) && defined(CONFIG_SMP)
-tl0_irq8:	TRAP_IRQ(smp_kgdb_capture_client, 8)
+tl0_irq7:	TRAP_IRQ(smp_kgdb_capture_client, 7)
 #else
-tl0_irq8:	BTRAP(0x48)
+tl0_irq7:	BTRAP(0x47)
 #endif
+tl0_irq8:	BTRAP(0x48)
 tl0_irq9:	BTRAP(0x49)
 tl0_irq10:	BTRAP(0x4a) BTRAP(0x4b) BTRAP(0x4c) BTRAP(0x4d)
 tl0_irq14:	TRAP_IRQ(timer_interrupt, 14)
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index b4f4733..1da4739 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -780,11 +780,6 @@ xcall_call_function:
 	wr		%g0, (1 << PIL_SMP_CALL_FUNC), %set_softint
 	retry
 
-	.globl		xcall_call_function_single
-xcall_call_function_single:
-	wr		%g0, (1 << PIL_SMP_CALL_FUNC_SNGL), %set_softint
-	retry
-
 	.globl		xcall_receive_signal
 xcall_receive_signal:
 	wr		%g0, (1 << PIL_SMP_RECEIVE_SIGNAL), %set_softint
-- 
1.8.1.2

