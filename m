Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaLEItc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:49:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:34011 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaLEIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:48:33 -0500
Message-Id: <20141205084147.232633738@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 05 Dec 2014 08:48:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: [patch 2/5] iommu, x86: Restructure setup of the irq remapping feature
References: <20141204234737.728961990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=iommu-restructure-setup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable_IR_x2apic() calls setup_irq_remapping_ops() which by default
installs the intel dmar remapping ops and then calls the amd iommu irq
remapping prepare callback to figure out whether we are running on an
AMD machine with irq remapping hardware.

Right after that it calls irq_remapping_prepare() which pointlessly
checks:
	if (!remap_ops || !remap_ops->prepare)
               return -ENODEV;
and then calls

    remap_ops->prepare()

which is silly in the AMD case as it got called from
setup_irq_remapping_ops() already a few microseconds ago.

Simplify this and just collapse everything into
irq_remapping_prepare().

The irq_remapping_prepare() remains still silly as it assigns blindly
the intel ops, but that's not scope of this patch.

The scope here is to move the preperatory work, i.e. memory
allocations out of the atomic section which is required to enable irq
remapping.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_remapping.h |    2 --
 arch/x86/kernel/apic/apic.c          |    3 ---
 drivers/iommu/irq_remapping.c        |   19 +++++++------------
 3 files changed, 7 insertions(+), 17 deletions(-)

Index: tip/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq_remapping.h
+++ tip/arch/x86/include/asm/irq_remapping.h
@@ -31,7 +31,6 @@ struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
@@ -58,7 +57,6 @@ static inline struct irq_domain *arch_ge
 
 #else  /* CONFIG_IRQ_REMAP */
 
-static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1597,9 +1597,6 @@ void __init enable_IR_x2apic(void)
 	int ret, x2apic_enabled = 0;
 	int hardware_init_ret;
 
-	/* Make sure irq_remap_ops are initialized */
-	setup_irq_remapping_ops();
-
 	hardware_init_ret = irq_remapping_prepare();
 	if (hardware_init_ret && !x2apic_supported())
 		return;
Index: tip/drivers/iommu/irq_remapping.c
===================================================================
--- tip.orig/drivers/iommu/irq_remapping.c
+++ tip/drivers/iommu/irq_remapping.c
@@ -75,16 +75,6 @@ static __init int setup_irqremap(char *s
 }
 early_param("intremap", setup_irqremap);
 
-void __init setup_irq_remapping_ops(void)
-{
-	remap_ops = &intel_irq_remap_ops;
-
-#ifdef CONFIG_AMD_IOMMU
-	if (amd_iommu_irq_ops.prepare() == 0)
-		remap_ops = &amd_iommu_irq_ops;
-#endif
-}
-
 void set_irq_remapping_broken(void)
 {
 	irq_remap_broken = 1;
@@ -103,9 +93,14 @@ int irq_remapping_supported(void)
 
 int __init irq_remapping_prepare(void)
 {
-	if (!remap_ops || !remap_ops->prepare)
-		return -ENODEV;
+	remap_ops = &intel_irq_remap_ops;
 
+#ifdef CONFIG_AMD_IOMMU
+	if (amd_iommu_irq_ops.prepare() == 0) {
+		remap_ops = &amd_iommu_irq_ops;
+		return 0;
+	}
+#endif
 	return remap_ops->prepare();
 }
 


