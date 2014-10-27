Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaJ0IMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:12:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:56417 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaJ0IMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621213674"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v3 12/20] x86, irq: Move HT IRQ related code from io_apic.c into htirq.c
Date: Mon, 27 Oct 2014 16:12:03 +0800
Message-Id: <1414397531-28254-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create arch/x86/kernel/apic/htirq.c to host Hypertransport IRQ related
code, preparing for enabling hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/Makefile  |    1 +
 arch/x86/kernel/apic/htirq.c   |  107 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c |   92 ----------------------------------
 3 files changed, 108 insertions(+), 92 deletions(-)
 create mode 100644 arch/x86/kernel/apic/htirq.c

diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index aac300750f0e..8bb12ddc5db8 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -7,6 +7,7 @@ obj-y				+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_PCI_MSI)		+= msi.o
+obj-$(CONFIG_HT_IRQ)		+= htirq.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
new file mode 100644
index 000000000000..a4980c5091f0
--- /dev/null
+++ b/arch/x86/kernel/apic/htirq.c
@@ -0,0 +1,107 @@
+/*
+ * Support Hypertransport IRQ
+ *
+ * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
+ *	Moved from arch/x86/kernel/apic/io_apic.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/htirq.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/hypertransport.h>
+
+/*
+ * Hypertransport interrupt support
+ */
+static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+{
+	struct ht_irq_msg msg;
+
+	fetch_ht_irq_msg(irq, &msg);
+
+	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
+	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
+
+	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
+	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
+
+	write_ht_irq_msg(irq, &msg);
+}
+
+static int
+ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	target_ht_irq(data->irq, dest, cfg->vector);
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+static struct irq_chip ht_irq_chip = {
+	.name			= "PCI-HT",
+	.irq_mask		= mask_ht_irq,
+	.irq_unmask		= unmask_ht_irq,
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= ht_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
+{
+	struct irq_cfg *cfg;
+	struct ht_irq_msg msg;
+	unsigned dest;
+	int err;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	cfg = irq_cfg(irq);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
+
+	msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
+
+	msg.address_lo =
+		HT_IRQ_LOW_BASE |
+		HT_IRQ_LOW_DEST_ID(dest) |
+		HT_IRQ_LOW_VECTOR(cfg->vector) |
+		((apic->irq_dest_mode == 0) ?
+			HT_IRQ_LOW_DM_PHYSICAL :
+			HT_IRQ_LOW_DM_LOGICAL) |
+		HT_IRQ_LOW_RQEOI_EDGE |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			HT_IRQ_LOW_MT_FIXED :
+			HT_IRQ_LOW_MT_ARBITRATED) |
+		HT_IRQ_LOW_IRQ_MASKED;
+
+	write_ht_irq_msg(irq, &msg);
+
+	irq_set_chip_and_handler_name(irq, &ht_irq_chip,
+				      handle_edge_irq, "edge");
+
+	dev_dbg(&dev->dev, "irq %d for HT\n", irq);
+
+	return 0;
+}
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f35dc27b48e7..b52166a69189 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 #include <linux/syscore_ops.h>
 #include <linux/irqdomain.h>
-#include <linux/htirq.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
@@ -49,7 +48,6 @@
 #include <asm/dma.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
-#include <asm/hypertransport.h>
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hw_irq.h>
@@ -2450,96 +2448,6 @@ static int __init ioapic_init_ops(void)
 
 device_initcall(ioapic_init_ops);
 
-/*
- * Hypertransport interrupt support
- */
-#ifdef CONFIG_HT_IRQ
-
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
-{
-	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
-
-	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
-	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
-
-	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
-	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
-
-	write_ht_irq_msg(irq, &msg);
-}
-
-static int
-ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest;
-	int ret;
-
-	ret = apic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	target_ht_irq(data->irq, dest, cfg->vector);
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-static struct irq_chip ht_irq_chip = {
-	.name			= "PCI-HT",
-	.irq_mask		= mask_ht_irq,
-	.irq_unmask		= unmask_ht_irq,
-	.irq_ack		= apic_ack_edge,
-	.irq_set_affinity	= ht_set_affinity,
-	.irq_retrigger		= apic_retrigger_irq,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
-int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
-{
-	struct irq_cfg *cfg;
-	struct ht_irq_msg msg;
-	unsigned dest;
-	int err;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
-
-	msg.address_lo =
-		HT_IRQ_LOW_BASE |
-		HT_IRQ_LOW_DEST_ID(dest) |
-		HT_IRQ_LOW_VECTOR(cfg->vector) |
-		((apic->irq_dest_mode == 0) ?
-			HT_IRQ_LOW_DM_PHYSICAL :
-			HT_IRQ_LOW_DM_LOGICAL) |
-		HT_IRQ_LOW_RQEOI_EDGE |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			HT_IRQ_LOW_MT_FIXED :
-			HT_IRQ_LOW_MT_ARBITRATED) |
-		HT_IRQ_LOW_IRQ_MASKED;
-
-	write_ht_irq_msg(irq, &msg);
-
-	irq_set_chip_and_handler_name(irq, &ht_irq_chip,
-				      handle_edge_irq, "edge");
-
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
-
-	return 0;
-}
-#endif /* CONFIG_HT_IRQ */
-
 static int
 io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 {
-- 
1.7.10.4

