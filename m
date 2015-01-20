Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbbATFtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:49:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:30024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbbATFtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:49:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664446512"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 01/33] x86/irq: Kill unused old IOAPIC irqdomain interfaces
Date: Tue, 20 Jan 2015 13:51:21 +0800
Message-Id: <1421733113-15704-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted to hierarchy irqdomain, so kill unused old IOAPIC
irqdomain interfaces and code.

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
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-11-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h |    4 -
 arch/x86/kernel/apic/io_apic.c |  202 +---------------------------------------
 2 files changed, 1 insertion(+), 205 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index ecc192624eaf..705c425c9c3d 100644
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
@@ -218,7 +215,6 @@ extern void mp_irqdomain_deactivate(struct irq_domain *domain,
 extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
 extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
 				  int node, int trigger, int polarity);
-extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 899b8cfb0d87..969c56f09221 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -91,7 +91,6 @@ struct mp_chip_data {
 struct mp_pin_info {
 	int trigger;
 	int polarity;
-	int node;
 	int set;
 	u32 count;
 };
@@ -1308,30 +1307,6 @@ static inline int IO_APIC_irq_trigger(int irq)
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
@@ -1356,48 +1331,6 @@ int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
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
@@ -1417,46 +1350,6 @@ static void __init setup_IO_APIC_irqs(void)
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
@@ -2667,20 +2560,6 @@ static int __init ioapic_init_ops(void)
 
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
@@ -3237,58 +3116,8 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
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
 static void mp_irqdomain_get_attr(u32 gsi, struct mp_chip_data *data,
-				 struct irq_alloc_info *info)
+				  struct irq_alloc_info *info)
 {
 	if (info && info->ioapic_valid) {
 		data->trigger = info->ioapic_trigger;
@@ -3412,35 +3241,6 @@ void mp_irqdomain_deactivate(struct irq_domain *domain,
 			  (int)irq_data->hwirq);
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
 int mp_irqdomain_ioapic_idx(struct irq_domain *domain)
 {
 	return (int)(long)domain->host_data;
-- 
1.7.10.4

