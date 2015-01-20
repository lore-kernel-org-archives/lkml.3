Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbbATFzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:55:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:32410 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbbATFzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:55:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448484"
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
Subject: [Patch Part2 v4 30/33] x86,ioapic: Cleanup irq_trigger/polarity()
Date: Tue, 20 Jan 2015 13:51:50 +0800
Message-Id: <1421733113-15704-31-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

These functions are full of pointless indentations, useless comments
and even more useless printks.

Clean them up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |  138 +++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 88 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6e838d6100c5..32f37445980d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -798,45 +798,47 @@ static int EISA_ELCR(unsigned int irq)
 static int irq_polarity(int idx)
 {
 	int bus = mp_irqs[idx].srcbus;
-	int polarity;
 
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].irqflag & 3)
-	{
-		case 0: /* conforms, ie. bus-type dependent polarity */
-			if (test_bit(bus, mp_bus_not_pci))
-				polarity = default_ISA_polarity(idx);
-			else
-				polarity = default_PCI_polarity(idx);
-			break;
-		case 1: /* high active */
-		{
-			polarity = IOAPIC_POL_HIGH;
-			break;
-		}
-		case 2: /* reserved */
-		{
-			pr_warn("broken BIOS!!\n");
-			polarity = IOAPIC_POL_LOW;
-			break;
-		}
-		case 3: /* low active */
-		{
-			polarity = IOAPIC_POL_LOW;
-			break;
-		}
-		default: /* invalid */
-		{
-			pr_warn("broken BIOS!!\n");
-			polarity = IOAPIC_POL_LOW;
-			break;
-		}
+	switch (mp_irqs[idx].irqflag & 0x03) {
+	case 0:
+		/* conforms to spec, ie. bus-type dependent polarity */
+		if (test_bit(bus, mp_bus_not_pci))
+			return default_ISA_polarity(idx);
+		else
+			return default_PCI_polarity(idx);
+	case 1:
+		return IOAPIC_POL_HIGH;
+	case 2:
+		pr_warn("IOAPIC: Invalid polarity: 2, defaulting to low\n");
+	case 3:
+	default: /* Pointless default required due to do gcc stupidity */
+		return IOAPIC_POL_LOW;
 	}
-	return polarity;
 }
 
+#ifdef CONFIG_EISA
+static int eisa_irq_trigger(int idx, int bus, int trigger)
+{
+	switch (mp_bus_id_to_type[bus]) {
+	case MP_BUS_PCI:
+	case MP_BUS_ISA:
+		return trigger;
+	case MP_BUS_EISA:
+		return default_EISA_trigger(idx);
+	}
+	pr_warn("IOAPIC: Invalid srcbus: %d defaulting to level\n", bus);
+	return IOAPIC_LEVEL;
+}
+#else
+static inline int eisa_irq_trigger(int idx, int bus, int trigger)
+{
+	return trigger;
+}
+#endif
+
 static int irq_trigger(int idx)
 {
 	int bus = mp_irqs[idx].srcbus;
@@ -845,63 +847,23 @@ static int irq_trigger(int idx)
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].irqflag>>2) & 3)
-	{
-		case 0: /* conforms, ie. bus-type dependent */
-			if (test_bit(bus, mp_bus_not_pci))
-				trigger = default_ISA_trigger(idx);
-			else
-				trigger = default_PCI_trigger(idx);
-#ifdef CONFIG_EISA
-			switch (mp_bus_id_to_type[bus]) {
-				case MP_BUS_ISA: /* ISA pin */
-				{
-					/* set before the switch */
-					break;
-				}
-				case MP_BUS_EISA: /* EISA pin */
-				{
-					trigger = default_EISA_trigger(idx);
-					break;
-				}
-				case MP_BUS_PCI: /* PCI pin */
-				{
-					/* set before the switch */
-					break;
-				}
-				default:
-				{
-					pr_warn("broken BIOS!!\n");
-					trigger = IOAPIC_LEVEL;
-					break;
-				}
-			}
-#endif
-			break;
-		case 1: /* edge */
-		{
-			trigger = IOAPIC_EDGE;
-			break;
-		}
-		case 2: /* reserved */
-		{
-			pr_warn("broken BIOS!!\n");
-			trigger = IOAPIC_LEVEL;
-			break;
-		}
-		case 3: /* level */
-		{
-			trigger = IOAPIC_LEVEL;
-			break;
-		}
-		default: /* invalid */
-		{
-			pr_warn("broken BIOS!!\n");
-			trigger = IOAPIC_EDGE;
-			break;
-		}
+	switch ((mp_irqs[idx].irqflag >> 2) & 0x03) {
+	case 0:
+		/* conforms to spec, ie. bus-type dependent trigger mode */
+		if (test_bit(bus, mp_bus_not_pci))
+			trigger = default_ISA_trigger(idx);
+		else
+			trigger = default_PCI_trigger(idx);
+		/* Take EISA into account */
+		return eisa_irq_trigger(idx, bus, trigger);
+	case 1:
+		return IOAPIC_EDGE;
+	case 2:
+		pr_warn("IOAPIC: Invalid trigger mode 2 defaulting to level\n");
+	case 3:
+	default: /* Pointless default required due to do gcc stupidity */
+		return IOAPIC_LEVEL;
 	}
-	return trigger;
 }
 
 void ioapic_set_alloc_attr(struct irq_alloc_info *info, int node,
-- 
1.7.10.4

