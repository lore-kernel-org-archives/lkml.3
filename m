Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaIZOCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:02:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:5513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbaIZOCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:02:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="609110258"
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
Subject: [RFT v2 15/24] x86, MSI: Use hierarchy irqdomain to manage MSI interrupts
Date: Fri, 26 Sep 2014 22:02:16 +0800
Message-Id: <1411740145-30626-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance MSI code to support hierarchy irqdomain, it helps to make
the architecture more clear.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h        |    8 +-
 arch/x86/include/asm/irq_remapping.h |    6 +-
 arch/x86/kernel/apic/msi.c           |  230 ++++++++++++++++++++++++++++------
 arch/x86/kernel/apic/vector.c        |    2 +
 drivers/iommu/irq_remapping.c        |    1 -
 5 files changed, 203 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 545460d470bd..a5d3b1c46b30 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -110,9 +110,9 @@ struct irq_2_irte {
 };
 #endif	/* CONFIG_IRQ_REMAP */
 
+struct irq_domain;
 #ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_data;
-struct irq_domain;
 struct pci_dev;
 struct msi_desc;
 
@@ -200,6 +200,12 @@ static inline void lock_vector_lock(void) {}
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
index 3653d10268cf..7f82841b1671 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -74,11 +74,7 @@ extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
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
index 6711edcd08e6..7a6c2710de40 100644
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
 static void msi_reset_irq_data_and_handler(struct irq_domain *domain, int virq)
 {
 	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
@@ -96,28 +100,28 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	return 0;
 }
 
-static int
-msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+static bool msi_irq_remapped(struct irq_data *irq_data)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-	struct msi_msg msg;
-	unsigned int dest;
-	int ret;
-
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
+	return irq_remapping_domain_is_remapped(irq_data->domain);
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
+	if (ret >= 0 && !msi_irq_remapped(data)) {
+		struct msi_msg msg;
 
-	__write_msi_msg(data->msi_desc, &msg);
+		__get_cached_msi_msg(data->msi_desc, &msg);
+		msi_update_msg(&msg, data);
+		__write_msi_msg(data->msi_desc, &msg);
+	}
 
-	return IRQ_SET_MASK_OK_NOCOPY;
+	return ret;
 }
 
 /*
@@ -128,9 +132,103 @@ static struct irq_chip msi_chip = {
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
+	for (i = 0; i < nr_irqs; i++)
+		msi_reset_irq_data_and_handler(domain, virq + i);
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
+	if (msi_irq_remapped(irq_data))
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
@@ -165,25 +263,56 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
+	int irq, cnt, nvec_pow2;
+	struct irq_domain *domain;
 	struct msi_desc *msidesc;
-	int irq, ret;
+	struct irq_alloc_info info;
+	int node = dev_to_node(&dev->dev);
 
-	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+	if (disable_apic)
+		return -ENOSYS;
+
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
-		irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
+		info.msi_desc = msidesc;
+		irq = irq_domain_alloc_irqs(domain, cnt, node, &info);
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
 
@@ -192,6 +321,38 @@ void native_teardown_msi_irq(unsigned int irq)
 	irq_domain_free_irqs(irq, 1);
 }
 
+static struct irq_domain *msi_create_domain(struct irq_domain *parent,
+					    bool remapped)
+{
+	struct irq_domain *domain;
+
+	domain = irq_domain_add_tree(NULL, &msi_domain_ops, NULL);
+	if (domain) {
+		domain->parent = parent;
+		if (remapped)
+			irq_remapping_domain_set_remapped(domain);
+	}
+
+	return domain;
+}
+
+void arch_init_msi_domain(struct irq_domain *parent)
+{
+	if (disable_apic)
+		return;
+
+	msi_default_domain = msi_create_domain(parent, false);
+	if (!msi_default_domain)
+		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
+}
+
+#ifdef CONFIG_IRQ_REMAP
+struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
+{
+	return msi_create_domain(parent, true);
+}
+#endif
+
 #ifdef CONFIG_DMAR_TABLE
 static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
@@ -262,11 +423,6 @@ static inline int hpet_dev_id(struct irq_domain *domain)
 	return (int)(long)domain->host_data;
 }
 
-static inline bool hpet_irq_remapped(struct irq_data *irq_data)
-{
-	return irq_remapping_domain_is_remapped(irq_data->domain);
-}
-
 static int hpet_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
 {
@@ -276,7 +432,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	/* No need to rewrite HPET registers if interrupt is remapped */
-	if (ret >= 0 && !hpet_irq_remapped(data)) {
+	if (ret >= 0 && !msi_irq_remapped(data)) {
 		hpet_msi_read(data->handler_data, &msg);
 		msi_update_msg(&msg, data);
 		hpet_msi_write(data->handler_data, &msg);
@@ -353,7 +509,7 @@ static int hpet_domain_activate(struct irq_domain *domain,
 	struct msi_msg msg;
 	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
-	if (hpet_irq_remapped(irq_data))
+	if (msi_irq_remapped(irq_data))
 		irq_remapping_get_msi_entry(irq_data->parent_data, &msg);
 	else
 		native_compose_msi_msg(NULL, irq_data->irq, cfg->dest_apicid,
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 0ad46c5c58a0..25db76fbe54f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -359,6 +359,8 @@ int __init arch_early_irq_init(void)
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

