Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaKKM7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:59:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:22547 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaKKM7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:59:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="635030843"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch] PCI/MSI: Enhance core to support hierarchy irqdomain
Date: Tue, 11 Nov 2014 21:02:18 +0800
Message-Id: <1415710943-6001-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415283644-2559-22-git-send-email-jiang.liu@linux.intel.com>
References: <1415283644-2559-22-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance PCI MSI core to support hierarchy irqdomain, so the common
code could be shared among architectures.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Thomas,
	This update fixes a possible conflict on other architectures
when they try to use the new MSI hierarchy irqdomain, as pointed out by
Suravee Suthikulanit. The main change is as below.
Regards!
Gerry

 static void msi_domain_deactivate(struct irq_domain *domain,
 				  struct irq_data *irq_data)
 {
 	struct msi_msg msg;
+	struct msi_desc *desc = irq_data->msi_desc;
 
-	if (!irq_data->chip_data) {
+	if (desc->irq == irq_data->irq) {
 		memset(&msg, 0, sizeof(msg));
 		__write_msi_msg(irq_data->msi_desc, &msg);
 	}
---
 drivers/pci/Kconfig |    4 ++
 drivers/pci/msi.c   |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/msi.h |   14 ++++++
 3 files changed, 151 insertions(+)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index b9db0f2ce11f..022e89745f86 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -16,6 +16,10 @@ config PCI_MSI
 
 	   If you don't know what to do here, say Y.
 
+config PCI_MSI_IRQ_DOMAIN
+	bool
+	depends on PCI_MSI && IRQ_DOMAIN_HIERARCHY
+
 config PCI_DEBUG
 	bool "PCI Debugging"
 	depends on PCI && DEBUG_KERNEL
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index da181c59394b..365e969f5e8d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/irqdomain.h>
 
 #include "pci.h"
 
@@ -1098,3 +1099,135 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msix_range);
+
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+/*
+ * Generate a unique ID number for each possible MSI source, the ID number
+ * is only used within the irqdomain.
+ */
+static inline irq_hw_number_t
+msi_get_hwirq(struct pci_dev *dev, struct msi_desc *desc)
+{
+	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
+		PCI_DEVID(dev->bus->number, dev->devfn) << 11 |
+		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
+}
+
+static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq = arch_msi_irq_domain_get_hwirq(arg);
+
+	if (irq_find_mapping(domain, hwirq) > 0)
+		return -EEXIST;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
+					      domain->host_data, NULL);
+		__irq_set_handler(virq + i, handle_edge_irq, 0, "edge");
+	}
+
+	return ret;
+}
+
+static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs)
+{
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct msi_desc *desc = irq_get_msi_desc(virq);
+
+		if (desc)
+			desc->irq = 0;
+	}
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+}
+
+static void msi_domain_activate(struct irq_domain *domain,
+				struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+	struct msi_desc *desc = irq_data->msi_desc;
+
+	/*
+	 * MSI-X message is written per-IRQ.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (desc->irq == irq_data->irq) {
+		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+		__write_msi_msg(irq_data->msi_desc, &msg);
+	}
+}
+
+static void msi_domain_deactivate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+	struct msi_desc *desc = irq_data->msi_desc;
+
+	if (desc->irq == irq_data->irq) {
+		memset(&msg, 0, sizeof(msg));
+		__write_msi_msg(irq_data->msi_desc, &msg);
+	}
+}
+
+static struct irq_domain_ops msi_domain_ops = {
+	.alloc = msi_domain_alloc,
+	.free = msi_domain_free,
+	.activate = msi_domain_activate,
+	.deactivate = msi_domain_deactivate,
+};
+
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct irq_chip *chip,
+					 struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	domain = irq_domain_add_tree(of_node, &msi_domain_ops, chip);
+	if (!domain)
+		return NULL;
+
+	domain->parent = parent;
+
+	return domain;
+}
+
+int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
+			      struct pci_dev *dev, void *arg)
+{
+	int i, virq;
+	struct msi_desc *desc;
+	int node = dev_to_node(&dev->dev);
+
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		arch_msi_irq_domain_set_hwirq(arg, msi_get_hwirq(dev, desc));
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
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 44f4746d033b..662c628fc2fa 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -75,4 +75,18 @@ struct msi_chip {
 	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
 };
 
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+struct irq_domain;
+struct irq_chip;
+
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct irq_chip *chip,
+					 struct irq_domain *parent);
+int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
+			      struct pci_dev *dev, void *arg);
+
+irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg);
+void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq);
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
+
 #endif /* LINUX_MSI_H */
-- 
1.7.10.4

