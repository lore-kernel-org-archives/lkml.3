Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000AbaESQZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:25:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:15881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964947AbaESQZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="534297008"
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
Subject: [Patch Part1 V2 24/29] x86, irq: introduce two helper functions to support irqdomain map operation
Date: Tue, 20 May 2014 00:23:08 +0800
Message-Id: <1400516594-11544-25-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/io_apic.h |    4 ++
 arch/x86/kernel/apic/io_apic.c |   79 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 666170437d78..d71da9cc30ae 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -184,6 +184,10 @@ extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 				      ioapic_create_domain_fn cb, void *arg);
 extern struct irq_domain *mp_irqdomain_create(int ioapic,
 		struct device_node *np, const struct irq_domain_ops *ops);
+extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
+			    irq_hw_number_t hwirq);
+extern int mp_set_pin_attr(int ioapic, int pin, int trigger, int polarity,
+			   int node);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1b9dd0a70dfa..6c838a2ecac0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -86,6 +86,14 @@ static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static DEFINE_MUTEX(ioapic_mutex);
 
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
@@ -99,6 +107,7 @@ static struct ioapic {
 	struct mpc_ioapic mp_config;
 	/* IO APIC gsi routing info */
 	struct mp_ioapic_gsi  gsi_config;
+	struct mp_pin_info *pin_info;
 	struct irq_domain *irqdomain;
 	ioapic_create_domain_fn irqdomain_cb;
 	void *irqdomain_arg;
@@ -140,6 +149,11 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
 	return ioapic == 0 || (irq >= 0 && irq < NR_IRQS_LEGACY);
 }
 
+static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
+{
+	return ioapics[ioapic_idx].pin_info + pin;
+}
+
 static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
 {
 	return ioapics[ioapic].irqdomain;
@@ -987,6 +1001,7 @@ int mp_map_pin_to_irq(int ioapic, int pin, int idx, unsigned int flags)
 	int irq = -1;
 	u32 gsi = mp_pin_2_gsi(ioapic, pin);
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
+	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
 
 	if (!domain) {
 		/*
@@ -1015,6 +1030,11 @@ int mp_map_pin_to_irq(int ioapic, int pin, int idx, unsigned int flags)
 			irq = irq_create_mapping(domain, pin);
 		else if (irq_create_strict_mappings(domain, gsi, pin, 1) == 0)
 			irq = gsi;
+
+		if (irq > 0)
+			info->count++;
+		else if (info->count == 0)
+			info->set = 0;
 	}
 out:
 	mutex_unlock(&ioapic_mutex);
@@ -2909,11 +2929,14 @@ out:
 
 static void ioapic_create_irqdomains(void)
 {
-	int i;
+	int i, size;
 	struct ioapic *ip;
 
 	for_each_ioapic(i) {
 		ip = &ioapics[i];
+		size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(i);
+		ip->pin_info = kzalloc(size, GFP_KERNEL);
+		BUG_ON(!ip->pin_info);
 		if (ip->irqdomain_cb)
 			ip->irqdomain = ip->irqdomain_cb(i, ip->irqdomain_arg);
 	}
@@ -3880,6 +3903,60 @@ struct irq_domain *mp_irqdomain_create(int ioapic, struct device_node *np,
 	return domain;
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
+		u32 gsi = mp_pin_2_gsi(ioapic, hwirq);
+		if (acpi_get_override_irq(gsi, &info->trigger,
+					  &info->polarity) < 0) {
+			return -ENODEV;
+		}
+		info->node = NUMA_NO_NODE;
+		info->set = 1;
+	}
+
+	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
+			     info->polarity);
+
+	return io_apic_setup_irq_pin(virq, info->node, &attr);
+}
+
+int mp_set_pin_attr(int ioapic, int pin, int trigger, int polarity, int node)
+{
+	int ret = 0;
+	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
+
+	trigger = !!trigger;
+	polarity = !!polarity;
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
-- 
1.7.10.4

