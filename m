Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbaFUVVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:21:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbaFUVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:18:10 -0400
Date: Sat, 21 Jun 2014 14:17:10 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-df334bead7e94772c41745af9f329383067d44ae@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-38-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-38-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce helper functions to release IOAPIC pin
Git-Commit-ID: df334bead7e94772c41745af9f329383067d44ae
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

Commit-ID:  df334bead7e94772c41745af9f329383067d44ae
Gitweb:     http://git.kernel.org/tip/df334bead7e94772c41745af9f329383067d44ae
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:20:06 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:44 +0200

x86, irq: Introduce helper functions to release IOAPIC pin

Introduce function mp_unmap_irq() to release IOAPIC IRQ when IRQ is not
used any more, which will typically called by pcibios_disabled_irq.

And function mp_irqdomain_unmap() is a common implementation of
irq_domain_ops.unmap for IOAPIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-38-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  3 +++
 arch/x86/kernel/apic/io_apic.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index af6f9d4..0aeed5c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -187,10 +187,12 @@ extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
+extern void mp_unmap_irq(int irq);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 				      struct ioapic_domain_cfg *cfg);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
+extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -234,6 +236,7 @@ static inline void ioapic_insert_resources(void) { }
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
+static inline void mp_unmap_irq(int irq) { }
 
 static inline int save_ioapic_entries(void)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8485d90..8d80a8f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -467,6 +467,21 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
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
@@ -1119,6 +1134,31 @@ int mp_map_gsi_to_irq(u32 gsi, unsigned int flags)
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
+		if (irq < nr_legacy_irqs() &&
+		    ioapics[ioapic].irqdomain_cfg.type == IOAPIC_DOMAIN_LEGACY)
+			mp_irqdomain_unmap(data->domain, irq);
+		else
+			irq_dispose_mapping(irq);
+	}
+	mutex_unlock(&ioapic_mutex);
+}
+
 /*
  * Find a specific PCI IRQ entry.
  * Not an __init, possibly needed by modules
@@ -3878,6 +3918,27 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
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
