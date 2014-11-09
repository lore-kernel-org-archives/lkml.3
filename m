Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaKIPKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:10:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:48707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaKIPKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:10:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933467"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 15/17] PCI, MSI: Clean up unused irqdomain related code
Date: Sun,  9 Nov 2014 23:10:37 +0800
Message-Id: <1415545839-28263-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI MSI has been converted to use common MSI code, so kill unsued code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |    9 +------
 drivers/pci/msi.c          |   62 ++------------------------------------------
 include/linux/msi.h        |   13 ++--------
 kernel/irq/msi.c           |    6 +++--
 4 files changed, 9 insertions(+), 81 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 6bd339ed59f5..15168893fcc3 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -89,7 +89,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	if (domain == NULL)
 		return -ENOSYS;
 
-	return msi_irq_domain_alloc_irqs(domain, type, dev, &info);
+	return pci_msi_irq_domain_alloc_irqs(domain, type, dev, &info);
 }
 
 void native_teardown_msi_irq(unsigned int irq)
@@ -97,13 +97,6 @@ void native_teardown_msi_irq(unsigned int irq)
 	irq_domain_free_irqs(irq, 1);
 }
 
-irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg)
-{
-	struct irq_alloc_info *info = arg;
-
-	return info->msi_hwirq;
-}
-
 static void pci_msi_generate_hwirq(struct msi_domain_info *minfo, void *arg,
 				   struct msi_desc *desc)
 {
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index adfabc9add24..1c5c7720b74c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1098,66 +1098,8 @@ irq_hw_number_t pci_msi_calc_hwirq(struct pci_dev *dev, struct msi_desc *desc)
 		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
 }
 
-static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
-			    unsigned int nr_irqs, void *arg)
-{
-	int i, ret;
-	irq_hw_number_t hwirq = arch_msi_irq_domain_get_hwirq(arg);
-
-	if (irq_find_mapping(domain, hwirq) > 0)
-		return -EEXIST;
-
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
-	if (ret < 0)
-		return ret;
-
-	for (i = 0; i < nr_irqs; i++) {
-		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
-					      domain->host_data, NULL);
-		__irq_set_handler(virq + i, handle_edge_irq, 0, "edge");
-	}
-
-	return ret;
-}
-
-static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
-			    unsigned int nr_irqs)
-{
-	int i;
-
-	for (i = 0; i < nr_irqs; i++) {
-		struct msi_desc *desc = irq_get_msi_desc(virq);
-
-		if (desc)
-			desc->irq = 0;
-	}
-	irq_domain_free_irqs_top(domain, virq, nr_irqs);
-}
-
-static struct irq_domain_ops msi_domain_ops = {
-	.alloc = msi_domain_alloc,
-	.free = msi_domain_free,
-	.activate = msi_domain_activate,
-	.deactivate = msi_domain_deactivate,
-};
-
-struct irq_domain *pci_msi_create_irq_domain(struct device_node *of_node,
-					     struct irq_chip *chip,
-					     struct irq_domain *parent)
-{
-	struct irq_domain *domain;
-
-	domain = irq_domain_add_tree(of_node, &msi_domain_ops, chip);
-	if (!domain)
-		return NULL;
-
-	domain->parent = parent;
-
-	return domain;
-}
-
-int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
-			      struct pci_dev *dev, void *arg)
+int pci_msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
+				  struct pci_dev *dev, void *arg)
 {
 	int i, virq;
 	struct msi_desc *desc;
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 7b102148c4c6..0c1446e48572 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -73,9 +73,6 @@ struct msi_domain_info {
 
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
-void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data);
-void msi_domain_deactivate(struct irq_domain *domain,
-			   struct irq_data *irq_data);
 struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 					 struct msi_domain_info *info,
 					 struct irq_domain *parent);
@@ -117,16 +114,10 @@ struct msi_chip {
 };
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
-struct irq_domain *pci_msi_create_irq_domain(struct device_node *of_node,
-					     struct irq_chip *chip,
-					     struct irq_domain *parent);
 void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
-int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
-			      struct pci_dev *dev, void *arg);
+int pci_msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
+				  struct pci_dev *dev, void *arg);
 irq_hw_number_t pci_msi_calc_hwirq(struct pci_dev *dev, struct msi_desc *desc);
-
-irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg);
-void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq);
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
 #endif /* CONFIG_PCI_MSI */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 85a50254d815..4f9f56e75804 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -43,7 +43,8 @@ int msi_domain_set_affinity(struct irq_data *irq_data,
 	return ret;
 }
 
-void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data)
+static void msi_domain_activate(struct irq_domain *domain,
+				struct irq_data *irq_data)
 {
 	struct msi_msg msg;
 
@@ -51,7 +52,8 @@ void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data)
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
-void msi_domain_deactivate(struct irq_domain *domain, struct irq_data *irq_data)
+static void msi_domain_deactivate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
 {
 	struct msi_msg msg;
 
-- 
1.7.10.4

