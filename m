Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3FEPyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:54:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26722 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3FEPyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/9] xen/smp: Coalesce the free_irq calls in one function.
Date: Wed,  5 Jun 2013 11:54:30 -0400
Message-Id: <1370447678-22367-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two functions that do a bunch of 'free_irq' on
the per_cpu IRQ. Instead of having duplicate code just move
it to one function.

This is just code movement.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index fb44426..19fc9f3 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -98,6 +98,23 @@ static void __cpuinit cpu_bringup_and_idle(void)
 	cpu_startup_entry(CPUHP_ONLINE);
 }
 
+static void xen_smp_intr_free(unsigned int cpu)
+{
+	if (per_cpu(xen_resched_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
+	if (per_cpu(xen_callfunc_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
+	if (per_cpu(xen_debug_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
+	if (per_cpu(xen_callfuncsingle_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu),
+				       NULL);
+	if (xen_hvm_domain())
+		return;
+
+	if (per_cpu(xen_irq_work, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+};
 static int xen_smp_intr_init(unsigned int cpu)
 {
 	int rc;
@@ -165,21 +182,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	return 0;
 
  fail:
-	if (per_cpu(xen_resched_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
-	if (per_cpu(xen_callfunc_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
-	if (per_cpu(xen_debug_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
-	if (per_cpu(xen_callfuncsingle_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu),
-				       NULL);
-	if (xen_hvm_domain())
-		return rc;
-
-	if (per_cpu(xen_irq_work, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
-
+	xen_smp_intr_free(cpu);
 	return rc;
 }
 
@@ -432,12 +435,7 @@ static void xen_cpu_die(unsigned int cpu)
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
-	unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
-	if (!xen_hvm_domain())
-		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_smp_intr_free(cpu);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
 }
-- 
1.8.1.4

