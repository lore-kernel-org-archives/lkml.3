Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbbATFzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:55:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:37523 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbbATFz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:55:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448441"
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
Subject: [Patch Part2 v4 29/33] x86, ioapic: Use proper defines for the entry fields
Date: Tue, 20 Jan 2015 13:51:49 +0800
Message-Id: <1421733113-15704-30-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

While looking at the printout issue, I stumbled more than once over
the various 0/1 assignments which are either commented in strange ways
or force to lookup the meaning.

Use proper constants and fix the misleading comments. While at it
remove pointless 0 assignments in native_disable_io_apic() which have
no value for understanding the code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |   16 +++++--
 arch/x86/kernel/apic/io_apic.c |   99 ++++++++++++++++++++--------------------
 2 files changed, 62 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index b2510b8dad44..c7aa7cd90d3f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -98,9 +98,19 @@ struct IR_IO_APIC_route_entry {
 struct irq_alloc_info;
 struct irq_data;
 
-#define IOAPIC_AUTO     -1
-#define IOAPIC_EDGE     0
-#define IOAPIC_LEVEL    1
+#define IOAPIC_AUTO			-1
+#define IOAPIC_EDGE			0
+#define IOAPIC_LEVEL			1
+
+#define IOAPIC_MASKED			1
+#define IOAPIC_UNMASKED			0
+
+#define IOAPIC_POL_HIGH			0
+#define IOAPIC_POL_LOW			1
+
+#define IOAPIC_DEST_MODE_PHYSICAL	0
+#define IOAPIC_DEST_MODE_LOGICAL	1
+
 #define	IOAPIC_MAP_ALLOC		0x1
 #define	IOAPIC_MAP_CHECK		0x2
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 068f26428984..6e838d6100c5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -358,7 +358,7 @@ static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 static void ioapic_mask_entry(int apic, int pin)
 {
 	unsigned long flags;
-	union entry_union eu = { .entry.mask = 1 };
+	union entry_union eu = { .entry.mask = IOAPIC_MASKED };
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
@@ -519,7 +519,7 @@ static void __eoi_ioapic_pin(int apic, int pin, int vector)
 		/*
 		 * Mask the entry and change the trigger mode to edge.
 		 */
-		entry1.mask = 1;
+		entry1.mask = IOAPIC_MASKED;
 		entry1.trigger = IOAPIC_EDGE;
 
 		__ioapic_write_entry(apic, pin, entry1);
@@ -555,8 +555,8 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 	 * Make sure the entry is masked and re-read the contents to check
 	 * if it is a level triggered pin and if the remote-IRR is set.
 	 */
-	if (!entry.mask) {
-		entry.mask = 1;
+	if (entry.mask == IOAPIC_UNMASKED) {
+		entry.mask = IOAPIC_MASKED;
 		ioapic_write_entry(apic, pin, entry);
 		entry = ioapic_read_entry(apic, pin);
 	}
@@ -569,7 +569,7 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 		 * doesn't clear the remote-IRR if the trigger mode is not
 		 * set to level.
 		 */
-		if (!entry.trigger) {
+		if (entry.trigger == IOAPIC_EDGE) {
 			entry.trigger = IOAPIC_LEVEL;
 			ioapic_write_entry(apic, pin, entry);
 		}
@@ -672,8 +672,8 @@ void mask_ioapic_entries(void)
 			struct IO_APIC_route_entry entry;
 
 			entry = ioapics[apic].saved_registers[pin];
-			if (!entry.mask) {
-				entry.mask = 1;
+			if (entry.mask == IOAPIC_UNMASKED) {
+				entry.mask = IOAPIC_MASKED;
 				ioapic_write_entry(apic, pin, entry);
 			}
 		}
@@ -775,11 +775,11 @@ static int EISA_ELCR(unsigned int irq)
 
 #endif
 
-/* ISA interrupts are always polarity zero edge triggered,
+/* ISA interrupts are always active high edge triggered,
  * when listed as conforming in the MP table. */
 
-#define default_ISA_trigger(idx)	(0)
-#define default_ISA_polarity(idx)	(0)
+#define default_ISA_trigger(idx)	(IOAPIC_EDGE)
+#define default_ISA_polarity(idx)	(IOAPIC_POL_HIGH)
 
 /* EISA interrupts are always polarity zero and can be edge or level
  * trigger depending on the ELCR value.  If an interrupt is listed as
@@ -789,11 +789,11 @@ static int EISA_ELCR(unsigned int irq)
 #define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].srcbusirq))
 #define default_EISA_polarity(idx)	default_ISA_polarity(idx)
 
-/* PCI interrupts are always polarity one level triggered,
+/* PCI interrupts are always active low level triggered,
  * when listed as conforming in the MP table. */
 
-#define default_PCI_trigger(idx)	(1)
-#define default_PCI_polarity(idx)	(1)
+#define default_PCI_trigger(idx)	(IOAPIC_LEVEL)
+#define default_PCI_polarity(idx)	(IOAPIC_POL_LOW)
 
 static int irq_polarity(int idx)
 {
@@ -813,24 +813,24 @@ static int irq_polarity(int idx)
 			break;
 		case 1: /* high active */
 		{
-			polarity = 0;
+			polarity = IOAPIC_POL_HIGH;
 			break;
 		}
 		case 2: /* reserved */
 		{
 			pr_warn("broken BIOS!!\n");
-			polarity = 1;
+			polarity = IOAPIC_POL_LOW;
 			break;
 		}
 		case 3: /* low active */
 		{
-			polarity = 1;
+			polarity = IOAPIC_POL_LOW;
 			break;
 		}
 		default: /* invalid */
 		{
 			pr_warn("broken BIOS!!\n");
-			polarity = 1;
+			polarity = IOAPIC_POL_LOW;
 			break;
 		}
 	}
@@ -872,7 +872,7 @@ static int irq_trigger(int idx)
 				default:
 				{
 					pr_warn("broken BIOS!!\n");
-					trigger = 1;
+					trigger = IOAPIC_LEVEL;
 					break;
 				}
 			}
@@ -880,24 +880,24 @@ static int irq_trigger(int idx)
 			break;
 		case 1: /* edge */
 		{
-			trigger = 0;
+			trigger = IOAPIC_EDGE;
 			break;
 		}
 		case 2: /* reserved */
 		{
 			pr_warn("broken BIOS!!\n");
-			trigger = 1;
+			trigger = IOAPIC_LEVEL;
 			break;
 		}
 		case 3: /* level */
 		{
-			trigger = 1;
+			trigger = IOAPIC_LEVEL;
 			break;
 		}
 		default: /* invalid */
 		{
 			pr_warn("broken BIOS!!\n");
-			trigger = 0;
+			trigger = IOAPIC_EDGE;
 			break;
 		}
 	}
@@ -937,11 +937,11 @@ static void ioapic_copy_alloc_attr(struct irq_alloc_info *dst,
 			dst->ioapic_polarity = polarity;
 		} else {
 			/*
-			 * PCI interrupts are always polarity one level
+			 * PCI interrupts are always active low level
 			 * triggered.
 			 */
-			dst->ioapic_trigger = 1;
-			dst->ioapic_polarity = 1;
+			dst->ioapic_trigger = IOAPIC_LEVEL;
+			dst->ioapic_polarity = IOAPIC_POL_LOW;
 		}
 	}
 }
@@ -1294,9 +1294,9 @@ static void io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 		entry = ioapic_read_entry(apic, i);
 		snprintf(buf, sizeof(buf),
 			 " pin%02x, %s, %s, %s, V(%02X), IRR(%1d), S(%1d)",
-			 i, entry.mask ? "disabled" : "enabled ",
-			 entry.trigger ? "level" : "edge ",
-			 entry.polarity ? "low " : "high",
+			 i, entry.mask == IOAPIC_MASKED ? "disabled" : "enabled ",
+			 entry.trigger == IOAPIC_LEVEL ? "level" : "edge ",
+			 entry.polarity == IOAPIC_POL_LOW ? "low " : "high",
 			 entry.vector, entry.irr, entry.delivery_status);
 		if (ir_entry->format)
 			printk(KERN_DEBUG "%s, remapped, I(%04X),  Z(%X)\n",
@@ -1304,7 +1304,9 @@ static void io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 			       ir_entry->zero);
 		else
 			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n",
-			       buf, entry.dest_mode ? "logical " : "physical",
+			       buf,
+			       entry.dest_mode == IOAPIC_DEST_MODE_LOGICAL ?
+			       "logical " : "physical",
 			       entry.dest, entry.delivery_mode);
 	}
 }
@@ -1474,15 +1476,12 @@ void native_disable_io_apic(void)
 		struct IO_APIC_route_entry entry;
 
 		memset(&entry, 0, sizeof(entry));
-		entry.mask            = 0; /* Enabled */
-		entry.trigger         = 0; /* Edge */
-		entry.irr             = 0;
-		entry.polarity        = 0; /* High */
-		entry.delivery_status = 0;
-		entry.dest_mode       = 0; /* Physical */
-		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
-		entry.vector          = 0;
-		entry.dest            = read_apic_id();
+		entry.mask		= IOAPIC_UNMASKED;
+		entry.trigger		= IOAPIC_EDGE;
+		entry.polarity		= IOAPIC_POL_HIGH;
+		entry.dest_mode		= IOAPIC_DEST_MODE_PHYSICAL;
+		entry.delivery_mode	= dest_ExtINT;
+		entry.dest		= read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1492,7 +1491,6 @@ void native_disable_io_apic(void)
 
 	if (cpu_has_apic || apic_from_smp_config())
 		disconnect_bsp_APIC(ioapic_i8259.pin != -1);
-
 }
 
 /*
@@ -2016,12 +2014,12 @@ static inline void __init unlock_ExtINT_logic(void)
 
 	memset(&entry1, 0, sizeof(entry1));
 
-	entry1.dest_mode = 0;			/* physical delivery */
-	entry1.mask = 0;			/* unmask IRQ now */
+	entry1.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
+	entry1.mask = IOAPIC_UNMASKED;
 	entry1.dest = hard_smp_processor_id();
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
-	entry1.trigger = 0;
+	entry1.trigger = IOAPIC_EDGE;
 	entry1.vector = 0;
 
 	ioapic_write_entry(apic, pin, entry1);
@@ -2909,9 +2907,9 @@ static void mp_irqdomain_get_attr(u32 gsi, struct mp_chip_data *data,
 		data->polarity = info->ioapic_polarity;
 	} else if (acpi_get_override_irq(gsi, &data->trigger,
 					 &data->polarity) < 0) {
-		/* PCI interrupts are always polarity one level triggered. */
-		data->trigger = 1;
-		data->polarity = 1;
+		/* PCI interrupts are always active low level triggered. */
+		data->trigger = IOAPIC_LEVEL;
+		data->polarity = IOAPIC_POL_LOW;
 	}
 }
 
@@ -2923,15 +2921,16 @@ static void mp_setup_entry(struct irq_cfg *cfg, struct mp_chip_data *data,
 	entry->dest_mode     = apic->irq_dest_mode;
 	entry->dest	     = cfg->dest_apicid;
 	entry->vector	     = cfg->vector;
-	entry->mask	     = 0;	/* enable IRQ */
 	entry->trigger	     = data->trigger;
 	entry->polarity	     = data->polarity;
 	/*
-	 * Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 * Mask level triggered irqs. Edge triggered irqs are masked
+	 * by the irq core code in case they fire.
 	 */
-	if (data->trigger)
-		entry->mask = 1;
+	if (data->trigger == IOAPIC_LEVEL)
+		entry->mask = IOAPIC_MASKED;
+	else
+		entry->mask = IOAPIC_UNMASKED;
 }
 
 int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
-- 
1.7.10.4

