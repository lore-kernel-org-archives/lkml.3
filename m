Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3KOOW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:22:57 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37107 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3KOOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:22:44 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] irqchip: orion: reverse irq handling priority
Date: Fri, 15 Nov 2013 15:22:32 +0100
Message-Id: <1384525354-901-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/irq-orion.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index e51d400..de30d5c 100644
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
@@ -116,7 +116,7 @@ static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 		   gc->mask_cache;
 
 	while (stat) {
-		u32 hwirq = ffs(stat) - 1;
+		u32 hwirq = __fls(stat);
 
 		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
 		stat &= ~(1 << hwirq);
-- 
1.7.2.5

