Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaFIIUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:20:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:6549 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbaFIIUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:20:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352320875"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
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
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [Patch V4 21/42] x86, ACPI, irq: consolidate algorithm of mapping (ioapic, pin) to IRQ number
Date: Mon,  9 Jun 2014 16:19:50 +0800
Message-Id: <1402302011-23642-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ACPI and ioapic both implement algorithms to map (ioapic, pin)
to IRQ number. So consolidate the common part into one place, which is
also preparing for irqdomain support.

It introduces mp_map_gsi_to_irq(), which will be used to allocate IRQ
number IOAPIC pins when irqdomain is enabled.

Also rename gsi_to_irq() to map_gsi_to_irq(), later we will introduce
unmap_gsi_to_irq() when enabling IOAPIC hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 ++
 arch/x86/kernel/acpi/boot.c    |   47 +++++++++++++++++++---------------------
 arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++----------
 3 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index b775cf3622c3..978e51fdcb59 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -172,6 +172,7 @@ extern u32 gsi_top;
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
+extern int mp_map_gsi_to_irq(u32 gsi);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -214,6 +215,7 @@ static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
+static inline int mp_map_gsi_to_irq(u32 gsi) { return gsi; }
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 8b09249bb253..e5e645fdd690 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -100,27 +100,15 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 
 #define	ACPI_INVALID_GSI		INT_MIN
 
-static unsigned int gsi_to_irq(unsigned int gsi)
+static int map_gsi_to_irq(unsigned int gsi)
 {
-	unsigned int irq = gsi + nr_legacy_irqs();
-	unsigned int i;
+	int i;
 
-	for (i = 0; i < nr_legacy_irqs(); i++) {
-		if (isa_irq_to_gsi[i] == gsi) {
+	for (i = 0; i < nr_legacy_irqs(); i++)
+		if (isa_irq_to_gsi[i] == gsi)
 			return i;
-		}
-	}
-
-	/* Provide an identity mapping of gsi == irq
-	 * except on truly weird platforms that have
-	 * non isa irqs in the first 16 gsis.
-	 */
-	if (gsi >= nr_legacy_irqs())
-		irq = gsi;
-	else
-		irq = gsi_top + gsi;
 
-	return irq;
+	return mp_map_gsi_to_irq(gsi);
 }
 
 /*
@@ -416,6 +404,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
+	int irq;
 	int ioapic;
 	int ioapic_pin;
 	struct io_apic_irq_attr irq_attr;
@@ -428,6 +417,10 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
 		return gsi;
 
+	irq = map_gsi_to_irq(gsi);
+	if (irq < 0)
+		return ACPI_INVALID_GSI;
+
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic < 0) {
 		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
@@ -449,7 +442,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	ret = io_apic_set_pci_routing(dev, irq, &irq_attr);
 	if (ret < 0)
 		gsi = ACPI_INVALID_GSI;
 
@@ -614,16 +607,20 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 	outb(new >> 8, 0x4d1);
 }
 
-int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
+int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	*irq = gsi_to_irq(gsi);
+	int irq = map_gsi_to_irq(gsi);
 
+	if (irq >= 0) {
 #ifdef CONFIG_X86_IO_APIC
-	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-		setup_IO_APIC_irq_extra(gsi);
+		if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+			setup_IO_APIC_irq_extra(gsi);
 #endif
+		*irqp = irq;
+		return 0;
+	}
 
-	return 0;
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
@@ -677,11 +674,11 @@ int (*acpi_suspend_lowlevel)(void);
  */
 int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
-	unsigned int plat_gsi = gsi;
+	unsigned int plat_gsi;
 
 	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
 	if (plat_gsi != ACPI_INVALID_GSI)
-		return gsi_to_irq(plat_gsi);
+		return map_gsi_to_irq(plat_gsi);
 
 	return -1;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 12d12f897107..ed159cd36971 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -959,11 +959,19 @@ static int irq_trigger(int idx)
 	return trigger;
 }
 
+int mp_map_gsi_to_irq(u32 gsi)
+{
+	/*
+	 * Provide an identity mapping of gsi == irq except on truly weird
+	 * platforms that have non isa irqs in the first 16 gsis.
+	 */
+	return gsi >= nr_legacy_irqs() ? gsi : gsi_top + gsi;
+}
+
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
 	int bus = mp_irqs[idx].srcbus;
-	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(apic);
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
@@ -971,17 +979,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 	if (mp_irqs[idx].dstirq != pin)
 		pr_err("broken BIOS or MPTABLE parser, ayiee!!\n");
 
-	if (test_bit(bus, mp_bus_not_pci)) {
-		irq = mp_irqs[idx].srcbusirq;
-	} else {
-		u32 gsi = gsi_cfg->gsi_base + pin;
-
-		if (gsi >= nr_legacy_irqs())
-			irq = gsi;
-		else
-			irq = gsi_top + gsi;
-	}
-
 #ifdef CONFIG_X86_32
 	/*
 	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
@@ -996,11 +993,17 @@ static int pin_2_irq(int idx, int apic, int pin)
 				apic_printk(APIC_VERBOSE, KERN_DEBUG
 						"using PIRQ%d -> IRQ %d\n",
 						pin-16, irq);
+				return irq;
 			}
 		}
 	}
 #endif
 
+	if (test_bit(bus, mp_bus_not_pci))
+		irq = mp_irqs[idx].srcbusirq;
+	else
+		irq = mp_map_gsi_to_irq(mp_pin_to_gsi(apic, pin));
+
 	return irq;
 }
 
-- 
1.7.10.4

