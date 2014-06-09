Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaFIITf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:19:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:14004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbaFIITa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:19:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352320149"
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
Subject: [Patch V4 13/42] x86, ioapic: introduce helper utilities to walk ioapics and pins
Date: Mon,  9 Jun 2014 16:19:42 +0800
Message-Id: <1402302011-23642-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper utilities for_each_ioapic(), for_each_ioapic_reverse(),
for_each_pin() and for_each_ioapic_pin() to walk ioapics and pins.
They will be rewritten e will rewrite later to support IOAPIC hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |  120 +++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e8cd0bf0ee82..8de9a837790b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -62,6 +62,16 @@
 
 #define __apicdebuginit(type) static type __init
 
+#define	for_each_ioapic(idx)		\
+	for ((idx) = 0; (idx) < nr_ioapics; (idx)++)
+#define	for_each_ioapic_reverse(idx)	\
+	for ((idx) = nr_ioapics - 1; (idx) >= 0; (idx)--)
+#define	for_each_pin(idx, pin)		\
+	for ((pin) = 0; (pin) < ioapics[(idx)].nr_registers; (pin)++)
+#define	for_each_ioapic_pin(idx, pin)	\
+	for_each_ioapic((idx))		\
+		for_each_pin((idx), (pin))
+
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
@@ -191,7 +201,7 @@ int __init arch_early_irq_init(void)
 	if (!legacy_pic->nr_legacy_irqs)
 		io_apic_irqs = ~0UL;
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		ioapics[i].saved_registers =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				ioapics[i].nr_registers, GFP_KERNEL);
@@ -624,9 +634,8 @@ static void clear_IO_APIC (void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
-			clear_IO_APIC_pin(apic, pin);
+	for_each_ioapic_pin(apic, pin)
+		clear_IO_APIC_pin(apic, pin);
 }
 
 #ifdef CONFIG_X86_32
@@ -675,13 +684,13 @@ int save_ioapic_entries(void)
 	int apic, pin;
 	int err = 0;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers) {
 			err = -ENOMEM;
 			continue;
 		}
 
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
+		for_each_pin(apic, pin)
 			ioapics[apic].saved_registers[pin] =
 				ioapic_read_entry(apic, pin);
 	}
@@ -696,11 +705,11 @@ void mask_ioapic_entries(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers)
 			continue;
 
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
+		for_each_pin(apic, pin) {
 			struct IO_APIC_route_entry entry;
 
 			entry = ioapics[apic].saved_registers[pin];
@@ -719,11 +728,11 @@ int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers)
 			continue;
 
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
+		for_each_pin(apic, pin)
 			ioapic_write_entry(apic, pin,
 					   ioapics[apic].saved_registers[pin]);
 	}
@@ -782,7 +791,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int ioapic_idx;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
 				return ioapic_idx;
 	}
@@ -1001,7 +1010,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
@@ -1224,12 +1233,10 @@ static inline int IO_APIC_irq_trigger(int irq)
 {
 	int apic, idx, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
-			idx = find_irq_entry(apic, pin, mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
-				return irq_trigger(idx);
-		}
+	for_each_ioapic_pin(apic, pin) {
+		idx = find_irq_entry(apic, pin, mp_INT);
+		if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
+			return irq_trigger(idx);
 	}
 	/*
          * nonexistent IRQs are edge default
@@ -1349,7 +1356,7 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < ioapics[ioapic_idx].nr_registers; pin++) {
+	for_each_pin(ioapic_idx, pin) {
 		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
 		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
 			continue;
@@ -1380,7 +1387,7 @@ static void __init setup_IO_APIC_irqs(void)
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		__io_apic_setup_irqs(ioapic_idx);
 }
 
@@ -1583,7 +1590,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
 		       mpc_ioapic_id(ioapic_idx),
 		       ioapics[ioapic_idx].nr_registers);
@@ -1594,7 +1601,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	 */
 	printk(KERN_INFO "testing the IO APIC.......................\n");
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		print_IO_APIC(ioapic_idx);
 
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
@@ -1825,26 +1832,22 @@ static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 void __init enable_IO_APIC(void)
 {
 	int i8259_apic, i8259_pin;
-	int apic;
+	int apic, pin;
 
 	if (!legacy_pic->nr_legacy_irqs)
 		return;
 
-	for(apic = 0; apic < nr_ioapics; apic++) {
-		int pin;
+	for_each_ioapic_pin(apic, pin) {
 		/* See if any of the pins is in ExtINT mode */
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
-			struct IO_APIC_route_entry entry;
-			entry = ioapic_read_entry(apic, pin);
+		struct IO_APIC_route_entry entry = ioapic_read_entry(apic, pin);
 
-			/* If the interrupt line is enabled and in ExtInt mode
-			 * I have found the pin where the i8259 is connected.
-			 */
-			if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
-				ioapic_i8259.apic = apic;
-				ioapic_i8259.pin  = pin;
-				goto found_i8259;
-			}
+		/* If the interrupt line is enabled and in ExtInt mode
+		 * I have found the pin where the i8259 is connected.
+		 */
+		if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
+			ioapic_i8259.apic = apic;
+			ioapic_i8259.pin  = pin;
+			goto found_i8259;
 		}
 	}
  found_i8259:
@@ -1947,7 +1950,7 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+	for_each_ioapic(ioapic_idx) {
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(ioapic_idx, 0);
@@ -2863,7 +2866,7 @@ static void ioapic_resume(void)
 {
 	int ioapic_idx;
 
-	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+	for_each_ioapic_reverse(ioapic_idx)
 		resume_ioapic_id(ioapic_idx);
 
 	restore_ioapic_entries();
@@ -3453,9 +3456,8 @@ static u8 __init io_apic_unique_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 
 	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i)
 		__set_bit(mpc_ioapic_id(i), used);
-	}
 	if (!test_bit(id, used))
 		return id;
 	return find_first_zero_bit(used, 256);
@@ -3513,8 +3515,7 @@ void __init setup_ioapic_dest(void)
 	if (skip_ioapic_setup == 1)
 		return;
 
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
-	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
+	for_each_ioapic_pin(ioapic, pin) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
@@ -3543,29 +3544,33 @@ void __init setup_ioapic_dest(void)
 
 static struct resource *ioapic_resources;
 
-static struct resource * __init ioapic_setup_resources(int nr_ioapics)
+static struct resource * __init ioapic_setup_resources(void)
 {
 	unsigned long n;
 	struct resource *res;
 	char *mem;
-	int i;
+	int i, num = 0;
 
-	if (nr_ioapics <= 0)
+	for_each_ioapic(i)
+		num++;
+	if (num == 0)
 		return NULL;
 
 	n = IOAPIC_RESOURCE_NAME_SIZE + sizeof(struct resource);
-	n *= nr_ioapics;
+	n *= num;
 
 	mem = alloc_bootmem(n);
 	res = (void *)mem;
 
-	mem += sizeof(struct resource) * nr_ioapics;
+	mem += sizeof(struct resource) * num;
 
-	for (i = 0; i < nr_ioapics; i++) {
-		res[i].name = mem;
-		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	num = 0;
+	for_each_ioapic(i) {
+		res[num].name = mem;
+		res[num].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
+		num++;
 	}
 
 	ioapic_resources = res;
@@ -3579,8 +3584,8 @@ void __init native_io_apic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	ioapic_res = ioapic_setup_resources(nr_ioapics);
-	for (i = 0; i < nr_ioapics; i++) {
+	ioapic_res = ioapic_setup_resources();
+	for_each_ioapic(i) {
 		if (smp_found_config) {
 			ioapic_phys = mpc_ioapic_addr(i);
 #ifdef CONFIG_X86_32
@@ -3625,7 +3630,7 @@ void __init ioapic_insert_resources(void)
 		return;
 	}
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		insert_resource(&iomem_resource, r);
 		r++;
 	}
@@ -3633,16 +3638,15 @@ void __init ioapic_insert_resources(void)
 
 int mp_find_ioapic(u32 gsi)
 {
-	int i = 0;
+	int i;
 
 	if (nr_ioapics == 0)
 		return -1;
 
 	/* Find the IOAPIC that manages this GSI. */
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
-		if ((gsi >= gsi_cfg->gsi_base)
-		    && (gsi <= gsi_cfg->gsi_end))
+		if (gsi >= gsi_cfg->gsi_base && gsi <= gsi_cfg->gsi_end)
 			return i;
 	}
 
@@ -3654,7 +3658,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	struct mp_ioapic_gsi *gsi_cfg;
 
-	if (WARN_ON(ioapic == -1))
+	if (WARN_ON(ioapic < 0))
 		return -1;
 
 	gsi_cfg = mp_ioapic_gsi_routing(ioapic);
-- 
1.7.10.4

