Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaIZPE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:04:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:47861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbaIZO4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292068"
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
Subject: [RFC v1 06/28] x86, irq: Kill unused old IOAPIC irqdomain interfaces
Date: Fri, 26 Sep 2014 22:57:36 +0800
Message-Id: <1411743478-31435-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted to hierarchy irqdomain, so kill unused old IOAPIC
irqdomain interfaces and code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 -
 arch/x86/kernel/apic/io_apic.c |  199 ----------------------------------------
 2 files changed, 203 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bc3bef8f1a4b..051011adff9b 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -204,9 +204,6 @@ extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      struct ioapic_domain_cfg *cfg);
 extern int mp_unregister_ioapic(u32 gsi_base);
 extern int mp_ioapic_registered(u32 gsi_base);
-extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
-			    irq_hw_number_t hwirq);
-extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nr_irqs, void *arg);
 extern void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
@@ -218,7 +215,6 @@ extern int mp_irqdomain_deactivate(struct irq_domain *domain,
 extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
 extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
 				  int node, int trigger, int polarity);
-extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 extern bool mp_should_keep_irq(struct device *dev);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b87b69e3f3e2..b0121560f05d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1288,30 +1288,6 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 #endif
 
-static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
-				 unsigned long trigger)
-{
-	struct irq_chip *chip = &ioapic_chip;
-	irq_flow_handler_t hdl;
-	bool fasteoi;
-
-	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL) {
-		irq_set_status_flags(irq, IRQ_LEVEL);
-		fasteoi = true;
-	} else {
-		irq_clear_status_flags(irq, IRQ_LEVEL);
-		fasteoi = false;
-	}
-
-	if (setup_remapped_irq(irq, cfg, chip))
-		fasteoi = trigger != 0;
-
-	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
-	irq_set_chip_and_handler_name(irq, chip, hdl,
-				      fasteoi ? "fasteoi" : "edge");
-}
-
 int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int vector,
 			      struct io_apic_irq_attr *attr)
@@ -1336,48 +1312,6 @@ int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	return 0;
 }
 
-static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
-				struct io_apic_irq_attr *attr)
-{
-	struct IO_APIC_route_entry entry;
-	unsigned int dest;
-
-	if (!IO_APIC_IRQ(irq))
-		return;
-
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
-		return;
-
-	if (apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus(),
-					 &dest)) {
-		pr_warn("Failed to obtain apicid for ioapic %d, pin %d\n",
-			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		clear_irq_vector(irq, cfg);
-
-		return;
-	}
-
-	apic_printk(APIC_VERBOSE,KERN_DEBUG
-		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
-		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
-		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
-		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
-
-	if (x86_io_apic_ops.setup_entry(irq, &entry, dest, cfg->vector, attr)) {
-		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		clear_irq_vector(irq, cfg);
-
-		return;
-	}
-
-	ioapic_register_intr(irq, cfg, attr->trigger);
-	if (irq < nr_legacy_irqs())
-		legacy_pic->mask(irq);
-
-	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
 	unsigned int ioapic, pin;
@@ -1397,46 +1331,6 @@ static void __init setup_IO_APIC_irqs(void)
 	}
 }
 
-/*
- * Set up the timer pin, possibly with the 8259A-master behind.
- */
-static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
-					unsigned int pin, int vector)
-{
-	struct IO_APIC_route_entry entry;
-	unsigned int dest;
-
-	memset(&entry, 0, sizeof(entry));
-
-	/*
-	 * We use logical delivery to get the timer IRQ
-	 * to the first CPU.
-	 */
-	if (unlikely(apic->cpu_mask_to_apicid_and(apic->target_cpus(),
-						  apic->target_cpus(), &dest)))
-		dest = BAD_APICID;
-
-	entry.dest_mode = apic->irq_dest_mode;
-	entry.mask = 0;			/* don't mask IRQ for edge */
-	entry.dest = dest;
-	entry.delivery_mode = apic->irq_delivery_mode;
-	entry.polarity = 0;
-	entry.trigger = 0;
-	entry.vector = vector;
-
-	/*
-	 * The timer IRQ doesn't have to know that behind the
-	 * scene we may have a 8259A-master in AEOI mode ...
-	 */
-	irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
-				      "edge");
-
-	/*
-	 * Add it to the IO-APIC irq-routing table:
-	 */
-	ioapic_write_entry(ioapic_idx, pin, entry);
-}
-
 void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 {
 	int i;
@@ -2621,20 +2515,6 @@ static int __init ioapic_init_ops(void)
 
 device_initcall(ioapic_init_ops);
 
-static int
-io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
-{
-	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
-	int ret;
-
-	if (!cfg)
-		return -EINVAL;
-	ret = __add_pin_to_irq_node(cfg, node, attr->ioapic, attr->ioapic_pin);
-	if (!ret)
-		setup_ioapic_irq(irq, cfg, attr);
-	return ret;
-}
-
 static int io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
@@ -3178,56 +3058,6 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 	irq_attr->polarity	= polarity;
 }
 
-int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
-		     irq_hw_number_t hwirq)
-{
-	int ioapic = mp_irqdomain_ioapic_idx(domain);
-	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
-	struct io_apic_irq_attr attr;
-
-	/* Get default attribute if not set by caller yet */
-	if (!info->set) {
-		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
-
-		if (acpi_get_override_irq(gsi, &info->trigger,
-					  &info->polarity) < 0) {
-			/*
-			 * PCI interrupts are always polarity one level
-			 * triggered.
-			 */
-			info->trigger = 1;
-			info->polarity = 1;
-		}
-		info->node = NUMA_NO_NODE;
-
-		/*
-		 * setup_IO_APIC_irqs() programs all legacy IRQs with default
-		 * trigger and polarity attributes. Don't set the flag for that
-		 * case so the first legacy IRQ user could reprogram the pin
-		 * with real trigger and polarity attributes.
-		 */
-		if (virq >= nr_legacy_irqs() || info->count)
-			info->set = 1;
-	}
-	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
-			     info->polarity);
-
-	return io_apic_setup_irq_pin(virq, info->node, &attr);
-}
-
-void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
-{
-	struct irq_data *data = irq_get_irq_data(virq);
-	struct irq_cfg *cfg = irq_cfg(virq);
-	int ioapic = mp_irqdomain_ioapic_idx(domain);
-	int pin = (int)data->hwirq;
-
-	ioapic_mask_entry(ioapic, pin);
-	__remove_pin_from_irq(cfg, ioapic, pin);
-	WARN_ON(!list_empty(&cfg->irq_2_pin));
-	arch_teardown_hwirq(virq);
-}
-
 static int mp_irqdomain_get_attr(int irq, u32 gsi, struct mp_pin_info *pinfo,
 				 struct irq_alloc_info *info)
 {
@@ -3418,35 +3248,6 @@ int mp_irqdomain_deactivate(struct irq_domain *domain,
 	return 0;
 }
 
-int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
-{
-	int ret = 0;
-	int ioapic, pin;
-	struct mp_pin_info *info;
-
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
-		return -ENODEV;
-
-	pin = mp_find_ioapic_pin(ioapic, gsi);
-	info = mp_pin_info(ioapic, pin);
-	trigger = trigger ? 1 : 0;
-	polarity = polarity ? 1 : 0;
-
-	mutex_lock(&ioapic_mutex);
-	if (!info->set) {
-		info->trigger = trigger;
-		info->polarity = polarity;
-		info->node = node;
-		info->set = 1;
-	} else if (info->trigger != trigger || info->polarity != polarity) {
-		ret = -EBUSY;
-	}
-	mutex_unlock(&ioapic_mutex);
-
-	return ret;
-}
-
 bool mp_should_keep_irq(struct device *dev)
 {
 	if (dev->power.is_prepared)
-- 
1.7.10.4

