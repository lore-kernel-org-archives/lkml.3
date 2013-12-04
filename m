Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3LDQUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:20:08 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36194 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3LDQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:20:03 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH v3 18/19] smp, tile: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:09 +0800
Message-Id: <1386173591-28514-19-git-send-email-liuj97@gmail.com>
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
 arch/x86/include/asm/xen/events.h |  1 -
 arch/x86/xen/smp.c                | 38 ++------------------------------------
 2 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
index 608a79d..a9e54dc 100644
--- a/arch/x86/include/asm/xen/events.h
+++ b/arch/x86/include/asm/xen/events.h
@@ -4,7 +4,6 @@
 enum ipi_vector {
 	XEN_RESCHEDULE_VECTOR,
 	XEN_CALL_FUNCTION_VECTOR,
-	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 	XEN_SPIN_UNLOCK_VECTOR,
 	XEN_IRQ_WORK_VECTOR,
 	XEN_NMI_VECTOR,
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c36b325..7cf1689 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -46,12 +46,10 @@ struct xen_common_irq {
 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq) = { .irq = -1 };
-static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
-static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
 
 /*
@@ -123,13 +121,6 @@ static void xen_smp_intr_free(unsigned int cpu)
 		kfree(per_cpu(xen_debug_irq, cpu).name);
 		per_cpu(xen_debug_irq, cpu).name = NULL;
 	}
-	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0) {
-		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu).irq,
-				       NULL);
-		per_cpu(xen_callfuncsingle_irq, cpu).irq = -1;
-		kfree(per_cpu(xen_callfuncsingle_irq, cpu).name);
-		per_cpu(xen_callfuncsingle_irq, cpu).name = NULL;
-	}
 	if (xen_hvm_domain())
 		return;
 
@@ -178,18 +169,6 @@ static int xen_smp_intr_init(unsigned int cpu)
 	per_cpu(xen_debug_irq, cpu).irq = rc;
 	per_cpu(xen_debug_irq, cpu).name = debug_name;
 
-	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
-	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
-				    cpu,
-				    xen_call_function_single_interrupt,
-				    IRQF_PERCPU|IRQF_NOBALANCING,
-				    callfunc_name,
-				    NULL);
-	if (rc < 0)
-		goto fail;
-	per_cpu(xen_callfuncsingle_irq, cpu).irq = rc;
-	per_cpu(xen_callfuncsingle_irq, cpu).name = callfunc_name;
-
 	/*
 	 * The IRQ worker on PVHVM goes through the native path and uses the
 	 * IPI mechanism.
@@ -569,8 +548,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	__xen_send_IPI_mask(cpumask_of(cpu),
-			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
+	__xen_send_IPI_mask(cpumask_of(cpu), XEN_CALL_FUNCTION_VECTOR);
 }
 
 static inline int xen_map_vector(int vector)
@@ -582,10 +560,8 @@ static inline int xen_map_vector(int vector)
 		xen_vector = XEN_RESCHEDULE_VECTOR;
 		break;
 	case CALL_FUNCTION_VECTOR:
-		xen_vector = XEN_CALL_FUNCTION_VECTOR;
-		break;
 	case CALL_FUNCTION_SINGLE_VECTOR:
-		xen_vector = XEN_CALL_FUNCTION_SINGLE_VECTOR;
+		xen_vector = XEN_CALL_FUNCTION_VECTOR;
 		break;
 	case IRQ_WORK_VECTOR:
 		xen_vector = XEN_IRQ_WORK_VECTOR;
@@ -663,16 +639,6 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
-{
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	inc_irq_stat(irq_call_count);
-	irq_exit();
-
-	return IRQ_HANDLED;
-}
-
 static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
-- 
1.8.1.2

