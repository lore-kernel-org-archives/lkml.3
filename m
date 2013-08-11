Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3HKCto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:49:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34914 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3HKCtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v4 22/28] x86, irq: Add mp_unregister_ioapic to handle hot-remove ioapic
Date: Sat, 10 Aug 2013 19:48:08 -0700
Message-Id: <1376189294-32022-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will free ioapic related irq_desc and also clear allocated_irqs bits.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/mpspec.h  |  1 +
 arch/x86/kernel/apic/io_apic.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 13cf60c..49f6ecc 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -97,6 +97,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 void generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
 int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
+int mp_unregister_ioapic(u32 gsi_base);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1616a35..a75e9d8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -334,6 +334,20 @@ static void __init reserve_ioapic_gsi_irq_extra(void)
 	}
 }
 
+static void free_ioapic_gsi_irq_base(int idx)
+{
+	int i;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(idx);
+	int irq_base = gsi_cfg->irq_base;
+	int irq_cnt = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+
+	if (irq_base < 0)
+		return;
+
+	for (i = irq_base; i < irq_base + irq_cnt; i++)
+		free_irq_at(i, irq_get_chip_data(i));
+}
+
 static void alloc_ioapic_saved_registers(int idx)
 {
 	if (ioapics[idx].saved_registers)
@@ -347,6 +361,11 @@ static void alloc_ioapic_saved_registers(int idx)
 		pr_err("IOAPIC %d: suspend/resume impossible!\n", idx);
 }
 
+static void free_ioapic_saved_registers(int idx)
+{
+	kfree(ioapics[idx].saved_registers);
+}
+
 int __init arch_early_irq_init(void)
 {
 	int node = cpu_to_node(0);
@@ -3991,6 +4010,31 @@ void mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	__mp_register_ioapic(id, address, gsi_base, false);
 }
 
+int mp_unregister_ioapic(u32 gsi_base)
+{
+	int idx;
+
+	lock_ioapics();
+
+	idx = __mp_find_ioapic(gsi_base);
+	if (idx < 0) {
+		unlock_ioapics();
+		return -EINVAL;
+	}
+
+	free_ioapic_saved_registers(idx);
+
+	free_ioapic_gsi_irq_base(idx);
+
+	clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+	memset(&ioapics[idx], 0, sizeof(struct ioapic));
+	clear_bit(idx, ioapics_mask);
+
+	unlock_ioapics();
+
+	return 0;
+}
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
-- 
1.8.1.4

