Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966240AbaFSVhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:37:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:55673 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965816AbaFSVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:40 -0400
Message-Id: <20140619212713.129694036@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 04/13] irqchip: spear_shirq: No point in storing the parent irq
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=spear-shirq-get-irq-of-misnomed-irq-member.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct member is pointless and a nismomer as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -47,7 +47,6 @@ struct shirq_regs {
 /*
  * struct spear_shirq: shared irq structure
  *
- * irq: hardware irq number
  * irq_base: base irq in linux domain
  * irq_nr: no. of shared interrupts in a particular block
  * irq_bit_off: starting bit offset in the status register
@@ -56,7 +55,6 @@ struct shirq_regs {
  * regs: register configuration for shared irq block
  */
 struct spear_shirq {
-	u32 irq;
 	u32 irq_base;
 	u32 irq_nr;
 	u32 irq_bit_off;
@@ -268,28 +266,29 @@ static void shirq_handler(unsigned irq,
 	chip->irq_unmask(&desc->irq_data);
 }
 
-static void __init spear_shirq_register(struct spear_shirq *shirq)
+static void __init spear_shirq_register(struct spear_shirq *shirq,
+					int parent_irq)
 {
 	int i;
 
 	if (shirq->invalid_irq)
 		return;
 
-	irq_set_chained_handler(shirq->irq, shirq_handler);
+	irq_set_chained_handler(parent_irq, shirq_handler);
+	irq_set_handler_data(parent_irq, shirq);
+
 	for (i = 0; i < shirq->irq_nr; i++) {
 		irq_set_chip_and_handler(shirq->irq_base + i,
 					 &shirq_chip, handle_simple_irq);
 		set_irq_flags(shirq->irq_base + i, IRQF_VALID);
 		irq_set_chip_data(shirq->irq_base + i, shirq);
 	}
-
-	irq_set_handler_data(shirq->irq, shirq);
 }
 
 static int __init shirq_init(struct spear_shirq **shirq_blocks, int block_nr,
 		struct device_node *np)
 {
-	int i, irq_base, hwirq = 0, irq_nr = 0;
+	int i, parent_irq, irq_base, hwirq = 0, irq_nr = 0;
 	struct irq_domain *shirq_domain;
 	void __iomem *base;
 
@@ -319,9 +318,9 @@ static int __init shirq_init(struct spea
 		shirq_blocks[i]->base = base;
 		shirq_blocks[i]->irq_base = irq_find_mapping(shirq_domain,
 				hwirq);
-		shirq_blocks[i]->irq = irq_of_parse_and_map(np, i);
 
-		spear_shirq_register(shirq_blocks[i]);
+		parent_irq = irq_of_parse_and_map(np, i);
+		spear_shirq_register(shirq_blocks[i], parent_irq);
 		hwirq += shirq_blocks[i]->irq_nr;
 	}
 


