Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKFO0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:26:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:40171 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaKFOZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:25:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="618223724"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [Patch Part2 v5 22/31] x86, PCI, MSI: Use hierarchy irqdomain to manage MSI interrupts
Date: Thu,  6 Nov 2014 22:20:35 +0800
Message-Id: <1415283644-2559-23-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415283644-2559-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415283644-2559-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance MSI code to support hierarchy irqdomain, it helps to make
the architecture more clear.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/hw_irq.h        |    9 ++-
 arch/x86/include/asm/irq_remapping.h |    6 +-
 arch/x86/kernel/apic/msi.c           |  120 +++++++++++++++++-----------------
 arch/x86/kernel/apic/vector.c        |    2 +
 drivers/iommu/irq_remapping.c        |    1 -
 6 files changed, 72 insertions(+), 67 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9df24a42f54d..a3675e4f4342 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -885,6 +885,7 @@ config X86_LOCAL_APIC
 	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select IRQ_DOMAIN
 	select IRQ_DOMAIN_HIERARCHY
+	select PCI_MSI_IRQ_DOMAIN if PCI_MSI
 
 config X86_IO_APIC
 	def_bool X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index cf84eac7a394..047d238e69d2 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -110,9 +110,10 @@ struct irq_2_irte {
 };
 #endif	/* CONFIG_IRQ_REMAP */
 
+struct irq_domain;
+
 #ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_data;
-struct irq_domain;
 struct pci_dev;
 struct msi_desc;
 
@@ -210,6 +211,12 @@ static inline void lock_vector_lock(void) {}
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
index d2410ac8cef9..c4fa0d2291b8 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -71,11 +71,7 @@ extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
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
index f3c463cc8173..f401bcd23e3a 100644
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
@@ -114,28 +118,22 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	return 0;
 }
 
-static int
-msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-	struct msi_msg msg;
-	unsigned int dest;
+	struct irq_data *parent = data->parent_data;
 	int ret;
 
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	__get_cached_msi_msg(data->msi_desc, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
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
@@ -146,70 +144,72 @@ static struct irq_chip msi_chip = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
-	.irq_ack		= apic_ack_edge,
+	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_print_chip		= irq_remapping_print_chip,
+	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-		  unsigned int irq_base, unsigned int irq_offset)
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	struct irq_chip *chip = &msi_chip;
-	struct msi_msg msg;
-	unsigned int irq = irq_base + irq_offset;
-	int ret;
-
-	ret = msi_compose_msg(dev, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
+	struct irq_domain *domain;
+	struct irq_alloc_info info;
 
-	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
+	init_irq_alloc_info(&info, NULL);
+	info.msi_dev = dev;
+	if (type == PCI_CAP_ID_MSI) {
+		info.type = X86_IRQ_ALLOC_TYPE_MSI;
+		info.flags |= X86_IRQ_ALLOC_CONTIGOUS_VECTORS;
+	} else {
+		info.type = X86_IRQ_ALLOC_TYPE_MSIX;
+	}
 
-	/*
-	 * MSI-X message is written per-IRQ, the offset is always 0.
-	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
-	 */
-	if (!irq_offset)
-		write_msi_msg(irq, &msg);
+	domain = irq_remapping_get_irq_domain(&info);
+	if (domain == NULL)
+		domain = msi_default_domain;
+	if (domain == NULL)
+		return -ENOSYS;
 
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
+	return msi_irq_domain_alloc_irqs(domain, type, dev, &info);
+}
 
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
+void native_teardown_msi_irq(unsigned int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
 
-	dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", irq);
+irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg)
+{
+	struct irq_alloc_info *info = arg;
 
-	return 0;
+	return info->msi_hwirq;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq)
 {
-	struct msi_desc *msidesc;
-	int irq, ret;
-
-	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+	struct irq_alloc_info *info = arg;
 
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
-		if (irq <= 0)
-			return -ENOSPC;
+	info->msi_hwirq = hwirq;
+}
 
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0) {
-			irq_domain_free_irqs(irq, 1);
-			return ret;
-		}
+void arch_init_msi_domain(struct irq_domain *parent)
+{
+	if (disable_apic)
+		return;
 
-	}
-	return 0;
+	msi_default_domain = msi_create_irq_domain(NULL, &msi_chip, parent);
+	if (!msi_default_domain)
+		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
 }
 
-void native_teardown_msi_irq(unsigned int irq)
+#ifdef CONFIG_IRQ_REMAP
+struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	irq_domain_free_irqs(irq, 1);
+	return msi_create_irq_domain(NULL, &msi_chip, parent);
 }
+#endif
 
 #ifdef CONFIG_DMAR_TABLE
 static int
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index e7b1d6892e66..6d3cc6a0b1eb 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -364,6 +364,8 @@ int __init arch_early_irq_init(void)
 	BUG_ON(x86_vector_domain == NULL);
 	irq_set_default_host(x86_vector_domain);
 
+	arch_init_msi_domain(x86_vector_domain);
+
 	return arch_early_ioapic_init();
 }
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 32fe5b1322d0..414ab0cddbbc 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -171,7 +171,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
-	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
 }
-- 
1.7.10.4

