Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3EFObf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:31:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:52231 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab3EFOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:30:26 -0400
Message-Id: <20130506142539.302898834@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 06 May 2013 14:30:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [patch 5/8] genirq: Add a mask calculation function
References: <20130503212258.385818955@linutronix.de>
 <20130506142348.321859745@linutronix.de>
Content-Disposition: inline;
 filename=genirq-generic-chip-add-mask-calculation-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chips have weird bit mask access patterns instead of the linear
you expect. Allow them to calculate the cached mask themself.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |    3 +++
 kernel/irq/generic-chip.c |    8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -296,6 +296,7 @@ static inline irq_hw_number_t irqd_to_hw
  * @irq_suspend:	function called from core code on suspend once per chip
  * @irq_resume:		function called from core code on resume once per chip
  * @irq_pm_shutdown:	function called from core code on shutdown once per chip
+ * @irq_calc_mask:	Optional function to set irq_data.mask for special cases
  * @irq_print_chip:	optional to print special chip info in show_interrupts
  * @flags:		chip specific flags
  */
@@ -327,6 +328,8 @@ struct irq_chip {
 	void		(*irq_resume)(struct irq_data *data);
 	void		(*irq_pm_shutdown)(struct irq_data *data);
 
+	void		(*irq_calc_mask)(struct irq_data *data);
+
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
 
 	unsigned long	flags;
Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -240,6 +240,7 @@ void irq_setup_generic_chip(struct irq_c
 			    unsigned int set)
 {
 	struct irq_chip_type *ct = gc->chip_types;
+	struct irq_chip *chip = &ct->chip;
 	unsigned int i;
 	u32 *mskptr = &gc->mask_cache, mskreg = ct->regs.mask;
 
@@ -267,9 +268,12 @@ void irq_setup_generic_chip(struct irq_c
 		if (!(flags & IRQ_GC_NO_MASK)) {
 			struct irq_data *d = irq_get_irq_data(i);
 
-			d->mask = 1 << (i - gc->irq_base);
+			if (chip->irq_calc_mask)
+				chip->irq_calc_mask(d);
+			else
+				d->mask = 1 << (i - gc->irq_base);
 		}
-		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
+		irq_set_chip_and_handler(i, chip, ct->handler);
 		irq_set_chip_data(i, gc);
 		irq_modify_status(i, clr, set);
 	}


