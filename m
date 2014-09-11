Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaIKODR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:03:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:38216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbaIKODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:03:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739403"
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
Subject: [RFC Part2 v1 17/21] x86, htirq: Use hierarchy irqdomain to manage Hypertransport interrupts
Date: Thu, 11 Sep 2014 22:03:44 +0800
Message-Id: <1410444228-3134-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hierarchy irqdomain to manage Hypertransport interrupts.
We have slightly changed the architecture interfaces to support htirq
PCI driver, it should be safe because currently Hypertransport interrupt
is only enabled on x86 platforms.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |   13 ++++
 arch/x86/kernel/apic/htirq.c  |  167 +++++++++++++++++++++++++++++++----------
 arch/x86/kernel/apic/vector.c |    1 +
 drivers/pci/htirq.c           |   47 ++----------
 include/linux/htirq.h         |   24 ++++--
 5 files changed, 165 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 9f705c49f850..1913607f6422 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -148,6 +148,14 @@ struct irq_alloc_info {
 			u32		ioapic_polarity : 1;
 		};
 #endif
+#ifdef	CONFIG_HT_IRQ
+		struct {
+			int		ht_pos;
+			int		ht_idx;
+			struct pci_dev	*ht_dev;
+			void		*ht_update;
+		};
+#endif
 	};
 };
 
@@ -204,6 +212,11 @@ extern void arch_init_msi_domain(struct irq_domain *domain);
 #else
 static inline void arch_init_msi_domain(struct irq_domain *domain) { }
 #endif
+#ifdef	CONFIG_HT_IRQ
+extern void arch_init_htirq_domain(struct irq_domain *domain);
+#else
+static inline void arch_init_htirq_domain(struct irq_domain *domain) { }
+#endif
 
 /* Statistics */
 extern atomic_t irq_err_count;
diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 55cb061a95cb..a67da63996df 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
  *	Moved from arch/x86/kernel/apic/io_apic.c.
+ * Jiang Liu <jiang.liu@linux.intel.com>
+ *	Add support of hierarchy irqdomain
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,69 +21,107 @@
 #include <asm/apic.h>
 #include <asm/hypertransport.h>
 
+static struct irq_domain *htirq_domain;
+
 /*
  * Hypertransport interrupt support
  */
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
-{
-	struct ht_irq_msg msg;
-
-	fetch_ht_irq_msg(irq, &msg);
-
-	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
-	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
-
-	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
-	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
-
-	write_ht_irq_msg(irq, &msg);
-}
-
 static int
 ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-	unsigned int dest;
+	struct irq_data *parent = data->parent_data;
 	int ret;
 
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	target_ht_irq(data->irq, dest, cfg->vector);
-	return IRQ_SET_MASK_OK_NOCOPY;
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0) {
+		struct ht_irq_msg msg;
+		struct irq_cfg *cfg = data->chip_data;
+
+		fetch_ht_irq_msg(data->irq, &msg);
+		msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK |
+				    HT_IRQ_LOW_DEST_ID_MASK);
+		msg.address_lo |= HT_IRQ_LOW_VECTOR(cfg->vector) |
+				  HT_IRQ_LOW_DEST_ID(cfg->dest_apicid);
+		msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
+		msg.address_hi |= HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
+		write_ht_irq_msg(data->irq, &msg);
+	}
+
+	return ret;
 }
 
 static struct irq_chip ht_irq_chip = {
 	.name			= "PCI-HT",
 	.irq_mask		= mask_ht_irq,
 	.irq_unmask		= unmask_ht_irq,
-	.irq_ack		= apic_ack_edge,
+	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= ht_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 };
 
-int arch_alloc_ht_irq(struct pci_dev *dev)
+static int htirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs, void *arg)
 {
-	return irq_domain_alloc_irqs(NULL, -1, 1, dev_to_node(&dev->dev), NULL);
+	struct ht_irq_cfg *ht_cfg;
+	struct irq_alloc_info *info = arg;
+	struct pci_dev *dev;
+	irq_hw_number_t hwirq;
+	int ret;
+
+	if (nr_irqs > 1 || !info)
+		return -EINVAL;
+
+	dev = info->ht_dev;
+	hwirq = (info->ht_idx & 0xFF) |
+		PCI_DEVID(dev->bus->number, dev->devfn) << 8 |
+		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 24;
+	if (irq_find_mapping(domain, hwirq) > 0)
+		return -EEXIST;
+
+	ht_cfg = kmalloc(sizeof(*ht_cfg), GFP_KERNEL);
+	if (!ht_cfg)
+		return -ENOMEM;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
+	if (ret < 0) {
+		kfree(ht_cfg);
+		return ret;
+	}
+
+	/* Initialize msg to a value that will never match the first write. */
+	ht_cfg->msg.address_lo = 0xffffffff;
+	ht_cfg->msg.address_hi = 0xffffffff;
+	ht_cfg->dev = info->ht_dev;
+	ht_cfg->update = info->ht_update;
+	ht_cfg->pos = info->ht_pos;
+	ht_cfg->idx = 0x10 + (info->ht_idx * 2);
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, &ht_irq_chip,
+				      ht_cfg);
+	__irq_set_handler(virq, handle_edge_irq, 0, "edge");
+
+	return 0;
 }
 
-void arch_free_ht_irq(int irq)
+static void htirq_domain_free(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs)
 {
-	irq_domain_free_irqs(irq, 1);
+	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
+
+	BUG_ON(nr_irqs != 1);
+	if (irq_data && irq_data->chip_data)
+		kfree(irq_data->chip_data);
+	irq_domain_set_hwirq_and_chip(domain, virq, 0, NULL, NULL);
+	irq_set_handler(virq, NULL);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
-int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
+static int htirq_domain_activate(struct irq_domain *domain,
+				 struct irq_data *irq_data)
 {
-	struct irq_cfg *cfg;
 	struct ht_irq_msg msg;
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
 	msg.address_hi = HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
-
 	msg.address_lo =
 		HT_IRQ_LOW_BASE |
 		HT_IRQ_LOW_DEST_ID(cfg->dest_apicid) |
@@ -94,13 +134,60 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 			HT_IRQ_LOW_MT_FIXED :
 			HT_IRQ_LOW_MT_ARBITRATED) |
 		HT_IRQ_LOW_IRQ_MASKED;
+	write_ht_irq_msg(irq_data->irq, &msg);
 
-	write_ht_irq_msg(irq, &msg);
+	return 0;
+}
 
-	irq_set_chip_and_handler_name(irq, &ht_irq_chip,
-				      handle_edge_irq, "edge");
+static int htirq_domain_deactivate(struct irq_domain *domain,
+				   struct irq_data *irq_data)
+{
+	struct ht_irq_msg msg;
 
-	dev_dbg(&dev->dev, "irq %d for HT\n", irq);
+	memset(&msg, 0, sizeof(msg));
+	write_ht_irq_msg(irq_data->irq, &msg);
 
 	return 0;
 }
+
+static struct irq_domain_ops htirq_domain_ops = {
+	.alloc = htirq_domain_alloc,
+	.free = htirq_domain_free,
+	.activate = htirq_domain_activate,
+	.deactivate = htirq_domain_deactivate,
+};
+
+void arch_init_htirq_domain(struct irq_domain *parent)
+{
+	if (disable_apic)
+		return;
+
+	htirq_domain = irq_domain_add_tree(NULL, &htirq_domain_ops, NULL);
+	if (!htirq_domain)
+		pr_warn("failed to initialize irqdomain for HTIRQ.\n");
+	else
+		htirq_domain->parent = parent;
+}
+
+int arch_setup_ht_irq(int idx, int pos, struct pci_dev *dev,
+		      ht_irq_update_t *update)
+{
+	struct irq_alloc_info info;
+
+	if (!htirq_domain)
+		return -ENOSYS;
+
+	init_irq_alloc_info(&info, NULL);
+	info.ht_idx = idx;
+	info.ht_pos = pos;
+	info.ht_dev = dev;
+	info.ht_update = update;
+
+	return irq_domain_alloc_irqs(htirq_domain, -1, 1,
+				     dev_to_node(&dev->dev), &info);
+}
+
+void arch_teardown_ht_irq(unsigned int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index e9329fc28c63..1ddede9d5be7 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -358,6 +358,7 @@ int __init arch_early_irq_init(void)
 	irq_set_default_host(x86_vector_domain);
 
 	arch_init_msi_domain(x86_vector_domain);
+	arch_init_htirq_domain(x86_vector_domain);
 
 	return arch_early_ioapic_init();
 }
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index ceb0ebeb7b5f..7eb4109a3df4 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -23,20 +23,11 @@
  */
 static DEFINE_SPINLOCK(ht_irq_lock);
 
-struct ht_irq_cfg {
-	struct pci_dev *dev;
-	 /* Update callback used to cope with buggy hardware */
-	ht_irq_update_t *update;
-	unsigned pos;
-	unsigned idx;
-	struct ht_irq_msg msg;
-};
-
-
 void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 {
 	struct ht_irq_cfg *cfg = irq_get_handler_data(irq);
 	unsigned long flags;
+
 	spin_lock_irqsave(&ht_irq_lock, flags);
 	if (cfg->msg.address_lo != msg->address_lo) {
 		pci_write_config_byte(cfg->dev, cfg->pos + 2, cfg->idx);
@@ -55,6 +46,7 @@ void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 {
 	struct ht_irq_cfg *cfg = irq_get_handler_data(irq);
+
 	*msg = cfg->msg;
 }
 
@@ -86,7 +78,6 @@ void unmask_ht_irq(struct irq_data *data)
  */
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 {
-	struct ht_irq_cfg *cfg;
 	int max_irq, pos, irq;
 	unsigned long flags;
 	u32 data;
@@ -105,29 +96,9 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	if (idx > max_irq)
 		return -EINVAL;
 
-	cfg = kmalloc(sizeof(*cfg), GFP_KERNEL);
-	if (!cfg)
-		return -ENOMEM;
-
-	cfg->dev = dev;
-	cfg->update = update;
-	cfg->pos = pos;
-	cfg->idx = 0x10 + (idx * 2);
-	/* Initialize msg to a value that will never match the first write. */
-	cfg->msg.address_lo = 0xffffffff;
-	cfg->msg.address_hi = 0xffffffff;
-
-	irq = arch_alloc_ht_irq(dev);
-	if (irq <= 0) {
-		kfree(cfg);
-		return -EBUSY;
-	}
-	irq_set_handler_data(irq, cfg);
-
-	if (arch_setup_ht_irq(irq, dev) < 0) {
-		ht_destroy_irq(irq);
-		return -EBUSY;
-	}
+	irq = arch_setup_ht_irq(idx, pos, dev, update);
+	if (irq > 0)
+		dev_dbg(&dev->dev, "irq %d for HT\n", irq);
 
 	return irq;
 }
@@ -158,12 +129,6 @@ EXPORT_SYMBOL(ht_create_irq);
  */
 void ht_destroy_irq(unsigned int irq)
 {
-	struct ht_irq_cfg *cfg;
-
-	cfg = irq_get_handler_data(irq);
-	irq_set_chip(irq, NULL);
-	irq_set_handler_data(irq, NULL);
-	arch_free_ht_irq(irq);
-	kfree(cfg);
+	arch_teardown_ht_irq(irq);
 }
 EXPORT_SYMBOL(ht_destroy_irq);
diff --git a/include/linux/htirq.h b/include/linux/htirq.h
index 5caa51b7b95c..d4a527e58434 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -1,26 +1,38 @@
 #ifndef LINUX_HTIRQ_H
 #define LINUX_HTIRQ_H
 
+struct pci_dev;
+struct irq_data;
+
 struct ht_irq_msg {
 	u32	address_lo;	/* low 32 bits of the ht irq message */
 	u32	address_hi;	/* high 32 bits of the it irq message */
 };
 
+typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
+			       struct ht_irq_msg *msg);
+
+struct ht_irq_cfg {
+	struct pci_dev *dev;
+	 /* Update callback used to cope with buggy hardware */
+	ht_irq_update_t *update;
+	unsigned pos;
+	unsigned idx;
+	struct ht_irq_msg msg;
+};
+
 /* Helper functions.. */
 void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
 void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-struct irq_data;
 void mask_ht_irq(struct irq_data *data);
 void unmask_ht_irq(struct irq_data *data);
 
 /* The arch hook for getting things started */
-int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
-int arch_alloc_ht_irq(struct pci_dev *dev);
-void arch_free_ht_irq(int irq);
+int arch_setup_ht_irq(int idx, int pos, struct pci_dev *dev,
+		      ht_irq_update_t *update);
+void arch_teardown_ht_irq(unsigned int irq);
 
 /* For drivers of buggy hardware */
-typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
-			       struct ht_irq_msg *msg);
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update);
 
 #endif /* LINUX_HTIRQ_H */
-- 
1.7.10.4

