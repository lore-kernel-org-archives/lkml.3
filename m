Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbaKSWvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:51:50 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35251 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbaKSWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:51:46 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Linus Walleij <linus.walleij@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] pinctrl: rockchip: Fix enable/disable/mask/unmask
Date: Wed, 19 Nov 2014 14:51:33 -0800
Message-Id: <1416437493-25588-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416437493-25588-1-git-send-email-dianders@chromium.org>
References: <1416437493-25588-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip pinctrl driver was only implementing the "mask" and
"unmask" operations though the hardware actually has two distinct
things: enable/disable and mask/unmask.  It was implementing the
"mask" operations as a hardware enable/disable and always leaving all
interrupts unmasked.

I believe that the old system had some downsides, specifically:
- (Untested) if an interrupt went off while interrupts were "masked"
  it would be lost.  Now it will be kept track of.
- If someone wanted to change an interrupt back into a GPIO (is such a
  thing sensible?) by calling irq_disable() it wouldn't actually take
  effect.  That's because Linux does some extra optimizations when
  there's no true "disable" function: it does a lazy mask.

Let's actually implement enable/disable/mask/unmask properly.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
Changes in v2:
- Spread out code (heiko)

 drivers/pinctrl/pinctrl-rockchip.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index e91e845..3c22dbe 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1562,6 +1562,34 @@ static void rockchip_irq_resume(struct irq_data *d)
 	irq_reg_writel(gc, bank->saved_enables, GPIO_INTEN);
 }
 
+static void rockchip_irq_disable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	u32 val;
+
+	irq_gc_lock(gc);
+
+	val = irq_reg_readl(gc, GPIO_INTEN);
+	val &= ~d->mask;
+	irq_reg_writel(gc, val, GPIO_INTEN);
+
+	irq_gc_unlock(gc);
+}
+
+static void rockchip_irq_enable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	u32 val;
+
+	irq_gc_lock(gc);
+
+	val = irq_reg_readl(gc, GPIO_INTEN);
+	val |= d->mask;
+	irq_reg_writel(gc, val, GPIO_INTEN);
+
+	irq_gc_unlock(gc);
+}
+
 static int rockchip_interrupts_register(struct platform_device *pdev,
 						struct rockchip_pinctrl *info)
 {
@@ -1600,11 +1628,13 @@ static int rockchip_interrupts_register(struct platform_device *pdev,
 		gc = irq_get_domain_generic_chip(bank->domain, 0);
 		gc->reg_base = bank->reg_base;
 		gc->private = bank;
-		gc->chip_types[0].regs.mask = GPIO_INTEN;
+		gc->chip_types[0].regs.mask = GPIO_INTMASK;
 		gc->chip_types[0].regs.ack = GPIO_PORTS_EOI;
 		gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
-		gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
-		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+		gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
+		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
+		gc->chip_types[0].chip.irq_enable = rockchip_irq_enable;
+		gc->chip_types[0].chip.irq_disable = rockchip_irq_disable;
 		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
 		gc->chip_types[0].chip.irq_suspend = rockchip_irq_suspend;
 		gc->chip_types[0].chip.irq_resume = rockchip_irq_resume;
-- 
2.1.0.rc2.206.gedb03e5

