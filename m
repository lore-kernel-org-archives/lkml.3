Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaIZOzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:55:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:52099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbaIZOzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597291998"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 03/28] x86, irq: Implement callbacks to enable hierarchy irqdomain on IOAPICs
Date: Fri, 26 Sep 2014 22:57:33 +0800
Message-Id: <1411743478-31435-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement required callbacks to prepare for enabling hierarchy irqdomain
on IOAPICs. Later we will clean up IOAPIC code a lot by using hierarchy
irqdomain framework.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |   10 ++
 arch/x86/kernel/apic/io_apic.c |  233 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 238 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bfab460f6e2c..bc3bef8f1a4b 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -96,6 +96,7 @@ struct IR_IO_APIC_route_entry {
 } __attribute__ ((packed));
 
 struct irq_alloc_info;
+struct irq_data;
 
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
@@ -206,6 +207,15 @@ extern int mp_ioapic_registered(u32 gsi_base);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
+extern int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs, void *arg);
+extern void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs);
+extern int mp_irqdomain_activate(struct irq_domain *domain,
+				 struct irq_data *irq_data);
+extern int mp_irqdomain_deactivate(struct irq_domain *domain,
+				   struct irq_data *irq_data);
+extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
 extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
 				  int node, int trigger, int polarity);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d17a71679775..61cf53b65225 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -78,6 +78,11 @@ static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
 static int ioapic_initialized;
 
+struct mp_chip_data {
+	struct IO_APIC_route_entry entry;
+	bool remapped;
+};
+
 struct mp_pin_info {
 	int trigger;
 	int polarity;
@@ -157,6 +162,18 @@ static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
 	return ioapics[ioapic].irqdomain;
 }
 
+int mp_irqdomain_ioapic_idx(struct irq_domain *domain)
+{
+	return (int)(long)domain->host_data;
+}
+
+static bool ioapic_irq_remapped(struct irq_data *irq_data)
+{
+	struct mp_chip_data *data = irq_data->chip_data;
+
+	return data->remapped;
+}
+
 int nr_ioapics;
 
 /* The one past the highest gsi number used */
@@ -953,7 +970,7 @@ static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin,
 				 struct irq_alloc_info *info)
 {
 	int irq = -1;
-	int ioapic = (int)(long)domain->host_data;
+	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	int type = ioapics[ioapic].irqdomain_cfg.type;
 
 	switch (type) {
@@ -1099,7 +1116,7 @@ void mp_unmap_irq(int irq)
 	if (!data || !data->domain)
 		return;
 
-	ioapic = (int)(long)data->domain->host_data;
+	ioapic = mp_irqdomain_ioapic_idx(data->domain);
 	pin = (int)data->hwirq;
 	info = mp_pin_info(ioapic, pin);
 
@@ -2339,10 +2356,13 @@ out:
 static int mp_irqdomain_create(int ioapic)
 {
 	size_t size;
+	struct irq_alloc_info info;
+	struct irq_domain *parent;
 	int hwirqs = mp_ioapic_pin_count(ioapic);
 	struct ioapic *ip = &ioapics[ioapic];
 	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
 	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+	bool remapped = false;
 
 	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
 	ip->pin_info = kzalloc(size, GFP_KERNEL);
@@ -2352,9 +2372,22 @@ static int mp_irqdomain_create(int ioapic)
 	if (cfg->type == IOAPIC_DOMAIN_INVALID)
 		return 0;
 
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_IOAPIC;
+	info.ioapic_id = mpc_ioapic_id(ioapic);
+	parent = irq_remapping_get_ir_irq_domain(&info);
+	if (parent)
+		remapped = true;
+	else
+		parent = x86_vector_domain;
+
 	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
 					      (void *)(long)ioapic);
-	if(!ip->irqdomain) {
+	if(ip->irqdomain) {
+		ip->irqdomain->parent = parent;
+		if (remapped)
+			irq_remapping_domain_set_remapped(ip->irqdomain);
+	} else {
 		kfree(ip->pin_info);
 		ip->pin_info = NULL;
 		return -ENOMEM;
@@ -3017,7 +3050,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 		     irq_hw_number_t hwirq)
 {
-	int ioapic = (int)(long)domain->host_data;
+	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
 	struct io_apic_irq_attr attr;
 
@@ -3055,7 +3088,7 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 {
 	struct irq_data *data = irq_get_irq_data(virq);
 	struct irq_cfg *cfg = irq_cfg(virq);
-	int ioapic = (int)(long)domain->host_data;
+	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	int pin = (int)data->hwirq;
 
 	ioapic_mask_entry(ioapic, pin);
@@ -3064,6 +3097,196 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 	arch_teardown_hwirq(virq);
 }
 
+static int mp_irqdomain_get_attr(int irq, u32 gsi, struct mp_pin_info *pinfo,
+				 struct irq_alloc_info *info)
+{
+	/*
+	 * setup_IO_APIC_irqs() programs all legacy IRQs with default
+	 * trigger and polarity attirbutes. So allow the first user
+	 * to reprogram the pin with real trigger and polarity attributes.
+	 */
+	if (pinfo->count == 0 ||
+	    (pinfo->count == 1 && irq < nr_legacy_irqs())) {
+		if (info && info->ioapic_valid) {
+			pinfo->trigger = info->ioapic_trigger;
+			pinfo->polarity = info->ioapic_polarity;
+		} else if (acpi_get_override_irq(gsi, &pinfo->trigger,
+						 &pinfo->polarity) < 0) {
+			/*
+			 * PCI interrupts are always polarity one level
+			 * triggered.
+			 */
+			pinfo->trigger = 1;
+			pinfo->polarity = 1;
+		}
+	} else if (pinfo->trigger != info->ioapic_trigger ||
+		   pinfo->polarity != info->ioapic_polarity) {
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void mp_irqdomain_setup_entry(bool remapped,
+				     struct irq_data *irq_data,
+				     struct irq_cfg *cfg,
+				     struct mp_pin_info *pinfo,
+				     struct IO_APIC_route_entry *entry)
+{
+	memset(entry, 0, sizeof(*entry));
+	if (remapped) {
+		irq_remapping_get_ioapic_entry(irq_data->parent_data,
+				(struct IR_IO_APIC_route_entry *)entry);
+	} else {
+		entry->delivery_mode = apic->irq_delivery_mode;
+		entry->dest_mode     = apic->irq_dest_mode;
+		entry->dest	     = cfg->dest_apicid;
+		entry->vector	     = cfg->vector;
+		entry->mask	     = 0;	/* enable IRQ */
+		entry->trigger	     = pinfo->trigger;
+		entry->polarity	     = pinfo->polarity;
+		/*
+		 * Mask level triggered irqs.
+		 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+		 */
+		if (pinfo->trigger)
+			entry->mask = 1;
+	}
+}
+
+static void mp_irqdomain_register_handler(unsigned int irq, int remapped,
+					  unsigned long trigger)
+{
+	irq_flow_handler_t hdl;
+	bool fasteoi;
+
+	if (trigger) {
+		irq_set_status_flags(irq, IRQ_LEVEL);
+		fasteoi = true;
+	} else {
+		irq_clear_status_flags(irq, IRQ_LEVEL);
+		fasteoi = false;
+	}
+	if (remapped)
+		fasteoi = trigger != 0;
+
+	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
+	__irq_set_handler(irq, hdl, 0, fasteoi ? "fasteoi" : "edge");
+}
+
+int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
+		       unsigned int nr_irqs, void *arg)
+{
+	bool remapped;
+	int ret, ioapic, pin;
+	struct irq_cfg *cfg;
+	struct irq_data *irq_data;
+	struct mp_chip_data *data;
+	struct mp_pin_info *pinfo;
+	struct irq_alloc_info *info = arg;
+
+	if (!info || nr_irqs > 1)
+		return -EINVAL;
+	irq_data = irq_domain_get_irq_data(domain, virq);
+	if (!irq_data)
+		return -EINVAL;
+
+	ioapic = mp_irqdomain_ioapic_idx(domain);
+	pin = info->ioapic_pin;
+	pinfo = mp_pin_info(ioapic, pin);
+	if (mp_irqdomain_get_attr(virq, mp_pin_to_gsi(ioapic, pin),
+				  pinfo, info))
+		return -EINVAL;
+
+	remapped = irq_remapping_domain_is_remapped(domain);
+	if (irq_find_mapping(domain, (irq_hw_number_t)pin) > 0) {
+		if (virq >= nr_legacy_irqs())
+			return -EEXIST;
+
+		/* Allow rewriting of legacy IRQ's attributes */
+		data = irq_data->chip_data;
+		cfg = irqd_cfg(irq_data);
+		mp_irqdomain_setup_entry(remapped, irq_data, cfg, pinfo,
+					 &data->entry);
+		mp_irqdomain_register_handler(virq, remapped, pinfo->trigger);
+		return 0;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
+	if (ret < 0) {
+		kfree(data);
+		return ret;
+	}
+
+	data->remapped = remapped;
+	irq_data->hwirq = info->ioapic_pin;
+	irq_data->chip = &ioapic_chip;
+	irq_data->chip_data = data;
+
+	cfg = irqd_cfg(irq_data);
+	add_pin_to_irq_node(cfg, info->ioapic_node, ioapic, pin);
+	mp_irqdomain_setup_entry(remapped, irq_data, cfg, pinfo, &data->entry);
+	mp_irqdomain_register_handler(virq, remapped, pinfo->trigger);
+	if (virq < nr_legacy_irqs())
+		legacy_pic->mask(virq);
+
+	apic_printk(APIC_VERBOSE, KERN_DEBUG
+		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> IRQ %d Mode:%i Active:%i Dest:%d)\n",
+		    ioapic, mpc_ioapic_id(ioapic), pin, cfg->vector,
+		    virq, pinfo->trigger, pinfo->polarity, cfg->dest_apicid);
+
+	return 0;
+}
+
+void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
+		       unsigned int nr_irqs)
+{
+	struct irq_cfg *cfg = irq_cfg(virq);
+	struct irq_data *irq_data;
+
+	BUG_ON(nr_irqs != 1);
+	irq_data = irq_domain_get_irq_data(domain, virq);
+	if (irq_data && irq_data->chip_data) {
+		__remove_pin_from_irq(cfg, mp_irqdomain_ioapic_idx(domain),
+				      (int)irq_data->hwirq);
+		WARN_ON(!list_empty(&cfg->irq_2_pin));
+		kfree(irq_data->chip_data);
+	}
+	irq_set_handler(virq, NULL);
+	irq_domain_reset_irq_data(irq_data);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+int mp_irqdomain_activate(struct irq_domain *domain,
+			  struct irq_data *irq_data)
+{
+	unsigned long flags;
+	struct irq_pin_list *entry;
+	struct mp_chip_data *data = irq_data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		__ioapic_write_entry(entry->apic, entry->pin, data->entry);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return 0;
+}
+
+int mp_irqdomain_deactivate(struct irq_domain *domain,
+			    struct irq_data *irq_data)
+{
+	/* It won't be called for IRQ with multiple IOAPIC pins associated */
+	ioapic_mask_entry(mp_irqdomain_ioapic_idx(domain),
+			  (int)irq_data->hwirq);
+
+	return 0;
+}
+
 int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 {
 	int ret = 0;
-- 
1.7.10.4

