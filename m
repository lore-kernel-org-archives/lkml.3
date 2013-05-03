Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab3ECVu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:50:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:47103 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938Ab3ECVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:50:54 -0400
Message-Id: <20130503214629.741399680@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 03 May 2013 21:50:52 -0000
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
Subject: [RFC patch 6/8] genirq: Split out code in generic chip
References: <alpine.LFD.2.02.1305031514230.2886@ionos>
 <20130503212258.385818955@linutronix.de>
Content-Disposition: inline; filename=genirq-generic-chip-split-out-code.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for linear interrupt domains.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -186,6 +186,19 @@ int irq_gc_set_wake(struct irq_data *d, 
 	return 0;
 }
 
+static void
+irq_init_generic_chip(struct irq_chip_generic *gc, const char *name,
+		      int num_ct, unsigned int irq_base,
+		      void __iomem *reg_base, irq_flow_handler_t handler)
+{
+	raw_spin_lock_init(&gc->lock);
+	gc->num_ct = num_ct;
+	gc->irq_base = irq_base;
+	gc->reg_base = reg_base;
+	gc->chip_types->chip.name = name;
+	gc->chip_types->handler = handler;
+}
+
 /**
  * irq_alloc_generic_chip - Allocate a generic chip and initialize it
  * @name:	Name of the irq chip
@@ -206,12 +219,8 @@ irq_alloc_generic_chip(const char *name,
 
 	gc = kzalloc(sz, GFP_KERNEL);
 	if (gc) {
-		raw_spin_lock_init(&gc->lock);
-		gc->num_ct = num_ct;
-		gc->irq_base = irq_base;
-		gc->reg_base = reg_base;
-		gc->chip_types->chip.name = name;
-		gc->chip_types->handler = handler;
+		irq_init_generic_chip(gc, name, num_ct, irq_base, reg_base,
+				      handler);
 	}
 	return gc;
 }


