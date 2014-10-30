Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbaJ3CTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:19:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50720 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbaJ3CTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:19:44 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 04/15] genirq: Generic chip: Change irq_reg_{readl,writel} arguments
Date: Wed, 29 Oct 2014 19:17:57 -0700
Message-Id: <1414635488-14137-5-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of taking a raw register virtual address, we will take an
irq_chip_generic struct and a register offset.  This makes it possible to
implement different behavior on different irqchips.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 kernel/irq/generic-chip.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 380595f..b2ee65d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -17,14 +17,16 @@
 static LIST_HEAD(gc_list);
 static DEFINE_RAW_SPINLOCK(gc_lock);
 
-static void irq_reg_writel(u32 val, void __iomem *addr)
+static void irq_reg_writel(struct irq_chip_generic *gc,
+			   u32 val, int reg_offset)
 {
-	writel(val, addr);
+	writel(val, gc->reg_base + reg_offset);
 }
 
-static u32 irq_reg_readl(void __iomem *addr)
+static u32 irq_reg_readl(struct irq_chip_generic *gc,
+			 int reg_offset)
 {
-	return readl(addr);
+	return readl(gc->reg_base + reg_offset);
 }
 
 /**
@@ -49,7 +51,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
+	irq_reg_writel(gc, mask, ct->regs.disable);
 	*ct->mask_cache &= ~mask;
 	irq_gc_unlock(gc);
 }
@@ -69,7 +71,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	*ct->mask_cache |= mask;
-	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(gc, *ct->mask_cache, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 EXPORT_SYMBOL_GPL(irq_gc_mask_set_bit);
@@ -89,7 +91,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	*ct->mask_cache &= ~mask;
-	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(gc, *ct->mask_cache, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 EXPORT_SYMBOL_GPL(irq_gc_mask_clr_bit);
@@ -108,7 +110,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
+	irq_reg_writel(gc, mask, ct->regs.enable);
 	*ct->mask_cache |= mask;
 	irq_gc_unlock(gc);
 }
@@ -124,7 +126,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
+	irq_reg_writel(gc, mask, ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 EXPORT_SYMBOL_GPL(irq_gc_ack_set_bit);
@@ -140,7 +142,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 	u32 mask = ~d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
+	irq_reg_writel(gc, mask, ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -155,8 +157,8 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.mask);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
+	irq_reg_writel(gc, mask, ct->regs.mask);
+	irq_reg_writel(gc, mask, ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -171,7 +173,7 @@ void irq_gc_eoi(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.eoi);
+	irq_reg_writel(gc, mask, ct->regs.eoi);
 	irq_gc_unlock(gc);
 }
 
@@ -255,7 +257,7 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
 		}
 		ct[i].mask_cache = mskptr;
 		if (flags & IRQ_GC_INIT_MASK_CACHE)
-			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
+			*mskptr = irq_reg_readl(gc, mskreg);
 	}
 }
 
-- 
2.1.1

