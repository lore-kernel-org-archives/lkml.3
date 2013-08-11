Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3HKCt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:49:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25856 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3HKCtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v4 17/28] x86, irq: Reserve irq range and alloc_reserved for booting path
Date: Sat, 10 Aug 2013 19:48:03 -0700
Message-Id: <1376189294-32022-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use reserve and alloc_reserved_irq_and_cfg_at for hotplug ioapic path.

To make thing simple, we could make booting path use same code.

All irq range for all GSIs will be reserved at first, and alloc_reserved
will really allocate those irq_desc/cfg when it is used.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/io_apic.h |  1 +
 arch/x86/kernel/apic/io_apic.c | 80 +++++++++++++++++++++++++++++++-----------
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index eaff3ad..8181fd8 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -176,6 +176,7 @@ extern void setup_ioapic_ids_from_mpc_nocheck(void);
 struct mp_ioapic_gsi{
 	u32 gsi_base;
 	u32 gsi_end;
+	u32 irq_base;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3e0530c..cb272c9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -280,8 +280,47 @@ static struct irq_cfg *alloc_reserved_irq_and_cfg_at(unsigned int at, int node)
 	return alloc_irq_and_cfg_at(at, node);
 }
 
-/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
+static int reserve_ioapic_gsi_irq_base(int idx)
+{
+	int irq;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(idx);
+	int cnt = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+
+	irq = __irq_reserve_irqs(-1, gsi_cfg->gsi_base, cnt);
+	if (irq >= 0) {
+		gsi_cfg->irq_base = irq;
+		apic_printk(APIC_VERBOSE, KERN_INFO
+			"IOAPIC[%d]: apic_id %d, GSI %d-%d ==> irq %d-%d reserved\n",
+			idx, mpc_ioapic_id(idx),
+			gsi_cfg->gsi_base, gsi_cfg->gsi_end,
+			irq, irq + cnt - 1);
+	} else
+		apic_printk(APIC_VERBOSE, KERN_WARNING
+			"IOAPIC[%d]: apic_id %d, GSI %d-%d ==> irq reserve failed\n",
+			idx, mpc_ioapic_id(idx),
+			gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+
+	return irq;
+}
+
+static void __init reserve_ioapic_gsi_irq_extra(void)
+{
+	int irq;
+
+	/* to prevent hot add ioapic taking those slots */
+	if (gsi_top) {
+		irq = irq_reserve_irqs(gsi_top, NR_IRQS_LEGACY);
+		if (irq >= 0)
+			apic_printk(APIC_VERBOSE, KERN_INFO
+				"IOAPIC[extra]: GSI %d-%d ==> irq %d-%d reserved\n",
+				gsi_top, gsi_top + NR_IRQS_LEGACY - 1,
+				irq, irq + NR_IRQS_LEGACY - 1);
+		else
+			apic_printk(APIC_VERBOSE, KERN_WARNING
+				"IOAPIC[extra]: GSI %d-%d ==> irq reserve failed\n",
+				gsi_top, gsi_top + NR_IRQS_LEGACY - 1);
+	}
+}
 
 static void alloc_ioapic_saved_registers(int idx)
 {
@@ -298,8 +337,9 @@ static void alloc_ioapic_saved_registers(int idx)
 
 int __init arch_early_irq_init(void)
 {
+	int node = cpu_to_node(0);
 	struct irq_cfg *cfg;
-	int count, node, i;
+	int i;
 
 	if (!legacy_pic->nr_legacy_irqs)
 		io_apic_irqs = ~0UL;
@@ -307,26 +347,23 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < nr_ioapics; i++)
 		alloc_ioapic_saved_registers(i);
 
-	cfg = irq_cfgx;
-	count = ARRAY_SIZE(irq_cfgx);
-	node = cpu_to_node(0);
+	for (i = 0; i < nr_ioapics; i++)
+		reserve_ioapic_gsi_irq_base(i);
 
-	/* Make sure the legacy interrupts are marked in the bitmap */
-	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
+	reserve_ioapic_gsi_irq_extra();
 
-	for (i = 0; i < count; i++) {
-		INIT_LIST_HEAD(&cfg[i].irq_2_pin);
-		irq_set_chip_data(i, &cfg[i]);
-		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
-		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
-		/*
-		 * For legacy IRQ's, start with assigning irq0 to irq15 to
-		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
-		 */
-		if (i < legacy_pic->nr_legacy_irqs) {
-			cfg[i].vector = IRQ0_VECTOR + i;
-			cpumask_setall(cfg[i].domain);
+	/*
+	 * For legacy IRQ's, start with assigning irq0 to irq15 to
+	 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
+	 */
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++) {
+		cfg = alloc_reserved_irq_and_cfg_at(i, node);
+		if (!cfg) {
+			pr_warn("can not allocate irq_desc/cfg for %d\n", i);
+			continue;
 		}
+		cfg->vector = IRQ0_VECTOR + i;
+		cpumask_setall(cfg->domain);
 	}
 
 	return 0;
@@ -3460,7 +3497,8 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return NR_IRQS_LEGACY;
+	/* x86 arch code will allocate irq_desc/cfg */
+	return 0;
 }
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
-- 
1.8.1.4

