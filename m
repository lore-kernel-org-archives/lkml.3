Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936258Ab3DPUKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:10:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22403 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936137Ab3DPUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:09:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 9/9] xen/smp: Unifiy some of the PVs and PVHVM offline CPU path
Date: Tue, 16 Apr 2013 16:09:07 -0400
Message-Id: <1366142947-18655-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "xen_cpu_die" and "xen_hvm_cpu_die" are very similar.
Lets coalesce them.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 415694c..0d466d7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -428,7 +428,7 @@ static int xen_cpu_disable(void)
 
 static void xen_cpu_die(unsigned int cpu)
 {
-	while (HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
+	while (xen_pv_domain() && HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
@@ -436,7 +436,8 @@ static void xen_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	if (!xen_hvm_domain())
+		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
 }
@@ -667,14 +668,7 @@ static int __cpuinit xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 static void xen_hvm_cpu_die(unsigned int cpu)
 {
-	unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
-	if (!xen_hvm_domain())
-		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
-	xen_uninit_lock_cpu(cpu);
-	xen_teardown_timer(cpu);
+	xen_cpu_die(cpu);
 	native_cpu_die(cpu);
 }
 
-- 
1.8.1.4

