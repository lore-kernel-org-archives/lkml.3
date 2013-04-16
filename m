Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936199Ab3DPUJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:09:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22427 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936062Ab3DPUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:09:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/9] xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM
Date: Tue, 16 Apr 2013 16:09:05 -0400
Message-Id: <1366142947-18655-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
(xen: disable PV spinlocks on HVM) for details.

But we did not disable it everywhere - which means that when
we boot as PVHVM we end up allocating per-CPU irq line for
spinlock. This fixes that.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/spinlock.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 47ae032..8b54603 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -367,6 +367,13 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
+	/*
+	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
+	 * (xen: disable PV spinlocks on HVM)
+	 */
+	if (xen_hvm_domain())
+		return;
+
 	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
@@ -385,12 +392,26 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 
 void xen_uninit_lock_cpu(int cpu)
 {
+	/*
+	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
+	 * (xen: disable PV spinlocks on HVM)
+	 */
+	if (xen_hvm_domain())
+		return;
+
 	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
 }
 
 void __init xen_init_spinlocks(void)
 {
+	/*
+	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
+	 * (xen: disable PV spinlocks on HVM)
+	 */
+	if (xen_hvm_domain())
+		return;
+
 	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
 
 	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
-- 
1.8.1.4

