Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaKBBHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:07:00 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62105 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaKBBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:04:59 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
Cc: linux-sh@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V3 08/14] irqchip: bcm7120-l2: Make sure all register accesses use base+offset
Date: Sat,  1 Nov 2014 18:03:55 -0700
Message-Id: <1414890241-9938-9-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
References: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of accesses to IRQEN (base+0x00) just used "base" directly, so
they would break if IRQEN ever became nonzero.  Make sure that all
reads/writes specify the register offset constant.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 7086fe0..22d3fa1 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -66,10 +66,10 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	/* Save the current mask and the interrupt forward mask */
-	b->saved_mask = __raw_readl(b->base) | b->irq_fwd_mask;
+	b->saved_mask = __raw_readl(b->base + IRQEN) | b->irq_fwd_mask;
 	if (b->can_wake) {
 		reg = b->saved_mask | gc->wake_active;
-		__raw_writel(reg, b->base);
+		__raw_writel(reg, b->base + IRQEN);
 	}
 	irq_gc_unlock(gc);
 }
@@ -81,7 +81,7 @@ static void bcm7120_l2_intc_resume(struct irq_data *d)
 
 	/* Restore the saved mask */
 	irq_gc_lock(gc);
-	__raw_writel(b->saved_mask, b->base);
+	__raw_writel(b->saved_mask, b->base + IRQEN);
 	irq_gc_unlock(gc);
 }
 
-- 
2.1.1

