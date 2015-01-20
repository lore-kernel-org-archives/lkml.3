Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbbATDOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:14:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:58344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbbATDOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:14:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442530214"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        David Rientjes <rientjes@google.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        sfi-devel@simplefirmware.org, linux-pm@vger.kernel.org
Subject: [Patch Part1 v7 38/38] x86/irq: Convert IOAPIC to use hierarchy irqdomain interfaces
Date: Tue, 20 Jan 2015 11:08:41 +0800
Message-Id: <1421723321-8386-39-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert IOAPIC driver to support and use hierarchy irqdomain interfaces.
It's a little big, but it always break bisectings if we split it into
multiple patches.

Fold in a patch from Andy Shevchenko <andriy.shevchenko@linux.intel.com>
to make it bisectable.
http://lkml.org/lkml/2014/12/10/622

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sfi-devel@simplefirmware.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1416901802-24211-10-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/acpi/boot.c                        |   11 +-
 arch/x86/kernel/apic/io_apic.c                     |  308 ++++++++++++++------
 arch/x86/kernel/devicetree.c                       |   37 +--
 arch/x86/kernel/mpparse.c                          |    6 +-
 arch/x86/pci/intel_mid_pci.c                       |    2 -
 .../platform/intel-mid/device_libs/platform_wdt.c  |    3 +-
 arch/x86/platform/intel-mid/sfi.c                  |    5 +-
 arch/x86/platform/sfi/sfi.c                        |    5 +-
 8 files changed, 240 insertions(+), 137 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 427917aa6ca1..dac090468f75 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -412,11 +412,6 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
 	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
-	if (mp_set_gsi_attr(gsi, trigger, polarity, node)) {
-		pr_warn("Failed to set pin attr for GSI%d\n", gsi);
-		return -1;
-	}
-
 	ioapic_set_alloc_attr(&info, node, trigger, polarity);
 	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info);
 	if (irq < 0)
@@ -442,8 +437,10 @@ static void mp_unregister_gsi(u32 gsi)
 }
 
 static struct irq_domain_ops acpi_irqdomain_ops = {
-	.map = mp_irqdomain_map,
-	.unmap = mp_irqdomain_unmap,
+	.alloc = mp_irqdomain_alloc,
+	.free = mp_irqdomain_free,
+	.activate = mp_irqdomain_activate,
+	.deactivate = mp_irqdomain_deactivate,
 };
 
 static int __init
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f3447a5dd6e4..899b8cfb0d87 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -144,6 +144,11 @@ u32 mp_pin_to_gsi(int ioapic, int pin)
 	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
 }
 
+static inline bool mp_is_legacy_irq(int irq)
+{
+	return irq >= 0 && irq < nr_legacy_irqs();
+}
+
 /*
  * Initialize all legacy IRQs and all pins on the first IOAPIC
  * if we have legacy interrupt controller. Kernel boot option "pirq="
@@ -154,7 +159,7 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
 	if (!nr_legacy_irqs())
 		return 0;
 
-	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
+	return ioapic == 0 || mp_is_legacy_irq(irq);
 }
 
 static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
@@ -233,7 +238,7 @@ struct irq_pin_list {
 
 static struct irq_pin_list *alloc_irq_pin_list(int node)
 {
-	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
+	return kzalloc_node(sizeof(struct irq_pin_list), GFP_ATOMIC, node);
 }
 
 static void alloc_ioapic_saved_registers(int idx)
@@ -562,6 +567,17 @@ void native_eoi_ioapic_pin(int apic, int pin, int vector)
 	}
 }
 
+void eoi_ioapic_pin(int vector, struct irq_cfg *cfg)
+{
+	unsigned long flags;
+	struct irq_pin_list *entry;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		native_eoi_ioapic_pin(entry->apic, entry->pin, vector);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
@@ -605,9 +621,8 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 			entry.trigger = IOAPIC_LEVEL;
 			ioapic_write_entry(apic, pin, entry);
 		}
-
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		x86_io_apic_ops.eoi_ioapic_pin(apic, pin, entry.vector);
+		native_eoi_ioapic_pin(apic, pin, entry.vector);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
@@ -1021,95 +1036,121 @@ static bool mp_check_pin_attr(int irq, struct irq_alloc_info *info)
 	       data->polarity == info->ioapic_polarity;
 }
 
-static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin,
+static int alloc_irq_from_domain(struct irq_domain *domain, int ioapic, u32 gsi,
 				 struct irq_alloc_info *info)
 {
+	bool legacy = false;
 	int irq = -1;
-	int ioapic = mp_irqdomain_ioapic_idx(domain);
 	int type = ioapics[ioapic].irqdomain_cfg.type;
 
 	switch (type) {
 	case IOAPIC_DOMAIN_LEGACY:
 		/*
-		 * Dynamically allocate IRQ number for non-ISA IRQs in the first 16
-		 * GSIs on some weird platforms.
+		 * Dynamically allocate IRQ number for non-ISA IRQs in the first
+		 * 16 GSIs on some weird platforms.
 		 */
-		if (gsi < nr_legacy_irqs())
-			irq = irq_create_mapping(domain, pin);
-		else if (irq_create_strict_mappings(domain, gsi, pin, 1) == 0)
+		if (!ioapic_initialized || gsi >= nr_legacy_irqs())
 			irq = gsi;
+		legacy = mp_is_legacy_irq(irq);
 		break;
 	case IOAPIC_DOMAIN_STRICT:
-		if (irq_create_strict_mappings(domain, gsi, pin, 1) == 0)
-			irq = gsi;
+		irq = gsi;
 		break;
 	case IOAPIC_DOMAIN_DYNAMIC:
-		irq = irq_create_mapping(domain, pin);
 		break;
 	default:
 		WARN(1, "ioapic: unknown irqdomain type %d\n", type);
-		break;
+		return -1;
+	}
+
+	return __irq_domain_alloc_irqs(domain, irq, 1,
+				       ioapic_alloc_attr_node(info),
+				       info, legacy);
+}
+
+/*
+ * Need special handling for ISA IRQs because there may be multiple IOAPIC pins
+ * sharing the same ISA IRQ number and irqdomain only supports 1:1 mapping
+ * between IOAPIC pin and IRQ number. A typical IOAPIC has 24 pins, pin 0-15 are
+ * used for legacy IRQs and pin 16-23 are used for PCI IRQs (PIRQ A-H).
+ * When ACPI is disabled, only legacy IRQ numbers (IRQ0-15) are available, and
+ * some BIOSes may use MP Interrupt Source records to override IRQ numbers for
+ * PIRQs instead of reprogramming the interrupt routing logic. Thus there may be
+ * multiple pins sharing the same legacy IRQ number when ACPI is disabled.
+ */
+static int alloc_isa_irq_from_domain(struct irq_domain *domain,
+				     int irq, int ioapic, int pin,
+				     struct irq_alloc_info *info)
+{
+	struct mp_chip_data *data;
+	struct irq_data *irq_data = irq_get_irq_data(irq);
+	int node = ioapic_alloc_attr_node(info);
+
+	/*
+	 * Legacy ISA IRQ has already been allocated, just add pin to
+	 * the pin list assoicated with this IRQ and program the IOAPIC
+	 * entry. The IOAPIC entry
+	 */
+	if (irq_data && irq_data->parent_data) {
+		struct irq_cfg *cfg = irqd_cfg(irq_data);
+
+		if (!mp_check_pin_attr(irq, info))
+			return -EBUSY;
+		if (__add_pin_to_irq_node(cfg, node, ioapic, info->ioapic_pin))
+			return -ENOMEM;
+	} else {
+		irq = __irq_domain_alloc_irqs(domain, irq, 1, node, info, true);
+		if (irq >= 0) {
+			irq_data = irq_domain_get_irq_data(domain, irq);
+			data = irq_data->chip_data;
+			data->isa_irq = true;
+		}
 	}
 
-	return irq > 0 ? irq : -1;
+	return irq;
 }
 
 static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 			     unsigned int flags, struct irq_alloc_info *info)
 {
 	int irq;
+	bool legacy = false;
+	struct irq_alloc_info tmp;
+	struct mp_chip_data *data;
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
-	struct mp_pin_info *pinfo = mp_pin_info(ioapic, pin);
 
 	if (!domain)
-		return -1;
+		return -ENOSYS;
 
-	mutex_lock(&ioapic_mutex);
-
-	/*
-	 * Don't use irqdomain to manage ISA IRQs because there may be
-	 * multiple IOAPIC pins sharing the same ISA IRQ number and
-	 * irqdomain only supports 1:1 mapping between IOAPIC pin and
-	 * IRQ number. A typical IOAPIC has 24 pins, pin 0-15 are used
-	 * for legacy IRQs and pin 16-23 are used for PCI IRQs (PIRQ A-H).
-	 * When ACPI is disabled, only legacy IRQ numbers (IRQ0-15) are
-	 * available, and some BIOSes may use MP Interrupt Source records
-	 * to override IRQ numbers for PIRQs instead of reprogramming
-	 * the interrupt routing logic. Thus there may be multiple pins
-	 * sharing the same legacy IRQ number when ACPI is disabled.
-	 */
 	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
-		if (flags & IOAPIC_MAP_ALLOC) {
-			if (pinfo->count == 0 &&
-			    mp_irqdomain_map(domain, irq, pin) != 0)
-				irq = -1;
+		legacy = mp_is_legacy_irq(irq);
+	}
 
-			/* special handling for timer IRQ0 */
+	mutex_lock(&ioapic_mutex);
+	if (!(flags & IOAPIC_MAP_ALLOC)) {
+		if (!legacy) {
+			irq = irq_find_mapping(domain, pin);
 			if (irq == 0)
-				pinfo->count++;
+				irq = -ENOENT;
 		}
 	} else {
-		irq = irq_find_mapping(domain, pin);
-		if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
-			irq = alloc_irq_from_domain(domain, gsi, pin, info);
-	}
-
-	if (flags & IOAPIC_MAP_ALLOC) {
-		/* special handling for legacy IRQs */
-		if (irq < nr_legacy_irqs() && pinfo->count == 1 &&
-		    mp_irqdomain_map(domain, irq, pin) != 0)
-			irq = -1;
-
-		if (irq > 0)
-			pinfo->count++;
-		else if (pinfo->count == 0)
-			pinfo->set = 0;
+		ioapic_copy_alloc_attr(&tmp, info, gsi, ioapic, pin);
+		if (legacy)
+			irq = alloc_isa_irq_from_domain(domain, irq,
+							ioapic, pin, &tmp);
+		else if ((irq = irq_find_mapping(domain, pin)) == 0)
+			irq = alloc_irq_from_domain(domain, ioapic, gsi, &tmp);
+		else if (!mp_check_pin_attr(irq, &tmp))
+			irq = -EBUSY;
+		if (irq >= 0) {
+			data = irq_get_chip_data(irq);
+			data->count++;
+		}
 	}
-
 	mutex_unlock(&ioapic_mutex);
 
-	return irq > 0 ? irq : -1;
+	return irq;
 }
 
 static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
@@ -1164,26 +1205,19 @@ int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
 
 void mp_unmap_irq(int irq)
 {
-	struct irq_data *data = irq_get_irq_data(irq);
-	struct mp_pin_info *info;
-	int ioapic, pin;
+	struct irq_data *irq_data = irq_get_irq_data(irq);
+	struct mp_chip_data *data;
 
-	if (!data || !data->domain)
+	if (!irq_data || !irq_data->domain)
 		return;
 
-	ioapic = (int)(long)data->domain->host_data;
-	pin = (int)data->hwirq;
-	info = mp_pin_info(ioapic, pin);
+	data = irq_data->chip_data;
+	if (!data || data->isa_irq)
+		return;
 
 	mutex_lock(&ioapic_mutex);
-	if (--info->count == 0) {
-		info->set = 0;
-		if (irq < nr_legacy_irqs() &&
-		    ioapics[ioapic].irqdomain_cfg.type == IOAPIC_DOMAIN_LEGACY)
-			mp_irqdomain_unmap(data->domain, irq);
-		else
-			irq_dispose_mapping(irq);
-	}
+	if (--data->count == 0)
+		irq_domain_free_irqs(irq, 1);
 	mutex_unlock(&ioapic_mutex);
 }
 
@@ -1250,7 +1284,7 @@ out:
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
-static struct irq_chip ioapic_chip;
+static struct irq_chip ioapic_chip, ioapic_ir_chip;
 
 #ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
@@ -1593,7 +1627,7 @@ void __init print_IO_APICs(void)
 		struct irq_pin_list *entry;
 
 		chip = irq_get_chip(irq);
-		if (chip != &ioapic_chip)
+		if (chip != &ioapic_chip && chip != &ioapic_ir_chip)
 			continue;
 
 		cfg = irq_cfg(irq);
@@ -2055,12 +2089,12 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 }
 #endif
 
-static void ack_ioapic_level(struct irq_data *data)
+static void ioapic_ack_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = irqd_cfg(data);
-	int i, irq = data->irq;
 	unsigned long v;
 	bool masked;
+	int i;
 
 	irq_complete_move(cfg);
 	masked = ioapic_irqd_mask(data, cfg);
@@ -2115,22 +2149,70 @@ static void ack_ioapic_level(struct irq_data *data)
 	 */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
-
-		eoi_ioapic_irq(irq, cfg);
+		eoi_ioapic_pin(cfg->vector, cfg);
 	}
 
 	ioapic_irqd_unmask(data, cfg, masked);
 }
 
+static void ioapic_ir_ack_level(struct irq_data *irq_data)
+{
+	struct mp_chip_data *data = irq_data->chip_data;
+
+	/*
+	 * Intr-remapping uses pin number as the virtual vector
+	 * in the RTE. Actual vector is programmed in
+	 * intr-remapping table entry. Hence for the io-apic
+	 * EOI we use the pin number.
+	 */
+	ack_APIC_irq();
+	eoi_ioapic_pin(data->entry.vector, irqd_cfg(irq_data));
+}
+
+static int ioapic_set_affinity(struct irq_data *irq_data,
+			       const struct cpumask *mask, bool force)
+{
+	struct irq_data *parent = irq_data->parent_data;
+	struct mp_chip_data *data = irq_data->chip_data;
+	unsigned int dest, irq = irq_data->irq;
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		cfg = irqd_cfg(irq_data);
+		data->entry.dest = cfg->dest_apicid;
+		data->entry.vector = cfg->vector;
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
+		__target_IO_APIC_irq(irq, dest, cfg);
+	}
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return ret;
+}
+
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
 	.irq_startup		= startup_ioapic_irq,
 	.irq_mask		= mask_ioapic_irq,
 	.irq_unmask		= unmask_ioapic_irq,
-	.irq_ack		= apic_ack_edge,
-	.irq_eoi		= ack_ioapic_level,
-	.irq_set_affinity	= native_ioapic_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_eoi		= ioapic_ack_level,
+	.irq_set_affinity	= ioapic_set_affinity,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+static struct irq_chip ioapic_ir_chip __read_mostly = {
+	.name			= "IR-IO-APIC",
+	.irq_startup		= startup_ioapic_irq,
+	.irq_mask		= mask_ioapic_irq,
+	.irq_unmask		= unmask_ioapic_irq,
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_eoi		= ioapic_ir_ack_level,
+	.irq_set_affinity	= ioapic_set_affinity,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -2263,6 +2345,24 @@ static int __init disable_timer_pin_setup(char *arg)
 }
 early_param("disable_timer_pin_1", disable_timer_pin_setup);
 
+static int mp_alloc_timer_irq(int ioapic, int pin)
+{
+	int irq = -1;
+	struct irq_alloc_info info;
+	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
+
+	if (domain) {
+		ioapic_set_alloc_attr(&info, NUMA_NO_NODE, 0, 0);
+		info.ioapic_id = mpc_ioapic_id(ioapic);
+		info.ioapic_pin = pin;
+		mutex_lock(&ioapic_mutex);
+		irq = alloc_isa_irq_from_domain(domain, 0, ioapic, pin, &info);
+		mutex_unlock(&ioapic_mutex);
+	}
+
+	return irq;
+}
+
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2285,7 +2385,6 @@ static inline void __init check_timer(void)
 	 * get/set the timer IRQ vector:
 	 */
 	legacy_pic->mask(0);
-	assign_irq_vector(0, cfg, apic->target_cpus());
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2326,15 +2425,12 @@ static inline void __init check_timer(void)
 	}
 
 	if (pin1 != -1) {
-		/*
-		 * Ok, does IRQ0 through the IOAPIC work?
-		 */
+		/* Ok, does IRQ0 through the IOAPIC work? */
 		if (no_pin1) {
-			add_pin_to_irq_node(cfg, node, apic1, pin1);
-			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
+			mp_alloc_timer_irq(apic1, pin1);
 		} else {
-			/* for edge trigger, setup_ioapic_irq already
-			 * leave it unmasked.
+			/*
+			 * for edge trigger, it's already unmasked,
 			 * so only need to unmask if it is level-trigger
 			 * do we really have level trigger timer?
 			 */
@@ -2343,6 +2439,7 @@ static inline void __init check_timer(void)
 			if (idx != -1 && irq_trigger(idx))
 				unmask_ioapic(cfg);
 		}
+		irq_domain_activate_irq(irq_get_irq_data(0));
 		if (timer_irq_works()) {
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
@@ -2363,7 +2460,7 @@ static inline void __init check_timer(void)
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
-		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
+		irq_domain_activate_irq(irq_get_irq_data(0));
 		legacy_pic->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -2441,6 +2538,8 @@ out:
 static int mp_irqdomain_create(int ioapic)
 {
 	size_t size;
+	struct irq_alloc_info info;
+	struct irq_domain *parent;
 	int hwirqs = mp_ioapic_pin_count(ioapic);
 	struct ioapic *ip = &ioapics[ioapic];
 	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
@@ -2454,9 +2553,18 @@ static int mp_irqdomain_create(int ioapic)
 	if (cfg->type == IOAPIC_DOMAIN_INVALID)
 		return 0;
 
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_IOAPIC;
+	info.ioapic_id = mpc_ioapic_id(ioapic);
+	parent = irq_remapping_get_ir_irq_domain(&info);
+	if (!parent)
+		parent = x86_vector_domain;
+
 	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
 					      (void *)(long)ioapic);
-	if(!ip->irqdomain) {
+	if (ip->irqdomain) {
+		ip->irqdomain->parent = parent;
+	} else {
 		kfree(ip->pin_info);
 		ip->pin_info = NULL;
 		return -ENOMEM;
@@ -3070,7 +3178,6 @@ int mp_unregister_ioapic(u32 gsi_base)
 {
 	int ioapic, pin;
 	int found = 0;
-	struct mp_pin_info *pin_info;
 
 	for_each_ioapic(ioapic)
 		if (ioapics[ioapic].gsi_config.gsi_base == gsi_base) {
@@ -3083,11 +3190,17 @@ int mp_unregister_ioapic(u32 gsi_base)
 	}
 
 	for_each_pin(ioapic, pin) {
-		pin_info = mp_pin_info(ioapic, pin);
-		if (pin_info->count) {
-			pr_warn("pin%d on IOAPIC%d is still in use.\n",
-				pin, ioapic);
-			return -EBUSY;
+		u32 gsi = mp_pin_to_gsi(ioapic, pin);
+		int irq = mp_map_gsi_to_irq(gsi, 0, NULL);
+		struct mp_chip_data *data;
+
+		if (irq >= 0) {
+			data = irq_get_chip_data(irq);
+			if (data && data->count) {
+				pr_warn("pin%d on IOAPIC%d is still in use.\n",
+					pin, ioapic);
+				return -EBUSY;
+			}
 		}
 	}
 
@@ -3239,7 +3352,8 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 	}
 
 	irq_data->hwirq = info->ioapic_pin;
-	irq_data->chip = &ioapic_chip;
+	irq_data->chip = (domain->parent == x86_vector_domain) ?
+			  &ioapic_chip : &ioapic_ir_chip;
 	irq_data->chip_data = data;
 	mp_irqdomain_get_attr(mp_pin_to_gsi(ioapic, pin), data, info);
 
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3d3503351242..9ca73a700912 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -196,38 +196,31 @@ static struct of_ioapic_type of_ioapic_type[] =
 	},
 };
 
-static int ioapic_xlate(struct irq_domain *domain,
-			struct device_node *controller,
-			const u32 *intspec, u32 intsize,
-			irq_hw_number_t *out_hwirq, u32 *out_type)
+static int dt_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs, void *arg)
 {
+	struct of_phandle_args *irq_data = (void *)arg;
 	struct of_ioapic_type *it;
-	u32 line, idx, gsi;
+	struct irq_alloc_info tmp;
 
-	if (WARN_ON(intsize < 2))
+	if (WARN_ON(irq_data->args_count < 2))
 		return -EINVAL;
-
-	line = intspec[0];
-
-	if (intspec[1] >= ARRAY_SIZE(of_ioapic_type))
+	if (irq_data->args[1] >= ARRAY_SIZE(of_ioapic_type))
 		return -EINVAL;
 
-	it = &of_ioapic_type[intspec[1]];
+	it = &of_ioapic_type[irq_data->args[1]];
+	ioapic_set_alloc_attr(&tmp, NUMA_NO_NODE, it->trigger, it->polarity);
+	tmp.ioapic_id = mpc_ioapic_id(mp_irqdomain_ioapic_idx(domain));
+	tmp.ioapic_pin = irq_data->args[0];
 
-	idx = (u32)(long)domain->host_data;
-	gsi = mp_pin_to_gsi(idx, line);
-	if (mp_set_gsi_attr(gsi, it->trigger, it->polarity, cpu_to_node(0)))
-		return -EBUSY;
-
-	*out_hwirq = line;
-	*out_type = it->out_type;
-	return 0;
+	return mp_irqdomain_alloc(domain, virq, nr_irqs, &tmp);
 }
 
 const struct irq_domain_ops ioapic_irq_domain_ops = {
-	.map = mp_irqdomain_map,
-	.unmap = mp_irqdomain_unmap,
-	.xlate = ioapic_xlate,
+	.alloc = dt_irqdomain_alloc,
+	.free = mp_irqdomain_free,
+	.activate = mp_irqdomain_activate,
+	.deactivate = mp_irqdomain_deactivate,
 };
 
 static void __init dtb_add_ioapic(struct device_node *dn)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 2d2a237f2c73..aa4feee74dbe 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -114,8 +114,10 @@ static void __init MP_bus_info(struct mpc_bus *m)
 }
 
 static struct irq_domain_ops mp_ioapic_irqdomain_ops = {
-	.map = mp_irqdomain_map,
-	.unmap = mp_irqdomain_unmap,
+	.alloc = mp_irqdomain_alloc,
+	.free = mp_irqdomain_free,
+	.activate = mp_irqdomain_activate,
+	.deactivate = mp_irqdomain_deactivate,
 };
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index fd9c4223acba..7f986441a4b7 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -224,8 +224,6 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	 * MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
 	 * IOAPIC RTE entries, so we just enable RTE for the device.
 	 */
-	if (mp_set_gsi_attr(dev->irq, 1, polarity, dev_to_node(&dev->dev)))
-		return -EBUSY;
 	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC, &info) < 0)
 		return -EBUSY;
 
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
index de0009f6d555..de734134bc8d 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -36,8 +36,7 @@ static int tangier_probe(struct platform_device *pdev)
 	/* IOAPIC builds identity mapping between GSI and IRQ on MID */
 	gsi = pdata->irq;
 	ioapic_set_alloc_attr(&info, cpu_to_node(0), 1, 0);
-	if (mp_set_gsi_attr(gsi, 1, 0, cpu_to_node(0)) ||
-	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info) <= 0) {
+	if (mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info) <= 0) {
 		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
 			 gsi);
 		return -EINVAL;
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 7d17355d820e..ce992e8cc065 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -469,10 +469,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 			}
 
 			ioapic_set_alloc_attr(&info, NUMA_NO_NODE, 1, polarity);
-			ret = mp_set_gsi_attr(irq, 1, polarity, NUMA_NO_NODE);
-			if (ret == 0)
-				ret = mp_map_gsi_to_irq(irq, IOAPIC_MAP_ALLOC,
-							&info);
+			ret = mp_map_gsi_to_irq(irq, IOAPIC_MAP_ALLOC, &info);
 			WARN_ON(ret < 0);
 		}
 
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index 2a8a74f3bd76..b66b194f9900 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -72,7 +72,10 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 
 #ifdef CONFIG_X86_IO_APIC
 static struct irq_domain_ops sfi_ioapic_irqdomain_ops = {
-	.map = mp_irqdomain_map,
+	.alloc = mp_irqdomain_alloc,
+	.free = mp_irqdomain_free,
+	.activate = mp_irqdomain_activate,
+	.deactivate = mp_irqdomain_deactivate,
 };
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
-- 
1.7.10.4

