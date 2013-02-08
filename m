Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab3BHTav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:30:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34313 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602Ab3BHTam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 20/26] x86, irq: Make mp_register_ioapic handle hotadd ioapic
Date: Fri,  8 Feb 2013 11:28:17 -0800
Message-Id: <1360351703-20571-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to reserve irq range in allocated_irqs bitmaps
and irq_base will be used to get right irq for ioapic/pin or gsi.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/mpspec.h  |    1 +
 arch/x86/kernel/apic/io_apic.c |   59 ++++++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3e2f42a..11bb6ea 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -96,6 +96,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8e92ba0..d3b3c14 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3893,7 +3893,7 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hotadd)
 {
 	int idx;
 	int entries;
@@ -3901,11 +3901,19 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = __mp_find_ioapic(gsi_base, true);
 	if (idx >= 0)
-		return;
+		return -EINVAL;
 
 	idx = nr_ioapics;
+	if (hotadd) {
+		/* find free spot */
+		for (idx = 0; idx < nr_ioapics; idx++)
+			if (!ioapics[idx].nr_registers &&
+			    ioapics[idx].mp_config.apicid == 0xff)
+				break;
+	}
+
 	if (bad_ioapic(idx, address))
-		return;
+		return -EINVAL;
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
@@ -3913,10 +3921,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
-	if (bad_ioapic_register(idx)) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
-	}
+	if (bad_ioapic_register(idx))
+		goto failed;
 
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
@@ -3927,10 +3933,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	entries = io_apic_get_redir_entries(idx);
 
-	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
-	}
+	if (!entries || entries > MP_MAX_IOAPIC_PIN)
+		goto failed;
 
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
@@ -3941,15 +3945,42 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
+			goto failed;
+
+		alloc_ioapic_saved_registers(idx);
+	}
 
 	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
 		idx, mpc_ioapic_id(idx),
 		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
-	nr_ioapics++;
+	if (idx == nr_ioapics)
+		nr_ioapics++;
+
+	return 0;
+
+failed:
+	clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+	memset(&ioapics[idx], 0, sizeof(struct ioapic));
+	ioapics[idx].mp_config.apicid = 0xff;
+	return -EINVAL;
+}
+
+void mp_register_ioapic(int id, u32 address, u32 gsi_base)
+{
+	__mp_register_ioapic(id, address, gsi_base, false);
 }
 
 /* Enable IOAPIC early just for system timer */
-- 
1.7.10.4

