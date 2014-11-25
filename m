Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaKYMGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:06:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaKYKkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grzegorz Jaszczyk <jaz@semihalf.com>, Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 011/254] irqchip: armada-370-xp: Fix MPIC interrupt handling
Date: Tue, 25 Nov 2014 10:36:01 +0000
Message-Id: <1416912004-5928-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Jaszczyk <jaz@semihalf.com>

commit 758e8366754d3fa57da978fef9d2c652f7b55c02 upstream.

In both Armada-375 and Armada-38x MPIC interrupts should be identified by
reading cause register multiplied by the interrupt mask.

A lack of above mentioned multiplication resulted in a bug, caused by the
fact that in Armada-375 and Armada-38x some of the interrupts
(e.g. network interrupts) can be handled either as a GIC or MPIC interrupts.
Therefore during MPIC interrupts handling, cause register shows hits from
interrupts even if they are masked for MPIC but unmasked for a GIC.

This resulted in 'bad IRQ' error, because masked MPIC interrupt without
registered interrupt handler, was trying to be handled during interrupt
handling procedure of some other unmasked MPIC interrupt (e.g. local timer
irq).

This commit fixes that by ensuring that during MPIC interrupt handling only
interrupts that are unmasked for MPIC are processed.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Fixes: bc69b8adfe22 ("irqchip: armada-370-xp: Setup a chained handler for the MPIC")
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Link: https://lkml.kernel.org/r/1411643839-64925-3-git-send-email-jaz@semihalf.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 91424c481782..1cb538fd85e9 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -43,6 +43,7 @@
 #define ARMADA_370_XP_INT_CLEAR_ENABLE_OFFS	(0x34)
 #define ARMADA_370_XP_INT_SOURCE_CTL(irq)	(0x100 + irq*4)
 #define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
+#define ARMADA_370_XP_INT_IRQ_FIQ_MASK(cpuid)	((BIT(0) | BIT(8)) << cpuid)
 
 #define ARMADA_370_XP_CPU_INTACK_OFFS		(0x44)
 #define ARMADA_375_PPI_CAUSE			(0x10)
@@ -410,19 +411,29 @@ static void armada_370_xp_mpic_handle_cascade_irq(unsigned int irq,
 						  struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_get_chip(irq);
-	unsigned long irqmap, irqn;
+	unsigned long irqmap, irqn, irqsrc, cpuid;
 	unsigned int cascade_irq;
 
 	chained_irq_enter(chip, desc);
 
 	irqmap = readl_relaxed(per_cpu_int_base + ARMADA_375_PPI_CAUSE);
-
-	if (irqmap & BIT(1)) {
-		armada_370_xp_handle_msi_irq(NULL, true);
-		irqmap &= ~BIT(1);
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
-- 
2.1.0

