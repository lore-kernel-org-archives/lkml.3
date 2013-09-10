Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3IJPaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:30:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17400 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab3IJPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:30:09 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v1 5/5] xen/PMU: Cache MSR accesses during interrupt handling
Date: Tue, 10 Sep 2013 11:31:50 -0400
Message-Id: <1378827110-4192-6-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid trapping to hypervisor on each MSR access during interrupt handling.
Instead, use cached MSR values provided in shared xenpmu_data by Xen. When
handling is completed, flush the registers to hypervisor who will load them
into HW.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/pmu.c             | 15 ++++++++++++++-
 include/xen/interface/xenpmu.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index d8b059b..bdd7c4a 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -345,14 +345,27 @@ static void xen_convert_regs(struct cpu_user_regs *xen_regs,
 
 irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
 {
-	int ret = IRQ_NONE;
+	int err, ret = IRQ_NONE;
 	struct pt_regs regs;
 	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
 						  smp_processor_id());
 
+	/*
+	 * While handling the interrupt MSR accesses will be cached
+	 * in PMU context
+	 */
+	xenpmu_data->pmu_flags |= PMU_CACHED;
 	xen_convert_regs(&xenpmu_data->regs, &regs);
 	if (x86_pmu.handle_irq(&regs))
 		ret = IRQ_HANDLED;
+	xenpmu_data->pmu_flags &= ~PMU_CACHED;
+
+	/* Write out cached context to HW */
+	err = HYPERVISOR_xenpmu_op(XENPMU_flush, NULL);
+	if (err) {
+		WARN(1, "%s failed hypercall, err: %d\n", __func__, err);
+		return IRQ_NONE;
+	}
 
 	return ret;
 }
diff --git a/include/xen/interface/xenpmu.h b/include/xen/interface/xenpmu.h
index 16fe1ab..ec0e802 100644
--- a/include/xen/interface/xenpmu.h
+++ b/include/xen/interface/xenpmu.h
@@ -16,6 +16,7 @@
 #define XENPMU_init            4
 #define XENPMU_finish          5
 #define XENPMU_lvtpc_set       6
+#define XENPMU_flush           7 /* Write cached MSR values to HW */
 
 /* Parameter structure for HYPERVISOR_xenpmu_op call */
 struct xenpmu_params {
-- 
1.8.1.4

