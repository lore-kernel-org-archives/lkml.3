Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaEPIGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:06:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:29914 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650AbaEPIGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:06:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540107461"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>, linux-pm@vger.kernel.org
Subject: [RFC Patch Part1 V1 19/30] x86, irq: introduce mechanisms to support dynamically allocate IRQ for IOAPIC
Date: Fri, 16 May 2014 16:05:39 +0800
Message-Id: <1400227550-5935-20-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently x86 support identity mapping between GSI(IOAPIC pin) and IRQ
number, so continous IRQs at low end are statically allocated to IOAPICs
at boot time. This design causes trouble to support IOAPIC hotplug.

This patch implements basic mechanism to dynamically allocate IRQ on
demand for IOAPIC pins by using irqdomain framework.

This patch enhances ioapic.c to provide basic mechanisms to support
dynamically allocate IRQ number for IOAPIC by using irqdomain.

It first adds several fields into struct ioapic to support irqdomain.
Then it implements an algorithm to dynamically allocate IRQ number
on demand.
1) Build identity mapping for GSIs below arch_dynirq_lower_bound(0).
   This is typically used to support legacy IRQs and simple platforms.
   There's an exception for overridden ISA IRQs, whose GSI number
   may be different from assigned IRQ number.
2) Dynamically allocate IRQs for GSIs above  arch_dynirq_lower_bound(0).
   This may be used to support big system and IOAPIC hotplug.

Function arch_dynirq_lower_bound(0) will be enhanced in coming patch
to enable dynamic IRQ allocation for IOAPIC. To ease our life,
arch_dynirq_lower_bound(0) must be greater than or equal to
NR_IRQS_LEGACY, otherwise it may break backward compatibilities.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    9 ++-
 arch/x86/kernel/acpi/boot.c    |   10 ++--
 arch/x86/kernel/apic/io_apic.c |  125 +++++++++++++++++++++++++++++++---------
 3 files changed, 110 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index f4fd0be26cec..13209bdf318d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -169,9 +169,11 @@ struct mp_ioapic_gsi{
 };
 extern u32 gsi_top;
 
+typedef struct irq_domain *(*ioapic_create_domain_fn)(int idx, void *arg);
+
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
-extern int mp_map_pin_to_irq(int ioapic, int pin);
+extern int mp_map_pin_to_irq(int idx, int ioapic, int pin, int alloc);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -213,7 +215,10 @@ extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
-static inline int mp_map_pin_to_irq(int ioapic, int pin) { return -1; }
+static inline int mp_map_pin_to_irq(int idx, int ioapic, int pin, int alloc)
+{
+	return -1;
+}
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6eae9a7231c4..cdf6908e9f75 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -99,7 +99,7 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 
 #define	ACPI_INVALID_GSI		INT_MIN
 
-static int map_gsi_to_irq(unsigned int gsi)
+static int map_gsi_to_irq(unsigned int gsi, int alloc)
 {
 	int i, ioapic, pin;
 
@@ -110,7 +110,7 @@ static int map_gsi_to_irq(unsigned int gsi)
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic >= 0) {
 		pin = mp_find_ioapic_pin(ioapic, gsi);
-		return mp_map_pin_to_irq(ioapic, pin);
+		return mp_map_pin_to_irq(-1, ioapic, pin, alloc);
 	}
 
 	pr_err("Failed to map GSI%d to IRQ number.\n", gsi);
@@ -490,7 +490,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq = map_gsi_to_irq(gsi);
+	int irq = map_gsi_to_irq(gsi, 1);
 
 	if (irq >= 0) {
 #ifdef CONFIG_X86_IO_APIC
@@ -559,7 +559,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
 	if (plat_gsi != ACPI_INVALID_GSI)
-		return map_gsi_to_irq(plat_gsi);
+		return map_gsi_to_irq(plat_gsi, 0);
 
 	return -1;
 }
@@ -1041,7 +1041,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
 		return gsi;
 
-	irq = map_gsi_to_irq(gsi);
+	irq = map_gsi_to_irq(gsi, 1);
 	if (irq < 0)
 		return ACPI_INVALID_GSI;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f55357bd0e07..fb87bdbb4307 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -31,6 +31,7 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/syscore_ops.h>
+#include <linux/irqdomain.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
@@ -83,6 +84,7 @@ int sis_apic_bug = -1;
 
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
+static DEFINE_MUTEX(ioapic_mutex);
 
 static struct ioapic {
 	/*
@@ -97,6 +99,9 @@ static struct ioapic {
 	struct mpc_ioapic mp_config;
 	/* IO APIC gsi routing info */
 	struct mp_ioapic_gsi  gsi_config;
+	struct irq_domain *irqdomain;
+	ioapic_create_domain_fn irqdomain_cb;
+	void *irqdomain_arg;
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
@@ -137,6 +142,11 @@ static inline int mp_init_pin_at_boot(int ioapic, int pin)
 	return ioapic == 0 || gsi < NR_IRQS_LEGACY;
 }
 
+static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
+{
+	return ioapics[ioapic].irqdomain;
+}
+
 int nr_ioapics;
 
 /* The one past the highest gsi number used */
@@ -980,19 +990,68 @@ static int irq_trigger(int idx)
 	return trigger;
 }
 
-int mp_map_pin_to_irq(int apic, int pin)
+/*
+ * Dynamically allocate IRQ for GSI above arch_dynirq_lower_bound(0),
+ * and build identity mapping for statically assigned IRQ, but need
+ * special handling for ISA IRQ overriden.
+ */
+static int alloc_irq_from_domain(struct irq_domain *domain,
+				 int idx, int apic, int pin, u32 gsi)
 {
-	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(apic);
-	u32 gsi = gsi_cfg->gsi_base + pin;
+	int irq;
+
+	if (gsi >= arch_dynirq_lower_bound(0))
+		return irq_create_mapping(domain, pin);
+
+	irq = irq_find_mapping(domain, pin);
+	if (irq > 0)
+		return irq;
+
+	if (idx < 0)
+		idx = find_irq_entry(apic, pin, mp_INT);
+
+	/* Handle ISA IRQ overridden */
+	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci))
+		irq = mp_irqs[idx].srcbusirq;
+	else
+		irq = gsi;
 
 	/*
-	 * Provide an identity mapping of gsi == irq except on truly weird
-	 * platforms that have non isa irqs in the first 16 gsis.
+	 * The first NR_IRQS_LEGACY irq descs are allocated in early_irq_init()
+	 * and need just a mapping. The remaining irqs need both.
 	 */
-	return gsi >= NR_IRQS_LEGACY ? gsi : gsi_top + gsi;
+	if (irq < NR_IRQS_LEGACY)
+		return irq_domain_associate(domain, irq, pin);
+
+	return irq_create_strict_mappings(domain, irq, pin, 1) ? -1 : irq;
 }
 
-static int pin_2_irq(int idx, int apic, int pin)
+int mp_map_pin_to_irq(int idx, int ioapic, int pin, int alloc)
+{
+	int irq;
+	u32 gsi = mp_pin_2_gsi(ioapic, pin);
+	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
+
+	if (!domain) {
+		/*
+		 * Provide an identity mapping of gsi == irq except on truly
+		 * weird platforms that have non isa irqs in the first 16 gsis.
+		 */
+		return gsi >= NR_IRQS_LEGACY ? gsi : gsi_top + gsi;
+	}
+
+	mutex_lock(&ioapic_mutex);
+	if (alloc) {
+		irq = alloc_irq_from_domain(domain, idx, ioapic, pin, gsi);
+	} else {
+		irq = irq_find_mapping(domain, pin);
+	}
+	mutex_unlock(&ioapic_mutex);
+
+	return irq > 0 ? irq : -1;
+}
+
+static int pin_2_irq(int idx, int apic, int pin, int alloc)
 {
 	int irq;
 	int bus = mp_irqs[idx].srcbus;
@@ -1026,7 +1085,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	if (test_bit(bus, mp_bus_not_pci))
 		irq = mp_irqs[idx].srcbusirq;
 	else
-		irq = mp_map_pin_to_irq(apic, pin);
+		irq = mp_map_pin_to_irq(idx, apic, pin, alloc);
 
 	return irq;
 }
@@ -1038,7 +1097,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int irq, i, best_guess = -1;
+	int irq, i, best_ioapic = -1, best_idx = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -1052,6 +1111,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 		int ioapic_idx, found = 0;
+		int gsi;
 
 		if (test_bit(lbus, mp_bus_not_pci) || (bus != lbus) ||
 		    mp_irqs[i].irqtype != mp_INT ||
@@ -1068,30 +1128,36 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 			continue;
 
 		/* Skip ISA IRQs */
-		irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
-		if (ioapic_idx == 0 && !IO_APIC_IRQ(irq))
+		gsi = mp_pin_2_gsi(ioapic_idx, mp_irqs[i].dstirq);
+		if (gsi < arch_dynirq_lower_bound(0) && !IO_APIC_IRQ(gsi))
 			continue;
 
 		if (pin == (mp_irqs[i].srcbusirq & 3)) {
-			set_io_apic_irq_attr(irq_attr, ioapic_idx,
-					     mp_irqs[i].dstirq,
-					     irq_trigger(i),
-					     irq_polarity(i));
-			return irq;
+			best_idx = i;
+			best_ioapic = ioapic_idx;
+			goto out;
 		}
+
 		/*
 		 * Use the first all-but-pin matching entry as a
 		 * best-guess fuzzy result for broken mptables.
 		 */
-		if (best_guess < 0) {
-			set_io_apic_irq_attr(irq_attr, ioapic_idx,
-					     mp_irqs[i].dstirq,
-					     irq_trigger(i),
-					     irq_polarity(i));
-			best_guess = irq;
+		if (best_idx < 0) {
+			best_idx = i;
+			best_ioapic = ioapic_idx;
 		}
 	}
-	return best_guess;
+	if (best_idx < 0)
+		return -1;
+
+out:
+	irq = pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq, 1);
+	if (irq > 0)
+		set_io_apic_irq_attr(irq_attr, best_ioapic,
+				     mp_irqs[best_idx].dstirq,
+				     irq_trigger(best_idx),
+				     irq_polarity(best_idx));
+	return irq;
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
@@ -1282,7 +1348,7 @@ static inline int IO_APIC_irq_trigger(int irq)
 
 	for_each_ioapic_pin(apic, pin) {
 		idx = find_irq_entry(apic, pin, mp_INT);
-		if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
+		if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin, 0)))
 			return irq_trigger(idx);
 	}
 	/*
@@ -1411,7 +1477,9 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
 			continue;
 
-		irq = pin_2_irq(idx, ioapic_idx, pin);
+		irq = pin_2_irq(idx, ioapic_idx, pin, 1);
+		if (irq < 0)
+			continue;
 
 		/*
 		 * Skip the timer IRQ if there's a quirk handler
@@ -1463,7 +1531,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 	if (idx == -1)
 		return;
 
-	irq = pin_2_irq(idx, ioapic_idx, pin);
+	irq = pin_2_irq(idx, ioapic_idx, pin, 1);
 
 	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
 			     irq_polarity(idx));
@@ -3637,7 +3705,10 @@ void __init setup_ioapic_dest(void)
 		if (irq_entry == -1)
 			continue;
 
-		irq = pin_2_irq(irq_entry, ioapic, pin);
+		irq = pin_2_irq(irq_entry, ioapic, pin, 0);
+		if (irq < 0)
+			continue;
+
 		idata = irq_get_irq_data(irq);
 
 		/*
-- 
1.7.10.4

