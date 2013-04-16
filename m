Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936241Ab3DPUKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:10:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22404 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936146Ab3DPUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:09:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/9] xen/spinlock:  Check against default value of -1 for IRQ line.
Date: Tue, 16 Apr 2013 16:09:04 -0400
Message-Id: <1366142947-18655-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default (uninitialized) value of the IRQ line is -1.
Check if we already have allocated an spinlock interrupt line
and if somebody is trying to do it again. Also set it to -1
when we offline the CPU.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/spinlock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index f7a080e..47ae032 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -364,6 +364,9 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 	int irq;
 	const char *name;
 
+	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
+	     cpu, per_cpu(lock_kicker_irq, cpu));
+
 	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
@@ -383,6 +386,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 void xen_uninit_lock_cpu(int cpu)
 {
 	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
+	per_cpu(lock_kicker_irq, cpu) = -1;
 }
 
 void __init xen_init_spinlocks(void)
-- 
1.8.1.4

