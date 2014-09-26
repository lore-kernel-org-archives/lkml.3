Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaIZOCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:02:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:5513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbaIZOCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="609110200"
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
Subject: [RFT v2 14/24] x86, hpet: Enhance HPET IRQ to support hierarchy irqdomain
Date: Fri, 26 Sep 2014 22:02:15 +0800
Message-Id: <1411740145-30626-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance HPET code to support hierarchy irqdomain, it helps to make
the architecture more clear.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hpet.h |    7 +-
 arch/x86/kernel/apic/msi.c  |  168 ++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/hpet.c      |   57 ++++-----------
 3 files changed, 171 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 36f7125945e3..e87e9faf87a9 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -74,11 +74,16 @@ extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
 struct irq_data;
+struct hpet_dev;
+struct irq_domain;
+
 extern void hpet_msi_unmask(struct irq_data *data);
 extern void hpet_msi_mask(struct irq_data *data);
-struct hpet_dev;
 extern void hpet_msi_write(struct hpet_dev *hdev, struct msi_msg *msg);
 extern void hpet_msi_read(struct hpet_dev *hdev, struct msi_msg *msg);
+extern struct irq_domain *hpet_create_irq_domain(int hpet_id);
+extern int hpet_assign_irq(struct irq_domain *domain,
+			   struct hpet_dev *dev, int dev_num);
 
 #ifdef CONFIG_PCI_MSI
 extern int default_setup_hpet_msi(unsigned int irq, unsigned int id);
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 29012f37aad9..6711edcd08e6 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -21,6 +21,16 @@
 #include <asm/apic.h>
 #include <asm/irq_remapping.h>
 
+static void msi_reset_irq_data_and_handler(struct irq_domain *domain, int virq)
+{
+	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
+
+	if (irq_data);
+		irq_domain_reset_irq_data(irq_data);
+	irq_set_handler_data(virq, NULL);
+	irq_set_handler(virq, NULL);
+}
+
 void native_compose_msi_msg(struct pci_dev *pdev,
 			    unsigned int irq, unsigned int dest,
 			    struct msi_msg *msg, u8 hpet_id)
@@ -51,6 +61,16 @@ void native_compose_msi_msg(struct pci_dev *pdev,
 		MSI_DATA_VECTOR(cfg->vector);
 }
 
+static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
+{
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
+
+	msg->data &= ~MSI_DATA_VECTOR_MASK;
+	msg->data |= MSI_DATA_VECTOR(cfg->vector);
+	msg->address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg->address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);
+}
+
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			   struct msi_msg *msg, u8 hpet_id)
 {
@@ -237,38 +257,42 @@ void dmar_free_hwirq(int irq)
  * MSI message composition
  */
 #ifdef CONFIG_HPET_TIMER
+static inline int hpet_dev_id(struct irq_domain *domain)
+{
+	return (int)(long)domain->host_data;
+}
+
+static inline bool hpet_irq_remapped(struct irq_data *irq_data)
+{
+	return irq_remapping_domain_is_remapped(irq_data->domain);
+}
 
 static int hpet_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
+	struct irq_data *parent = data->parent_data;
 	struct msi_msg msg;
-	unsigned int dest;
 	int ret;
 
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
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	/* No need to rewrite HPET registers if interrupt is remapped */
+	if (ret >= 0 && !hpet_irq_remapped(data)) {
+		hpet_msi_read(data->handler_data, &msg);
+		msi_update_msg(&msg, data);
+		hpet_msi_write(data->handler_data, &msg);
+	}
 
-	return IRQ_SET_MASK_OK_NOCOPY;
+	return ret;
 }
 
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
-	.irq_ack = apic_ack_edge,
+	.irq_ack = irq_chip_ack_parent,
 	.irq_set_affinity = hpet_msi_set_affinity,
-	.irq_retrigger = apic_retrigger_irq,
+	.irq_retrigger = irq_chip_retrigger_hierarchy,
+	.irq_print_chip = irq_remapping_print_chip,
 };
 
 int default_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -288,4 +312,114 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
 }
+
+static int hpet_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			     unsigned int nr_irqs, void *arg)
+{
+	struct irq_alloc_info *info = arg;
+	int ret;
+
+	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_HPET)
+		return -EINVAL;
+	if (irq_find_mapping(domain, info->hpet_index)) {
+		pr_warn("IRQ for HPET%d already exists.\n", info->hpet_index);
+		return -EEXIST;
+	}
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret >= 0) {
+		irq_set_status_flags(virq, IRQ_MOVE_PCNTXT);
+		irq_domain_set_hwirq_and_chip(domain, virq, info->hpet_index,
+					      &hpet_msi_type, NULL);
+		irq_set_handler_data(virq, info->hpet_data);
+		__irq_set_handler(virq, handle_edge_irq, 0, "edge");
+	}
+
+	return ret;
+}
+
+static void hpet_domain_free(struct irq_domain *domain, unsigned int virq,
+			     unsigned int nr_irqs)
+{
+	BUG_ON(nr_irqs > 1);
+	msi_reset_irq_data_and_handler(domain, virq);
+	irq_clear_status_flags(virq, IRQ_MOVE_PCNTXT);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int hpet_domain_activate(struct irq_domain *domain,
+				struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
+
+	if (hpet_irq_remapped(irq_data))
+		irq_remapping_get_msi_entry(irq_data->parent_data, &msg);
+	else
+		native_compose_msi_msg(NULL, irq_data->irq, cfg->dest_apicid,
+				       &msg, hpet_dev_id(domain));
+	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
+
+	return 0;
+}
+
+static int hpet_domain_deactivate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
+
+	return 0;
+}
+
+static struct irq_domain_ops hpet_domain_ops = {
+	.alloc = hpet_domain_alloc,
+	.free = hpet_domain_free,
+	.activate = hpet_domain_activate,
+	.deactivate = hpet_domain_deactivate,
+};
+
+struct irq_domain *hpet_create_irq_domain(int hpet_id)
+{
+	struct irq_domain *parent, *domain;
+	struct irq_alloc_info info;
+	bool remapped = false;
+
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_HPET;
+	info.hpet_id = hpet_id;
+	parent = irq_remapping_get_ir_irq_domain(&info);
+	if (parent)
+		remapped = true;
+	else
+		parent = x86_vector_domain;
+	if (!parent)
+		return NULL;
+
+	domain = irq_domain_add_tree(NULL, &hpet_domain_ops,
+				     (void *)(long)hpet_id);
+	if (domain) {
+		domain->parent = parent;
+		if (remapped)
+			irq_remapping_domain_set_remapped(domain);
+	}
+
+	return domain;
+}
+
+int hpet_assign_irq(struct irq_domain *domain, struct hpet_dev *dev,
+		    int dev_num)
+{
+	struct irq_alloc_info info;
+
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_HPET;
+	info.hpet_data = dev;
+	info.hpet_id = hpet_dev_id(domain);
+	info.hpet_index = dev_num;
+
+	return irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, NULL);
+}
 #endif
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 24db2d33fab7..a22d7288202b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -306,8 +306,6 @@ static void hpet_legacy_clockevent_register(void)
 	printk(KERN_DEBUG "hpet clockevent registered\n");
 }
 
-static int hpet_setup_msi_irq(unsigned int irq);
-
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
@@ -358,7 +356,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 			hpet_enable_legacy_int();
 		} else {
 			struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
-			hpet_setup_msi_irq(hdev->irq);
+			irq_domain_activate_irq(irq_get_irq_data(hdev->irq));
 			disable_irq(hdev->irq);
 			irq_set_affinity(hdev->irq, cpumask_of(hdev->cpu));
 			enable_irq(hdev->irq);
@@ -424,6 +422,7 @@ static int hpet_legacy_next_event(unsigned long delta,
 
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
+static struct irq_domain *hpet_domain;
 
 void hpet_msi_unmask(struct irq_data *data)
 {
@@ -474,32 +473,6 @@ static int hpet_msi_next_event(unsigned long delta,
 	return hpet_next_event(delta, evt, hdev->num);
 }
 
-static int hpet_setup_msi_irq(unsigned int irq)
-{
-	if (x86_msi.setup_hpet_msi(irq, hpet_blockid)) {
-		irq_domain_free_irqs(irq, 1);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int hpet_assign_irq(struct hpet_dev *dev)
-{
-	int irq;
-
-	irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
-	if (irq <= 0)
-		return -EINVAL;
-
-	irq_set_handler_data(irq, dev);
-
-	if (hpet_setup_msi_irq(irq))
-		return -EINVAL;
-
-	dev->irq = irq;
-	return 0;
-}
-
 static irqreturn_t hpet_interrupt_handler(int irq, void *data)
 {
 	struct hpet_dev *dev = (struct hpet_dev *)data;
@@ -542,9 +515,6 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 	if (!(hdev->flags & HPET_DEV_VALID))
 		return;
 
-	if (hpet_setup_msi_irq(hdev->irq))
-		return;
-
 	hdev->cpu = cpu;
 	per_cpu(cpu_hpet_dev, cpu) = hdev;
 	evt->name = hdev->name;
@@ -576,7 +546,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	unsigned int id;
 	unsigned int num_timers;
 	unsigned int num_timers_used = 0;
-	int i;
+	int i, irq;
 
 	if (hpet_msi_disable)
 		return;
@@ -589,6 +559,10 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	num_timers++; /* Value read out starts from 0 */
 	hpet_print_config();
 
+	hpet_domain = hpet_create_irq_domain(hpet_blockid);
+	if (!hpet_domain)
+		return;
+
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
 	if (!hpet_devs)
 		return;
@@ -603,15 +577,16 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 		if (!(cfg & HPET_TN_FSB_CAP))
 			continue;
 
+		irq = hpet_assign_irq(hpet_domain, hdev, hdev->num);
+		if (irq < 0)
+			continue;
+
+		sprintf(hdev->name, "hpet%d", i);
+		hdev->num = i;
+		hdev->irq = irq;
 		hdev->flags = 0;
 		if (cfg & HPET_TN_PERIODIC_CAP)
 			hdev->flags |= HPET_DEV_PERI_CAP;
-		hdev->num = i;
-
-		sprintf(hdev->name, "hpet%d", i);
-		if (hpet_assign_irq(hdev))
-			continue;
-
 		hdev->flags |= HPET_DEV_FSB_CAP;
 		hdev->flags |= HPET_DEV_VALID;
 		num_timers_used++;
@@ -711,10 +686,6 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 }
 #else
 
-static int hpet_setup_msi_irq(unsigned int irq)
-{
-	return 0;
-}
 static void hpet_msi_capability_lookup(unsigned int start_timer)
 {
 	return;
-- 
1.7.10.4

