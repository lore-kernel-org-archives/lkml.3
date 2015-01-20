Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbbATFxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:53:31 -0500
Received: from mga14.intel.com ([192.55.52.115]:53747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbbATFx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:53:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447906"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 20/33] x86/irq: Use cached IOAPIC entry instead of reading from hardware
Date: Tue, 20 Jan 2015 13:51:40 +0800
Message-Id: <1421733113-15704-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cached IOAPIC entry instead of reading data from IOAPIC hardware
registers to improve performance.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/io_apic.c |   78 +++++++++++-----------------------------
 1 file changed, 21 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2298ee7d86d3..83c3c90bd903 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -69,8 +69,13 @@
 int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity);
 
 /*
- *      Is the SiS APIC rmw bug present ?
+ * Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
+ * When doing a read-modify-write operation on IOAPIC registers, older SiS APIC
+ * requires we rewrite the index register again where the read already set up
+ * the index register.
+ * The code to make use of sis_apic_bug has been removed, but we don't want to
+ * loss this knowledge.
  */
 int sis_apic_bug = -1;
 
@@ -295,22 +300,6 @@ static void io_apic_write(unsigned int apic, unsigned int reg,
 	writel(value, &io_apic->data);
 }
 
-/*
- * Re-write a value: to be used for read-modify-write
- * cycles where the read already set up the index register.
- *
- * Older SiS APIC requires we rewrite the index register
- */
-static void io_apic_modify(unsigned int apic, unsigned int reg,
-			   unsigned int value)
-{
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-
-	if (sis_apic_bug)
-		writel(reg, &io_apic->index);
-	writel(value, &io_apic->data);
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -447,29 +436,23 @@ static void __init replace_pin_at_irq_node(struct mp_chip_data *data, int node,
 	add_pin_to_irq_node(data, node, newapic, newpin);
 }
 
-static void __io_apic_modify_irq(struct irq_pin_list *entry,
-				 int mask_and, int mask_or,
-				 void (*final)(struct irq_pin_list *entry))
-{
-	unsigned int reg, pin;
-
-	pin = entry->pin;
-	reg = io_apic_read(entry->apic, 0x10 + pin * 2);
-	reg &= mask_and;
-	reg |= mask_or;
-	io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
-	if (final)
-		final(entry);
-}
-
 static void io_apic_modify_irq(struct mp_chip_data *data,
 			       int mask_and, int mask_or,
 			       void (*final)(struct irq_pin_list *entry))
 {
+	union entry_union eu;
 	struct irq_pin_list *entry;
 
-	for_each_irq_pin(entry, data->irq_2_pin)
-		__io_apic_modify_irq(entry, mask_and, mask_or, final);
+	eu.entry = data->entry;
+	eu.w1 &= mask_and;
+	eu.w1 |= mask_or;
+	data->entry = eu.entry;
+
+	for_each_irq_pin(entry, data->irq_2_pin) {
+		io_apic_write(entry->apic, 0x10 + 2 * entry->pin, eu.w1);
+		if (final)
+			final(entry);
+	}
 }
 
 static void io_apic_sync(struct irq_pin_list *entry)
@@ -1737,28 +1720,6 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-static void __target_IO_APIC_irq(unsigned int irq, struct irq_cfg *cfg,
-				 struct mp_chip_data *data)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-	u8 vector = cfg->vector;
-	unsigned int dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
-
-	for_each_irq_pin(entry, data->irq_2_pin) {
-		unsigned int reg;
-
-		apic = entry->apic;
-		pin = entry->pin;
-
-		io_apic_write(apic, 0x11 + pin*2, dest);
-		reg = io_apic_read(apic, 0x10 + pin*2);
-		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
-		reg |= vector;
-		io_apic_modify(apic, 0x10 + pin*2, reg);
-	}
-}
-
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -1924,6 +1885,7 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 {
 	struct irq_data *parent = irq_data->parent_data;
 	struct mp_chip_data *data = irq_data->chip_data;
+	struct irq_pin_list *entry;
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	int ret;
@@ -1934,7 +1896,9 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 		cfg = irqd_cfg(irq_data);
 		data->entry.dest = cfg->dest_apicid;
 		data->entry.vector = cfg->vector;
-		__target_IO_APIC_irq(irq_data->irq, cfg, irq_data->chip_data);
+		for_each_irq_pin(entry, data->irq_2_pin)
+			__ioapic_write_entry(entry->apic, entry->pin,
+					     data->entry);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-- 
1.7.10.4

