Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaIKOHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:07:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:23636 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaIKOC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739298"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 15/21] x86, MSI: Use hierarchy irqdomain to manage MSI interrupts
Date: Thu, 11 Sep 2014 22:03:42 +0800
Message-Id: <1410444228-3134-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance MSI code to support hierarchy irqdomain, it helps to make
the and and architecture more clear.


Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h        |    6 +
 arch/x86/include/asm/irq_remapping.h |    6 +-
 arch/x86/kernel/apic/msi.c           |  225 +++++++++++++++++++++++++++++-----
 arch/x86/kernel/apic/vector.c        |    2 +
 drivers/iommu/irq_remapping.c        |    1 -
 5 files changed, 204 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 57f81f5a9686..9f705c49f850 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -199,6 +199,12 @@ static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
+#ifdef	CONFIG_PCI_MSI
+extern void arch_init_msi_domain(struct irq_domain *domain);
+#else
+static inline void arch_init_msi_domain(struct irq_domain *domain) { }
+#endif
+
 /* Statistics */
 extern atomic_t irq_err_count;
 extern atomic_t irq_mis_count;
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 428b4e6d637c..440053ca7515 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -73,11 +73,7 @@ extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
  * Create MSI/MSIx irqdomain for interrupt remapping device, use @parent as
  * parent irqdomain.
  */
-static inline struct irq_domain *
-arch_create_msi_irq_domain(struct irq_domain *parent)
-{
-	return NULL;
-}
+extern struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent);
 
 /* Get parent irqdomain for interrupt remapping irqdomain */
 static inline struct irq_domain *arch_get_ir_parent_domain(void)
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 709fedab44f2..5696703271af 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
  *	Moved from arch/x86/kernel/apic/io_apic.c.
+ * Jiang Liu <jiang.liu@linux.intel.com>
+ *	Add support of hierarchy irqdomain
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,6 +23,8 @@
 #include <asm/apic.h>
 #include <asm/irq_remapping.h>
 
+static struct irq_domain *msi_default_domain;
+
 void native_compose_msi_msg(struct pci_dev *pdev,
 			    unsigned int irq, unsigned int dest,
 			    struct msi_msg *msg, u8 hpet_id)
@@ -76,28 +80,32 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	return 0;
 }
 
-static int
-msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+static bool msi_remapped(struct irq_domain *domain)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-	struct msi_msg msg;
-	unsigned int dest;
-	int ret;
-
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
+	return domain->host_data != NULL;
+}
 
-	__get_cached_msi_msg(data->msi_desc, &msg);
+static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
+{
+	struct irq_data *parent = data->parent_data;
+	int ret;
 
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	/* No need to reprogram MSI registers if interrupt is remapped */
+	if (ret >= 0 && !msi_remapped(data->domain)) {
+		struct irq_cfg *cfg = irqd_cfg(data);
+		struct msi_msg msg;
 
-	__write_msi_msg(data->msi_desc, &msg);
+		__get_cached_msi_msg(data->msi_desc, &msg);
+		msg.data &= ~MSI_DATA_VECTOR_MASK;
+		msg.data |= MSI_DATA_VECTOR(cfg->vector);
+		msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+		msg.address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);
+		__write_msi_msg(data->msi_desc, &msg);
+	}
 
-	return IRQ_SET_MASK_OK_NOCOPY;
+	return ret;
 }
 
 /*
@@ -108,9 +116,105 @@ static struct irq_chip msi_chip = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
-	.irq_ack		= apic_ack_edge,
+	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_print_chip		= irq_remapping_print_chip,
+};
+
+static inline irq_hw_number_t
+get_hwirq_from_pcidev(struct pci_dev *pdev, struct msi_desc *msidesc)
+{
+	return (irq_hw_number_t)msidesc->msi_attrib.entry_nr |
+		PCI_DEVID(pdev->bus->number, pdev->devfn) << 11 |
+		(pci_domain_nr(pdev->bus) & 0xFFFFFFFF) << 27;
+}
+
+static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq;
+	struct irq_alloc_info *info = arg;
+
+	hwirq = get_hwirq_from_pcidev(info->msi_dev, info->msi_desc);
+	if (irq_find_mapping(domain, hwirq) > 0)
+		return -EEXIST;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_set_msi_desc_off(virq, i, info->msi_desc);
+		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
+					      &msi_chip, (void *)(long)i);
+		__irq_set_handler(virq + i, handle_edge_irq, 0, "edge");
+		dev_dbg(&info->msi_dev->dev, "irq %d for MSI/MSI-X\n",
+			virq + i);
+	}
+
+	return ret;
+}
+
+static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs)
+{
+	int i;
+	struct msi_desc *msidesc = irq_get_msi_desc(virq);
+
+	if (msidesc)
+		msidesc->irq = 0;
+	for (i = 0; i < nr_irqs; i++) {
+		irq_set_handler(virq + i, NULL);
+		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
+	}
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int msi_domain_activate(struct irq_domain *domain,
+			       struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
+
+	/*
+	 * irq_data->chip_data is MSI/MSIx offset.
+	 * MSI-X message is written per-IRQ, the offset is always 0.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (irq_data->chip_data)
+		return 0;
+
+	if (msi_remapped(domain))
+		irq_remapping_get_msi_entry(irq_data->parent_data, &msg);
+	else
+		native_compose_msi_msg(NULL, irq_data->irq, cfg->dest_apicid,
+				       &msg, 0);
+	write_msi_msg(irq_data->irq, &msg);
+
+	return 0;
+}
+
+static int msi_domain_deactivate(struct irq_domain *domain,
+				 struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	if (irq_data->chip_data)
+		return 0;
+
+	memset(&msg, 0, sizeof(msg));
+	write_msi_msg(irq_data->irq, &msg);
+
+	return 0;
+}
+
+static struct irq_domain_ops msi_domain_ops = {
+	.alloc = msi_domain_alloc,
+	.free = msi_domain_free,
+	.activate = msi_domain_activate,
+	.deactivate = msi_domain_deactivate,
 };
 
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
@@ -145,25 +249,56 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
+	int irq, cnt, nvec_pow2;
+	struct irq_domain *domain;
 	struct msi_desc *msidesc;
-	int irq, ret;
+	struct irq_alloc_info info;
+	int node = dev_to_node(&dev->dev);
+
+	if (disable_apic)
+		return -ENOSYS;
 
-	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+	init_irq_alloc_info(&info, NULL);
+	info.msi_dev = dev;
+	if (type == PCI_CAP_ID_MSI) {
+		msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+		WARN_ON(!list_is_singular(&dev->msi_list));
+		WARN_ON(msidesc->irq);
+		WARN_ON(msidesc->msi_attrib.multiple);
+		WARN_ON(msidesc->nvec_used);
+		info.type = X86_IRQ_ALLOC_TYPE_MSI;
+		cnt = nvec;
+	} else {
+		info.type = X86_IRQ_ALLOC_TYPE_MSIX;
+		cnt = 1;
+	}
+
+	domain = irq_remapping_get_irq_domain(&info);
+	if (domain == NULL) {
+		/*
+		 * Multiple MSI vectors only supported with interrupt
+		 * remapping
+		 */
+		if (type == PCI_CAP_ID_MSI && nvec > 1)
+			return 1;
+		domain = msi_default_domain;
+	}
+	if (domain == NULL)
+		return -ENOSYS;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_domain_alloc_irqs(NULL, -1, 1, NUMA_NO_NODE, NULL);
+		info.msi_desc = msidesc;
+		irq = irq_domain_alloc_irqs(domain, -1, cnt, node, &info);
 		if (irq <= 0)
 			return -ENOSPC;
+	}
 
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0) {
-			irq_domain_free_irqs(irq, 1);
-			return ret;
-		}
-
+	if (type == PCI_CAP_ID_MSI) {
+		nvec_pow2 = __roundup_pow_of_two(nvec);
+		msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
+		msidesc->nvec_used = nvec;
 	}
+
 	return 0;
 }
 
@@ -172,6 +307,36 @@ void native_teardown_msi_irq(unsigned int irq)
 	irq_domain_free_irqs(irq, 1);
 }
 
+static struct irq_domain *msi_create_domain(struct irq_domain *parent,
+					    int remapped)
+{
+	struct irq_domain *domain;
+
+	domain = irq_domain_add_tree(NULL, &msi_domain_ops,
+				     (void *)(long)remapped);
+	if (domain)
+		domain->parent = parent;
+
+	return domain;
+}
+
+void arch_init_msi_domain(struct irq_domain *parent)
+{
+	if (disable_apic)
+		return;
+
+	msi_default_domain = msi_create_domain(parent, 0);
+	if (!msi_default_domain)
+		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
+}
+
+#ifdef CONFIG_IRQ_REMAP
+struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
+{
+	return msi_create_domain(parent, 1);
+}
+#endif
+
 #ifdef CONFIG_DMAR_TABLE
 static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 774ab5ba95f2..e9329fc28c63 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -357,6 +357,8 @@ int __init arch_early_irq_init(void)
 	BUG_ON(x86_vector_domain == NULL);
 	irq_set_default_host(x86_vector_domain);
 
+	arch_init_msi_domain(x86_vector_domain);
+
 	return arch_early_ioapic_init();
 }
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 7ac44a464be0..bda0d8e73fde 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -178,7 +178,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
-	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
 }
-- 
1.7.10.4

