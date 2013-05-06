Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3EFOcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:32:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:52206 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3EFOaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:30:23 -0400
Message-Id: <20130506142539.152569748@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 06 May 2013 14:30:21 -0000
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
        linux-arm-kernel@lists.infradead.org,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Simon Guinot <simon@sequanux.org>, Joey Oravec <joravec@drewtech.com>,
        Ben Dooks <ben-linux@fluff.org>, Nicolas Pitre <nico@fluxnic.net>,
        Holger Brunck <Holger.Brunck@keymile.com>
Subject: [patch 3/8] genirq: generic chip: Handle separate mask registers
References: <20130503212258.385818955@linutronix.de>
 <20130506142348.321859745@linutronix.de>
Content-Disposition: inline;
 filename=genirq-handle-separate-mask-registers.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerlando Falauto <gerlando.falauto@keymile.com>

There are cases where all irq_chip_type instances have separate mask
registers, making a shared mask register cache unsuitable for the
purpose.

Introduce a new flag IRQ_GC_MASK_CACHE_PER_TYPE. If set, point the per
chip mask pointer to the per chip private mask cache instead.

[ tglx: Simplified code, renamed flag and massaged changelog ]

Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Simon Guinot <simon@sequanux.org>
Cc: Joey Oravec <joravec@drewtech.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Holger Brunck <Holger.Brunck@keymile.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |    2 ++
 kernel/irq/generic-chip.c |   17 ++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -704,10 +704,12 @@ struct irq_chip_generic {
  * @IRQ_GC_INIT_NESTED_LOCK:	Set the lock class of the irqs to nested for
  *				irq chips which need to call irq_set_wake() on
  *				the parent irq. Usually GPIO implementations
+ * @IRQ_GC_MASK_CACHE_PER_TYPE:	Mask cache is chip type private
  */
 enum irq_gc_flags {
 	IRQ_GC_INIT_MASK_CACHE		= 1 << 0,
 	IRQ_GC_INIT_NESTED_LOCK		= 1 << 1,
+	IRQ_GC_MASK_CACHE_PER_TYPE	= 1 << 2,
 };
 
 /* Generic chip callback functions */
Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -241,18 +241,21 @@ void irq_setup_generic_chip(struct irq_c
 {
 	struct irq_chip_type *ct = gc->chip_types;
 	unsigned int i;
+	u32 *mskptr = &gc->mask_cache, mskreg = ct->regs.mask;
 
 	raw_spin_lock(&gc_lock);
 	list_add_tail(&gc->list, &gc_list);
 	raw_spin_unlock(&gc_lock);
 
-	/* Init mask cache ? */
-	if (flags & IRQ_GC_INIT_MASK_CACHE)
-		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
-
-	/* Initialize mask cache pointer */
-	for (i = 0; i < gc->num_ct; i++)
-		ct[i].mask_cache = &gc->mask_cache;
+	for (i = 0; i < gc->num_ct; i++) {
+		if (flags & IRQ_GC_MASK_CACHE_PER_TYPE) {
+			mskptr = &ct[i].mask_cache_priv;
+			mskreg = ct[i].regs.mask;
+		}
+		ct[i].mask_cache = mskptr;
+		if (flags & IRQ_GC_INIT_MASK_CACHE)
+			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
+	}
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
 		if (!(msk & 0x01))


