Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaKKPsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56200 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaKKPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:38 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 11/15] irqchip: GICv3: ITS: MSI support
Date: Tue, 11 Nov 2014 15:48:09 +0000
Message-Id: <1415720893-13371-12-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, the bit of code that allow us to use the ITS as a MSI controller.
Both MSI and MSI-X are supported.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 131 +++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |   6 ++
 2 files changed, 137 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 8d13012..0f51d23 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -35,6 +35,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/exception.h>
+#include <asm/msi.h>
 
 #include "irqchip.h"
 
@@ -587,12 +588,27 @@ static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	return IRQ_SET_MASK_OK;
 }
 
+static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_node *its;
+	u64 addr;
+
+	its = its_dev->its;
+	addr = its->phys_base + GITS_TRANSLATER;
+
+	msg->address_lo		= addr & ((1UL << 32) - 1);
+	msg->address_hi		= addr >> 32;
+	msg->data		= its_get_event_id(d);
+}
+
 static struct irq_chip its_irq_chip = {
 	.name			= "ITS",
 	.irq_mask		= its_mask_irq,
 	.irq_unmask		= its_unmask_irq,
 	.irq_eoi		= its_eoi_irq,
 	.irq_set_affinity	= its_set_affinity,
+	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
 };
 
 /*
@@ -1055,3 +1071,118 @@ static void its_free_device(struct its_device *its_dev)
 	kfree(its_dev->itt);
 	kfree(its_dev);
 }
+
+static int its_alloc_device_irq(struct its_device *dev, irq_hw_number_t *hwirq)
+{
+	int idx;
+
+	idx = find_first_zero_bit(dev->lpi_map, dev->nr_lpis);
+	if (idx == dev->nr_lpis)
+		return -ENOSPC;
+
+	*hwirq = dev->lpi_base + idx;
+	set_bit(idx, dev->lpi_map);
+
+	/* Map the GIC irq ID to the device */
+	its_send_mapvi(dev, *hwirq, idx);
+
+	return 0;
+}
+
+static int its_irq_gic_domain_alloc(struct irq_domain *domain,
+				    unsigned int virq,
+				    irq_hw_number_t hwirq)
+{
+	struct of_phandle_args args;
+
+	args.np = domain->parent->of_node;
+	args.args_count = 3;
+	args.args[0] = GIC_IRQ_TYPE_LPI;
+	args.args[1] = hwirq;
+	args.args[2] = IRQ_TYPE_EDGE_RISING;
+
+	return irq_domain_alloc_irqs_parent(domain, virq, 1, &args);
+}
+
+/* FIXME: Use proper API once it is available in the kernel... */
+#define PCI_REQUESTER_ID(dev)	PCI_DEVID((dev)->bus->number, (dev)->devfn)
+
+static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *arg)
+{
+	struct arm64_msi_info *info = arg;
+	struct pci_dev *pdev = info->pdev;
+	struct msi_chip *chip = pdev->bus->msi;
+	struct its_node *its = container_of(chip, struct its_node, msi_chip);
+	u32 dev_id = PCI_REQUESTER_ID(pdev);
+	struct its_device *its_dev;
+	irq_hw_number_t hwirq;
+	int err;
+	int i;
+
+	its_dev = its_find_device(its, dev_id);
+	if (!its_dev) {
+		its_dev = its_create_device(its, dev_id, info->nvec);
+		dev_dbg(&pdev->dev, "ITT %d entries, %d bits\n",
+			info->nvec, ilog2(info->nvec));
+	}
+	if (!its_dev)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_irqs; i++) {
+		err = its_alloc_device_irq(its_dev, &hwirq);
+		if (err)
+			return err;
+
+		err = its_irq_gic_domain_alloc(domain, virq, hwirq);
+		if (err)
+			return err;
+
+		irq_domain_set_hwirq_and_chip(lpi_domain, virq + i,
+					      hwirq, &its_irq_chip, its_dev);
+		dev_dbg(&pdev->dev, "ID:%d pID:%d vID:%d\n",
+			(int)(hwirq - its_dev->lpi_base),
+			(int)hwirq, virq + i);
+	}
+
+	return 0;
+}
+
+static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs)
+{
+	struct irq_data *d = irq_get_irq_data(virq);
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		int event = its_get_event_id(d);
+
+		/* Stop the delivery of interrupts */
+		its_send_discard(its_dev, event);
+
+		/* Mark interrupt index as unused, and clear the mapping */
+		clear_bit(event, its_dev->lpi_map);
+
+		irq_set_handler(virq + i, NULL);
+		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
+	}
+
+	/* If all interrupts have been freed, start mopping the floor */
+	if (bitmap_empty(its_dev->lpi_map, its_dev->nr_lpis)) {
+		its_lpi_free(its_dev->lpi_map,
+			     its_dev->lpi_base,
+			     its_dev->nr_lpis);
+
+		/* Unmap device/itt */
+		its_send_mapd(its_dev, 0);
+		its_free_device(its_dev);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static const struct irq_domain_ops its_domain_ops = {
+	.alloc			= its_irq_domain_alloc,
+	.free			= its_irq_domain_free,
+};
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 21c9d70..2a7486b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -295,6 +295,12 @@
 
 #include <linux/stringify.h>
 
+/*
+ * We need a value to serve as a irq-type for LPIs. Choose one that will
+ * pick the interest of the reviewer.
+ */
+#define GIC_IRQ_TYPE_LPI		0xa110c8ed
+
 struct rdists {
 	struct {
 		void __iomem	*rd_base;
-- 
2.0.4

