Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966123AbaFSVfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:35:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:55713 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965938AbaFSVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:44 -0400
Message-Id: <20140619212713.662897061@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 10/13] irqchip: spear_shirq: Simplify chained handler
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-kill-loop-nonsense.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if there are less efficient ways to code that. Get rid of
the loop mess and use efficient code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -224,23 +224,20 @@ static void shirq_handler(unsigned irq,
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
 	struct irq_data *idata = irq_desc_get_irq_data(desc);
 	struct irq_chip *chip = irq_data_get_irq_chip(idata);
-	u32 i, j, val, mask;
+	u32 pend;
 
 	chip->irq_ack(idata);
 
-	mask = shirq->mask;
-	while ((val = readl(shirq->base + shirq->regs.status_reg) &
-				mask)) {
+	pend = readl(shirq->base + shirq->regs.status_reg) & shirq->mask;
+	pend >>= shirq->offset;
 
-		val >>= shirq->offset;
-		for (i = 0, j = 1; i < shirq->nr_irqs; i++, j <<= 1) {
+	while (pend) {
+		int irq = __ffs(pend);
 
-			if (!(j & val))
-				continue;
-
-			generic_handle_irq(shirq->virq_base + i);
-		}
+		pend &= ~(0x1 << irq);
+		generic_handle_irq(shirq->virq_base + irq);
 	}
+
 	chip->irq_unmask(idata);
 }
 


