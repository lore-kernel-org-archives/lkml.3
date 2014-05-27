Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaE0IM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:12:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:41564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaE0IMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:12:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538019086"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V3 33/37] x86, irq: introduce helper functions to release IOAPIC pin
Date: Tue, 27 May 2014 16:08:08 +0800
Message-Id: <1401178092-1228-34-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce function mp_unmap_irq() to release IOAPIC IRQ when IRQ is not
used any more, which will typically called by pcibios_disabled_irq.

And function mp_irqdomain_unmap() is a common implementation of
irq_domain_ops.unmap for IOAPIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    3 ++
 arch/x86/kernel/apic/io_apic.c |   60 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 073358c12d90..6b40122bec0c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -180,12 +180,14 @@ extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
+extern void mp_unmap_irq(int irq);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 				      ioapic_create_domain_fn cb, void *arg);
 extern struct irq_domain *mp_irqdomain_create(int ioapic,
 		struct device_node *np, const struct irq_domain_ops *ops);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
+extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -229,6 +231,7 @@ static inline void ioapic_insert_resources(void) { }
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
+static inline void mp_unmap_irq(int irq) { }
 
 static inline int save_ioapic_entries(void)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7fc34fcf3ea3..c7c84d5c0e57 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -480,6 +480,21 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
 	return 0;
 }
 
+static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
+{
+	struct irq_pin_list **last, *entry;
+
+	last = &cfg->irq_2_pin;
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		if (entry->apic == apic && entry->pin == pin) {
+			*last = entry->next;
+			kfree(entry);
+			return;
+		} else {
+			last = &entry->next;
+		}
+}
+
 static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	if (__add_pin_to_irq_node(cfg, node, apic, pin))
@@ -1068,6 +1083,30 @@ int mp_map_gsi_to_irq(u32 gsi, unsigned int flags)
 	return mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
 }
 
+void mp_unmap_irq(int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	struct mp_pin_info *info;
+	int ioapic, pin;
+
+	if (!data || !data->domain)
+		return;
+
+	ioapic = (int)(long)data->domain->host_data;
+	pin = (int)data->hwirq;
+	info = mp_pin_info(ioapic, pin);
+
+	mutex_lock(&ioapic_mutex);
+	if (--info->count == 0) {
+		info->set = 0;
+		if (irq < NR_IRQS_LEGACY)
+			irq_domain_disassociate(data->domain, irq);
+		else
+			irq_dispose_mapping(irq);
+	}
+	mutex_unlock(&ioapic_mutex);
+}
+
 static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
 {
 	u32 gsi = mp_pin_to_gsi(ioapic, pin);
@@ -3857,6 +3896,27 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 	return io_apic_setup_irq_pin(virq, info->node, &attr);
 }
 
+void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
+{
+	struct irq_data *data = irq_get_irq_data(virq);
+	struct irq_cfg *cfg = irq_cfg(virq);
+	int ioapic = (int)(long)domain->host_data;
+	int pin = (int)data->hwirq;
+
+	/*
+	 * Skip the timer IRQ if there's a quirk handler installed and if it
+	 * returns 1:
+	 */
+	if (apic->multi_timer_check &&
+	    apic->multi_timer_check(ioapic, virq))
+		return;
+
+	ioapic_mask_entry(ioapic, pin);
+	__remove_pin_from_irq(cfg, ioapic, pin);
+	WARN_ON(cfg->irq_2_pin != NULL);
+	arch_teardown_hwirq(virq);
+}
+
 int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 {
 	int ret = 0;
-- 
1.7.10.4

