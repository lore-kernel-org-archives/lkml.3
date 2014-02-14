Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaBNBAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:10 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaBNA7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:08 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/27] clocksource: sh_cmt: Split channel setup to separate function
Date: Fri, 14 Feb 2014 01:59:41 +0100
Message-Id: <1392339605-20691-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the channel setup code from sh_cmt_setup to a new
sh_cmt_setup_channel function and call it from sh_cmt_setup.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 87 ++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 68cca0a..3a3cc83 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -695,12 +695,59 @@ static int sh_cmt_register(struct sh_cmt_channel *ch, char *name,
 	return 0;
 }
 
+static int sh_cmt_setup_channel(struct sh_cmt_channel *ch,
+				struct sh_cmt_device *cmt)
+{
+	struct sh_timer_config *cfg = cmt->pdev->dev.platform_data;
+	int irq;
+	int ret;
+
+	memset(ch, 0, sizeof(*ch));
+	ch->cmt = cmt;
+
+	/* Request irq using setup_irq() (too early for request_irq()). */
+	irq = platform_get_irq(cmt->pdev, 0);
+	if (irq < 0) {
+		dev_err(&cmt->pdev->dev, "failed to get irq\n");
+		return irq;
+	}
+
+	ch->irqaction.name = dev_name(&cmt->pdev->dev);
+	ch->irqaction.handler = sh_cmt_interrupt;
+	ch->irqaction.dev_id = ch;
+	ch->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
+
+	if (cmt->width == (sizeof(ch->max_match_value) * 8))
+		ch->max_match_value = ~0;
+	else
+		ch->max_match_value = (1 << cmt->width) - 1;
+
+	ch->match_value = ch->max_match_value;
+	raw_spin_lock_init(&ch->lock);
+
+	ret = sh_cmt_register(ch, (char *)dev_name(&cmt->pdev->dev),
+			      cfg->clockevent_rating,
+			      cfg->clocksource_rating);
+	if (ret) {
+		dev_err(&cmt->pdev->dev, "registration failed\n");
+		return ret;
+	}
+	ch->cs_enabled = false;
+
+	ret = setup_irq(irq, &ch->irqaction);
+	if (ret) {
+		dev_err(&cmt->pdev->dev, "failed to request irq %d\n", irq);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	struct sh_cmt_channel *ch = &cmt->channel;
 	struct resource *res, *res2;
-	int irq, ret;
+	int ret;
 	ret = -ENXIO;
 
 	memset(cmt, 0, sizeof(*cmt));
@@ -720,12 +767,6 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	/* optional resource for the shared timer start/stop register */
 	res2 = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 1);
 
-	irq = platform_get_irq(cmt->pdev, 0);
-	if (irq < 0) {
-		dev_err(&cmt->pdev->dev, "failed to get irq\n");
-		goto err0;
-	}
-
 	/* map memory, let mapbase point to our channel */
 	cmt->mapbase = ioremap_nocache(res->start, resource_size(res));
 	if (cmt->mapbase == NULL) {
@@ -742,12 +783,6 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		goto err1;
 	}
 
-	/* request irq using setup_irq() (too early for request_irq()) */
-	ch->irqaction.name = dev_name(&cmt->pdev->dev);
-	ch->irqaction.handler = sh_cmt_interrupt;
-	ch->irqaction.dev_id = ch;
-	ch->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
-
 	/* get hold of clock */
 	cmt->clk = clk_get(&cmt->pdev->dev, "cmt_fck");
 	if (IS_ERR(cmt->clk)) {
@@ -783,29 +818,9 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		cmt->clear_bits = ~0xc000;
 	}
 
-	if (cmt->width == (sizeof(ch->max_match_value) * 8))
-		ch->max_match_value = ~0;
-	else
-		ch->max_match_value = (1 << cmt->width) - 1;
-
-	ch->cmt = cmt;
-	ch->match_value = ch->max_match_value;
-	raw_spin_lock_init(&ch->lock);
-
-	ret = sh_cmt_register(ch, (char *)dev_name(&cmt->pdev->dev),
-			      cfg->clockevent_rating,
-			      cfg->clocksource_rating);
-	if (ret) {
-		dev_err(&cmt->pdev->dev, "registration failed\n");
-		goto err4;
-	}
-	ch->cs_enabled = false;
-
-	ret = setup_irq(irq, &ch->irqaction);
-	if (ret) {
-		dev_err(&cmt->pdev->dev, "failed to request irq %d\n", irq);
+	ret = sh_cmt_setup_channel(&cmt->channel, cmt);
+	if (ret < 0)
 		goto err4;
-	}
 
 	platform_set_drvdata(pdev, cmt);
 
-- 
1.8.3.2

