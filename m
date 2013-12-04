Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3LDQUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:20:54 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61769 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3LDQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:20:51 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Gleb Natapov <gleb@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Kosina <trivial@kernel.org>, Wang YanQing <udknight@gmail.com>,
        linux-arch@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH v3 19/19] smp, x86: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:10 +0800
Message-Id: <1386173591-28514-20-git-send-email-liuj97@gmail.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/x86/include/asm/entry_arch.h        |  1 -
 arch/x86/include/asm/hw_irq.h            |  3 ---
 arch/x86/include/asm/irq_vectors.h       |  7 +++----
 arch/x86/include/asm/trace/irq_vectors.h |  6 ------
 arch/x86/kernel/entry_64.S               |  2 --
 arch/x86/kernel/irqinit.c                |  4 ----
 arch/x86/kernel/smp.c                    | 24 +-----------------------
 arch/x86/xen/smp.c                       |  1 -
 8 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index dc5fa66..9670cff 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -12,7 +12,6 @@
 #ifdef CONFIG_SMP
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
-BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT3(irq_move_cleanup_interrupt, IRQ_MOVE_CLEANUP_VECTOR,
 		 smp_irq_move_cleanup_interrupt)
 BUILD_INTERRUPT3(reboot_interrupt, REBOOT_VECTOR, smp_reboot_interrupt)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index cba45d9..66bacec 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -75,7 +75,6 @@ extern asmlinkage void reboot_interrupt(void);
 extern asmlinkage void threshold_interrupt(void);
 
 extern asmlinkage void call_function_interrupt(void);
-extern asmlinkage void call_function_single_interrupt(void);
 
 #ifdef CONFIG_TRACING
 /* Interrupt handlers registered during init_IRQ */
@@ -88,7 +87,6 @@ extern void trace_thermal_interrupt(void);
 extern void trace_reschedule_interrupt(void);
 extern void trace_threshold_interrupt(void);
 extern void trace_call_function_interrupt(void);
-extern void trace_call_function_single_interrupt(void);
 #define trace_irq_move_cleanup_interrupt  irq_move_cleanup_interrupt
 #define trace_reboot_interrupt  reboot_interrupt
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
@@ -182,7 +180,6 @@ extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
 #ifdef CONFIG_SMP
 extern __visible void smp_reschedule_interrupt(struct pt_regs *);
 extern __visible void smp_call_function_interrupt(struct pt_regs *);
-extern __visible void smp_call_function_single_interrupt(struct pt_regs *);
 extern __visible void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 5702d7e..98a302d 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -92,10 +92,9 @@
 #define ERROR_APIC_VECTOR		0xfe
 #define RESCHEDULE_VECTOR		0xfd
 #define CALL_FUNCTION_VECTOR		0xfc
-#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
-#define THERMAL_APIC_VECTOR		0xfa
-#define THRESHOLD_APIC_VECTOR		0xf9
-#define REBOOT_VECTOR			0xf8
+#define THERMAL_APIC_VECTOR		0xfb
+#define THRESHOLD_APIC_VECTOR		0xfa
+#define REBOOT_VECTOR			0xf9
 
 /*
  * Generic system vector for platform specific use
diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
index 4cab890..e672e20 100644
--- a/arch/x86/include/asm/trace/irq_vectors.h
+++ b/arch/x86/include/asm/trace/irq_vectors.h
@@ -89,12 +89,6 @@ TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);
 DEFINE_IRQ_VECTOR_EVENT(call_function);
 
 /*
- * call_function_single - called when entering/exiting a call function
- * single interrupt vector handler
- */
-DEFINE_IRQ_VECTOR_EVENT(call_function_single);
-
-/*
  * threshold_apic - called when entering/exiting a threshold apic interrupt
  * vector handler
  */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e21b078..8d5d21a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1182,8 +1182,6 @@ apicinterrupt THERMAL_APIC_VECTOR \
 #endif
 
 #ifdef CONFIG_SMP
-apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
-	call_function_single_interrupt smp_call_function_single_interrupt
 apicinterrupt CALL_FUNCTION_VECTOR \
 	call_function_interrupt smp_call_function_interrupt
 apicinterrupt RESCHEDULE_VECTOR \
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index a2a1fbc..4aa1b8c 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -141,10 +141,6 @@ static void __init smp_intr_init(void)
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
-	/* IPI for generic single function call */
-	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-			call_function_single_interrupt);
-
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 7c3a5a6..f363dd2 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -129,7 +129,7 @@ static void native_smp_send_reschedule(int cpu)
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_VECTOR);
 }
 
 void native_send_call_func_ipi(const struct cpumask *mask)
@@ -311,28 +311,6 @@ __visible void smp_trace_call_function_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
-static inline void __smp_call_function_single_interrupt(void)
-{
-	generic_smp_call_function_single_interrupt();
-	inc_irq_stat(irq_call_count);
-}
-
-__visible void smp_call_function_single_interrupt(struct pt_regs *regs)
-{
-	smp_entering_irq();
-	__smp_call_function_single_interrupt();
-	exiting_irq();
-}
-
-__visible void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
-{
-	smp_entering_irq();
-	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
-	__smp_call_function_single_interrupt();
-	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
-	exiting_irq();
-}
-
 static int __init nonmi_ipi_setup(char *str)
 {
 	smp_no_nmi_ipi = true;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7cf1689..f241792 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -560,7 +560,6 @@ static inline int xen_map_vector(int vector)
 		xen_vector = XEN_RESCHEDULE_VECTOR;
 		break;
 	case CALL_FUNCTION_VECTOR:
-	case CALL_FUNCTION_SINGLE_VECTOR:
 		xen_vector = XEN_CALL_FUNCTION_VECTOR;
 		break;
 	case IRQ_WORK_VECTOR:
-- 
1.8.1.2

