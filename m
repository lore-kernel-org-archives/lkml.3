Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaCETf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:35:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60241 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaCETf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:35:56 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: msm: drop wake_irqs bitmap
Date: Wed,  5 Mar 2014 13:33:08 -0600
Message-Id: <1394047988-14081-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the wake_irqs bitmap is used to track whether there are any
gpio's which are configured as wake irqs, and uses this to determine
whether or not to call enable_irq_wake()/disable_irq_wake() on the
summary interrupt.

However, the genirq core already handles this case, by maintaining a
'wake_count' per irq_desc, and only calling into the controlling
irq_chip when wake_count transitions 0 <-> 1.

Drop this bitmap, and unconditionally call irq_set_irq_wake() on the
summary interrupt.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/pinctrl/pinctrl-msm.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 2cfb1d4..9b6b3a7 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -50,7 +50,6 @@
  * @enabled_irqs:   Bitmap of currently enabled irqs.
  * @dual_edge_irqs: Bitmap of irqs that need sw emulated dual edge
  *                  detection.
- * @wake_irqs:      Bitmap of irqs with requested as wakeup source.
  * @soc;            Reference to soc_data of platform specific data.
  * @regs:           Base address for the TLMM register map.
  */
@@ -65,7 +64,6 @@ struct msm_pinctrl {
 
 	DECLARE_BITMAP(dual_edge_irqs, MAX_NR_GPIO);
 	DECLARE_BITMAP(enabled_irqs, MAX_NR_GPIO);
-	DECLARE_BITMAP(wake_irqs, MAX_NR_GPIO);
 
 	const struct msm_pinctrl_soc_data *soc;
 	void __iomem *regs;
@@ -810,22 +808,12 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct msm_pinctrl *pctrl;
 	unsigned long flags;
-	unsigned ngpio;
 
 	pctrl = irq_data_get_irq_chip_data(d);
-	ngpio = pctrl->chip.ngpio;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
-	if (on) {
-		if (bitmap_empty(pctrl->wake_irqs, ngpio))
-			enable_irq_wake(pctrl->irq);
-		set_bit(d->hwirq, pctrl->wake_irqs);
-	} else {
-		clear_bit(d->hwirq, pctrl->wake_irqs);
-		if (bitmap_empty(pctrl->wake_irqs, ngpio))
-			disable_irq_wake(pctrl->irq);
-	}
+	irq_set_irq_wake(pctrl->irq, on);
 
 	spin_unlock_irqrestore(&pctrl->lock, flags);
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

