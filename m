Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaACAPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:15:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23640 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaACAHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v5 14/33] x86, irq: Move down arch_early_irq_init()
Date: Thu,  2 Jan 2014 16:05:46 -0800
Message-Id: <1388707565-16535-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change position only.

Prepare to update arch_early_irq_init() that needs to call some static
functions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c | 89 +++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4b836ea..5822c37 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -185,51 +185,6 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
-
-/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
-
-int __init arch_early_irq_init(void)
-{
-	struct irq_cfg *cfg;
-	int count, node, i;
-
-	if (!legacy_pic->nr_legacy_irqs)
-		io_apic_irqs = ~0UL;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		ioapics[i].saved_registers =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				ioapics[i].nr_registers, GFP_KERNEL);
-		if (!ioapics[i].saved_registers)
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
-
-	cfg = irq_cfgx;
-	count = ARRAY_SIZE(irq_cfgx);
-	node = cpu_to_node(0);
-
-	/* Make sure the legacy interrupts are marked in the bitmap */
-	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
-
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
-		}
-	}
-
-	return 0;
-}
-
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
@@ -325,6 +280,50 @@ static struct irq_cfg *alloc_reserved_irq_and_cfg_at(unsigned int at, int node)
 	return alloc_irq_and_cfg_at(at, node);
 }
 
+/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
+static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
+
+int __init arch_early_irq_init(void)
+{
+	struct irq_cfg *cfg;
+	int count, node, i;
+
+	if (!legacy_pic->nr_legacy_irqs)
+		io_apic_irqs = ~0UL;
+
+	for (i = 0; i < nr_ioapics; i++) {
+		ioapics[i].saved_registers =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				ioapics[i].nr_registers, GFP_KERNEL);
+		if (!ioapics[i].saved_registers)
+			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
+	}
+
+	cfg = irq_cfgx;
+	count = ARRAY_SIZE(irq_cfgx);
+	node = cpu_to_node(0);
+
+	/* Make sure the legacy interrupts are marked in the bitmap */
+	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
+
+	for (i = 0; i < count; i++) {
+		INIT_LIST_HEAD(&cfg[i].irq_2_pin);
+		irq_set_chip_data(i, &cfg[i]);
+		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
+		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
+		/*
+		 * For legacy IRQ's, start with assigning irq0 to irq15 to
+		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
+		 */
+		if (i < legacy_pic->nr_legacy_irqs) {
+			cfg[i].vector = IRQ0_VECTOR + i;
+			cpumask_setall(cfg[i].domain);
+		}
+	}
+
+	return 0;
+}
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
-- 
1.8.4

