Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaKLNnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:43:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:41735 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaKLNnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:17 -0500
Message-Id: <20141112134121.196562300@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 16/16] PCI/MSI: Enhance core to support hierarchy irqdomain
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=pci-msi-enhance-core-to-support-hierarchy-irqdomain.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Enhance PCI MSI core to support hierarchy irqdomain, so the common
code can be shared across architectures.

[ tglx: Extracted and combined from several patches ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/Kconfig |    5 ++++
 drivers/pci/msi.c   |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/msi.h |    8 ++++++
 3 files changed, 75 insertions(+)

Index: tip/drivers/pci/Kconfig
===================================================================
--- tip.orig/drivers/pci/Kconfig
+++ tip/drivers/pci/Kconfig
@@ -17,6 +17,11 @@ config PCI_MSI
 
 	   If you don't know what to do here, say Y.
 
+config PCI_MSI_IRQ_DOMAIN
+	bool
+	depends on PCI_MSI
+	select GENERIC_MSI_IRQ_DOMAIN
+
 config PCI_DEBUG
 	bool "PCI Debugging"
 	depends on PCI && DEBUG_KERNEL
Index: tip/drivers/pci/msi.c
===================================================================
--- tip.orig/drivers/pci/msi.c
+++ tip/drivers/pci/msi.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/irqdomain.h>
 
 #include "pci.h"
 
@@ -1072,3 +1073,64 @@ int pci_enable_msix_range(struct pci_dev
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msix_range);
+
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data->msi_desc;
+
+	/*
+	 * MSI-X message is written per-IRQ.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (desc->irq == irq_data->irq)
+		pci_write_msi_msg(desc, msg);
+}
+
+/*
+ * Generate a unique ID number for each possible MSI source, the ID number
+ * is only used within the irqdomain.
+ */
+irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
+					  struct msi_desc *desc)
+{
+	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
+		PCI_DEVID(dev->bus->number, dev->devfn) << 11 |
+		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
+}
+
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, int type,
+			      struct pci_dev *dev, void *arg)
+{
+	struct msi_domain_info *info = domain->host_data;
+	int node = dev_to_node(&dev->dev);
+	struct msi_desc *desc;
+	int i, virq;
+
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		if (info->ops->calc_hwirq)
+			info->ops->calc_hwirq(info, arg, desc);
+
+		virq = irq_domain_alloc_irqs(domain, desc->nvec_used,
+					     node, arg);
+		if (virq < 0) {
+			/* Special handling for pci_enable_msi_range(). */
+			if (type == PCI_CAP_ID_MSI && desc->nvec_used > 1)
+				return 1;
+			else
+				return -ENOSPC;
+		}
+		for (i = 0; i < desc->nvec_used; i++)
+			irq_set_msi_desc_off(virq, i, desc);
+	}
+
+	list_for_each_entry(desc, &dev->msi_list, list)
+		if (desc->nvec_used == 1)
+			dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", virq);
+		else
+			dev_dbg(&dev->dev, "irq [%d-%d] for MSI/MSI-X\n",
+				virq, virq + desc->nvec_used - 1);
+
+	return 0;
+}
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
Index: tip/include/linux/msi.h
===================================================================
--- tip.orig/include/linux/msi.h
+++ tip/include/linux/msi.h
@@ -112,4 +112,12 @@ struct msi_domain_info *msi_get_domain_i
 
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, int type,
+			      struct pci_dev *dev, void *arg);
+irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
+					  struct msi_desc *desc);
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
+
 #endif /* LINUX_MSI_H */


