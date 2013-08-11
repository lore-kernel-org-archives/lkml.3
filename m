Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3HKCvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:51:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34904 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3HKCtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:35 -0400
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
Subject: [PATCH v4 21/28] x86, irq: Make mp_register_ioapic handle hot-added ioapic
Date: Sat, 10 Aug 2013 19:48:07 -0700
Message-Id: <1376189294-32022-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
 arch/x86/kernel/apic/io_apic.c | 68 ++++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 626cf70..13cf60c 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -96,6 +96,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 
 void generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 60c6706..1616a35 100644
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
 
@@ -3885,25 +3895,28 @@ static __init int bad_ioapic_register(int idx)
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
@@ -3912,10 +3925,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
-	if (bad_ioapic_register(idx)) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
-	}
+	if (bad_ioapic_register(idx))
+		goto clear_out;
 
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
@@ -3926,11 +3937,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
@@ -3941,8 +3949,21 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
@@ -3951,6 +3972,23 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
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
1.8.1.4

