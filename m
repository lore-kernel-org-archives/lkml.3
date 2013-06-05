Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3FEPyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:54:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37934 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab3FEPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/9] xen/smp: Set the per-cpu IRQ number to a valid default.
Date: Wed,  5 Jun 2013 11:54:32 -0400
Message-Id: <1370447678-22367-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we free it we want to make sure to set it to a default
value of -1 so that we don't double-free it (in case somebody
calls us twice).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index f5b29ec..6a483cd 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -43,10 +43,10 @@ struct xen_common_irq {
 	int irq;
 	char *name;
 };
-static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq);
-static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq);
-static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq);
-static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work);
+static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq) = { .irq = -1 };
+static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq) = { .irq = -1 };
+static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq) = { .irq = -1 };
+static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
@@ -104,20 +104,30 @@ static void __cpuinit cpu_bringup_and_idle(void)
 
 static void xen_smp_intr_free(unsigned int cpu)
 {
-	if (per_cpu(xen_resched_irq, cpu).irq >= 0)
+	if (per_cpu(xen_resched_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu).irq, NULL);
-	if (per_cpu(xen_callfunc_irq, cpu).irq >= 0)
+		per_cpu(xen_resched_irq, cpu).irq = -1;
+	}
+	if (per_cpu(xen_callfunc_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu).irq, NULL);
-	if (per_cpu(xen_debug_irq, cpu).irq >= 0)
+		per_cpu(xen_callfunc_irq, cpu).irq = -1;
+	}
+	if (per_cpu(xen_debug_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu).irq, NULL);
-	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0)
+		per_cpu(xen_debug_irq, cpu).irq = -1;
+	}
+	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu).irq,
 				       NULL);
+		per_cpu(xen_callfuncsingle_irq, cpu).irq = -1;
+	}
 	if (xen_hvm_domain())
 		return;
 
-	if (per_cpu(xen_irq_work, cpu).irq >= 0)
+	if (per_cpu(xen_irq_work, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu).irq, NULL);
+		per_cpu(xen_irq_work, cpu).irq = -1;
+	}
 };
 static int xen_smp_intr_init(unsigned int cpu)
 {
-- 
1.8.1.4

