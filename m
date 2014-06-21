Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbaFUVS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:18:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaFUVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:18:25 -0400
Date: Sat, 21 Jun 2014 14:12:27 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-79598505aee61bc943955de3653be054c2f7393f@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-16-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-16-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Reorganize IO_APIC_get_PCI_irq_vector()
  to prepare for irqdomain
Git-Commit-ID: 79598505aee61bc943955de3653be054c2f7393f
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

Commit-ID:  79598505aee61bc943955de3653be054c2f7393f
Gitweb:     http://git.kernel.org/tip/79598505aee61bc943955de3653be054c2f7393f
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:44 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:41 +0200

x86, irq: Reorganize IO_APIC_get_PCI_irq_vector() to prepare for irqdomain

Reorganize function IO_APIC_get_PCI_irq_vector() a bit to better support
coming irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-16-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 61 +++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 446a931..09e5c7b 100644
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
