Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaKIPKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:10:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:62453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaKIPKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:10:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933411"
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
Subject: [RFC Part4 v1 14/17] x86, PCI, MSI: Use common code to manage MSI interrupts
Date: Sun,  9 Nov 2014 23:10:36 +0800
Message-Id: <1415545839-28263-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert x86 PCI MSI interrupt driver to use common MSI code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |  200 ++++++++++++++++++++++++++------------------
 drivers/pci/msi.c          |    7 +-
 include/linux/msi.h        |    1 +
 3 files changed, 124 insertions(+), 84 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 9774092012b8..6bd339ed59f5 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -57,7 +57,7 @@ static void msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
  */
-static struct irq_chip msi_chip = {
+static struct irq_chip pci_msi_type = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
@@ -104,25 +104,65 @@ irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg)
 	return info->msi_hwirq;
 }
 
-void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq)
+static void pci_msi_generate_hwirq(struct msi_domain_info *minfo, void *arg,
+				   struct msi_desc *desc)
 {
 	struct irq_alloc_info *info = arg;
 
-	info->msi_hwirq = hwirq;
+	info->msi_hwirq = pci_msi_calc_hwirq(info->msi_dev, desc);
 }
 
+static irq_hw_number_t pci_msi_get_hwirq(struct msi_domain_info *minfo,
+					 void *arg)
+{
+	struct irq_alloc_info *info = arg;
+
+	return info->msi_hwirq;
+}
+
+static int pci_msi_init(struct irq_domain *domain,
+			struct msi_domain_info *minfo, unsigned int virq,
+			irq_hw_number_t hwirq, void *arg)
+{
+	irq_domain_set_info(domain, virq, hwirq, minfo->chip, NULL,
+			    handle_edge_irq, NULL, "edge");
+
+	return 0;
+}
+
+static void pci_msi_free(struct irq_domain *domain,
+			 struct msi_domain_info *info, unsigned int virq)
+{
+	struct msi_desc *desc = irq_get_msi_desc(virq);
+
+	if (desc)
+		desc->irq = 0;
+}
+
+static struct msi_domain_ops pci_msi_ops = {
+	.calc_hwirq = pci_msi_generate_hwirq,
+	.get_hwirq = pci_msi_get_hwirq,
+	.msi_init = pci_msi_init,
+	.msi_free = pci_msi_free,
+};
+
+static struct msi_domain_info pci_msi_info = {
+	.ops = &pci_msi_ops,
+	.chip = &pci_msi_type,
+};
+
 void arch_init_msi_domain(struct irq_domain *parent)
 {
 	if (disable_apic)
 		return;
 
-	msi_default_domain = pci_msi_create_irq_domain(NULL, &msi_chip, parent);
+	msi_default_domain = msi_create_irq_domain(NULL, &pci_msi_info, parent);
 	if (!msi_default_domain)
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
 }
 
 #ifdef CONFIG_IRQ_REMAP
-static struct irq_chip msi_ir_chip = {
+static struct irq_chip pci_msi_ir_chip = {
 	.name			= "IR-PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
@@ -133,9 +173,14 @@ static struct irq_chip msi_ir_chip = {
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
+static struct msi_domain_info pci_msi_ir_info = {
+	.ops = &pci_msi_ops,
+	.chip = &pci_msi_ir_chip,
+};
+
 struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	return pci_msi_create_irq_domain(NULL, &msi_ir_chip, parent);
+	return msi_create_irq_domain(NULL, &pci_msi_ir_info, parent);
 }
 #endif
 
@@ -157,42 +202,34 @@ static struct irq_chip dmar_msi_type = {
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-static int dmar_domain_alloc(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs, void *arg)
+static irq_hw_number_t dmar_msi_get_hwirq(struct msi_domain_info *minfo,
+					  void *arg)
 {
 	struct irq_alloc_info *info = arg;
-	int ret;
 
-	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_DMAR)
-		return -EINVAL;
-	if (irq_find_mapping(domain, info->dmar_id)) {
-		pr_warn("IRQ for DMAR%d already exists.\n", info->dmar_id);
-		return -EEXIST;
-	}
-
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
-	if (ret >= 0) {
-		irq_domain_set_hwirq_and_chip(domain, virq, info->dmar_id,
-					      &dmar_msi_type, NULL);
-		irq_set_handler_data(virq, info->dmar_data);
-		__irq_set_handler(virq, handle_edge_irq, 0, "edge");
-	}
-
-	return ret;
+	return info->dmar_id;
 }
 
-static void dmar_domain_free(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs)
+static int dmar_msi_init(struct irq_domain *domain,
+			 struct msi_domain_info *minfo, unsigned int virq,
+			 irq_hw_number_t hwirq, void *arg)
 {
-	BUG_ON(nr_irqs > 1);
-	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+	struct irq_alloc_info *info = arg;
+
+	irq_domain_set_info(domain, virq, hwirq, minfo->chip, NULL,
+			    handle_edge_irq, info->dmar_data, "edge");
+
+	return 0;
 }
 
-static struct irq_domain_ops dmar_domain_ops = {
-	.alloc = dmar_domain_alloc,
-	.free = dmar_domain_free,
-	.activate = msi_domain_activate,
-	.deactivate = msi_domain_deactivate,
+static struct msi_domain_ops dmar_msi_ops = {
+	.get_hwirq = dmar_msi_get_hwirq,
+	.msi_init = dmar_msi_init,
+};
+
+static struct msi_domain_info dmar_msi_info = {
+	.ops = &dmar_msi_ops,
+	.chip = &dmar_msi_type,
 };
 
 static struct irq_domain *dmar_get_irq_domain(void)
@@ -200,11 +237,13 @@ static struct irq_domain *dmar_get_irq_domain(void)
 	static struct irq_domain *dmar_domain;
 	static DEFINE_MUTEX(dmar_lock);
 
+	if (x86_vector_domain == NULL)
+		return NULL;
+
 	mutex_lock(&dmar_lock);
 	if (dmar_domain == NULL) {
-		dmar_domain = irq_domain_add_tree(NULL, &dmar_domain_ops, NULL);
-		if (dmar_domain)
-			dmar_domain->parent = x86_vector_domain;
+		dmar_domain = msi_create_irq_domain(NULL, &dmar_msi_info,
+						    x86_vector_domain);
 	}
 	mutex_unlock(&dmar_lock);
 
@@ -237,11 +276,6 @@ void dmar_free_hwirq(int irq)
  * MSI message composition
  */
 #ifdef CONFIG_HPET_TIMER
-static inline int hpet_dev_id(struct irq_domain *domain)
-{
-	return (int)(long)domain->host_data;
-}
-
 static void hpet_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	hpet_msi_write(data->handler_data, msg);
@@ -259,69 +293,73 @@ static struct irq_chip hpet_msi_type = {
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
-static int hpet_domain_alloc(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs, void *arg)
+static inline int hpet_dev_id(struct irq_domain *domain)
+{
+	struct msi_domain_info *minfo = msi_get_domain_info(domain);
+
+	return (int)(long)minfo->data;
+}
+
+static irq_hw_number_t hpet_msi_get_hwirq(struct msi_domain_info *minfo,
+					  void *arg)
 {
 	struct irq_alloc_info *info = arg;
-	int ret;
 
-	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_HPET)
-		return -EINVAL;
-	if (irq_find_mapping(domain, info->hpet_index)) {
-		pr_warn("IRQ for HPET%d already exists.\n", info->hpet_index);
-		return -EEXIST;
-	}
+	return info->hpet_index;
+}
 
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
-	if (ret >= 0) {
-		irq_set_status_flags(virq, IRQ_MOVE_PCNTXT);
-		irq_domain_set_hwirq_and_chip(domain, virq, info->hpet_index,
-					      &hpet_msi_type, NULL);
-		irq_set_handler_data(virq, info->hpet_data);
-		__irq_set_handler(virq, handle_edge_irq, 0, "edge");
-	}
+static int hpet_msi_init(struct irq_domain *domain,
+			 struct msi_domain_info *minfo, unsigned int virq,
+			 irq_hw_number_t hwirq, void *arg)
+{
+	struct irq_alloc_info *info = arg;
+
+	irq_set_status_flags(virq, IRQ_MOVE_PCNTXT);
+	irq_domain_set_info(domain, virq, hwirq, minfo->chip, NULL,
+			    handle_edge_irq, info->hpet_data, "edge");
 
-	return ret;
+	return 0;
 }
 
-static void hpet_domain_free(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs)
+static void hpet_msi_free(struct irq_domain *domain,
+			  struct msi_domain_info *info, unsigned int virq)
 {
-	BUG_ON(nr_irqs > 1);
 	irq_clear_status_flags(virq, IRQ_MOVE_PCNTXT);
-	irq_domain_free_irqs_top(domain, virq, nr_irqs);
 }
 
-static struct irq_domain_ops hpet_domain_ops = {
-	.alloc = hpet_domain_alloc,
-	.free = hpet_domain_free,
-	.activate = msi_domain_activate,
-	.deactivate = msi_domain_deactivate,
+static struct msi_domain_ops hpet_msi_ops = {
+	.get_hwirq = hpet_msi_get_hwirq,
+	.msi_init = hpet_msi_init,
+	.msi_free = hpet_msi_free,
 };
 
 struct irq_domain *hpet_create_irq_domain(int hpet_id)
 {
-	struct irq_domain *domain;
+	struct irq_domain *parent;
+	struct msi_domain_info *minfo;
 	struct irq_alloc_info info;
 
 	if (x86_vector_domain == NULL)
 		return NULL;
 
+	minfo = kzalloc(sizeof(*minfo), GFP_KERNEL);
+	if (minfo == NULL)
+		return NULL;
+
+	minfo->ops = &hpet_msi_ops;
+	minfo->chip = &hpet_msi_type;
+	minfo->data = (void *)(long)hpet_id;
+
 	init_irq_alloc_info(&info, NULL);
 	info.type = X86_IRQ_ALLOC_TYPE_HPET;
 	info.hpet_id = hpet_id;
+	parent = irq_remapping_get_ir_irq_domain(&info);
+	if (parent)
+		hpet_msi_type.name = "IR-HPET-MSI";
+	else
+		parent = x86_vector_domain;
 
-	domain = irq_domain_add_tree(NULL, &hpet_domain_ops,
-				     (void *)(long)hpet_id);
-	if (domain) {
-		domain->parent = irq_remapping_get_ir_irq_domain(&info);
-		if (!domain->parent)
-			domain->parent = x86_vector_domain;
-		else
-			hpet_msi_type.name = "IR-HPET-MSI";
-	}
-
-	return domain;
+	return msi_create_irq_domain(NULL, minfo, parent);
 }
 
 int hpet_assign_irq(struct irq_domain *domain, struct hpet_dev *dev,
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 17343cb4d756..adfabc9add24 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1091,8 +1091,7 @@ void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
  * Generate a unique ID number for each possible MSI source, the ID number
  * is only used within the irqdomain.
  */
-static inline irq_hw_number_t
-msi_get_hwirq(struct pci_dev *dev, struct msi_desc *desc)
+irq_hw_number_t pci_msi_calc_hwirq(struct pci_dev *dev, struct msi_desc *desc)
 {
 	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
 		PCI_DEVID(dev->bus->number, dev->devfn) << 11 |
@@ -1163,9 +1162,11 @@ int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
 	int i, virq;
 	struct msi_desc *desc;
 	int node = dev_to_node(&dev->dev);
+	struct msi_domain_info *info = domain->host_data;
 
 	list_for_each_entry(desc, &dev->msi_list, list) {
-		arch_msi_irq_domain_set_hwirq(arg, msi_get_hwirq(dev, desc));
+		if (info->ops->calc_hwirq)
+			info->ops->calc_hwirq(info, arg, desc);
 		virq = irq_domain_alloc_irqs(domain, desc->nvec_used,
 					     node, arg);
 		if (virq < 0) {
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 43c0a7ae0df7..7b102148c4c6 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -123,6 +123,7 @@ struct irq_domain *pci_msi_create_irq_domain(struct device_node *of_node,
 void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
 int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
 			      struct pci_dev *dev, void *arg);
+irq_hw_number_t pci_msi_calc_hwirq(struct pci_dev *dev, struct msi_desc *desc);
 
 irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg);
 void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq);
-- 
1.7.10.4

