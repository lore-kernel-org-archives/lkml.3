Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaIZODU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:03:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:54485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbaIZODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:03:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="609110503"
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
Subject: [RFT v2 22/24] x86, irq: Use hierarchy irqdomain to manage DMAR interrupts
Date: Fri, 26 Sep 2014 22:02:23 +0800
Message-Id: <1411740145-30626-23-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance DMAR code to support hierarchy irqdomain, it helps to make
the architecture more clear.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |    7 +++
 arch/x86/kernel/apic/msi.c    |  129 +++++++++++++++++++++++++++++++----------
 2 files changed, 106 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a5d3b1c46b30..7ed68ce5929a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -121,6 +121,7 @@ enum irq_alloc_type {
 	X86_IRQ_ALLOC_TYPE_HPET,
 	X86_IRQ_ALLOC_TYPE_MSI,
 	X86_IRQ_ALLOC_TYPE_MSIX,
+	X86_IRQ_ALLOC_TYPE_DMAR,
 };
 
 struct irq_alloc_info {
@@ -149,6 +150,12 @@ struct irq_alloc_info {
 			u32		ioapic_polarity : 1;
 		};
 #endif
+#ifdef	CONFIG_DMAR_TABLE
+		struct {
+			int		dmar_id;
+			void		*dmar_data;
+		};
+#endif
 	};
 };
 
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 08b6d1987ea6..409638b3918a 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -69,6 +69,9 @@ static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
 	msg->data |= MSI_DATA_VECTOR(cfg->vector);
 	msg->address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg->address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);
+	if (x2apic_enabled())
+		msg->address_hi = MSI_ADDR_BASE_HI |
+				  MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
 }
 
 static bool msi_irq_remapped(struct irq_data *irq_data)
@@ -298,58 +301,124 @@ static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		      bool force)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-	unsigned int dest, irq = data->irq;
+	struct irq_data *parent = data->parent_data;
 	struct msi_msg msg;
 	int ret;
 
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
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0) {
+		dmar_msi_read(data->irq, &msg);
+		msi_update_msg(&msg, data);
+		dmar_msi_write(data->irq, &msg);
+	}
 
-	return IRQ_SET_MASK_OK_NOCOPY;
+	return ret;
 }
 
 static struct irq_chip dmar_msi_type = {
 	.name			= "DMAR_MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
-	.irq_ack		= apic_ack_edge,
+	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= dmar_msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 };
 
-int dmar_alloc_hwirq(int id, int node, void *arg)
+static int dmar_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			     unsigned int nr_irqs, void *arg)
+{
+	struct irq_alloc_info *info = arg;
+	int ret;
+
+	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_DMAR)
+		return -EINVAL;
+	if (irq_find_mapping(domain, info->dmar_id)) {
+		pr_warn("IRQ for DMAR%d already exists.\n", info->dmar_id);
+		return -EEXIST;
+	}
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret >= 0) {
+		irq_domain_set_hwirq_and_chip(domain, virq, info->dmar_id,
+					      &dmar_msi_type, NULL);
+		irq_set_handler_data(virq, info->dmar_data);
+		__irq_set_handler(virq, handle_edge_irq, 0, "edge");
+	}
+
+	return ret;
+}
+
+static void dmar_domain_free(struct irq_domain *domain, unsigned int virq,
+			     unsigned int nr_irqs)
+{
+	BUG_ON(nr_irqs > 1);
+	msi_reset_irq_data_and_handler(domain, virq);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int dmar_domain_activate(struct irq_domain *domain,
+				struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	native_compose_msi_msg(irqd_cfg(irq_data), &msg);
+	dmar_msi_write(irq_data->irq, &msg);
+
+	return 0;
+}
+
+static int dmar_domain_deactivate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
 {
-	int irq;
 	struct msi_msg msg;
 
-	irq = irq_domain_alloc_irqs(NULL, 1, node, NULL);
-	if (irq > 0) {
-		irq_set_handler_data(irq, arg);
-		irq_set_chip_and_handler_name(irq, &dmar_msi_type,
-					      handle_edge_irq, "edge");
-		native_compose_msi_msg(irq_cfg(irq), &msg);
-		dmar_msi_write(irq, &msg);
+	memset(&msg, 0, sizeof(msg));
+	dmar_msi_write(irq_data->irq, &msg);
+
+	return 0;
+}
+
+static struct irq_domain_ops dmar_domain_ops = {
+	.alloc = dmar_domain_alloc,
+	.free = dmar_domain_free,
+	.activate = dmar_domain_activate,
+	.deactivate = dmar_domain_deactivate,
+};
+
+static struct irq_domain *dmar_get_irq_domain(void)
+{
+	static struct irq_domain *dmar_domain;
+	static DEFINE_MUTEX(dmar_lock);
+
+	mutex_lock(&dmar_lock);
+	if (dmar_domain == NULL) {
+		dmar_domain = irq_domain_add_tree(NULL, &dmar_domain_ops, NULL);
+		if (dmar_domain)
+			dmar_domain->parent = x86_vector_domain;
 	}
+	mutex_unlock(&dmar_lock);
+
+	return dmar_domain;
+}
+
+int dmar_alloc_hwirq(int id, int node, void *arg)
+{
+	struct irq_domain *domain = dmar_get_irq_domain();
+	struct irq_alloc_info info;
+
+	if (!domain)
+		return -1;
+
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_DMAR;
+	info.dmar_id = id;
+	info.dmar_data = arg;
 
-	return irq;
+	return irq_domain_alloc_irqs(domain, 1, node, &info);
 }
 
 void dmar_free_hwirq(int irq)
 {
-	irq_set_handler_data(irq, NULL);
-	irq_set_handler(irq, NULL);
 	irq_domain_free_irqs(irq, 1);
 }
 #endif
-- 
1.7.10.4

