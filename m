Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3EFMcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:32:35 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:38105 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3EFMcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:32:32 -0400
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
Subject: [RFC patch 7/8] fixup 2/2: genirq: generic chip: Add linear irq domain support
Date: Mon,  6 May 2013 14:32:13 +0200
Message-Id: <1367843533-7117-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367843533-7117-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20130503214629.810207749@linutronix.de>
 <1367843533-7117-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mask_cache pointer also needs to be initialized for domain generic
chips.

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
 kernel/irq/generic-chip.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 3dbfe2e..3e0312f 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -275,12 +275,22 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 
 	p += sizeof(*dgc) + numchips * sizeof(void *);
 	for (i = 0; i < numchips; i++) {
+		int k;
+
 		gc = (struct irq_chip_generic *)p;
 		dgc->gc[i] = gc;
 		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
 				      NULL, handler);
 		gc->domain = d;
 
+		for (k = 0; k < gc->num_ct; k++) {
+			struct irq_chip_type *ct = &gc->chip_types[k];
+			if (gcflags & IRQ_GC_MASK_CACHE_PER_TYPE)
+				ct->mask_cache = &ct->mask_cache_priv;
+			else
+				ct->mask_cache = &gc->mask_cache;
+		}
+
 		raw_spin_lock_irqsave(&gc_lock, flags);
 		list_add_tail(&gc->list, &gc_list);
 		raw_spin_unlock_irqrestore(&gc_lock, flags);
-- 
1.7.2.5

