Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbaEGPoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:48603 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaEGPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:01 -0400
Message-Id: <20140507154338.132662495@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 20/32] tile: pci: Use irq_alloc/free_hwirq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=tile-core-use-alloc-free-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: tip/arch/tile/kernel/pci_gx.c
===================================================================
--- tip.orig/arch/tile/kernel/pci_gx.c
+++ tip/arch/tile/kernel/pci_gx.c
@@ -350,10 +350,9 @@ static int tile_init_irqs(struct pci_con
 		int cpu;
 
 		/* Ask the kernel to allocate an IRQ. */
-		irq = create_irq();
-		if (irq < 0) {
+		irq = irq_alloc_hwirq(-1);
+		if (!irq) {
 			pr_err("PCI: no free irq vectors, failed for %d\n", i);
-
 			goto free_irqs;
 		}
 		controller->irq_intx_table[i] = irq;
@@ -382,7 +381,7 @@ static int tile_init_irqs(struct pci_con
 
 free_irqs:
 	for (j = 0; j < i; j++)
-		destroy_irq(controller->irq_intx_table[j]);
+		irq_free_hwirq(controller->irq_intx_table[j]);
 
 	return -1;
 }
@@ -1500,9 +1499,9 @@ int arch_setup_msi_irq(struct pci_dev *p
 	int irq;
 	int ret;
 
-	irq = create_irq();
-	if (irq < 0)
-		return irq;
+	irq = irq_alloc_hwirq(-1);
+	if (!irq)
+		return -ENOSPC;
 
 	/*
 	 * Since we use a 64-bit Mem-Map to accept the MSI write, we fail
@@ -1601,11 +1600,11 @@ hv_msi_config_failure:
 	/* Free mem-map */
 msi_mem_map_alloc_failure:
 is_64_failure:
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 	return ret;
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
 {
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 }


