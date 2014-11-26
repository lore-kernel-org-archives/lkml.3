Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaKZXVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:21:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKZXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:21:04 -0500
Date: Wed, 26 Nov 2014 15:20:08 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-fda7c08b1349cc4c65f8a5240b10f7e9938604b8@git.kernel.org>
Cc: mingo@kernel.org, rdunlap@infradead.org, bhelgaas@google.com,
        hpa@zytor.com, tony.luck@intel.com, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com, grant.likely@linaro.org,
        konrad.wilk@oracle.com, bp@alien8.de, gregkh@linuxfoundation.org,
        tglx@linutronix.de, yinghai@kernel.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        jroedel@suse.de
Reply-To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, jroedel@suse.de, tglx@linutronix.de,
        yinghai@kernel.org, grant.likely@linaro.org, konrad.wilk@oracle.com,
        jiang.liu@linux.intel.com, tony.luck@intel.com, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, bp@alien8.de, mingo@kernel.org,
        hpa@zytor.com, bhelgaas@google.com, rdunlap@infradead.org
In-Reply-To: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Use cached IOAPIC entry instead of reading from hardware
Git-Commit-ID: fda7c08b1349cc4c65f8a5240b10f7e9938604b8
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

Commit-ID:  fda7c08b1349cc4c65f8a5240b10f7e9938604b8
Gitweb:     http://git.kernel.org/tip/fda7c08b1349cc4c65f8a5240b10f7e9938604b8
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:53 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Use cached IOAPIC entry instead of reading from hardware

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
 arch/x86/kernel/apic/io_apic.c | 78 ++++++++++++------------------------------
 1 file changed, 21 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a915ee0..8a62933 100644
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
 
@@ -290,22 +295,6 @@ static void io_apic_write(unsigned int apic, unsigned int reg,
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
@@ -442,29 +431,23 @@ static void __init replace_pin_at_irq_node(struct mp_chip_data *data, int node,
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
@@ -1729,28 +1712,6 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
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
@@ -1916,6 +1877,7 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 {
 	struct irq_data *parent = irq_data->parent_data;
 	struct mp_chip_data *data = irq_data->chip_data;
+	struct irq_pin_list *entry;
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	int ret;
@@ -1926,7 +1888,9 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 		cfg = irqd_cfg(irq_data);
 		data->entry.dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
 		data->entry.vector = cfg->vector;
-		__target_IO_APIC_irq(irq_data->irq, cfg, irq_data->chip_data);
+		for_each_irq_pin(entry, data->irq_2_pin)
+			__ioapic_write_entry(entry->apic, entry->pin,
+					     data->entry);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
