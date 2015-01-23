Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbbAWFfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:35:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:45686 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbbAWFfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:35:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042290"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org
Subject: [Resend Patch v4 11/16] smp, x86, xen: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:50 +0800
Message-Id: <1421991416-20297-12-git-send-email-jiang.liu@linux.intel.com>
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

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/xen/events.h |    1 -
 arch/x86/xen/smp.c                |   38 ++-----------------------------------
 2 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
index 608a79d5a466..a9e54dc05c50 100644
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
index 4c071aeb8417..d54c122a0486 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -47,12 +47,10 @@ struct xen_common_irq {
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
@@ -136,13 +134,6 @@ static void xen_smp_intr_free(unsigned int cpu)
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
 
@@ -191,18 +182,6 @@ static int xen_smp_intr_init(unsigned int cpu)
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
@@ -599,8 +578,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	__xen_send_IPI_mask(cpumask_of(cpu),
-			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
+	__xen_send_IPI_mask(cpumask_of(cpu), XEN_CALL_FUNCTION_VECTOR);
 }
 
 static inline int xen_map_vector(int vector)
@@ -612,10 +590,8 @@ static inline int xen_map_vector(int vector)
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
@@ -693,16 +669,6 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
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
1.7.10.4

