Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaEWKyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:54:46 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38533 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaEWKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:42 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/71] clocksource: sh_cmt: Split channel setup to separate function
Date: Fri, 23 May 2014 12:30:44 +0200
Message-Id: <1400841111-6683-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Move the channel setup code from sh_cmt_setup to a new
sh_cmt_setup_channel function and call it from sh_cmt_setup.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |   79 +++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 604199a..26f73cf 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -693,12 +693,55 @@ static int sh_cmt_register(struct sh_cmt_channel *ch, char *name,
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
+	irq = platform_get_irq(cmt->pdev, 0);
+	if (irq < 0) {
+		dev_err(&cmt->pdev->dev, "failed to get irq\n");
+		return irq;
+	}
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
+	ret = request_irq(irq, sh_cmt_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&cmt->pdev->dev), ch);
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
@@ -718,12 +761,6 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
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
@@ -775,31 +812,9 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
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
-	ret = request_irq(irq, sh_cmt_interrupt,
-			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
-			  dev_name(&cmt->pdev->dev), ch);
-	if (ret) {
-		dev_err(&cmt->pdev->dev, "failed to request irq %d\n", irq);
+	ret = sh_cmt_setup_channel(&cmt->channel, cmt);
+	if (ret < 0)
 		goto err4;
-	}
 
 	platform_set_drvdata(pdev, cmt);
 
-- 
1.7.9.5

