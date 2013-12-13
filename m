Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3LMNgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:36:04 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46637 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3LMNgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:36:02 -0500
Message-ID: <1386941755.17095.2.camel@phoenix>
Subject: [RFT][PATCH] pinctrl: msm: Fix set gpio setting
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Dec 2013 21:35:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set g->out_bit bit for gpio output high, clear g->out_bit bit for gpio output
low.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Bjorn,
I don't have the datasheet, just found current code does not make sense
because current code unconditionally set BIT(g->out_bit) in msm_gpio_set.
I assume setting g->out_bit bit for gpio output high, clear the bit
for gpio output low.
Please check if this patch is correct.

Thanks,
Axel

 drivers/pinctrl/pinctrl-msm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 28b90ab..4537d0d 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -435,7 +435,12 @@ static int msm_gpio_direction_output(struct gpio_chip *chip, unsigned offset, in
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
-	writel(value ? BIT(g->out_bit) : 0, pctrl->regs + g->io_reg);
+	val = readl(pctrl->regs + g->io_reg);
+	if (value)
+		val |= BIT(g->out_bit);
+	else
+		val &= ~BIT(g->out_bit);
+	writel(val, pctrl->regs + g->io_reg);
 
 	val = readl(pctrl->regs + g->ctl_reg);
 	val |= BIT(g->oe_bit);
@@ -476,7 +481,10 @@ static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	spin_lock_irqsave(&pctrl->lock, flags);
 
 	val = readl(pctrl->regs + g->io_reg);
-	val |= BIT(g->out_bit);
+	if (value)
+		val |= BIT(g->out_bit);
+	else
+		val &= ~BIT(g->out_bit);
 	writel(val, pctrl->regs + g->io_reg);
 
 	spin_unlock_irqrestore(&pctrl->lock, flags);
-- 
1.8.1.2



