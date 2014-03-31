Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaCaVuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:50:18 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19447 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbaCaVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:50:12 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/4] pinctrl: msm: Correct interrupt code for TLMM v2
Date: Mon, 31 Mar 2014 14:49:54 -0700
Message-ID: <1396302597-31801-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acking interrupts are done differently between on v2 and v3, so add an extra
attribute to the pingroup struct to let the platform definitions control this.
Also make sure to start dual edge detection by detecting the rising edge.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-msm.c | 6 +++++-
 drivers/pinctrl/pinctrl-msm.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 343f421..706809e 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -665,7 +665,10 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 	spin_lock_irqsave(&pctrl->lock, flags);
 
 	val = readl(pctrl->regs + g->intr_status_reg);
-	val &= ~BIT(g->intr_status_bit);
+	if (g->intr_ack_high)
+		val |= BIT(g->intr_status_bit);
+	else
+		val &= ~BIT(g->intr_status_bit);
 	writel(val, pctrl->regs + g->intr_status_reg);
 
 	if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
@@ -744,6 +747,7 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 			break;
 		case IRQ_TYPE_EDGE_BOTH:
 			val |= BIT(g->intr_detection_bit);
+			val |= BIT(g->intr_polarity_bit);
 			break;
 		case IRQ_TYPE_LEVEL_LOW:
 			break;
diff --git a/drivers/pinctrl/pinctrl-msm.h b/drivers/pinctrl/pinctrl-msm.h
index 8fbe9fb..6e26f1b 100644
--- a/drivers/pinctrl/pinctrl-msm.h
+++ b/drivers/pinctrl/pinctrl-msm.h
@@ -84,6 +84,7 @@ struct msm_pingroup {
 
 	unsigned intr_enable_bit:5;
 	unsigned intr_status_bit:5;
+	unsigned intr_ack_high:1;
 
 	unsigned intr_target_bit:5;
 	unsigned intr_raw_status_bit:5;
-- 
1.8.2.2

