Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947002Ab3BHTbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:31:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34185 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760434Ab3BHTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 21/26] x86, irq: Add mp_unregister_ioapic to handle hot-remove ioapic
Date: Fri,  8 Feb 2013 11:28:18 -0800
Message-Id: <1360351703-20571-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will free ioapic related irq_desc and also clear allocated_irqs bits.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/mpspec.h  |    1 +
 arch/x86/kernel/apic/io_apic.c |   42 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 11bb6ea..e70b7e5 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -97,6 +97,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
 int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
+int mp_unregister_ioapic(u32 gsi_base);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d3b3c14..4a9ccf6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -256,6 +256,14 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
+static void free_irqs(unsigned int from, int cnt)
+{
+	int i;
+
+	for (i = from; i < from + cnt; i++)
+		free_irq_at(i, irq_get_chip_data(i));
+}
+
 static struct irq_cfg *realloc_irq_and_cfg_at(unsigned int at, int node)
 {
 	struct irq_desc *desc = irq_to_desc(at);
@@ -329,6 +337,16 @@ static void __init reserve_ioapic_gsi_irq_extra(void)
 	}
 }
 
+static void free_ioapic_gsi_irq_base(int idx)
+{
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(idx);
+	int irq_base = gsi_cfg->irq_base;
+	int irq_cnt = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+
+	if (irq_base > 0)
+		free_irqs(irq_base, irq_cnt);
+}
+
 static void alloc_ioapic_saved_registers(int idx)
 {
 	if (ioapics[idx].saved_registers)
@@ -342,6 +360,11 @@ static void alloc_ioapic_saved_registers(int idx)
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
@@ -3983,6 +4006,25 @@ void mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	__mp_register_ioapic(id, address, gsi_base, false);
 }
 
+int mp_unregister_ioapic(u32 gsi_base)
+{
+	int idx;
+
+	idx = mp_find_ioapic(gsi_base);
+	if (idx < 0)
+		return -EINVAL;
+
+	free_ioapic_saved_registers(idx);
+
+	free_ioapic_gsi_irq_base(idx);
+
+	clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+	memset(&ioapics[idx], 0, sizeof(struct ioapic));
+	ioapics[idx].mp_config.apicid = 0xff;
+
+	return 0;
+}
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
-- 
1.7.10.4

