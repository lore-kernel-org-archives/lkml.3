Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaKIPLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:11:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:62511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaKIPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:11:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933605"
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
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 17/17] x86, htirq: Use common MSI code to manage Hypertransport interrupts
Date: Sun,  9 Nov 2014 23:10:39 +0800
Message-Id: <1415545839-28263-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hypertransport interrupt is a type of "Message Signalled Interrupt",
so use common MSI code to manage it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/htirq.c |  134 +++++++++++++++---------------------------
 drivers/pci/Kconfig          |    1 +
 drivers/pci/htirq.c          |   16 ++---
 include/linux/htirq.h        |    5 +-
 4 files changed, 60 insertions(+), 96 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index b6503510f1af..230e37ab3948 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -17,37 +17,33 @@
 #include <linux/pci.h>
 #include <linux/htirq.h>
 #include <linux/irqdomain.h>
+#include <linux/msi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
 #include <asm/hypertransport.h>
 
 static struct irq_domain *htirq_domain;
 
-/*
- * Hypertransport interrupt support
- */
-static int
-ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+static void ht_irq_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_data *parent = data->parent_data;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0) {
-		struct msi_msg msg;
-		struct irq_cfg *cfg = irqd_cfg(data);
-
-		fetch_ht_irq_msg(data->irq, &msg);
-		msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK |
-				    HT_IRQ_LOW_DEST_ID_MASK);
-		msg.address_lo |= HT_IRQ_LOW_VECTOR(cfg->vector) |
-				  HT_IRQ_LOW_DEST_ID(cfg->dest_apicid);
-		msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
-		msg.address_hi |= HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
-		write_ht_irq_msg(data->irq, &msg);
-	}
-
-	return ret;
+	struct irq_cfg *cfg = irqd_cfg(data);
+	struct ht_irq_cfg *ht_cfg = data->chip_data;
+
+	msg->address_hi = HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
+	msg->address_lo = HT_IRQ_LOW_BASE |
+			  HT_IRQ_LOW_DEST_ID(cfg->dest_apicid) |
+			  HT_IRQ_LOW_VECTOR(cfg->vector) |
+			  HT_IRQ_LOW_RQEOI_EDGE;
+	if (ht_cfg->masked)
+		msg->address_lo |= HT_IRQ_LOW_IRQ_MASKED;
+	if (apic->irq_dest_mode)
+		msg->address_lo |= HT_IRQ_LOW_DM_LOGICAL;
+	else
+		msg->address_lo |= HT_IRQ_LOW_DM_PHYSICAL;
+	if (apic->irq_delivery_mode == dest_LowestPrio)
+		msg->address_lo |= HT_IRQ_LOW_MT_ARBITRATED;
+	else
+		msg->address_lo |= HT_IRQ_LOW_MT_FIXED;
 }
 
 static struct irq_chip ht_irq_chip = {
@@ -55,40 +51,34 @@ static struct irq_chip ht_irq_chip = {
 	.irq_mask		= mask_ht_irq,
 	.irq_unmask		= unmask_ht_irq,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= ht_set_affinity,
+	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_compose_msi_msg	= ht_irq_compose_msg,
+	.irq_write_msi_msg	= write_ht_irq_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-static int htirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
-			      unsigned int nr_irqs, void *arg)
+static irq_hw_number_t ht_irq_get_hwirq(struct msi_domain_info *minfo,
+					void *arg)
 {
-	struct ht_irq_cfg *ht_cfg;
 	struct irq_alloc_info *info = arg;
-	struct pci_dev *dev;
-	irq_hw_number_t hwirq;
-	int ret;
+	struct pci_dev *dev = info->ht_dev;
 
-	if (nr_irqs > 1 || !info)
-		return -EINVAL;
-
-	dev = info->ht_dev;
-	hwirq = (info->ht_idx & 0xFF) |
+	return (info->ht_idx & 0xFF) |
 		PCI_DEVID(dev->bus->number, dev->devfn) << 8 |
 		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 24;
-	if (irq_find_mapping(domain, hwirq) > 0)
-		return -EEXIST;
+}
+
+static int ht_irq_init(struct irq_domain *domain, struct msi_domain_info *minfo,
+		       unsigned int virq, irq_hw_number_t hwirq, void *arg)
+{
+	struct ht_irq_cfg *ht_cfg;
+	struct irq_alloc_info *info = arg;
 
 	ht_cfg = kmalloc(sizeof(*ht_cfg), GFP_KERNEL);
 	if (!ht_cfg)
 		return -ENOMEM;
 
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
-	if (ret < 0) {
-		kfree(ht_cfg);
-		return ret;
-	}
-
 	/* Initialize msg to a value that will never match the first write. */
 	ht_cfg->msg.address_lo = 0xffffffff;
 	ht_cfg->msg.address_hi = 0xffffffff;
@@ -96,58 +86,30 @@ static int htirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	ht_cfg->update = info->ht_update;
 	ht_cfg->pos = info->ht_pos;
 	ht_cfg->idx = 0x10 + (info->ht_idx * 2);
-	irq_domain_set_info(domain, virq, hwirq, &ht_irq_chip, ht_cfg,
+	ht_cfg->masked = true;
+	irq_domain_set_info(domain, virq, hwirq, minfo->chip, ht_cfg,
 			    handle_edge_irq, NULL, "edge");
 
 	return 0;
 }
 
-static void htirq_domain_free(struct irq_domain *domain, unsigned int virq,
-			      unsigned int nr_irqs)
+static void ht_irq_free(struct irq_domain *domain, struct msi_domain_info *info,
+			unsigned int virq)
 {
 	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
 
-	BUG_ON(nr_irqs != 1);
 	kfree(irq_data->chip_data);
-	irq_domain_free_irqs_top(domain, virq, nr_irqs);
-}
-
-static void htirq_domain_activate(struct irq_domain *domain,
-				  struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
-
-	msg.address_hi = HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
-	msg.address_lo =
-		HT_IRQ_LOW_BASE |
-		HT_IRQ_LOW_DEST_ID(cfg->dest_apicid) |
-		HT_IRQ_LOW_VECTOR(cfg->vector) |
-		((apic->irq_dest_mode == 0) ?
-			HT_IRQ_LOW_DM_PHYSICAL :
-			HT_IRQ_LOW_DM_LOGICAL) |
-		HT_IRQ_LOW_RQEOI_EDGE |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			HT_IRQ_LOW_MT_FIXED :
-			HT_IRQ_LOW_MT_ARBITRATED) |
-		HT_IRQ_LOW_IRQ_MASKED;
-	write_ht_irq_msg(irq_data->irq, &msg);
 }
 
-static void htirq_domain_deactivate(struct irq_domain *domain,
-				    struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
-	write_ht_irq_msg(irq_data->irq, &msg);
-}
+static struct msi_domain_ops ht_irq_domain_ops = {
+	.get_hwirq = ht_irq_get_hwirq,
+	.msi_init = ht_irq_init,
+	.msi_free = ht_irq_free,
+};
 
-static struct irq_domain_ops htirq_domain_ops = {
-	.alloc = htirq_domain_alloc,
-	.free = htirq_domain_free,
-	.activate = htirq_domain_activate,
-	.deactivate = htirq_domain_deactivate,
+static struct msi_domain_info ht_irq_domain_info = {
+	.ops = &ht_irq_domain_ops,
+	.chip = &ht_irq_chip,
 };
 
 void arch_init_htirq_domain(struct irq_domain *parent)
@@ -155,11 +117,9 @@ void arch_init_htirq_domain(struct irq_domain *parent)
 	if (disable_apic)
 		return;
 
-	htirq_domain = irq_domain_add_tree(NULL, &htirq_domain_ops, NULL);
+	htirq_domain = msi_create_irq_domain(NULL, &ht_irq_domain_info, parent);
 	if (!htirq_domain)
 		pr_warn("failed to initialize irqdomain for HTIRQ.\n");
-	else
-		htirq_domain->parent = parent;
 }
 
 int arch_setup_ht_irq(int idx, int pos, struct pci_dev *dev,
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 7a8f1c5e65af..22f948f9738a 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -68,6 +68,7 @@ config HT_IRQ
 	bool "Interrupts on hypertransport devices"
 	default y
 	depends on PCI && X86_LOCAL_APIC
+	select GENERIC_MSI_IRQ_DOMAIN
 	help
 	   This allows native hypertransport devices to use interrupts.
 
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 3bbbc5cdcb9b..27b09b266bb6 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -23,9 +23,9 @@
  */
 static DEFINE_SPINLOCK(ht_irq_lock);
 
-void write_ht_irq_msg(unsigned int irq, struct msi_msg *msg)
+void write_ht_irq_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct ht_irq_cfg *cfg = irq_get_handler_data(irq);
+	struct ht_irq_cfg *cfg = data->chip_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ht_irq_lock, flags);
@@ -38,14 +38,14 @@ void write_ht_irq_msg(unsigned int irq, struct msi_msg *msg)
 		pci_write_config_dword(cfg->dev, cfg->pos + 4, msg->address_hi);
 	}
 	if (cfg->update)
-		cfg->update(cfg->dev, irq, msg);
+		cfg->update(cfg->dev, data->irq, msg);
 	spin_unlock_irqrestore(&ht_irq_lock, flags);
 	cfg->msg = *msg;
 }
 
-void fetch_ht_irq_msg(unsigned int irq, struct msi_msg *msg)
+void fetch_ht_irq_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct ht_irq_cfg *cfg = irq_get_handler_data(irq);
+	struct ht_irq_cfg *cfg = data->chip_data;
 
 	*msg = cfg->msg;
 }
@@ -56,7 +56,8 @@ void mask_ht_irq(struct irq_data *data)
 	struct msi_msg msg = cfg->msg;
 
 	msg.address_lo |= 1;
-	write_ht_irq_msg(data->irq, &msg);
+	write_ht_irq_msg(data, &msg);
+	cfg->masked = true;
 }
 
 void unmask_ht_irq(struct irq_data *data)
@@ -65,7 +66,8 @@ void unmask_ht_irq(struct irq_data *data)
 	struct msi_msg msg = cfg->msg;
 
 	msg.address_lo &= ~1;
-	write_ht_irq_msg(data->irq, &msg);
+	write_ht_irq_msg(data, &msg);
+	cfg->masked = false;
 }
 
 /**
diff --git a/include/linux/htirq.h b/include/linux/htirq.h
index 98e432f7f9b1..c5d03a81809c 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -14,12 +14,13 @@ struct ht_irq_cfg {
 	ht_irq_update_t *update;
 	unsigned pos;
 	unsigned idx;
+	bool masked;
 	struct msi_msg msg;
 };
 
 /* Helper functions.. */
-void fetch_ht_irq_msg(unsigned int irq, struct msi_msg *msg);
-void write_ht_irq_msg(unsigned int irq, struct msi_msg *msg);
+void fetch_ht_irq_msg(struct irq_data *data, struct msi_msg *msg);
+void write_ht_irq_msg(struct irq_data *data, struct msi_msg *msg);
 void mask_ht_irq(struct irq_data *data);
 void unmask_ht_irq(struct irq_data *data);
 
-- 
1.7.10.4

