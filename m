Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaEGPoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:48521 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:54 -0400
Message-Id: <20140507154335.452206351@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [patch 08/32] x86: htirq: Use irq_alloc/free_irq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-htirq-use-irq-alloc-hwirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just cleaned up a bit.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/htirq.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: tip/drivers/pci/htirq.c
===================================================================
--- tip.orig/drivers/pci/htirq.c
+++ tip/drivers/pci/htirq.c
@@ -87,12 +87,9 @@ void unmask_ht_irq(struct irq_data *data
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 {
 	struct ht_irq_cfg *cfg;
+	int max_irq, pos, irq;
 	unsigned long flags;
 	u32 data;
-	int max_irq;
-	int pos;
-	int irq;
-	int node;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -120,10 +117,8 @@ int __ht_create_irq(struct pci_dev *dev,
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
-	node = dev_to_node(&dev->dev);
-	irq = create_irq_nr(0, node);
-
-	if (irq <= 0) {
+	irq = irq_alloc_hwirq(dev_to_node(&dev->dev));
+	if (!irq) {
 		kfree(cfg);
 		return -EBUSY;
 	}
@@ -166,7 +161,7 @@ void ht_destroy_irq(unsigned int irq)
 	cfg = irq_get_handler_data(irq);
 	irq_set_chip(irq, NULL);
 	irq_set_handler_data(irq, NULL);
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 
 	kfree(cfg);
 }


