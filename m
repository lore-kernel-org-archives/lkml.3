Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964AbaFSVeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:34:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:55694 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965908AbaFSVem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:42 -0400
Message-Id: <20140619212713.404243909@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 07/13] irqchip: spear_shirq: Use the proper interfaces
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-use-proper-interfaces.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in doing a full irq lookup, when the desc pointer is
available.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -232,12 +232,12 @@ static struct irq_chip shirq_chip = {
 
 static void shirq_handler(unsigned irq, struct irq_desc *desc)
 {
-	u32 i, j, val, mask, tmp;
-	struct irq_chip *chip;
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
+	struct irq_data *idata = irq_desc_get_irq_data(desc);
+	struct irq_chip *chip = irq_data_get_irq_chip(idata);
+	u32 i, j, val, mask, tmp;
 
-	chip = irq_get_chip(irq);
-	chip->irq_ack(&desc->irq_data);
+	chip->irq_ack(idata);
 
 	mask = ((0x1 << shirq->nr_irqs) - 1) << shirq->offset;
 	while ((val = readl(shirq->base + shirq->regs.status_reg) &
@@ -263,7 +263,7 @@ static void shirq_handler(unsigned irq,
 			writel(tmp, shirq->base + shirq->regs.clear_reg);
 		}
 	}
-	chip->irq_unmask(&desc->irq_data);
+	chip->irq_unmask(idata);
 }
 
 static void __init spear_shirq_register(struct spear_shirq *shirq,


