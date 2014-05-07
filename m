Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaEGPn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:43:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:48502 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaEGPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:52 -0400
Message-Id: <20140507154334.741805075@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [patch 05/32] x86: irq_remapping: Use irq_alloc/free_hwirq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=x86-irq-remap-use-irq-alloc-free-hwirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The create_irq variants are going away. Use the new interface. The
core and arch code already excludes the gsi interrupts from the
allocation, so no functional change.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/irq_remapping.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: tip/drivers/iommu/irq_remapping.c
===================================================================
--- tip.orig/drivers/iommu/irq_remapping.c
+++ tip/drivers/iommu/irq_remapping.c
@@ -51,7 +51,7 @@ static void irq_remapping_disable_io_api
 
 static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 {
-	int node, ret, sub_handle, nvec_pow2, index = 0;
+	int ret, sub_handle, nvec_pow2, index = 0;
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
@@ -61,8 +61,7 @@ static int do_setup_msi_irqs(struct pci_
 	WARN_ON(msidesc->msi_attrib.multiple);
 	WARN_ON(msidesc->nvec_used);
 
-	node = dev_to_node(&dev->dev);
-	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
+	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
 	if (irq == 0)
 		return -ENOSPC;
 
@@ -89,7 +88,7 @@ static int do_setup_msi_irqs(struct pci_
 	return 0;
 
 error:
-	destroy_irqs(irq, nvec);
+	irq_free_hwirqs(irq, nvec);
 
 	/*
 	 * Restore altered MSI descriptor fields and prevent just destroyed
@@ -109,12 +108,11 @@ static int do_setup_msix_irqs(struct pci
 	unsigned int irq;
 
 	node		= dev_to_node(&dev->dev);
-	irq		= get_nr_irqs_gsi();
 	sub_handle	= 0;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 
-		irq = create_irq_nr(irq, node);
+		irq = irq_alloc_hwirq(node);
 		if (irq == 0)
 			return -1;
 
@@ -137,7 +135,7 @@ static int do_setup_msix_irqs(struct pci
 	return 0;
 
 error:
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 	return ret;
 }
 


