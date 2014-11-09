Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaKIPKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:10:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:62417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaKIPKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:10:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933341"
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
Subject: [RFC Part4 v1 13/17] MSI: Provide irqdomain support for generic MSI
Date: Sun,  9 Nov 2014 23:10:35 +0800
Message-Id: <1415545839-28263-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance generic MSI code to support hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |    4 +--
 drivers/pci/msi.c          |    6 ++--
 include/linux/msi.h        |   29 ++++++++++++++++--
 kernel/irq/msi.c           |   70 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index f625c2f21377..9774092012b8 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -116,7 +116,7 @@ void arch_init_msi_domain(struct irq_domain *parent)
 	if (disable_apic)
 		return;
 
-	msi_default_domain = msi_create_irq_domain(NULL, &msi_chip, parent);
+	msi_default_domain = pci_msi_create_irq_domain(NULL, &msi_chip, parent);
 	if (!msi_default_domain)
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
 }
@@ -135,7 +135,7 @@ static struct irq_chip msi_ir_chip = {
 
 struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	return msi_create_irq_domain(NULL, &msi_ir_chip, parent);
+	return pci_msi_create_irq_domain(NULL, &msi_ir_chip, parent);
 }
 #endif
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 80be534df522..17343cb4d756 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1142,9 +1142,9 @@ static struct irq_domain_ops msi_domain_ops = {
 	.deactivate = msi_domain_deactivate,
 };
 
-struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
-					 struct irq_chip *chip,
-					 struct irq_domain *parent)
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *of_node,
+					     struct irq_chip *chip,
+					     struct irq_domain *parent)
 {
 	struct irq_domain *domain;
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 5639970db71d..43c0a7ae0df7 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -8,6 +8,7 @@ struct irq_data;
 struct irq_chip;
 struct irq_domain;
 struct device_node;
+struct irq_domain;
 
 struct msi_msg {
 	u32	address_lo;	/* low 32 bits of msi message address */
@@ -52,11 +53,33 @@ void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 #ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+struct msi_domain_info;
+
+struct msi_domain_ops {
+	void (*calc_hwirq)(struct msi_domain_info *info, void *arg,
+			   struct msi_desc *desc);
+	irq_hw_number_t (*get_hwirq)(struct msi_domain_info *info, void *arg);
+	int (*msi_init)(struct irq_domain *domain, struct msi_domain_info *info,
+			unsigned int virq, irq_hw_number_t hwirq, void *arg);
+	void (*msi_free)(struct irq_domain *domain,
+			 struct msi_domain_info *info, unsigned int virq);
+};
+
+struct msi_domain_info {
+	struct msi_domain_ops *ops;
+	struct irq_chip *chip;
+	void *data;
+};
+
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
 void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data);
 void msi_domain_deactivate(struct irq_domain *domain,
 			   struct irq_data *irq_data);
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent);
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
 #ifdef CONFIG_PCI_MSI
@@ -94,9 +117,9 @@ struct msi_chip {
 };
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
-struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
-					 struct irq_chip *chip,
-					 struct irq_domain *parent);
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *of_node,
+					     struct irq_chip *chip,
+					     struct irq_domain *parent);
 void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
 int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
 			      struct pci_dev *dev, void *arg);
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 6ae0bd7ee204..85a50254d815 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -58,4 +58,74 @@ void msi_domain_deactivate(struct irq_domain *domain, struct irq_data *irq_data)
 	memset(&msg, 0, sizeof(msg));
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
+
+static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	struct msi_domain_info *info = domain->host_data;
+	struct msi_domain_ops *ops = info->ops;
+	irq_hw_number_t hwirq = ops->get_hwirq(info, arg);
+
+	if (irq_find_mapping(domain, hwirq) > 0)
+		return -EEXIST;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		ret = ops->msi_init(domain, info, virq + i, hwirq + i, arg);
+		if (ret < 0) {
+			if (ops->msi_free) {
+				for (i--; i > 0; i--)
+					ops->msi_free(domain, info, virq + i);
+			}
+			irq_domain_free_irqs_top(domain, virq, nr_irqs);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs)
+{
+	int i;
+	struct msi_domain_info *info = domain->host_data;
+
+	if (info->ops->msi_free) {
+		for (i = 0; i < nr_irqs; i++)
+			info->ops->msi_free(domain, info, virq + i);
+	}
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
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
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	domain = irq_domain_add_tree(of_node, &msi_domain_ops, info);
+	if (!domain)
+		return NULL;
+
+	domain->parent = parent;
+
+	return domain;
+}
+
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
+{
+	return (struct msi_domain_info *)domain->host_data;
+}
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
-- 
1.7.10.4

