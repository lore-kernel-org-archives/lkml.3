Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbaFUVPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:15:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446AbaFUVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:14:59 -0400
Date: Sat, 21 Jun 2014 14:13:51 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-6b9fb7082409cd4a2c7caf43e3c023ad82dad0d4@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1402380812-32446-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402380812-32446-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ACPI, irq: Consolidate algorithm of mapping (
 ioapic, pin) to IRQ number
Git-Commit-ID: 6b9fb7082409cd4a2c7caf43e3c023ad82dad0d4
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

Commit-ID:  6b9fb7082409cd4a2c7caf43e3c023ad82dad0d4
Gitweb:     http://git.kernel.org/tip/6b9fb7082409cd4a2c7caf43e3c023ad82dad0d4
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 10 Jun 2014 14:13:25 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:42 +0200

x86, ACPI, irq: Consolidate algorithm of mapping (ioapic, pin) to IRQ number

Currently ACPI and ioapic both implement algorithms to map (ioapic, pin)
to IRQ number. So consolidate the common part into one place, which is
also preparing for irqdomain support.

It introduces mp_map_gsi_to_irq(), which will be used to allocate IRQ
number IOAPIC pins when irqdomain is enabled.

Also rename gsi_to_irq() to map_gsi_to_irq(), later we will introduce
unmap_gsi_to_irq() when enabling IOAPIC hotplug.

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
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1402380812-32446-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  2 ++
 arch/x86/kernel/acpi/boot.c    | 45 ++++++++++++++++++++----------------------
 arch/x86/kernel/apic/io_apic.c | 27 ++++++++++++++-----------
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index b775cf3..978e51f 100644
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
index b129765..9965afb 100644
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
 
@@ -681,7 +678,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	plat_gsi = __acpi_register_gsi(dev, gsi, trigger, polarity);
 	if (plat_gsi != ACPI_INVALID_GSI)
-		return gsi_to_irq(plat_gsi);
+		return map_gsi_to_irq(plat_gsi);
 
 	return -1;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e25e7e3..7fd9f1b 100644
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
 
