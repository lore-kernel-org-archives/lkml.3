Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaFIIXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:23:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:34384 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbaFIIXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:23:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321831"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [Patch V4 35/42] x86, irq: simplify the way to handle ISA IRQ
Date: Mon,  9 Jun 2014 16:20:04 +0800
Message-Id: <1402302011-23642-36-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On startup, setup_IO_APIC_irqs() will program all IOAPIC pins for ISA
IRQs. Later when mp_map_pin_to_irq() is called, it just returns ISA IRQ
number without programming corresponding IOAPIC pin.

This patch consolidates the way to program IOAPIC pins for both ISA and
non-ISA IRQs into mp_map_pin_to_irq() as below:
1) For ISA IRQs, mp_irqs array is used to map IOAPIC pin to IRQ and
   mp_irqdomain_map() is used to actually program the pin.
2) For non-ISA IRQs, irqdomain is used to map IOAPIC pin to IRQ, and
   mp_irqdomain_map() is also used to actually program the pin.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c    |   15 +-----
 arch/x86/kernel/apic/io_apic.c |   98 ++++++++++++++++------------------------
 2 files changed, 40 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index edb48a8e0a0d..ef3336ab6432 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -101,17 +101,6 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 
 #define	ACPI_INVALID_GSI		INT_MIN
 
-static int map_gsi_to_irq(unsigned int gsi, unsigned int flags)
-{
-	int i;
-
-	for (i = 0; i < nr_legacy_irqs(); i++)
-		if (isa_irq_to_gsi[i] == gsi)
-			return i;
-
-	return mp_map_gsi_to_irq(gsi, flags);
-}
-
 /*
  * This is just a simple wrapper around early_ioremap(),
  * with sanity checks for phys == 0 and size == 0.
@@ -422,7 +411,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 		return -1;
 	}
 
-	irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
 	if (irq < 0)
 		return irq;
 
@@ -603,7 +592,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
 
 	if (irq >= 0) {
 		*irqp = irq;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1623f5dba6c2..5fc76cf51e44 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -204,8 +204,6 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static int io_apic_setup_irq_pin(unsigned int irq, int node,
-				 struct io_apic_irq_attr *attr);
 static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
 
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
@@ -1021,6 +1019,16 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
 	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
 
+	if (!domain) {
+		/*
+		 * Provide an identity mapping of gsi == irq except on truly
+		 * weird platforms that have non isa irqs in the first 16 gsis.
+		 */
+		return gsi >= nr_legacy_irqs() ? gsi : gsi_top + gsi;
+	}
+
+	mutex_lock(&ioapic_mutex);
+
 	/*
 	 * Don't use irqdomain to manage ISA IRQs because there may be
 	 * multiple IOAPIC pins sharing the same ISA IRQ number and
@@ -1033,28 +1041,30 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	 * the interrupt routing logic. Thus there may be multiple pins
 	 * sharing the same legacy IRQ number when ACPI is disabled.
 	 */
-	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci))
-		return mp_irqs[idx].srcbusirq;
-
-	if (!domain) {
-		/*
-		 * Provide an identity mapping of gsi == irq except on truly
-		 * weird platforms that have non isa irqs in the first 16 gsis.
-		 */
-		return gsi >= nr_legacy_irqs() ? gsi : gsi_top + gsi;
+	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
+		irq = mp_irqs[idx].srcbusirq;
+		if (flags & IOAPIC_MAP_ALLOC) {
+			if (info->count == 0 &&
+			    mp_irqdomain_map(domain, irq, pin) != 0)
+				irq = -1;
+
+			/* special handling for timer IRQ0 */
+			if (irq == 0)
+				info->count++;
+		}
+	} else {
+		irq = irq_find_mapping(domain, pin);
+		if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
+			irq = alloc_irq_from_domain(domain, gsi, pin);
 	}
 
-	mutex_lock(&ioapic_mutex);
-	irq = irq_find_mapping(domain, pin);
-	if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
-		irq = alloc_irq_from_domain(domain, gsi, pin);
-
 	if (flags & IOAPIC_MAP_ALLOC) {
 		if (irq > 0)
 			info->count++;
 		else if (info->count == 0)
 			info->set = 0;
 	}
+
 	mutex_unlock(&ioapic_mutex);
 
 	return irq > 0 ? irq : -1;
@@ -1471,55 +1481,23 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
 }
 
-static bool __init io_apic_pin_not_connected(int idx, int ioapic_idx, int pin)
-{
-	if (idx != -1)
-		return false;
-
-	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mpc_ioapic_id(ioapic_idx), pin);
-	return true;
-}
-
-static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
-{
-	int idx, node = cpu_to_node(0);
-	struct io_apic_irq_attr attr;
-	unsigned int pin, irq;
-
-	for_each_pin(ioapic_idx, pin) {
-		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
-		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
-			continue;
-
-		irq = pin_2_irq(idx, ioapic_idx, pin,
-				ioapic_idx ? 0 : IOAPIC_MAP_ALLOC);
-		if (irq < 0 || !mp_init_irq_at_boot(ioapic_idx, irq))
-			continue;
-
-		/*
-		 * Skip the timer IRQ if there's a quirk handler
-		 * installed and if it returns 1:
-		 */
-		if (apic->multi_timer_check &&
-		    apic->multi_timer_check(ioapic_idx, irq))
-			continue;
-
-		set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
-				     irq_polarity(idx));
-
-		io_apic_setup_irq_pin(irq, node, &attr);
-	}
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
-	unsigned int ioapic_idx;
+	unsigned int ioapic, pin;
+	int idx;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for_each_ioapic(ioapic_idx)
-		__io_apic_setup_irqs(ioapic_idx);
+	for_each_ioapic_pin(ioapic, pin) {
+		idx = find_irq_entry(ioapic, pin, mp_INT);
+		if (idx < 0)
+			apic_printk(APIC_VERBOSE,
+				    KERN_DEBUG " apic %d pin %d not connected\n",
+				    mpc_ioapic_id(ioapic), pin);
+		else
+			pin_2_irq(idx, ioapic, pin,
+				  ioapic ? 0 : IOAPIC_MAP_ALLOC);
+	}
 }
 
 /*
-- 
1.7.10.4

