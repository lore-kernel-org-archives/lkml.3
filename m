Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbbAWFfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:35:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:58258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbbAWFf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:35:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042193"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jiang Liu <jiang.liu@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [Resend Patch v4 09/16] smp, sparc64: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:48 +0800
Message-Id: <1421991416-20297-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/sparc/include/asm/pil.h  |    5 ++---
 arch/sparc/kernel/smp_64.c    |   13 +------------
 arch/sparc/kernel/ttable_64.S |   12 ++++--------
 arch/sparc/mm/ultra.S         |    5 -----
 4 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/arch/sparc/include/asm/pil.h b/arch/sparc/include/asm/pil.h
index 266937030546..5ffb15df5062 100644
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
index da6f1a7fc4db..a91b4f9ca822 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -805,12 +805,9 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
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
@@ -821,14 +818,6 @@ void __irq_entry smp_call_function_client(int irq, struct pt_regs *regs)
 	irq_exit();
 }
 
-void __irq_entry smp_call_function_single_client(int irq, struct pt_regs *regs)
-{
-	clear_softint(1 << irq);
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	irq_exit();
-}
-
 static void tsb_sync(void *info)
 {
 	struct trap_per_cpu *tp = &trap_block[raw_smp_processor_id()];
diff --git a/arch/sparc/kernel/ttable_64.S b/arch/sparc/kernel/ttable_64.S
index c6dfdaa29e20..defa2db9f914 100644
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
index b4f4733abc6e..1da47398df65 100644
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
1.7.10.4

