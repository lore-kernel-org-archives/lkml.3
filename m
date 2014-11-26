Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaKZXPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:15:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaKZXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:14:54 -0500
Date: Wed, 26 Nov 2014 15:13:56 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-653c4a3437aa1c857bb2b121cbbf8c8b67ff51cd@git.kernel.org>
Cc: konrad.wilk@oracle.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, gregkh@linuxfoundation.org, bp@alien8.de,
        rdunlap@infradead.org, tony.luck@intel.com, rjw@rjwysocki.net,
        jroedel@suse.de, jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        yinghai@kernel.org, tglx@linutronix.de, grant.likely@linaro.org,
        joro@8bytes.org, hpa@zytor.com
Reply-To: jroedel@suse.de, yinghai@kernel.org, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, tglx@linutronix.de, grant.likely@linaro.org,
        hpa@zytor.com, joro@8bytes.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, bhelgaas@google.com,
        bp@alien8.de, gregkh@linuxfoundation.org, rdunlap@infradead.org,
        tony.luck@intel.com, rjw@rjwysocki.net
In-Reply-To: <1416901802-24211-6-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Implement callbacks to enable hierarchy irqdomain on IOAPICs
Git-Commit-ID: 653c4a3437aa1c857bb2b121cbbf8c8b67ff51cd
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

Commit-ID:  653c4a3437aa1c857bb2b121cbbf8c8b67ff51cd
Gitweb:     http://git.kernel.org/tip/653c4a3437aa1c857bb2b121cbbf8c8b67ff51cd
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:29 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, irq: Implement callbacks to enable hierarchy irqdomain on IOAPICs

Implement required callbacks to prepare for enabling hierarchy irqdomain
on IOAPICs. Later we will clean up IOAPIC code a lot by using hierarchy
irqdomain framework.

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
Link: http://lkml.kernel.org/r/1416901802-24211-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h |  10 +++
 arch/x86/kernel/apic/io_apic.c | 159 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 166 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index cdda8ed..073b9c7 100644
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
+extern void mp_irqdomain_activate(struct irq_domain *domain,
+				  struct irq_data *irq_data);
+extern void mp_irqdomain_deactivate(struct irq_domain *domain,
+				    struct irq_data *irq_data);
+extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
 extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
 				  int node, int trigger, int polarity);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8b3b856..e465171 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -78,6 +78,13 @@ static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
 static int ioapic_initialized;
 
+struct mp_chip_data {
+	struct IO_APIC_route_entry entry;
+	int trigger;
+	int polarity;
+	bool isa_irq;
+};
+
 struct mp_pin_info {
 	int trigger;
 	int polarity;
@@ -949,11 +956,28 @@ void ioapic_set_alloc_attr(struct irq_alloc_info *info, int node,
 	info->ioapic_valid = 1;
 }
 
+static void mp_register_handler(unsigned int irq, unsigned long trigger)
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
+
+	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
+	__irq_set_handler(irq, hdl, 0, fasteoi ? "fasteoi" : "edge");
+}
+
 static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin,
 				 struct irq_alloc_info *info)
 {
 	int irq = -1;
-	int ioapic = (int)(long)domain->host_data;
+	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	int type = ioapics[ioapic].irqdomain_cfg.type;
 
 	switch (type) {
@@ -3026,7 +3050,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 		     irq_hw_number_t hwirq)
 {
-	int ioapic = (int)(long)domain->host_data;
+	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
 	struct io_apic_irq_attr attr;
 
@@ -3064,7 +3088,7 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 {
 	struct irq_data *data = irq_get_irq_data(virq);
 	struct irq_cfg *cfg = irq_cfg(virq);
-	int ioapic = (int)(long)domain->host_data;
+	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	int pin = (int)data->hwirq;
 
 	ioapic_mask_entry(ioapic, pin);
@@ -3073,6 +3097,130 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 	arch_teardown_hwirq(virq);
 }
 
+static void mp_irqdomain_get_attr(u32 gsi, struct mp_chip_data *data,
+				 struct irq_alloc_info *info)
+{
+	if (info && info->ioapic_valid) {
+		data->trigger = info->ioapic_trigger;
+		data->polarity = info->ioapic_polarity;
+	} else if (acpi_get_override_irq(gsi, &data->trigger,
+					 &data->polarity) < 0) {
+		/* PCI interrupts are always polarity one level triggered. */
+		data->trigger = 1;
+		data->polarity = 1;
+	}
+}
+
+static void mp_setup_entry(struct irq_cfg *cfg, struct mp_chip_data *data,
+			   struct IO_APIC_route_entry *entry)
+{
+	memset(entry, 0, sizeof(*entry));
+	entry->delivery_mode = apic->irq_delivery_mode;
+	entry->dest_mode     = apic->irq_dest_mode;
+	entry->dest	     = cfg->dest_apicid;
+	entry->vector	     = cfg->vector;
+	entry->mask	     = 0;	/* enable IRQ */
+	entry->trigger	     = data->trigger;
+	entry->polarity	     = data->polarity;
+	/*
+	 * Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (data->trigger)
+		entry->mask = 1;
+}
+
+int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
+		       unsigned int nr_irqs, void *arg)
+{
+	int ret, ioapic, pin;
+	struct irq_cfg *cfg;
+	struct irq_data *irq_data;
+	struct mp_chip_data *data;
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
+	if (irq_find_mapping(domain, (irq_hw_number_t)pin) > 0)
+		return -EEXIST;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	info->ioapic_entry = &data->entry;
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
+	if (ret < 0) {
+		kfree(data);
+		return ret;
+	}
+
+	irq_data->hwirq = info->ioapic_pin;
+	irq_data->chip = &ioapic_chip;
+	irq_data->chip_data = data;
+	mp_irqdomain_get_attr(mp_pin_to_gsi(ioapic, pin), data, info);
+
+	cfg = irqd_cfg(irq_data);
+	add_pin_to_irq_node(cfg, info->ioapic_node, ioapic, pin);
+	if (info->ioapic_entry)
+		mp_setup_entry(cfg, data, info->ioapic_entry);
+	mp_register_handler(virq, data->trigger);
+	if (virq < nr_legacy_irqs())
+		legacy_pic->mask(virq);
+
+	apic_printk(APIC_VERBOSE, KERN_DEBUG
+		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> IRQ %d Mode:%i Active:%i Dest:%d)\n",
+		    ioapic, mpc_ioapic_id(ioapic), pin, cfg->vector,
+		    virq, data->trigger, data->polarity, cfg->dest_apicid);
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
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+}
+
+void mp_irqdomain_activate(struct irq_domain *domain,
+			   struct irq_data *irq_data)
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
+}
+
+void mp_irqdomain_deactivate(struct irq_domain *domain,
+			     struct irq_data *irq_data)
+{
+	/* It won't be called for IRQ with multiple IOAPIC pins associated */
+	ioapic_mask_entry(mp_irqdomain_ioapic_idx(domain),
+			  (int)irq_data->hwirq);
+}
+
 int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 {
 	int ret = 0;
@@ -3101,3 +3249,8 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 
 	return ret;
 }
+
+int mp_irqdomain_ioapic_idx(struct irq_domain *domain)
+{
+	return (int)(long)domain->host_data;
+}
