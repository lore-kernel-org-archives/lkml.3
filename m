Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355Ab3E2JSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:18:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965261Ab3E2JSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:18:10 -0400
Date: Wed, 29 May 2013 02:17:16 -0700
From: tip-bot for Gerlando Falauto <tipbot@zytor.com>
Message-ID: <tip-af80b0fed67261dcba2ce2406db1d553d07cbe75@git.kernel.org>
Cc: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, Holger.Brunck@keymile.com,
        thomas.petazzoni@free-electrons.com, kernel@wantstofly.org,
        linux@arm.linux.org.uk, simon@sequanux.org,
        ezequiel.garcia@free-electrons.com, tglx@linutronix.de,
        joravec@drewtech.com, maxime.ripard@free-electrons.com,
        rob@landley.net, nico@fluxnic.net, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, hpa@zytor.com, grant.likely@linaro.org,
        jason@lakedaemon.net, gerlando.falauto@keymile.com,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com,
        rob.herring@calxeda.com, andrew@lunn.ch
Reply-To: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, Holger.Brunck@keymile.com,
        thomas.petazzoni@free-electrons.com, kernel@wantstofly.org,
        linux@arm.linux.org.uk, joravec@drewtech.com, tglx@linutronix.de,
        ezequiel.garcia@free-electrons.com, simon@sequanux.org,
        maxime.ripard@free-electrons.com, nico@fluxnic.net, rob@landley.net,
        jason@lakedaemon.net, grant.likely@linaro.org, hpa@zytor.com,
        ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        gerlando.falauto@keymile.com, rob.herring@calxeda.com,
        sebastian.hesselbarth@gmail.com, gregory.clement@free-electrons.com,
        andrew@lunn.ch
In-Reply-To: <20130506142539.152569748@linutronix.de>
References: <20130506142539.152569748@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Generic chip:
  Handle separate mask registers
Git-Commit-ID: af80b0fed67261dcba2ce2406db1d553d07cbe75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af80b0fed67261dcba2ce2406db1d553d07cbe75
Gitweb:     http://git.kernel.org/tip/af80b0fed67261dcba2ce2406db1d553d07cbe75
Author:     Gerlando Falauto <gerlando.falauto@keymile.com>
AuthorDate: Mon, 6 May 2013 14:30:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 10:57:10 +0200

genirq: Generic chip: Handle separate mask registers

There are cases where all irq_chip_type instances have separate mask
registers, making a shared mask register cache unsuitable for the
purpose.

Introduce a new flag IRQ_GC_MASK_CACHE_PER_TYPE. If set, point the per
chip mask pointer to the per chip private mask cache instead.

[ tglx: Simplified code, renamed flag and massaged changelog ]

Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Joey Oravec <joravec@drewtech.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Holger Brunck <Holger.Brunck@keymile.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Simon Guinot <simon@sequanux.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Rob Landley <rob@landley.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Link: http://lkml.kernel.org/r/20130506142539.152569748@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |  2 ++
 kernel/irq/generic-chip.c | 17 ++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 38709a3..7f1f015 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
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
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 113d9eb..da2a941 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -241,18 +241,21 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
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
