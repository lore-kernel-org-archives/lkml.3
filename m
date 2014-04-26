Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaDZTed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 15:34:33 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63069 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaDZTea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 15:34:30 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 3/3] irqchip: orion: reverse irq handling priority
Date: Sat, 26 Apr 2014 21:34:15 +0200
Message-Id: <1398540855-27367-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398540855-27367-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398540855-27367-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-DT irq handlers were working through irq causes from most-significant
to least-significant bit, while DT irqchip driver does it the other way
round. This revealed some more HW issues on Kirkwood peripheral IP, where
spurious sdio irqs can happen although IP's irq enable registers are all
zero. Although, not directly related with the described issue, reverse
irq bit handling back to original order by replacing ffs() with fls().

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
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

