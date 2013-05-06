Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3EFMcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:32:33 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41614 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3EFMcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:32:31 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC patch 7/8] fixup 1/2: genirq: generic chip: Add linear irq domain support
Date: Mon,  6 May 2013 14:32:12 +0200
Message-Id: <1367843533-7117-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130503214629.810207749@linutronix.de>
References: <20130503214629.810207749@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain_chip_generic is allocating and indexing irq_chip_generic
itself. However, the size of irq_chip_generic varies with number of
irq_chip_types. This fixup moves irq_chip_generic helt by
irq_domain_chip_generic to array of ptr and fixes the pointer arith
used by irq_alloc_domain_generic_chip.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/irq.h       |    4 ++--
 kernel/irq/generic-chip.c |   20 +++++++++++++-------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7315155..fd2d7cb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -730,7 +730,7 @@ enum irq_gc_flags {
  * @irq_flags_to_set:	IRQ* flags to set on irq setup
  * @irq_flags_to_clear:	IRQ* flags to clear on irq setup
  * @gc_flags:		Generic chip specific setup flags
- * @gc:			Array of generic interrupt chips
+ * @gc:			Array of pointer to generic interrupt chips
  */
 struct irq_domain_chip_generic {
 	unsigned int		irqs_per_chip;
@@ -738,7 +738,7 @@ struct irq_domain_chip_generic {
 	unsigned int		irq_flags_to_clear;
 	unsigned int		irq_flags_to_set;
 	enum irq_gc_flags	gc_flags;
-	struct irq_chip_generic	gc[0];
+	struct irq_chip_generic	*gc[0];
 };
 
 /* Generic chip callback functions */
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index e212b26..3dbfe2e 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -247,6 +247,7 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	struct irq_chip_generic *gc;
 	int numchips, sz, i;
 	unsigned long flags;
+	void *p;
 
 	if (d->gc)
 		return -EBUSY;
@@ -260,9 +261,9 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 
 	sz = sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
 	sz *= numchips;
-	sz += sizeof(*dgc);
+	sz += sizeof(*dgc) + numchips * sizeof(void *);
 
-	dgc = kzalloc(sz, GFP_KERNEL);
+	p = dgc = kzalloc(sz, GFP_KERNEL);
 	if (!dgc)
 		return -ENOMEM;
 	dgc->irqs_per_chip = irqs_per_chip;
@@ -270,17 +271,22 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	dgc->irq_flags_to_set = set;
 	dgc->irq_flags_to_clear = clr;
 	dgc->gc_flags = gcflags;
-	gc = dgc->gc;
+	d->gc = dgc;
 
-	for (i = 0; i < numchips; i++, gc++) {
+	p += sizeof(*dgc) + numchips * sizeof(void *);
+	for (i = 0; i < numchips; i++) {
+		gc = (struct irq_chip_generic *)p;
+		dgc->gc[i] = gc;
 		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
 				      NULL, handler);
 		gc->domain = d;
+
 		raw_spin_lock_irqsave(&gc_lock, flags);
 		list_add_tail(&gc->list, &gc_list);
 		raw_spin_unlock_irqrestore(&gc_lock, flags);
+
+		p += sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
 	}
-	d->gc = dgc;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_alloc_domain_generic_chips);
@@ -301,7 +307,7 @@ irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq)
 	idx = hw_irq / dgc->irqs_per_chip;
 	if (idx >= dgc->num_chips)
 		return NULL;
-	return &dgc->gc[idx];
+	return dgc->gc[idx];
 }
 EXPORT_SYMBOL_GPL(irq_get_domain_generic_chip);
 
@@ -331,7 +337,7 @@ static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 	idx = hw_irq / dgc->irqs_per_chip;
 	if (idx >= dgc->num_chips)
 		return -EINVAL;
-	gc = &dgc->gc[idx];
+	gc = dgc->gc[idx];
 
 	idx = hw_irq % dgc->irqs_per_chip;
 
-- 
1.7.2.5

