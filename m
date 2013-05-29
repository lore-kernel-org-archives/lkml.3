Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab3E2JUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:20:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965304Ab3E2JUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:20:31 -0400
Date: Wed, 29 May 2013 02:19:49 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d0051816e619f8f082582bec07ffa51bdb4f2104@git.kernel.org>
Cc: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, thomas.petazzoni@free-electrons.com,
        linux@arm.linux.org.uk, ezequiel.garcia@free-electrons.com,
        tglx@linutronix.de, maxime.ripard@free-electrons.com, rob@landley.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jason@lakedaemon.net,
        grant.likely@linaro.org, gerlando.falauto@keymile.com,
        sebastian.hesselbarth@gmail.com, rob.herring@calxeda.com,
        gregory.clement@free-electrons.com, andrew@lunn.ch
Reply-To: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, thomas.petazzoni@free-electrons.com,
        linux@arm.linux.org.uk, ezequiel.garcia@free-electrons.com,
        tglx@linutronix.de, maxime.ripard@free-electrons.com, rob@landley.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jason@lakedaemon.net,
        grant.likely@linaro.org, gerlando.falauto@keymile.com,
        gregory.clement@free-electrons.com, rob.herring@calxeda.com,
        sebastian.hesselbarth@gmail.com, andrew@lunn.ch
In-Reply-To: <20130506142539.302898834@linutronix.de>
References: <20130506142539.302898834@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: irqchip: Add a mask calculation function
Git-Commit-ID: d0051816e619f8f082582bec07ffa51bdb4f2104
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

Commit-ID:  d0051816e619f8f082582bec07ffa51bdb4f2104
Gitweb:     http://git.kernel.org/tip/d0051816e619f8f082582bec07ffa51bdb4f2104
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 6 May 2013 14:30:24 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 10:57:10 +0200

genirq: irqchip: Add a mask calculation function

Some chips have weird bit mask access patterns instead of the linear
you expect. Allow them to calculate the cached mask themself.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Rob Landley <rob@landley.net>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Link: http://lkml.kernel.org/r/20130506142539.302898834@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       | 3 +++
 kernel/irq/generic-chip.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index d5fc7f5..ab8169f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -296,6 +296,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
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
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 957155c..5068fe3 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -240,6 +240,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			    unsigned int set)
 {
 	struct irq_chip_type *ct = gc->chip_types;
+	struct irq_chip *chip = &ct->chip;
 	unsigned int i;
 	u32 *mskptr = &gc->mask_cache, mskreg = ct->regs.mask;
 
@@ -267,9 +268,12 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
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
