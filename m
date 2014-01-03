Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaACAQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:16:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23632 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaACAHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v5 21/33] x86, irq: Make mp_register_ioapic handle hot-added ioapic
Date: Thu,  2 Jan 2014 16:05:53 -0800
Message-Id: <1388707565-16535-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to reserve irq range in allocated_irqs bitmaps
and irq_base will be used to get right irq for ioapic/pin or gsi.

also need to use lock to protect ioapics_mask to avoid racing.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/mpspec.h  |  1 +
 arch/x86/kernel/apic/io_apic.c | 74 ++++++++++++++++++++++++++++++++----------
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3142a94..59d8465 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -96,6 +96,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 
 int generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d43894e..0fdda49 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -94,6 +94,16 @@ static struct ioapic {
 } ioapics[MAX_IO_APICS];
 
 DECLARE_BITMAP(ioapics_mask, MAX_IO_APICS);
+static DEFINE_MUTEX(ioapics_mask_lock);
+
+static void lock_ioapics(void)
+{
+	mutex_lock(&ioapics_mask_lock);
+}
+static void unlock_ioapics(void)
+{
+	mutex_unlock(&ioapics_mask_lock);
+}
 
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
 
@@ -3556,7 +3566,7 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
 }
 
 #ifdef CONFIG_X86_32
-static int __init io_apic_get_unique_id(int ioapic, int apic_id)
+static int io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -3631,7 +3641,7 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	return apic_id;
 }
 
-static u8 __init io_apic_unique_id(u8 id)
+static u8 io_apic_unique_id(u8 id)
 {
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
@@ -3640,7 +3650,7 @@ static u8 __init io_apic_unique_id(u8 id)
 		return id;
 }
 #else
-static u8 __init io_apic_unique_id(u8 id)
+static u8 io_apic_unique_id(u8 id)
 {
 	int i;
 	DECLARE_BITMAP(used, 256);
@@ -3893,25 +3903,28 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hotadd)
 {
 	int idx;
 	int entries;
 	struct mp_ioapic_gsi *gsi_cfg;
+	int ret = -EINVAL;
 
 	if (bad_ioapic(address))
-		return;
+		return ret;
+
+	lock_ioapics();
 
 	/* already registered ? */
 	idx = __mp_find_ioapic(gsi_base);
 	if (idx >= 0)
-		return;
+		goto out;
 
 	idx = find_first_zero_bit(ioapics_mask, MAX_IO_APICS);
 	if (idx >= MAX_IO_APICS) {
 		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded, skipping\n",
 			MAX_IO_APICS);
-		return;
+		goto out;
 	}
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
@@ -3920,10 +3933,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
-	if (bad_ioapic_register(idx)) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
-	}
+	if (bad_ioapic_register(idx))
+		goto clear_out;
 
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
@@ -3934,11 +3945,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	entries = io_apic_get_redir_entries(idx);
 
-	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		memset(&ioapics[idx], 0, sizeof(struct ioapic));
-		return;
-	}
+	if (!entries || entries > MP_MAX_IOAPIC_PIN)
+		goto clear_out;
 
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
@@ -3949,8 +3957,21 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	ioapics[idx].nr_registers = entries;
 
-	if (gsi_cfg->gsi_end >= gsi_top)
-		gsi_top = gsi_cfg->gsi_end + 1;
+	if (!hotadd) {
+		/*
+		 * irqs will be reserved in arch_early_irq_init()
+		 * don't need to update gsi_top for hot add case
+		 */
+		if (gsi_cfg->gsi_end >= gsi_top)
+			gsi_top = gsi_cfg->gsi_end + 1;
+	} else {
+		int irq = reserve_ioapic_gsi_irq_base(idx);
+
+		if (irq < 0)
+			goto clear_out;
+
+		alloc_ioapic_saved_registers(idx);
+	}
 
 	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
 		idx, mpc_ioapic_id(idx),
@@ -3959,6 +3980,23 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_bit(idx, ioapics_mask);
 	nr_ioapics = bitmap_weight(ioapics_mask, MAX_IO_APICS);
+
+	unlock_ioapics();
+
+	return 0;
+
+clear_out:
+	clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+	memset(&ioapics[idx], 0, sizeof(struct ioapic));
+out:
+	unlock_ioapics();
+
+	return ret;
+}
+
+void mp_register_ioapic(int id, u32 address, u32 gsi_base)
+{
+	__mp_register_ioapic(id, address, gsi_base, false);
 }
 
 /* Enable IOAPIC early just for system timer */
-- 
1.8.4

