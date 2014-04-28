Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbaD1VMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:12:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56347 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbaD1VMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:12:17 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] irqchip: orion: reverse irq handling priority
Date: Mon, 28 Apr 2014 23:12:08 +0200
Message-Id: <1398719528-23607-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398540855-27367-4-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398540855-27367-4-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-DT irq handlers were working through irq causes from most-significant
to least-significant bit, while DT irqchip driver does it the other way
round. This revealed some more HW issues on Kirkwood peripheral IP, where
spurious sdio irqs can happen although irqs are masked.

Also, the generated binaries show that original non-DT order compared
to DT order save two instructions for each bit count check:

irqchip DT order with ffs():
  60:   e3a06001        mov     r6, #1
  64:   e2643000        rsb     r3, r4, #0
  68:   e0033004        and     r3, r3, r4
  6c:   e16f3f13        clz     r3, r3
  70:   e263301f        rsb     r3, r3, #31
  74:   e1c44316        bic     r4, r4, r6, lsl r3
  78:   e5971004        ldr     r1, [r7, #4]

Original non-DT order with fls():
  60:   e3a07001        mov     r7, #1
  64:   e16f3f14        clz     r3, r4
  68:   e263301f        rsb     r3, r3, #31
  6c:   e1c44317        bic     r4, r4, r7, lsl r3
  70:   e5951004        ldr     r1, [r5, #4]

Therefore, reverse irq bit handling back to original order by replacing
ffs() with fls().

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
Changelog:
v1->v2:
- reword commit msg to state less number of instructions

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/irq-orion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index e25f246cd2fb..34d18b48bb78 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -42,7 +42,7 @@ __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
 		u32 stat = readl_relaxed(gc->reg_base + ORION_IRQ_CAUSE) &
 			gc->mask_cache;
 		while (stat) {
-			u32 hwirq = ffs(stat) - 1;
+			u32 hwirq = __fls(stat);
 			u32 irq = irq_find_mapping(orion_irq_domain,
 						   gc->irq_base + hwirq);
 			handle_IRQ(irq, regs);
@@ -117,7 +117,7 @@ static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 		   gc->mask_cache;
 
 	while (stat) {
-		u32 hwirq = ffs(stat) - 1;
+		u32 hwirq = __fls(stat);
 
 		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
 		stat &= ~(1 << hwirq);
-- 
1.9.1

