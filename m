Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaJ3CWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:22:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63950 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbaJ3CTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:19:51 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 08/15] irqchip: bcm7120-l2: Eliminate bad IRQ check
Date: Wed, 29 Oct 2014 19:18:01 -0700
Message-Id: <1414635488-14137-9-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check may be prone to race conditions, e.g.

1) Some external event (e.g. GPIO level) causes an IRQ to become pending
2) Peripheral asserts the L2 IRQ
3) CPU takes an interrupt
4) The event from #1 goes away
5) bcm7120_l2_intc_irq_handle() reads back a 0 status

Unlike the hardware supported by brcmstb-l2, the bcm7120-l2 controller
does not latch the IRQ status.  Bits can change if the inputs to the
controller change.  Also, do_bad_IRQ() is an ARM-specific macro.

So let's just nuke it.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index b9f4fb8..49d8f3d 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -27,8 +27,6 @@
 
 #include "irqchip.h"
 
-#include <asm/mach/irq.h>
-
 /* Register offset in the L2 interrupt controller */
 #define IRQEN		0x00
 #define IRQSTAT		0x04
@@ -51,19 +49,12 @@ static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 
 	status = __raw_readl(b->base + IRQSTAT);
-
-	if (status == 0) {
-		do_bad_IRQ(irq, desc);
-		goto out;
-	}
-
 	do {
 		irq = ffs(status) - 1;
 		status &= ~(1 << irq);
 		generic_handle_irq(irq_find_mapping(b->domain, irq));
 	} while (status);
 
-out:
 	chained_irq_exit(chip, desc);
 }
 
-- 
2.1.1

