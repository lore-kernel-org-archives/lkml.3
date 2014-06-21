Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbaFUVSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:18:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbaFUVSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:18:34 -0400
Date: Sat, 21 Jun 2014 14:15:37 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-15a3c7cc9154321fc3ed1f7738bb7bbe690af91d@git.kernel.org>
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
In-Reply-To: <1402302011-23642-30-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-30-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce two helper functions to support irqdomain map operation
Git-Commit-ID: 15a3c7cc9154321fc3ed1f7738bb7bbe690af91d
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

Commit-ID:  15a3c7cc9154321fc3ed1f7738bb7bbe690af91d
Gitweb:     http://git.kernel.org/tip/15a3c7cc9154321fc3ed1f7738bb7bbe690af91d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:58 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:43 +0200

x86, irq: Introduce two helper functions to support irqdomain map operation

Currently there are multiple entries to program IOAPIC pins, such as
io_apic_setup_irq_pin_once(), io_apic_set_pci_routing() and
setup_IO_APIC_irq_extra() etc.

This patch introduces two functions to help consolidate the code to
program IOAPIC pins. Function mp_set_pin_attr() is used to optionally
set trigger, polarity and NUMA node property for an IOAPIC pin.
If mp_set_pin_attr() is not invoked for a pin, the default configuration
from BIOS will be used.

Function mp_irqdomain_map() is an common implementation of irqdomain map()
operation. It figures out attribures for pin and then actually programs
the IOAPIC pin. We hope this will be the only entrance for programming
IOAPIC pin.

And the flow will:
1) caller such as xxx_pci_irq_enable figures out pin attributes.
2) Invoke mp_set_pin_attr() to set attributes for a pin. If the pin has
   already bin programmed,  mp_set_pin_attr() will aslo detects attribute
   confictions.
3) Invoke mp_map_pin_to_irq()
3.1) If IRQ has already been assigned, return irq_find_mapping()
3.2) Else irq_create_mapping()
		->irq_domain_associate()
			->mp_irqdomain_map()
				->io_apic_setup_irq_pin()

So every pin will only programmed once by mp_irqdomain_map(), so we
could kill io_apic_setup_irq_pin_once(), io_apic_set_pci_routing() and
setup_IO_APIC_irq_extra() etc.

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
Link: http://lkml.kernel.org/r/1402302011-23642-30-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  5 +++
 arch/x86/kernel/apic/io_apic.c | 99 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 3e4bea3..c535878 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -173,7 +173,9 @@ enum ioapic_domain_type {
 };
 
 struct device_node;
+struct irq_domain;
 struct irq_domain_ops;
+
 struct ioapic_domain_cfg {
 	enum ioapic_domain_type		type;
 	const struct irq_domain_ops	*ops;
@@ -192,6 +194,9 @@ extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 				      struct ioapic_domain_cfg *cfg);
+extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
+			    irq_hw_number_t hwirq);
+extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 563f450..a602b35 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -87,6 +87,14 @@ static DEFINE_RAW_SPINLOCK(vector_lock);
 static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
 
+struct mp_pin_info {
+	int trigger;
+	int polarity;
+	int node;
+	int set;
+	u32 count;
+};
+
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -102,6 +110,7 @@ static struct ioapic {
 	struct mp_ioapic_gsi  gsi_config;
 	struct ioapic_domain_cfg irqdomain_cfg;
 	struct irq_domain *irqdomain;
+	struct mp_pin_info *pin_info;
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
@@ -147,6 +156,11 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
 	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
 }
 
+static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
+{
+	return ioapics[ioapic_idx].pin_info + pin;
+}
+
 static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
 {
 	return ioapics[ioapic].irqdomain;
@@ -1006,6 +1020,7 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 {
 	int irq;
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
+	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
 
 	/*
 	 * Don't use irqdomain to manage ISA IRQs because there may be
@@ -1034,6 +1049,13 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	irq = irq_find_mapping(domain, pin);
 	if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
 		irq = alloc_irq_from_domain(domain, gsi, pin);
+
+	if (flags & IOAPIC_MAP_ALLOC) {
+		if (irq > 0)
+			info->count++;
+		else if (info->count == 0)
+			info->set = 0;
+	}
 	mutex_unlock(&ioapic_mutex);
 
 	return irq > 0 ? irq : -1;
@@ -2923,18 +2945,27 @@ out:
 
 static int mp_irqdomain_create(int ioapic)
 {
+	size_t size;
 	int hwirqs = mp_ioapic_pin_count(ioapic);
 	struct ioapic *ip = &ioapics[ioapic];
 	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
 	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
 
+	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
+	ip->pin_info = kzalloc(size, GFP_KERNEL);
+	if (!ip->pin_info)
+		return -ENOMEM;
+
 	if (cfg->type == IOAPIC_DOMAIN_INVALID)
 		return 0;
 
 	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
 					      (void *)(long)ioapic);
-	if(!ip->irqdomain)
+	if(!ip->irqdomain) {
+		kfree(ip->pin_info);
+		ip->pin_info = NULL;
 		return -ENOMEM;
+	}
 
 	if (cfg->type == IOAPIC_DOMAIN_LEGACY ||
 	    cfg->type == IOAPIC_DOMAIN_STRICT)
@@ -3902,6 +3933,72 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	nr_ioapics++;
 }
 
+int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
+		     irq_hw_number_t hwirq)
+{
+	int ioapic = (int)(long)domain->host_data;
+	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
+	struct io_apic_irq_attr attr;
+
+	/*
+	 * Skip the timer IRQ if there's a quirk handler installed and if it
+	 * returns 1:
+	 */
+	if (apic->multi_timer_check &&
+	    apic->multi_timer_check(ioapic, virq))
+		return 0;
+
+	/* Get default attribute if not set by caller yet */
+	if (!info->set) {
+		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
+
+		if (acpi_get_override_irq(gsi, &info->trigger,
+					  &info->polarity) < 0) {
+			/*
+			 * PCI interrupts are always polarity one level
+			 * triggered.
+			 */
+			info->trigger = 1;
+			info->polarity = 1;
+		}
+		info->node = NUMA_NO_NODE;
+		info->set = 1;
+	}
+	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
+			     info->polarity);
+
+	return io_apic_setup_irq_pin(virq, info->node, &attr);
+}
+
+int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
+{
+	int ret = 0;
+	int ioapic, pin;
+	struct mp_pin_info *info;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return -ENODEV;
+
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	info = mp_pin_info(ioapic, pin);
+	trigger = trigger ? 1 : 0;
+	polarity = polarity ? 1 : 0;
+
+	mutex_lock(&ioapic_mutex);
+	if (!info->set) {
+		info->trigger = trigger;
+		info->polarity = polarity;
+		info->node = node;
+		info->set = 1;
+	} else if (info->trigger != trigger || info->polarity != polarity) {
+		ret = -EBUSY;
+	}
+	mutex_unlock(&ioapic_mutex);
+
+	return ret;
+}
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
