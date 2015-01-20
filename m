Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbbATDLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:11:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:39987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbATDLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:11:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529595"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 27/38] x86/irq: Simplify MSI/DMAR/HPET implementation by using common code
Date: Tue, 20 Jan 2015 11:08:30 +0800
Message-Id: <1421723321-8386-28-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common MSI interfaces to simplify DMAR/HPET driver implementation.

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
Link: http://lkml.kernel.org/r/1416894816-23245-28-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/msi.c |  192 +++++++++++++-------------------------------
 1 file changed, 54 insertions(+), 138 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index f5b899514634..da163da5fdee 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -62,10 +62,8 @@ static struct irq_chip pci_msi_controller = {
 	.irq_unmask		= pci_msi_unmask_irq,
 	.irq_mask		= pci_msi_mask_irq,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
-	.irq_write_msi_msg	= pci_msi_domain_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -153,9 +151,7 @@ static struct irq_chip pci_msi_ir_controller = {
 	.irq_unmask		= pci_msi_unmask_irq,
 	.irq_mask		= pci_msi_mask_irq,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
-	.irq_write_msi_msg	= pci_msi_domain_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -175,23 +171,6 @@ struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 #endif
 
 #ifdef CONFIG_DMAR_TABLE
-static int
-dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		      bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct msi_msg msg;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0) {
-		irq_chip_compose_msi_msg(data, &msg);
-		dmar_msi_write(data->irq, &msg);
-	}
-
-	return ret;
-}
-
 static void dmar_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	dmar_msi_write(data->irq, msg);
@@ -202,67 +181,37 @@ static struct irq_chip dmar_msi_controller = {
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= dmar_msi_set_affinity,
+	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-static int dmar_domain_alloc(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs, void *arg)
+static irq_hw_number_t dmar_msi_get_hwirq(struct msi_domain_info *info,
+					  msi_alloc_info_t *arg)
 {
-	struct irq_alloc_info *info = arg;
-	int ret;
-
-	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_DMAR)
-		return -EINVAL;
-	if (irq_find_mapping(domain, info->dmar_id)) {
-		pr_warn("IRQ for DMAR%d already exists.\n", info->dmar_id);
-		return -EEXIST;
-	}
-
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
-	if (ret >= 0) {
-		irq_domain_set_hwirq_and_chip(domain, virq, info->dmar_id,
-					      &dmar_msi_controller, NULL);
-		irq_set_handler_data(virq, info->dmar_data);
-		__irq_set_handler(virq, handle_edge_irq, 0, "edge");
-	}
-
-	return ret;
+	return arg->dmar_id;
 }
 
-static void dmar_domain_free(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs)
+static int dmar_msi_init(struct irq_domain *domain,
+			 struct msi_domain_info *info, unsigned int virq,
+			 irq_hw_number_t hwirq, msi_alloc_info_t *arg)
 {
-	BUG_ON(nr_irqs > 1);
-	irq_domain_free_irqs_top(domain, virq, nr_irqs);
-}
+	irq_domain_set_info(domain, virq, arg->dmar_id, info->chip, NULL,
+			    handle_edge_irq, arg->dmar_data, "edge");
 
-static void dmar_domain_activate(struct irq_domain *domain,
-				 struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
-	dmar_msi_write(irq_data->irq, &msg);
+	return 0;
 }
 
-static void dmar_domain_deactivate(struct irq_domain *domain,
-				   struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
-	dmar_msi_write(irq_data->irq, &msg);
-}
+static struct msi_domain_ops dmar_msi_domain_ops = {
+	.get_hwirq	= dmar_msi_get_hwirq,
+	.msi_init	= dmar_msi_init,
+};
 
-static struct irq_domain_ops dmar_domain_ops = {
-	.alloc = dmar_domain_alloc,
-	.free = dmar_domain_free,
-	.activate = dmar_domain_activate,
-	.deactivate = dmar_domain_deactivate,
+static struct msi_domain_info dmar_msi_domain_info = {
+	.ops		= &dmar_msi_domain_ops,
+	.chip		= &dmar_msi_controller,
 };
 
 static struct irq_domain *dmar_get_irq_domain(void)
@@ -271,11 +220,9 @@ static struct irq_domain *dmar_get_irq_domain(void)
 	static DEFINE_MUTEX(dmar_lock);
 
 	mutex_lock(&dmar_lock);
-	if (dmar_domain == NULL) {
-		dmar_domain = irq_domain_add_tree(NULL, &dmar_domain_ops, NULL);
-		if (dmar_domain)
-			dmar_domain->parent = x86_vector_domain;
-	}
+	if (dmar_domain == NULL)
+		dmar_domain = msi_create_irq_domain(NULL, &dmar_msi_domain_info,
+						    x86_vector_domain);
 	mutex_unlock(&dmar_lock);
 
 	return dmar_domain;
@@ -309,23 +256,9 @@ void dmar_free_hwirq(int irq)
 #ifdef CONFIG_HPET_TIMER
 static inline int hpet_dev_id(struct irq_domain *domain)
 {
-	return (int)(long)domain->host_data;
-}
+	struct msi_domain_info *info = msi_get_domain_info(domain);
 
-static int hpet_msi_set_affinity(struct irq_data *data,
-				 const struct cpumask *mask, bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct msi_msg msg;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		irq_chip_compose_msi_msg(data, &msg);
-		hpet_msi_write(data->handler_data, &msg);
-	}
-
-	return ret;
+	return (int)(long)info->data;
 }
 
 static void hpet_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
@@ -338,79 +271,63 @@ static struct irq_chip hpet_msi_controller = {
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
 	.irq_ack = irq_chip_ack_parent,
-	.irq_set_affinity = hpet_msi_set_affinity,
+	.irq_set_affinity = msi_domain_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg = irq_msi_compose_msg,
 	.irq_write_msi_msg = hpet_msi_write_msg,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
-static int hpet_domain_alloc(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs, void *arg)
-{
-	struct irq_alloc_info *info = arg;
-	int ret;
-
-	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_HPET)
-		return -EINVAL;
-	if (irq_find_mapping(domain, info->hpet_index)) {
-		pr_warn("IRQ for HPET%d already exists.\n", info->hpet_index);
-		return -EEXIST;
-	}
-
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
-	if (ret >= 0) {
-		irq_set_status_flags(virq, IRQ_MOVE_PCNTXT);
-		irq_domain_set_hwirq_and_chip(domain, virq, info->hpet_index,
-					      &hpet_msi_controller, NULL);
-		irq_set_handler_data(virq, info->hpet_data);
-		__irq_set_handler(virq, handle_edge_irq, 0, "edge");
-	}
-
-	return ret;
-}
-
-static void hpet_domain_free(struct irq_domain *domain, unsigned int virq,
-			     unsigned int nr_irqs)
+static irq_hw_number_t hpet_msi_get_hwirq(struct msi_domain_info *info,
+					  msi_alloc_info_t *arg)
 {
-	BUG_ON(nr_irqs > 1);
-	irq_clear_status_flags(virq, IRQ_MOVE_PCNTXT);
-	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+	return arg->hpet_index;
 }
 
-static void hpet_domain_activate(struct irq_domain *domain,
-				struct irq_data *irq_data)
+static int hpet_msi_init(struct irq_domain *domain,
+			 struct msi_domain_info *info, unsigned int virq,
+			 irq_hw_number_t hwirq, msi_alloc_info_t *arg)
 {
-	struct msi_msg msg;
+	irq_set_status_flags(virq, IRQ_MOVE_PCNTXT);
+	irq_domain_set_info(domain, virq, arg->hpet_index, info->chip, NULL,
+			    handle_edge_irq, arg->hpet_data, "edge");
 
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
-	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
+	return 0;
 }
 
-static void hpet_domain_deactivate(struct irq_domain *domain,
-				  struct irq_data *irq_data)
+static void hpet_msi_free(struct irq_domain *domain,
+			  struct msi_domain_info *info, unsigned int virq)
 {
-	struct msi_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
-	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
+	irq_clear_status_flags(virq, IRQ_MOVE_PCNTXT);
 }
 
-static struct irq_domain_ops hpet_domain_ops = {
-	.alloc = hpet_domain_alloc,
-	.free = hpet_domain_free,
-	.activate = hpet_domain_activate,
-	.deactivate = hpet_domain_deactivate,
+static struct msi_domain_ops hpet_msi_domain_ops = {
+	.get_hwirq	= hpet_msi_get_hwirq,
+	.msi_init	= hpet_msi_init,
+	.msi_free	= hpet_msi_free,
+};
+
+static struct msi_domain_info hpet_msi_domain_info = {
+	.ops		= &hpet_msi_domain_ops,
+	.chip		= &hpet_msi_controller,
 };
 
 struct irq_domain *hpet_create_irq_domain(int hpet_id)
 {
 	struct irq_domain *parent;
 	struct irq_alloc_info info;
+	struct msi_domain_info *domain_info;
 
 	if (x86_vector_domain == NULL)
 		return NULL;
 
+	domain_info = kzalloc(sizeof(*domain_info), GFP_KERNEL);
+	if (!domain_info)
+		return NULL;
+
+	*domain_info = hpet_msi_domain_info;
+	domain_info->data = (void *)(long)hpet_id;
+
 	init_irq_alloc_info(&info, NULL);
 	info.type = X86_IRQ_ALLOC_TYPE_HPET;
 	info.hpet_id = hpet_id;
@@ -420,8 +337,7 @@ struct irq_domain *hpet_create_irq_domain(int hpet_id)
 	else
 		hpet_msi_controller.name = "IR-HPET-MSI";
 
-	return irq_domain_add_hierarchy(parent, 0, 0, NULL, &hpet_domain_ops,
-					(void *)(long)hpet_id);
+	return msi_create_irq_domain(NULL, domain_info, parent);
 }
 
 int hpet_assign_irq(struct irq_domain *domain, struct hpet_dev *dev,
-- 
1.7.10.4

