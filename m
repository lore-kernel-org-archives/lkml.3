Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaFII35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:29:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:36134 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbaFIITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352320247"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V4 15/42] x86, irq: reorganize IO_APIC_get_PCI_irq_vector() to prepare for irqdomain
Date: Mon,  9 Jun 2014 16:19:44 +0800
Message-Id: <1402302011-23642-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize function IO_APIC_get_PCI_irq_vector() a bit to better support
coming irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   61 ++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0b2fb2aac7a6..4ca3151d26f9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -997,7 +997,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int ioapic_idx, i, best_guess = -1;
+	int irq, i, best_guess = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -1007,41 +1007,46 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 			    "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
 		return -1;
 	}
+
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
+		int ioapic_idx, found = 0;
+
+		if (bus != lbus || mp_irqs[i].irqtype != mp_INT ||
+		    slot != ((mp_irqs[i].srcbusirq >> 2) & 0x1f))
+			continue;
 
 		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
-			    mp_irqs[i].dstapic == MP_APIC_ALL)
+			    mp_irqs[i].dstapic == MP_APIC_ALL) {
+				found = 1;
 				break;
+			}
+		if (!found)
+			continue;
 
-		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    mp_irqs[i].irqtype == mp_INT &&
-		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
-
-			if (!(ioapic_idx || IO_APIC_IRQ(irq)))
-				continue;
+		/* Skip ISA IRQs */
+		irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
+		if (ioapic_idx == 0 && !IO_APIC_IRQ(irq))
+			continue;
 
-			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				set_io_apic_irq_attr(irq_attr, ioapic_idx,
-						     mp_irqs[i].dstirq,
-						     irq_trigger(i),
-						     irq_polarity(i));
-				return irq;
-			}
-			/*
-			 * Use the first all-but-pin matching entry as a
-			 * best-guess fuzzy result for broken mptables.
-			 */
-			if (best_guess < 0) {
-				set_io_apic_irq_attr(irq_attr, ioapic_idx,
-						     mp_irqs[i].dstirq,
-						     irq_trigger(i),
-						     irq_polarity(i));
-				best_guess = irq;
-			}
+		if (pin == (mp_irqs[i].srcbusirq & 3)) {
+			set_io_apic_irq_attr(irq_attr, ioapic_idx,
+					     mp_irqs[i].dstirq,
+					     irq_trigger(i),
+					     irq_polarity(i));
+			return irq;
+		}
+		/*
+		 * Use the first all-but-pin matching entry as a
+		 * best-guess fuzzy result for broken mptables.
+		 */
+		if (best_guess < 0) {
+			set_io_apic_irq_attr(irq_attr, ioapic_idx,
+					     mp_irqs[i].dstirq,
+					     irq_trigger(i),
+					     irq_polarity(i));
+			best_guess = irq;
 		}
 	}
 	return best_guess;
-- 
1.7.10.4

