Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaKZXLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:11:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaKZXLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:11:45 -0500
Date: Wed, 26 Nov 2014 15:10:51 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9a013f9684208bc74e9aff1e0414276489396a1a@git.kernel.org>
Cc: rjw@rjwysocki.net, konrad.wilk@oracle.com, mingo@kernel.org, hpa@zytor.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com,
        benh@kernel.crashing.org, tglx@linutronix.de,
        jiang.liu@linux.intel.com, rdunlap@infradead.org, joro@8bytes.org,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        bp@alien8.de
Reply-To: tglx@linutronix.de, jiang.liu@linux.intel.com,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, rjw@rjwysocki.net, mingo@kernel.org,
        hpa@zytor.com, konrad.wilk@oracle.com, bp@alien8.de,
        yinghai@kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        joro@8bytes.org, rdunlap@infradead.org
In-Reply-To: <1416894816-23245-21-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-21-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Use hierarchy irqdomain to manage DMAR interrupts
Git-Commit-ID: 9a013f9684208bc74e9aff1e0414276489396a1a
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

Commit-ID:  9a013f9684208bc74e9aff1e0414276489396a1a
Gitweb:     http://git.kernel.org/tip/9a013f9684208bc74e9aff1e0414276489396a1a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:29 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

x86, irq: Use hierarchy irqdomain to manage DMAR interrupts

Enhance DMAR code to support hierarchy irqdomain, it helps to make
the architecture more clear.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-21-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h |   7 ++
 arch/x86/kernel/apic/msi.c    | 153 ++++++++++++++++++++++++++----------------
 2 files changed, 103 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 270c432..29f1dc1 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -122,6 +122,7 @@ enum irq_alloc_type {
 	X86_IRQ_ALLOC_TYPE_HPET,
 	X86_IRQ_ALLOC_TYPE_MSI,
 	X86_IRQ_ALLOC_TYPE_MSIX,
+	X86_IRQ_ALLOC_TYPE_DMAR,
 };
 
 struct irq_alloc_info {
@@ -154,6 +155,12 @@ struct irq_alloc_info {
 			struct IO_APIC_route_entry *ioapic_entry;
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
index 695c82b..a24b803 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -25,32 +25,6 @@
 
 static struct irq_domain *msi_default_domain;
 
-static void native_compose_msi_msg(struct irq_cfg *cfg, struct msi_msg *msg)
-{
-	msg->address_hi = MSI_ADDR_BASE_HI;
-
-	if (x2apic_enabled())
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
-
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		((apic->irq_dest_mode == 0) ?
-			MSI_ADDR_DEST_MODE_PHYSICAL :
-			MSI_ADDR_DEST_MODE_LOGICAL) |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_ADDR_REDIRECTION_CPU :
-			MSI_ADDR_REDIRECTION_LOWPRI) |
-		MSI_ADDR_DEST_ID(cfg->dest_apicid);
-
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_DATA_DELIVERY_FIXED :
-			MSI_DATA_DELIVERY_LOWPRI) |
-		MSI_DATA_VECTOR(cfg->vector);
-}
-
 static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	struct irq_cfg *cfg = irqd_cfg(data);
@@ -87,6 +61,9 @@ static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
 	msg->data |= MSI_DATA_VECTOR(cfg->vector);
 	msg->address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg->address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);
+	if (x2apic_enabled())
+		msg->address_hi = MSI_ADDR_BASE_HI |
+				  MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
 }
 
 /*
@@ -196,59 +173,121 @@ static int
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
 
-static struct irq_chip dmar_msi_type = {
+static struct irq_chip dmar_msi_controller = {
 	.name			= "DMAR_MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
-	.irq_ack		= apic_ack_edge,
+	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= dmar_msi_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
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
+					      &dmar_msi_controller, NULL);
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
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+}
+
+static void dmar_domain_activate(struct irq_domain *domain,
+				 struct irq_data *irq_data)
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
+	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	dmar_msi_write(irq_data->irq, &msg);
+}
+
+static void dmar_domain_deactivate(struct irq_domain *domain,
+				   struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+	dmar_msi_write(irq_data->irq, &msg);
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
