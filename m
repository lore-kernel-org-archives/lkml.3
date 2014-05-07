Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaEGPwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:52:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:48544 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbaEGPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:56 -0400
Message-Id: <20140507154336.372289825@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Joerg Roedel <joro@8bytes.org>
Subject: [patch 12/32] iommu: dmar: Provide arch specific irq allocation
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=iommu-dmar-provide-arch-specific-irq-alloc.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 and x86 share this driver. x86 is moving to a different irq
allocation and ia64 keeps its private irq_create/destroy stuff.

Use macros to redirect to one or the other. Yes, macros to avoid
include hell.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
---
 arch/ia64/include/asm/irq_remapping.h |    2 ++
 arch/x86/include/asm/irq_remapping.h  |    3 +++
 drivers/iommu/dmar.c                  |    6 +++---
 3 files changed, 8 insertions(+), 3 deletions(-)

Index: tip/arch/ia64/include/asm/irq_remapping.h
===================================================================
--- tip.orig/arch/ia64/include/asm/irq_remapping.h
+++ tip/arch/ia64/include/asm/irq_remapping.h
@@ -1,4 +1,6 @@
 #ifndef __IA64_INTR_REMAPPING_H
 #define __IA64_INTR_REMAPPING_H
 #define irq_remapping_enabled 0
+#define dmar_alloc_hwirq	create_irq
+#define dmar_free_hwirq		destroy_irq
 #endif
Index: tip/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq_remapping.h
+++ tip/arch/x86/include/asm/irq_remapping.h
@@ -58,6 +58,9 @@ extern bool setup_remapped_irq(int irq,
 
 void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
+#define dmar_alloc_hwirq()	irq_alloc_hwirq(-1)
+#define dmar_free_hwirq		irq_free_hwirq
+
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
Index: tip/drivers/iommu/dmar.c
===================================================================
--- tip.orig/drivers/iommu/dmar.c
+++ tip/drivers/iommu/dmar.c
@@ -994,7 +994,7 @@ static void free_iommu(struct intel_iomm
 	if (iommu->irq) {
 		free_irq(iommu->irq, iommu);
 		irq_set_handler_data(iommu->irq, NULL);
-		destroy_irq(iommu->irq);
+		dmar_free_hwirq(iommu->irq);
 	}
 
 	if (iommu->qi) {
@@ -1550,7 +1550,7 @@ int dmar_set_interrupt(struct intel_iomm
 	if (iommu->irq)
 		return 0;
 
-	irq = create_irq();
+	irq = dmar_alloc_hwirq();
 	if (irq <= 0) {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
@@ -1563,7 +1563,7 @@ int dmar_set_interrupt(struct intel_iomm
 	if (ret) {
 		irq_set_handler_data(irq, NULL);
 		iommu->irq = 0;
-		destroy_irq(irq);
+		dmar_free_hwirq(irq);
 		return ret;
 	}
 


