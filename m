Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaFEHDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:03:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:3246 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaFEHC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,979,1392192000"; 
   d="scan'208";a="551900755"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-pci@vger.kernel.org
Subject: [RFC Patch 3/3] x86, irq: count legacy IRQs by legacy_pic->nr_legacy_irqs instead of NR_IRQS_LEGACY
Date: Thu,  5 Jun 2014 15:04:37 +0800
Message-Id: <1401951877-23032-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <5385BCD0.1080802@linutronix.de>
References: <5385BCD0.1080802@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms, such as Intel MID and mshypv, do not support legacy
interrupt controllers. So count legacy IRQs by legacy_pic->nr_legacy_irqs
instead of hard-coded NR_IRQS_LEGACY.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/i8259.h   |    2 ++
 arch/x86/kernel/acpi/boot.c    |   13 ++++++------
 arch/x86/kernel/apic/io_apic.c |   43 +++++++++++++++++++++++-----------------
 arch/x86/kernel/devicetree.c   |   12 +++++------
 arch/x86/kernel/irqinit.c      |    6 +++---
 arch/x86/pci/xen.c             |    6 +++---
 6 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index a20365953bf8..fdac75b8782a 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -67,4 +67,6 @@ struct legacy_pic {
 extern struct legacy_pic *legacy_pic;
 extern struct legacy_pic null_legacy_pic;
 
+#define	nr_legacy_irqs()	(legacy_pic->nr_legacy_irqs)
+
 #endif /* _ASM_X86_I8259_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d6493863bd4b..8b09249bb253 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -43,6 +43,7 @@
 #include <asm/io.h>
 #include <asm/mpspec.h>
 #include <asm/smp.h>
+#include <asm/i8259.h>
 
 #include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
 static int __initdata acpi_force = 0;
@@ -101,10 +102,10 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 
 static unsigned int gsi_to_irq(unsigned int gsi)
 {
-	unsigned int irq = gsi + NR_IRQS_LEGACY;
+	unsigned int irq = gsi + nr_legacy_irqs();
 	unsigned int i;
 
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		if (isa_irq_to_gsi[i] == gsi) {
 			return i;
 		}
@@ -114,7 +115,7 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	 * except on truly weird platforms that have
 	 * non isa irqs in the first 16 gsis.
 	 */
-	if (gsi >= NR_IRQS_LEGACY)
+	if (gsi >= nr_legacy_irqs())
 		irq = gsi;
 	else
 		irq = gsi_top + gsi;
@@ -371,7 +372,7 @@ static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 	 * otherwise there will be more than one entry with the same GSI
 	 * and acpi_isa_irq_to_gsi() may give wrong result.
 	 */
-	if (gsi < NR_IRQS_LEGACY && isa_irq_to_gsi[gsi] == gsi)
+	if (gsi < nr_legacy_irqs() && isa_irq_to_gsi[gsi] == gsi)
 		isa_irq_to_gsi[gsi] = ACPI_INVALID_GSI;
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
@@ -628,7 +629,7 @@ EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
-	if (isa_irq < NR_IRQS_LEGACY &&
+	if (isa_irq < nr_legacy_irqs() &&
 	    isa_irq_to_gsi[isa_irq] != ACPI_INVALID_GSI) {
 		*gsi = isa_irq_to_gsi[isa_irq];
 		return 0;
@@ -1017,7 +1018,7 @@ static void __init mp_config_acpi_legacy_irqs(void)
 	 * Use the default configuration for the IRQs 0-15.  Unless
 	 * overridden by (MADT) interrupt source override entries.
 	 */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		int ioapic, pin;
 		unsigned int dstapic;
 		int idx;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 02faa7104aa5..72cbb92ca401 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -129,10 +129,17 @@ u32 mp_pin_to_gsi(int ioapic, int pin)
 	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
 }
 
-/* Initialize all legacy IRQs and all pins on the first IOAPIC at boot */
+/*
+ * Initialize all legacy IRQs and all pins on the first IOAPIC
+ * if we have legacy interrupt controller. Kernel boot option "pirq="
+ * may rely on non-legacy pins on the first IOAPIC.
+ */
 static inline int mp_init_irq_at_boot(int ioapic, int irq)
 {
-	return ioapic == 0 || (irq >= 0 && irq < NR_IRQS_LEGACY);
+	if (!nr_legacy_irqs())
+		return 0;
+
+	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
 }
 
 int nr_ioapics;
@@ -216,7 +223,7 @@ int __init arch_early_irq_init(void)
 	struct irq_cfg *cfg;
 	int count, node, i;
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
 
 	for_each_ioapic(i) {
@@ -239,7 +246,7 @@ int __init arch_early_irq_init(void)
 		 * For legacy IRQ's, start with assigning irq0 to irq15 to
 		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
 		 */
-		if (i < legacy_pic->nr_legacy_irqs) {
+		if (i < nr_legacy_irqs()) {
 			cfg[i].vector = IRQ0_VECTOR + i;
 			cpumask_setall(cfg[i].domain);
 		}
@@ -823,7 +830,7 @@ static int __init find_isa_irq_apic(int irq, int type)
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < legacy_pic->nr_legacy_irqs) {
+	if (irq < nr_legacy_irqs()) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -980,7 +987,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	} else {
 		u32 gsi = gsi_cfg->gsi_base + pin;
 
-		if (gsi >= NR_IRQS_LEGACY)
+		if (gsi >= nr_legacy_irqs())
 			irq = gsi;
 		else
 			irq = gsi_top + gsi;
@@ -1357,7 +1364,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	}
 
 	ioapic_register_intr(irq, cfg, attr->trigger);
-	if (irq < legacy_pic->nr_legacy_irqs)
+	if (irq < nr_legacy_irqs())
 		legacy_pic->mask(irq);
 
 	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
@@ -1782,7 +1789,7 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		return;
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1854,7 +1861,7 @@ void __init enable_IO_APIC(void)
 	int i8259_apic, i8259_pin;
 	int apic, pin;
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		return;
 
 	for_each_ioapic_pin(apic, pin) {
@@ -1939,7 +1946,7 @@ void disable_IO_APIC(void)
 	 */
 	clear_IO_APIC();
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		return;
 
 	x86_io_apic_ops.disable();
@@ -2143,7 +2150,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < legacy_pic->nr_legacy_irqs) {
+	if (irq < nr_legacy_irqs()) {
 		legacy_pic->mask(irq);
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
@@ -2542,7 +2549,7 @@ static inline void init_IO_APIC_traps(void)
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < legacy_pic->nr_legacy_irqs)
+			if (irq < nr_legacy_irqs())
 				legacy_pic->make_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -2839,7 +2846,7 @@ void __init setup_IO_APIC(void)
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
-	io_apic_irqs = legacy_pic->nr_legacy_irqs ? ~PIC_IRQS : ~0UL;
+	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 	/*
@@ -2850,7 +2857,7 @@ void __init setup_IO_APIC(void)
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
-	if (legacy_pic->nr_legacy_irqs)
+	if (nr_legacy_irqs())
 		check_timer();
 }
 
@@ -3344,7 +3351,7 @@ static int __init io_apic_get_redir_entries(int ioapic)
 
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
-	unsigned int min = gsi_top + NR_IRQS_LEGACY;
+	unsigned int min = gsi_top + nr_legacy_irqs();
 
 	return from < min ? min : from;
 }
@@ -3356,17 +3363,17 @@ int __init arch_probe_nr_irqs(void)
 	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
 		nr_irqs = NR_VECTORS * nr_cpu_ids;
 
-	nr = (gsi_top + NR_IRQS_LEGACY) + 8 * nr_cpu_ids;
+	nr = (gsi_top + nr_legacy_irqs()) + 8 * nr_cpu_ids;
 #if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
 	/*
 	 * for MSI and HT dyn irq
 	 */
-	nr += (gsi_top + NR_IRQS_LEGACY) * 16;
+	nr += gsi_top * 16;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return NR_IRQS_LEGACY;
+	return nr_legacy_irqs();
 }
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index d35078ea1446..68f8805401be 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -316,7 +316,7 @@ static void dt_add_ioapic_domain(unsigned int ioapic_num,
 	struct irq_domain *id;
 	struct mp_ioapic_gsi *gsi_cfg;
 	int ret;
-	int num;
+	int num, legacy_irqs = nr_legacy_irqs();
 
 	gsi_cfg = mp_ioapic_gsi_routing(ioapic_num);
 	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
@@ -326,17 +326,17 @@ static void dt_add_ioapic_domain(unsigned int ioapic_num,
 	BUG_ON(!id);
 	if (gsi_cfg->gsi_base == 0) {
 		/*
-		 * The first NR_IRQS_LEGACY irq descs are allocated in
+		 * The first nr_legacy_irqs() irq descs are allocated in
 		 * early_irq_init() and need just a mapping. The
 		 * remaining irqs need both. All of them are preallocated
 		 * and assigned so we can keep the 1:1 mapping which the ioapic
 		 * is having.
 		 */
-		irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
+		irq_domain_associate_many(id, 0, 0, legacy_irqs);
 
-		if (num > NR_IRQS_LEGACY) {
-			ret = irq_create_strict_mappings(id, NR_IRQS_LEGACY,
-					NR_IRQS_LEGACY, num - NR_IRQS_LEGACY);
+		if (num > legacy_irqs) {
+			ret = irq_create_strict_mappings(id, legacy_irqs,
+					legacy_irqs, num - legacy_irqs);
 			if (ret)
 				pr_err("Error creating mapping for the "
 						"remaining IRQs: %d\n", ret);
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 7f50156542fb..a0111e91eb4b 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -78,7 +78,7 @@ void __init init_ISA_irqs(void)
 #endif
 	legacy_pic->init(0);
 
-	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
+	for (i = 0; i < nr_legacy_irqs(); i++)
 		irq_set_chip_and_handler_name(i, chip, handle_level_irq, name);
 }
 
@@ -100,7 +100,7 @@ void __init init_IRQ(void)
 	 * then this vector space can be freed and re-used dynamically as the
 	 * irq's migrate etc.
 	 */
-	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
+	for (i = 0; i < nr_legacy_irqs(); i++)
 		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
 
 	x86_init.irqs.intr_init();
@@ -121,7 +121,7 @@ void setup_vector_irq(int cpu)
 	 * legacy PIC, for the new cpu that is coming online, setup the static
 	 * legacy vector to irq mapping:
 	 */
-	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
+	for (irq = 0; irq < nr_legacy_irqs(); irq++)
 		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
 #endif
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 905956f16465..8debddd2c6d1 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -40,7 +40,7 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 	/* In PV DomU the Xen PCI backend puts the PIRQ in the interrupt line.*/
 	pirq = gsi;
 
-	if (gsi < NR_IRQS_LEGACY)
+	if (gsi < nr_legacy_irqs())
 		share = 0;
 
 	rc = xen_bind_pirq_gsi_to_irq(gsi, pirq, share, "pcifront");
@@ -511,7 +511,7 @@ int __init pci_xen_initial_domain(void)
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 	/* Pre-allocate legacy irqs */
-	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+	for (irq = 0; irq < nr_legacy_irqs(); irq++) {
 		int trigger, polarity;
 
 		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
@@ -522,7 +522,7 @@ int __init pci_xen_initial_domain(void)
 			true /* Map GSI to PIRQ */);
 	}
 	if (0 == nr_ioapics) {
-		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
+		for (irq = 0; irq < nr_legacy_irqs(); irq++)
 			xen_bind_pirq_gsi_to_irq(irq, irq, 0, "xt-pic");
 	}
 	return 0;
-- 
1.7.10.4

