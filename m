Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaKEQoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:44:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaKEQoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:44:34 -0500
Date: Wed, 5 Nov 2014 08:38:21 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-2a4974e35bb7dd99629979e22dfbd2a670d7bf31@git.kernel.org>
Cc: benh@kernel.crashing.org, tglx@linutronix.de, joro@8bytes.org,
        grant.likely@linaro.org, bhelgaas@google.com, mingo@kernel.org,
        rjw@rjwysocki.net, prarit@redhat.com, jiang.liu@linux.intel.com,
        yinghai@kernel.org, bp@alien8.de, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, rdunlap@infradead.org, tony.luck@intel.com,
        hpa@zytor.com, gregkh@linuxfoundation.org
Reply-To: rjw@rjwysocki.net, mingo@kernel.org, grant.likely@linaro.org,
        bhelgaas@google.com, tglx@linutronix.de, joro@8bytes.org,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        rdunlap@infradead.org, konrad.wilk@oracle.com, tony.luck@intel.com,
        bp@alien8.de, linux-kernel@vger.kernel.org, prarit@redhat.com,
        yinghai@kernel.org, jiang.liu@linux.intel.com
In-Reply-To: <1414397531-28254-13-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-13-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Move HT IRQ related code from io_apic.c into htirq.c
Git-Commit-ID: 2a4974e35bb7dd99629979e22dfbd2a670d7bf31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a4974e35bb7dd99629979e22dfbd2a670d7bf31
Gitweb:     http://git.kernel.org/tip/2a4974e35bb7dd99629979e22dfbd2a670d7bf31
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:03 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:47 +0100

x86, irq: Move HT IRQ related code from io_apic.c into htirq.c

Create arch/x86/kernel/apic/htirq.c to host Hypertransport IRQ related
code, preparing for enabling hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414397531-28254-13-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/Makefile  |   1 +
 arch/x86/kernel/apic/htirq.c   | 107 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c |  92 -----------------------------------
 3 files changed, 108 insertions(+), 92 deletions(-)

diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index aac3007..8bb12dd 100644
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
index 0000000..a4980c5
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
index 653fe21..b1acb68 100644
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
