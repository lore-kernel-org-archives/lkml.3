Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaKEQoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:44:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaKEQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:44:31 -0500
Date: Wed, 5 Nov 2014 08:38:02 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-cc7392eb40b4f2ad3bed3c7fb6af42b65e175a94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, hpa@zytor.com,
        bp@alien8.de, tglx@linutronix.de, konrad.wilk@oracle.com,
        joro@8bytes.org, rjw@rjwysocki.net, rdunlap@infradead.org,
        yinghai@kernel.org, rafael.j.wysocki@intel.com, prarit@redhat.com,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        tony.luck@intel.com, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, bhelgaas@google.com, bp@alien8.de,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, hpa@zytor.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, joro@8bytes.org,
        yinghai@kernel.org, rjw@rjwysocki.net, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, prarit@redhat.com,
        benh@kernel.crashing.org, rafael.j.wysocki@intel.com,
        tony.luck@intel.com, mingo@kernel.org
In-Reply-To: <1414397531-28254-12-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-12-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Move PCI MSI related code from io_apic.c into msi.c
Git-Commit-ID: cc7392eb40b4f2ad3bed3c7fb6af42b65e175a94
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

Commit-ID:  cc7392eb40b4f2ad3bed3c7fb6af42b65e175a94
Gitweb:     http://git.kernel.org/tip/cc7392eb40b4f2ad3bed3c7fb6af42b65e175a94
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:02 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:47 +0100

x86, irq: Move PCI MSI related code from io_apic.c into msi.c

Create arch/x86/kernel/apic/msi.c to host MSI related code,
preparing for enabling hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414397531-28254-12-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |   4 -
 arch/x86/include/asm/pci.h     |   3 +
 arch/x86/kernel/apic/Makefile  |   1 +
 arch/x86/kernel/apic/io_apic.c | 272 ---------------------------------------
 arch/x86/kernel/apic/msi.c     | 286 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 290 insertions(+), 276 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0db2b70..bdd45c2 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -148,9 +148,6 @@ extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
-extern void native_compose_msi_msg(struct pci_dev *pdev,
-				   unsigned int irq, unsigned int dest,
-				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
 
 extern int save_ioapic_entries(void);
@@ -261,7 +258,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
-#define native_compose_msi_msg		NULL
 #define native_eoi_ioapic_pin		NULL
 #endif
 
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 0892ea0..4e370a5 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,12 +96,15 @@ extern void pci_iommu_alloc(void);
 #ifdef CONFIG_PCI_MSI
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
+void native_compose_msi_msg(struct pci_dev *pdev, unsigned int irq,
+			    unsigned int dest, struct msi_msg *msg, u8 hpet_id);
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev);
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 		  unsigned int irq_base, unsigned int irq_offset);
 #else
+#define native_compose_msi_msg		NULL
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
 #endif
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 84299e5..aac3007 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o vector.o
 obj-y				+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
+obj-$(CONFIG_PCI_MSI)		+= msi.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0614262..653fe21 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -32,15 +32,12 @@
 #include <linux/module.h>
 #include <linux/syscore_ops.h>
 #include <linux/irqdomain.h>
-#include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
 #include <linux/bootmem.h>
-#include <linux/dmar.h>
-#include <linux/hpet.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -52,11 +49,9 @@
 #include <asm/dma.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
-#include <asm/msidef.h>
 #include <asm/hypertransport.h>
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
-#include <asm/hpet.h>
 #include <asm/hw_irq.h>
 
 #include <asm/apic.h>
@@ -2456,273 +2451,6 @@ static int __init ioapic_init_ops(void)
 device_initcall(ioapic_init_ops);
 
 /*
- * MSI message composition
- */
-void native_compose_msi_msg(struct pci_dev *pdev,
-			    unsigned int irq, unsigned int dest,
-			    struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	msg->address_hi = MSI_ADDR_BASE_HI;
-
-	if (x2apic_enabled())
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
-
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		((apic->irq_dest_mode == 0) ?
-			MSI_ADDR_DEST_MODE_PHYSICAL:
-			MSI_ADDR_DEST_MODE_LOGICAL) |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_ADDR_REDIRECTION_CPU:
-			MSI_ADDR_REDIRECTION_LOWPRI) |
-		MSI_ADDR_DEST_ID(dest);
-
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_DATA_DELIVERY_FIXED:
-			MSI_DATA_DELIVERY_LOWPRI) |
-		MSI_DATA_VECTOR(cfg->vector);
-}
-
-#ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg;
-	int err;
-	unsigned dest;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-
-	return 0;
-}
-
-static int
-msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
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
-	__write_msi_msg(data->msi_desc, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-/*
- * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
- * which implement the MSI or MSI-X Capability Structure.
- */
-static struct irq_chip msi_chip = {
-	.name			= "PCI-MSI",
-	.irq_unmask		= unmask_msi_irq,
-	.irq_mask		= mask_msi_irq,
-	.irq_ack		= apic_ack_edge,
-	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-		  unsigned int irq_base, unsigned int irq_offset)
-{
-	struct irq_chip *chip = &msi_chip;
-	struct msi_msg msg;
-	unsigned int irq = irq_base + irq_offset;
-	int ret;
-
-	ret = msi_compose_msg(dev, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
-
-	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
-
-	/*
-	 * MSI-X message is written per-IRQ, the offset is always 0.
-	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
-	 */
-	if (!irq_offset)
-		write_msi_msg(irq, &msg);
-
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
-
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
-
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
-
-	return 0;
-}
-
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-{
-	struct msi_desc *msidesc;
-	unsigned int irq;
-	int node, ret;
-
-	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
-
-	node = dev_to_node(&dev->dev);
-
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_alloc_hwirq(node);
-		if (!irq)
-			return -ENOSPC;
-
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0) {
-			irq_free_hwirq(irq);
-			return ret;
-		}
-
-	}
-	return 0;
-}
-
-void native_teardown_msi_irq(unsigned int irq)
-{
-	irq_free_hwirq(irq);
-}
-
-#ifdef CONFIG_DMAR_TABLE
-static int
-dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		      bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest, irq = data->irq;
-	struct msi_msg msg;
-	int ret;
-
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	dmar_msi_read(irq, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
-	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
-
-	dmar_msi_write(irq, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-static struct irq_chip dmar_msi_type = {
-	.name			= "DMAR_MSI",
-	.irq_unmask		= dmar_msi_unmask,
-	.irq_mask		= dmar_msi_mask,
-	.irq_ack		= apic_ack_edge,
-	.irq_set_affinity	= dmar_msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
-int arch_setup_dmar_msi(unsigned int irq)
-{
-	int ret;
-	struct msi_msg msg;
-
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
-	dmar_msi_write(irq, &msg);
-	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
-				      "edge");
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_HPET_TIMER
-
-static int hpet_msi_set_affinity(struct irq_data *data,
-				 const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	struct msi_msg msg;
-	unsigned int dest;
-	int ret;
-
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	hpet_msi_read(data->handler_data, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
-
-	hpet_msi_write(data->handler_data, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-static struct irq_chip hpet_msi_type = {
-	.name = "HPET_MSI",
-	.irq_unmask = hpet_msi_unmask,
-	.irq_mask = hpet_msi_mask,
-	.irq_ack = apic_ack_edge,
-	.irq_set_affinity = hpet_msi_set_affinity,
-	.irq_retrigger = apic_retrigger_irq,
-	.flags = IRQCHIP_SKIP_SET_WAKE,
-};
-
-int default_setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	struct irq_chip *chip = &hpet_msi_type;
-	struct msi_msg msg;
-	int ret;
-
-	ret = msi_compose_msg(NULL, irq, &msg, id);
-	if (ret < 0)
-		return ret;
-
-	hpet_msi_write(irq_get_handler_data(irq), &msg);
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
-
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
-	return 0;
-}
-#endif
-
-#endif /* CONFIG_PCI_MSI */
-/*
  * Hypertransport interrupt support
  */
 #ifdef CONFIG_HT_IRQ
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
new file mode 100644
index 0000000..7eff986
--- /dev/null
+++ b/arch/x86/kernel/apic/msi.c
@@ -0,0 +1,286 @@
+/*
+ * Support of MSI, HPET and DMAR interrupts.
+ *
+ * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
+ *	Moved from arch/x86/kernel/apic/io_apic.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/dmar.h>
+#include <linux/hpet.h>
+#include <linux/msi.h>
+#include <asm/msidef.h>
+#include <asm/hpet.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/irq_remapping.h>
+
+void native_compose_msi_msg(struct pci_dev *pdev,
+			    unsigned int irq, unsigned int dest,
+			    struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg = irq_cfg(irq);
+
+	msg->address_hi = MSI_ADDR_BASE_HI;
+
+	if (x2apic_enabled())
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
+
+	msg->address_lo =
+		MSI_ADDR_BASE_LO |
+		((apic->irq_dest_mode == 0) ?
+			MSI_ADDR_DEST_MODE_PHYSICAL :
+			MSI_ADDR_DEST_MODE_LOGICAL) |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_ADDR_REDIRECTION_CPU :
+			MSI_ADDR_REDIRECTION_LOWPRI) |
+		MSI_ADDR_DEST_ID(dest);
+
+	msg->data =
+		MSI_DATA_TRIGGER_EDGE |
+		MSI_DATA_LEVEL_ASSERT |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_DATA_DELIVERY_FIXED :
+			MSI_DATA_DELIVERY_LOWPRI) |
+		MSI_DATA_VECTOR(cfg->vector);
+}
+
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+			   struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg;
+	int err;
+	unsigned dest;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	cfg = irq_cfg(irq);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
+
+	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+
+	return 0;
+}
+
+static int
+msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	struct msi_msg msg;
+	unsigned int dest;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	__get_cached_msi_msg(data->msi_desc, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	__write_msi_msg(data->msi_desc, &msg);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+/*
+ * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
+ * which implement the MSI or MSI-X Capability Structure.
+ */
+static struct irq_chip msi_chip = {
+	.name			= "PCI-MSI",
+	.irq_unmask		= unmask_msi_irq,
+	.irq_mask		= mask_msi_irq,
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= msi_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+		  unsigned int irq_base, unsigned int irq_offset)
+{
+	struct irq_chip *chip = &msi_chip;
+	struct msi_msg msg;
+	unsigned int irq = irq_base + irq_offset;
+	int ret;
+
+	ret = msi_compose_msg(dev, irq, &msg, -1);
+	if (ret < 0)
+		return ret;
+
+	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
+
+	/*
+	 * MSI-X message is written per-IRQ, the offset is always 0.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (!irq_offset)
+		write_msi_msg(irq, &msg);
+
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
+
+	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
+
+	dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", irq);
+
+	return 0;
+}
+
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_desc *msidesc;
+	unsigned int irq;
+	int node, ret;
+
+	/* Multiple MSI vectors only supported with interrupt remapping */
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
+	node = dev_to_node(&dev->dev);
+
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = irq_alloc_hwirq(node);
+		if (!irq)
+			return -ENOSPC;
+
+		ret = setup_msi_irq(dev, msidesc, irq, 0);
+		if (ret < 0) {
+			irq_free_hwirq(irq);
+			return ret;
+		}
+
+	}
+	return 0;
+}
+
+void native_teardown_msi_irq(unsigned int irq)
+{
+	irq_free_hwirq(irq);
+}
+
+#ifdef CONFIG_DMAR_TABLE
+static int
+dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      bool force)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest, irq = data->irq;
+	struct msi_msg msg;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	dmar_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
+
+	dmar_msi_write(irq, &msg);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+static struct irq_chip dmar_msi_type = {
+	.name			= "DMAR_MSI",
+	.irq_unmask		= dmar_msi_unmask,
+	.irq_mask		= dmar_msi_mask,
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= dmar_msi_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+int arch_setup_dmar_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg, -1);
+	if (ret < 0)
+		return ret;
+	dmar_msi_write(irq, &msg);
+	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+				      "edge");
+	return 0;
+}
+#endif
+
+/*
+ * MSI message composition
+ */
+#ifdef CONFIG_HPET_TIMER
+
+static int hpet_msi_set_affinity(struct irq_data *data,
+				 const struct cpumask *mask, bool force)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	struct msi_msg msg;
+	unsigned int dest;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	hpet_msi_read(data->handler_data, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	hpet_msi_write(data->handler_data, &msg);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+static struct irq_chip hpet_msi_type = {
+	.name = "HPET_MSI",
+	.irq_unmask = hpet_msi_unmask,
+	.irq_mask = hpet_msi_mask,
+	.irq_ack = apic_ack_edge,
+	.irq_set_affinity = hpet_msi_set_affinity,
+	.irq_retrigger = apic_retrigger_irq,
+	.flags = IRQCHIP_SKIP_SET_WAKE,
+};
+
+int default_setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct irq_chip *chip = &hpet_msi_type;
+	struct msi_msg msg;
+	int ret;
+
+	ret = msi_compose_msg(NULL, irq, &msg, id);
+	if (ret < 0)
+		return ret;
+
+	hpet_msi_write(irq_get_handler_data(irq), &msg);
+	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
+
+	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
+	return 0;
+}
+#endif
