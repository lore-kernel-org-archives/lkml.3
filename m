Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966093AbaFSVfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:35:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:55719 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965966AbaFSVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:44 -0400
Message-Id: <20140619212713.754300980@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 11/13] irqchip: spear_shirq: Remove the parent irq "ack"/unmask
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=spear-shirq-kill-vic-ack-unmask-hackery.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ack" is actually a mask in the parent irq. The demultiplexer and the
handlers run with interrupts disabled. No point in masking and
unmasking the parent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -222,12 +222,8 @@ static struct irq_chip shirq_chip = {
 static void shirq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
-	struct irq_data *idata = irq_desc_get_irq_data(desc);
-	struct irq_chip *chip = irq_data_get_irq_chip(idata);
 	u32 pend;
 
-	chip->irq_ack(idata);
-
 	pend = readl(shirq->base + shirq->regs.status_reg) & shirq->mask;
 	pend >>= shirq->offset;
 
@@ -237,8 +233,6 @@ static void shirq_handler(unsigned irq,
 		pend &= ~(0x1 << irq);
 		generic_handle_irq(shirq->virq_base + irq);
 	}
-
-	chip->irq_unmask(idata);
 }
 
 static void __init spear_shirq_register(struct spear_shirq *shirq,


