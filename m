Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3FEP5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:57:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26731 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3FEPyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/9] xen/smp: Introduce a common structure to contain the IRQ name and interrupt line.
Date: Wed,  5 Jun 2013 11:54:31 -0400
Message-Id: <1370447678-22367-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new structure to contain the common two things
that each of the per-cpu interrupts need:
 - an interrupt number,
 - and the name of the interrupt (to be added in 'xen/smp: Don't leak
   interrupt name when offlining').

This allows us to carry the tuple of the per-cpu interrupt data structure
and expand it as we need in the future.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 19fc9f3..f5b29ec 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -39,11 +39,15 @@
 
 cpumask_var_t xen_cpu_initialized_map;
 
-static DEFINE_PER_CPU(int, xen_resched_irq);
-static DEFINE_PER_CPU(int, xen_callfunc_irq);
-static DEFINE_PER_CPU(int, xen_callfuncsingle_irq);
-static DEFINE_PER_CPU(int, xen_irq_work);
-static DEFINE_PER_CPU(int, xen_debug_irq) = -1;
+struct xen_common_irq {
+	int irq;
+	char *name;
+};
+static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq);
+static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq);
+static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq);
+static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work);
+static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
@@ -100,20 +104,20 @@ static void __cpuinit cpu_bringup_and_idle(void)
 
 static void xen_smp_intr_free(unsigned int cpu)
 {
-	if (per_cpu(xen_resched_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
-	if (per_cpu(xen_callfunc_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
-	if (per_cpu(xen_debug_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
-	if (per_cpu(xen_callfuncsingle_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu),
+	if (per_cpu(xen_resched_irq, cpu).irq >= 0)
+		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu).irq, NULL);
+	if (per_cpu(xen_callfunc_irq, cpu).irq >= 0)
+		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu).irq, NULL);
+	if (per_cpu(xen_debug_irq, cpu).irq >= 0)
+		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu).irq, NULL);
+	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0)
+		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu).irq,
 				       NULL);
 	if (xen_hvm_domain())
 		return;
 
-	if (per_cpu(xen_irq_work, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	if (per_cpu(xen_irq_work, cpu).irq >= 0)
+		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu).irq, NULL);
 };
 static int xen_smp_intr_init(unsigned int cpu)
 {
@@ -129,7 +133,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(xen_resched_irq, cpu) = rc;
+	per_cpu(xen_resched_irq, cpu).irq = rc;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfunc%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
@@ -140,7 +144,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(xen_callfunc_irq, cpu) = rc;
+	per_cpu(xen_callfunc_irq, cpu).irq = rc;
 
 	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
 	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
@@ -148,7 +152,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				     debug_name, NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(xen_debug_irq, cpu) = rc;
+	per_cpu(xen_debug_irq, cpu).irq = rc;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
@@ -159,7 +163,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(xen_callfuncsingle_irq, cpu) = rc;
+	per_cpu(xen_callfuncsingle_irq, cpu).irq = rc;
 
 	/*
 	 * The IRQ worker on PVHVM goes through the native path and uses the
@@ -177,7 +181,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(xen_irq_work, cpu) = rc;
+	per_cpu(xen_irq_work, cpu).irq = rc;
 
 	return 0;
 
-- 
1.8.1.4

