Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaKZXUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:20:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaKZXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:19:58 -0500
Date: Wed, 26 Nov 2014 15:09:02 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-c07a443c77c4fe7d9f85c18e127020653bb8a45c@git.kernel.org>
Cc: rjw@rjwysocki.net, benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        bhelgaas@google.com, tglx@linutronix.de, mingo@kernel.org,
        konrad.wilk@oracle.com, jiang.liu@linux.intel.com, bp@alien8.de,
        hpa@zytor.com, yinghai@kernel.org, rdunlap@infradead.org
Reply-To: joro@8bytes.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        rjw@rjwysocki.net, benh@kernel.crashing.org,
        gregkh@linuxfoundation.org, bp@alien8.de, jiang.liu@linux.intel.com,
        hpa@zytor.com, yinghai@kernel.org, rdunlap@infradead.org,
        bhelgaas@google.com, tglx@linutronix.de, mingo@kernel.org,
        konrad.wilk@oracle.com
In-Reply-To: <1416894816-23245-14-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-14-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, PCI, MSI:
  Use hierarchy irqdomain to manage MSI interrupts
Git-Commit-ID: c07a443c77c4fe7d9f85c18e127020653bb8a45c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c07a443c77c4fe7d9f85c18e127020653bb8a45c
Gitweb:     http://git.kernel.org/tip/c07a443c77c4fe7d9f85c18e127020653bb8a45c
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:22 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

x86, PCI, MSI: Use hierarchy irqdomain to manage MSI interrupts

Enhance MSI code to support hierarchy irqdomain, it helps to make
the architecture more clear.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/1416894816-23245-14-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/hw_irq.h        |   9 ++-
 arch/x86/include/asm/irq_remapping.h |   6 +-
 arch/x86/include/asm/msi.h           |   7 ++
 arch/x86/kernel/apic/msi.c           | 141 +++++++++++++++++++----------------
 arch/x86/kernel/apic/vector.c        |   2 +
 drivers/iommu/irq_remapping.c        |   1 -
 7 files changed, 94 insertions(+), 73 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 14385eb..e05be74 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -883,6 +883,7 @@ config X86_LOCAL_APIC
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
 	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select IRQ_DOMAIN_HIERARCHY
+	select PCI_MSI_IRQ_DOMAIN if PCI_MSI
 
 config X86_IO_APIC
 	def_bool X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bd7881c..270c432 100644
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
 
@@ -214,6 +215,12 @@ static inline void lock_vector_lock(void) {}
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
index 3421f10..3b11f5a 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -68,11 +68,7 @@ irq_remapping_get_irq_domain(struct irq_alloc_info *info);
 extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
 
 /* Create PCI MSI/MSIx irqdomain, use @parent as the parent irqdomain. */
-static inline struct irq_domain *
-arch_create_msi_irq_domain(struct irq_domain *parent)
-{
-	return NULL;
-}
+extern struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent);
 
 /* Get parent irqdomain for interrupt remapping irqdomain */
 static inline struct irq_domain *arch_get_ir_parent_domain(void)
diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
new file mode 100644
index 0000000..93724cc
--- /dev/null
+++ b/arch/x86/include/asm/msi.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_X86_MSI_H
+#define _ASM_X86_MSI_H
+#include <asm/hw_irq.h>
+
+typedef struct irq_alloc_info msi_alloc_info_t;
+
+#endif /* _ASM_X86_MSI_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 10d9ae8..e82ab79 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
  *	Moved from arch/x86/kernel/apic/io_apic.c.
+ * Jiang Liu <jiang.liu@linux.intel.com>
+ *	Convert to hierarchy irqdomain
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
@@ -114,102 +118,107 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	return 0;
 }
 
-static int
-msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = irqd_cfg(data);
-	struct msi_msg msg;
-	unsigned int dest;
-	int ret;
-
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
-
-	__pci_write_msi_msg(data->msi_desc, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
  */
-static struct irq_chip msi_chip = {
+static struct irq_chip pci_msi_controller = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= pci_msi_unmask_irq,
 	.irq_mask		= pci_msi_mask_irq,
-	.irq_ack		= apic_ack_edge,
-	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_set_affinity	= msi_domain_set_affinity,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_print_chip		= irq_remapping_print_chip,
+	.irq_compose_msi_msg	= irq_msi_compose_msg,
+	.irq_write_msi_msg	= pci_msi_domain_write_msg,
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
+	struct irq_domain *domain;
+	struct irq_alloc_info info;
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_MSI;
+	info.msi_dev = dev;
 
-	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
+	domain = irq_remapping_get_irq_domain(&info);
+	if (domain == NULL)
+		domain = msi_default_domain;
+	if (domain == NULL)
+		return -ENOSYS;
 
-	/*
-	 * MSI-X message is written per-IRQ, the offset is always 0.
-	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
-	 */
-	if (!irq_offset)
-		pci_write_msi_msg(irq, &msg);
+	return pci_msi_domain_alloc_irqs(domain, dev, nvec, type);
+}
 
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
+void native_teardown_msi_irq(unsigned int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
 
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
+static irq_hw_number_t pci_msi_get_hwirq(struct msi_domain_info *info,
+					 msi_alloc_info_t *arg)
+{
+	return arg->msi_hwirq;
+}
 
-	dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", irq);
+static int pci_msi_prepare(struct irq_domain *domain, struct device *dev,
+			   int nvec, msi_alloc_info_t *arg)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct msi_desc *desc = first_pci_msi_entry(pdev);
+
+	init_irq_alloc_info(arg, NULL);
+	arg->msi_dev = pdev;
+	if (desc->msi_attrib.is_msix) {
+		arg->type = X86_IRQ_ALLOC_TYPE_MSIX;
+	} else {
+		arg->type = X86_IRQ_ALLOC_TYPE_MSI;
+		arg->flags |= X86_IRQ_ALLOC_CONTIGOUS_VECTORS;
+	}
 
 	return 0;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static void pci_msi_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
 {
-	struct msi_desc *msidesc;
-	int irq, ret;
+	arg->msi_hwirq = pci_msi_domain_calc_hwirq(arg->msi_dev, desc);
+}
 
-	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+static struct msi_domain_ops pci_msi_domain_ops = {
+	.get_hwirq	= pci_msi_get_hwirq,
+	.msi_prepare	= pci_msi_prepare,
+	.set_desc	= pci_msi_set_desc,
+};
 
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
-		if (irq <= 0)
-			return -ENOSPC;
+static struct msi_domain_info pci_msi_domain_info = {
+	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+			  MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
+	.ops		= &pci_msi_domain_ops,
+	.chip		= &pci_msi_controller,
+	.handler	= handle_edge_irq,
+	.handler_name	= "edge",
+};
 
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
+	msi_default_domain = pci_msi_create_irq_domain(NULL,
+					&pci_msi_domain_info, parent);
+	if (!msi_default_domain)
+		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
 }
 
-void native_teardown_msi_irq(unsigned int irq)
+#ifdef CONFIG_IRQ_REMAP
+struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	irq_domain_free_irqs(irq, 1);
+	return msi_create_irq_domain(NULL, &pci_msi_domain_info, parent);
 }
+#endif
 
 #ifdef CONFIG_DMAR_TABLE
 static int
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index f8340c7..e971c87 100644
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
index 04ea521..6ec0099 100644
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
