Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbaEGPy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:54:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:48526 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEGPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:54 -0400
Message-Id: <20140507154335.749579081@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 09/32] x86: ioapic: Use irq_alloc/free_hwirq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-use-irq-alloc-hwirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change just less crap.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/kernel/apic/io_apic.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3169,8 +3169,8 @@ int setup_msi_irq(struct pci_dev *dev, s
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
+	unsigned int irq;
 	int node, ret;
 
 	/* Multiple MSI vectors only supported with interrupt remapping */
@@ -3178,28 +3178,25 @@ int native_setup_msi_irqs(struct pci_dev
 		return 1;
 
 	node = dev_to_node(&dev->dev);
-	irq_want = nr_irqs_gsi;
+
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want, node);
-		if (irq == 0)
+		irq = irq_alloc_hwirq(node);
+		if (!irq)
 			return -ENOSPC;
 
-		irq_want = irq + 1;
-
 		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0)
-			goto error;
+		if (ret < 0) {
+			irq_free_hwirq(irq);
+			return ret;
+		}
+
 	}
 	return 0;
-
-error:
-	destroy_irq(irq);
-	return ret;
 }
 
 void native_teardown_msi_irq(unsigned int irq)
 {
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 }
 
 #ifdef CONFIG_DMAR_TABLE


