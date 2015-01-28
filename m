Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbbA1UsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:48:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45527 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbbA1UsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:06 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andre Przywara <andre.przywara@arm.com>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: Fix pcibios_update_irq misuse of irq number
Date: Wed, 28 Jan 2015 14:51:23 +0000
Message-Id: <1422456683-797-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_update_irq writes an irq number into the config space
of a given PCI device, but ignores the fact that this number
is a virtual interrupt number, which might be a very different
value from what the underlying hardware is using.

The obvious fix is to fetch the HW interrupt number from the
corresponding irq_data structure. This is slightly complicated
by the fact that this interrupt might be services by a stacked
domain.

This has been tested on KVM with kvmtool.

Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/setup-irq.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index 4e2d595..828cbc9 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -15,11 +15,19 @@
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/cache.h>
+#include <linux/irq.h>
 
 void __weak pcibios_update_irq(struct pci_dev *dev, int irq)
 {
-	dev_dbg(&dev->dev, "assigning IRQ %02d\n", irq);
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
+	struct irq_data *d;
+
+	d = irq_get_irq_data(irq);
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	while (d->parent_data)
+		d = d->parent_data;
+#endif
+	dev_dbg(&dev->dev, "assigning IRQ %02ld\n", d->hwirq);
+	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, d->hwirq);
 }
 
 static void pdev_fixup_irq(struct pci_dev *dev,
-- 
2.1.4

