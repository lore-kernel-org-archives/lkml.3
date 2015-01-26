Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbbAZQY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:24:26 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36862 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbbAZQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:24:21 -0500
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: rockchip: Only mask interrupts; never disable
Date: Mon, 26 Jan 2015 08:24:03 -0800
Message-Id: <1422289444-15142-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip GPIO interrupt controller totally throws away all status
about an interrupt when you "disable" the interrupt.  That has
unfortunate consequences in the following situation:

1. An edge-triggered interrupt is enabled and should wake the system.
2. System suspend happens: interrupt is disabled and marked for wake.
3. rockchip_irq_suspend() reenables the interrupt so we can wake.
4. Interrupt happens when asleep.
5. rockchip_irq_resume() redisables the interrupt.
6. Disabling the interrupt throws away all status about it.
7. Normal system resume happens and we enable the interrupt again,
   since we threw away status about the interrupt we don't know it
   fired while suspended.  Even worse: if we need both edges of the
   interrupt the logic to swap edges never runs.

Note: even if we somehow can post the status about wakeup interrupts
in rockchip_irq_resume() we would still have a window of losing any
edges that came in while interrupts were disabled.

If we use mask only then we don't need to worry.  The GPIO Interrupt
controller keeps track of pending interrupts that are enabled and just
masked.

There was no real strong reason to support the enable/disable
functionality (other than that it seemed right), so let's go back to
just supporting mask/unmask but actually map it to the real
mask/unmask.  This ends up with slightly different (and more correct)
behavior than before (f2dd028 pinctrl: rockchip: Fix
enable/disable/mask/unmask).

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 48 +++++++++++---------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index d144330..dee7d5f 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -89,7 +89,7 @@ struct rockchip_iomux {
  * @reg_pull: optional separate register for additional pull settings
  * @clk: clock of the gpio bank
  * @irq: interrupt of the gpio bank
- * @saved_enables: Saved content of GPIO_INTEN at suspend time.
+ * @saved_masks: Saved content of GPIO_INTEN at suspend time.
  * @pin_base: first pin number
  * @nr_pins: number of pins in this bank
  * @name: name of the bank
@@ -108,7 +108,7 @@ struct rockchip_pin_bank {
 	struct regmap			*regmap_pull;
 	struct clk			*clk;
 	int				irq;
-	u32				saved_enables;
+	u32				saved_masks;
 	u32				pin_base;
 	u8				nr_pins;
 	char				*name;
@@ -1545,8 +1545,8 @@ static void rockchip_irq_suspend(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct rockchip_pin_bank *bank = gc->private;
 
-	bank->saved_enables = irq_reg_readl(gc, GPIO_INTEN);
-	irq_reg_writel(gc, gc->wake_active, GPIO_INTEN);
+	bank->saved_masks = irq_reg_readl(gc, GPIO_INTMASK);
+	irq_reg_writel(gc, ~gc->wake_active, GPIO_INTMASK);
 }
 
 static void rockchip_irq_resume(struct irq_data *d)
@@ -1554,35 +1554,7 @@ static void rockchip_irq_resume(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct rockchip_pin_bank *bank = gc->private;
 
-	irq_reg_writel(gc, bank->saved_enables, GPIO_INTEN);
-}
-
-static void rockchip_irq_disable(struct irq_data *d)
-{
-	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 val;
-
-	irq_gc_lock(gc);
-
-	val = irq_reg_readl(gc, GPIO_INTEN);
-	val &= ~d->mask;
-	irq_reg_writel(gc, val, GPIO_INTEN);
-
-	irq_gc_unlock(gc);
-}
-
-static void rockchip_irq_enable(struct irq_data *d)
-{
-	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 val;
-
-	irq_gc_lock(gc);
-
-	val = irq_reg_readl(gc, GPIO_INTEN);
-	val |= d->mask;
-	irq_reg_writel(gc, val, GPIO_INTEN);
-
-	irq_gc_unlock(gc);
+	irq_reg_writel(gc, bank->saved_masks, GPIO_INTMASK);
 }
 
 static int rockchip_interrupts_register(struct platform_device *pdev,
@@ -1620,6 +1592,14 @@ static int rockchip_interrupts_register(struct platform_device *pdev,
 			continue;
 		}
 
+		/*
+		 * Linux assumes that all interrupts start out disabled/masked.
+		 * Our driver only uses the concept of masked and always keeps
+		 * things enabled, so for us that's all masked and all enabled.
+		 */
+		writel_relaxed(0xffffffff, bank->reg_base + GPIO_INTMASK);
+		writel_relaxed(0xffffffff, bank->reg_base + GPIO_INTEN);
+
 		gc = irq_get_domain_generic_chip(bank->domain, 0);
 		gc->reg_base = bank->reg_base;
 		gc->private = bank;
@@ -1628,8 +1608,6 @@ static int rockchip_interrupts_register(struct platform_device *pdev,
 		gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
 		gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
 		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
-		gc->chip_types[0].chip.irq_enable = rockchip_irq_enable;
-		gc->chip_types[0].chip.irq_disable = rockchip_irq_disable;
 		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
 		gc->chip_types[0].chip.irq_suspend = rockchip_irq_suspend;
 		gc->chip_types[0].chip.irq_resume = rockchip_irq_resume;
-- 
2.2.0.rc0.207.ga3a616c

