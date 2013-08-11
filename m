Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3HKCuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:50:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3HKCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Grant Likely <grant.likely@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andy Lutomirski <luto@amacapital.net>,
        iommu@lists.linux-foundation.org
Subject: [PATCH v4 19/28] x86, irq: Add for_each_ioapic helper
Date: Sat, 10 Aug 2013 19:48:05 -0700
Message-Id: <1376189294-32022-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hotadd and hotremove ioapic controller, we leave blank
slots in ioapics array.

So we can not use for (i=...) to loop them any more.

Introdue ioapics_mask bitmap to track used ioapics, and use
for_each_ioapic to loop them.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: iommu@lists.linux-foundation.org
---
 arch/x86/include/asm/io_apic.h      |  6 ++++
 arch/x86/kernel/apic/io_apic.c      | 64 ++++++++++++++++++++-----------------
 arch/x86/kernel/devicetree.c        |  2 +-
 drivers/iommu/amd_iommu_init.c      |  2 +-
 drivers/iommu/intel_irq_remapping.c |  2 +-
 5 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 02ac411..a25dcf1 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -105,6 +105,12 @@ struct IR_IO_APIC_route_entry {
  * # of IO-APICs and # of IRQ routing registers
  */
 extern int nr_ioapics;
+extern DECLARE_BITMAP(ioapics_mask, MAX_IO_APICS);
+
+#define for_each_ioapic(i)						\
+	for ((i) = -1;							\
+		(i) = find_next_bit(ioapics_mask, MAX_IO_APICS, (i)+1), \
+		(i) < MAX_IO_APICS;)
 
 extern int mpc_ioapic_id(int ioapic);
 extern unsigned int mpc_ioapic_addr(int ioapic);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8d087f1..b026cc7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -93,6 +93,8 @@ static struct ioapic {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
+DECLARE_BITMAP(ioapics_mask, MAX_IO_APICS);
+
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
 
 int mpc_ioapic_id(int ioapic_idx)
@@ -344,10 +346,10 @@ int __init arch_early_irq_init(void)
 	if (!legacy_pic->nr_legacy_irqs)
 		io_apic_irqs = ~0UL;
 
-	for (i = 0; i < nr_ioapics; i++)
+	for_each_ioapic(i)
 		alloc_ioapic_saved_registers(i);
 
-	for (i = 0; i < nr_ioapics; i++)
+	for_each_ioapic(i)
 		reserve_ioapic_gsi_irq_base(i);
 
 	reserve_ioapic_gsi_irq_extra();
@@ -715,7 +717,7 @@ static void clear_IO_APIC (void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++)
+	for_each_ioapic(apic)
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			clear_IO_APIC_pin(apic, pin);
 }
@@ -766,7 +768,7 @@ int save_ioapic_entries(void)
 	int apic, pin;
 	int err = 0;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers) {
 			err = -ENOMEM;
 			continue;
@@ -787,7 +789,7 @@ void mask_ioapic_entries(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers)
 			continue;
 
@@ -810,7 +812,7 @@ int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers)
 			continue;
 
@@ -873,7 +875,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int ioapic_idx;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
 				return ioapic_idx;
 	}
@@ -1095,7 +1097,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
@@ -1316,7 +1318,7 @@ static inline int IO_APIC_irq_trigger(int irq)
 {
 	int apic, idx, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			idx = find_irq_entry(apic, pin, mp_INT);
 			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
@@ -1472,7 +1474,7 @@ static void __init setup_IO_APIC_irqs(void)
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		__io_apic_setup_irqs(ioapic_idx);
 }
 
@@ -1694,7 +1696,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
 		       mpc_ioapic_id(ioapic_idx),
 		       ioapics[ioapic_idx].nr_registers);
@@ -1705,7 +1707,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	 */
 	printk(KERN_INFO "testing the IO APIC.......................\n");
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		print_IO_APIC(ioapic_idx);
 
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
@@ -1940,7 +1942,7 @@ void __init enable_IO_APIC(void)
 	if (!legacy_pic->nr_legacy_irqs)
 		return;
 
-	for(apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
@@ -2057,7 +2059,7 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+	for_each_ioapic(ioapic_idx) {
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(ioapic_idx, 0);
@@ -2987,7 +2989,8 @@ static void ioapic_resume(void)
 {
 	int ioapic_idx;
 
-	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+	/* really do that in reverse order ? */
+	for_each_ioapic(ioapic_idx)
 		resume_ioapic_id(ioapic_idx);
 
 	restore_ioapic_entries();
@@ -3635,9 +3638,9 @@ static u8 __init io_apic_unique_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 
 	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i)
 		__set_bit(mpc_ioapic_id(i), used);
-	}
+
 	if (!test_bit(id, used))
 		return id;
 	return find_first_zero_bit(used, 256);
@@ -3695,7 +3698,7 @@ void __init setup_ioapic_dest(void)
 	if (skip_ioapic_setup == 1)
 		return;
 
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
+	for_each_ioapic(ioapic)
 	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
@@ -3743,7 +3746,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 
 	mem += sizeof(struct resource) * nr_ioapics;
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		res[i].name = mem;
 		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
@@ -3762,7 +3765,7 @@ void __init native_io_apic_init_mappings(void)
 	int i;
 
 	ioapic_res = ioapic_setup_resources(nr_ioapics);
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		if (smp_found_config) {
 			ioapic_phys = mpc_ioapic_addr(i);
 #ifdef CONFIG_X86_32
@@ -3809,7 +3812,7 @@ void __init ioapic_insert_resources(void)
 		return;
 	}
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		insert_resource(&iomem_resource, r);
 		r++;
 	}
@@ -3823,7 +3826,7 @@ int mp_find_ioapic(u32 gsi)
 		return -1;
 
 	/* Find the IOAPIC that manages this GSI. */
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
 		if ((gsi >= gsi_cfg->gsi_base)
 		    && (gsi <= gsi_cfg->gsi_end))
@@ -3850,11 +3853,6 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 
 static __init int bad_ioapic(unsigned long address)
 {
-	if (nr_ioapics >= MAX_IO_APICS) {
-		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
-			MAX_IO_APICS, nr_ioapics);
-		return 1;
-	}
 	if (!address) {
 		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
 		return 1;
@@ -3883,14 +3881,19 @@ static __init int bad_ioapic_register(int idx)
 
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
-	int idx = 0;
+	int idx;
 	int entries;
 	struct mp_ioapic_gsi *gsi_cfg;
 
 	if (bad_ioapic(address))
 		return;
 
-	idx = nr_ioapics;
+	idx = find_first_zero_bit(ioapics_mask, MAX_IO_APICS);
+	if (idx >= MAX_IO_APICS) {
+		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded, skipping\n",
+			MAX_IO_APICS);
+		return;
+	}
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
@@ -3928,7 +3931,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
-	nr_ioapics++;
+	set_bit(idx, ioapics_mask);
+	nr_ioapics = bitmap_weight(ioapics_mask, MAX_IO_APICS);
 }
 
 /* Enable IOAPIC early just for system timer */
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 69eb2fa..c811e2f 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -393,7 +393,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 		return;
 	}
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		if (r.start == mpc_ioapic_addr(i)) {
 			dt_add_ioapic_domain(i, np);
 			return;
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 7acbf35..7bbe9d2 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1743,7 +1743,7 @@ static bool __init check_ioapic_information(void)
 	if (cmdline_maps)
 		fw_bug = "";
 
-	for (idx = 0; idx < nr_ioapics; idx++) {
+	for_each_ioapic(idx) {
 		int devid, id = mpc_ioapic_id(idx);
 
 		devid = get_ioapic_devid(id);
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f71673d..84a6807 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -793,7 +793,7 @@ int __init parse_ioapics_under_ir(void)
 	if (!ir_supported)
 		return 0;
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+	for_each_ioapic(ioapic_idx) {
 		int ioapic_id = mpc_ioapic_id(ioapic_idx);
 		if (!map_ioapic_to_ir(ioapic_id)) {
 			pr_err(FW_BUG "ioapic %d has no mapping iommu, "
-- 
1.8.1.4

