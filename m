Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbbATDSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:18:13 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60565 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbbATDSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:18:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/3] x86: rename eisa_set_level_irq to elcr_set_level_irq
Date: Mon, 19 Jan 2015 22:18:19 -0500
Message-ID: <1421723901-32303-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
References: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This routine has been around for over a decade, but with EISA
being dead and abandoned for about twice that long, the name can
be kind of confusing.  The function is going at the PIC Edge/Level
Configuration Registers (ELCR), so rename it as such and mentally
decouple it from the long since dead EISA bus.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/hw_irq.h |  3 +--
 arch/x86/kernel/acpi/boot.c   |  2 +-
 arch/x86/pci/irq.c            | 13 +++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 9662290..abeb255 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -163,8 +163,7 @@ static inline void unlock_vector_lock(void) {}
 extern atomic_t irq_err_count;
 extern atomic_t irq_mis_count;
 
-/* EISA */
-extern void eisa_set_level_irq(unsigned int irq);
+extern void elcr_set_level_irq(unsigned int irq);
 
 /* SMP */
 extern __visible void smp_apic_timer_interrupt(struct pt_regs *);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d162636..9b3ce03 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -647,7 +647,7 @@ static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
 	 */
 	if (trigger == ACPI_LEVEL_SENSITIVE)
-		eisa_set_level_irq(gsi);
+		elcr_set_level_irq(gsi);
 #endif
 
 	return gsi;
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 5dc6ca5..9bd1154 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -146,19 +146,20 @@ static void __init pirq_peer_trick(void)
 
 /*
  *  Code for querying and setting of IRQ routes on various interrupt routers.
+ *  PIC Edge/Level Control Registers (ELCR) 0x4d0 & 0x4d1.
  */
 
-void eisa_set_level_irq(unsigned int irq)
+void elcr_set_level_irq(unsigned int irq)
 {
 	unsigned char mask = 1 << (irq & 7);
 	unsigned int port = 0x4d0 + (irq >> 3);
 	unsigned char val;
-	static u16 eisa_irq_mask;
+	static u16 elcr_irq_mask;
 
-	if (irq >= 16 || (1 << irq) & eisa_irq_mask)
+	if (irq >= 16 || (1 << irq) & elcr_irq_mask)
 		return;
 
-	eisa_irq_mask |= (1 << irq);
+	elcr_irq_mask |= (1 << irq);
 	printk(KERN_DEBUG "PCI: setting IRQ %u as level-triggered\n", irq);
 	val = inb(port);
 	if (!(val & mask)) {
@@ -965,11 +966,11 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 	} else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
 	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
 		msg = "found";
-		eisa_set_level_irq(irq);
+		elcr_set_level_irq(irq);
 	} else if (newirq && r->set &&
 		(dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
 		if (r->set(pirq_router_dev, dev, pirq, newirq)) {
-			eisa_set_level_irq(newirq);
+			elcr_set_level_irq(newirq);
 			msg = "assigned";
 			irq = newirq;
 		}
-- 
2.2.1

