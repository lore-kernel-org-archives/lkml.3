Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaKHOCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:02:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:52017 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaKHOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:02:51 -0500
Date: Sat, 8 Nov 2014 15:02:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq updates for 3.18
Message-ID: <alpine.DEB.2.11.1411081458410.10721@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Two fixlets for the armada SoC interrupt controller.

Thanks,

	tglx

------------------>
Grzegorz Jaszczyk (2):
      irqchip: armada-370-xp: Fix MSI interrupt handling
      irqchip: armada-370-xp: Fix MPIC interrupt handling


 drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 3e238cd049e6..6a2e168c3ab0 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -43,6 +43,7 @@
 #define ARMADA_370_XP_INT_CLEAR_ENABLE_OFFS	(0x34)
 #define ARMADA_370_XP_INT_SOURCE_CTL(irq)	(0x100 + irq*4)
 #define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
+#define ARMADA_370_XP_INT_IRQ_FIQ_MASK(cpuid)	((BIT(0) | BIT(8)) << cpuid)
 
 #define ARMADA_370_XP_CPU_INTACK_OFFS		(0x44)
 #define ARMADA_375_PPI_CAUSE			(0x10)
@@ -406,19 +407,29 @@ static void armada_370_xp_mpic_handle_cascade_irq(unsigned int irq,
 						  struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_get_chip(irq);
-	unsigned long irqmap, irqn;
+	unsigned long irqmap, irqn, irqsrc, cpuid;
 	unsigned int cascade_irq;
 
 	chained_irq_enter(chip, desc);
 
 	irqmap = readl_relaxed(per_cpu_int_base + ARMADA_375_PPI_CAUSE);
-
-	if (irqmap & BIT(0)) {
-		armada_370_xp_handle_msi_irq(NULL, true);
-		irqmap &= ~BIT(0);
-	}
+	cpuid = cpu_logical_map(smp_processor_id());
 
 	for_each_set_bit(irqn, &irqmap, BITS_PER_LONG) {
+		irqsrc = readl_relaxed(main_int_base +
+				       ARMADA_370_XP_INT_SOURCE_CTL(irqn));
+
+		/* Check if the interrupt is not masked on current CPU.
+		 * Test IRQ (0-1) and FIQ (8-9) mask bits.
+		 */
+		if (!(irqsrc & ARMADA_370_XP_INT_IRQ_FIQ_MASK(cpuid)))
+			continue;
+
+		if (irqn == 1) {
+			armada_370_xp_handle_msi_irq(NULL, true);
+			continue;
+		}
+
 		cascade_irq = irq_find_mapping(armada_370_xp_mpic_domain, irqn);
 		generic_handle_irq(cascade_irq);
 	}
