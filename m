Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaEWKty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:49:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45893 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEWKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:01 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 20/71] clocksource: sh_cmt: Request IRQ for clock event device only
Date: Fri, 23 May 2014 12:31:00 +0200
Message-Id: <1400841111-6683-20-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Clock sources don't need an IRQ, request the IRQ only for channels used
as clock event devices.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |   51 ++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 9f215e7..bc8d025 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -785,10 +785,28 @@ static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
 	pm_genpd_syscore_poweron(&ch->cmt->pdev->dev);
 }
 
-static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
-				       const char *name)
+static int sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
+				      const char *name)
 {
 	struct clock_event_device *ced = &ch->ced;
+	int irq;
+	int ret;
+
+	irq = platform_get_irq(ch->cmt->pdev, ch->cmt->legacy ? 0 : ch->index);
+	if (irq < 0) {
+		dev_err(&ch->cmt->pdev->dev, "ch%u: failed to get irq\n",
+			ch->index);
+		return irq;
+	}
+
+	ret = request_irq(irq, sh_cmt_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&ch->cmt->pdev->dev), ch);
+	if (ret) {
+		dev_err(&ch->cmt->pdev->dev, "ch%u: failed to request irq %d\n",
+			ch->index, irq);
+		return ret;
+	}
 
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
@@ -803,14 +821,20 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 	dev_info(&ch->cmt->pdev->dev, "ch%u: used for clock events\n",
 		 ch->index);
 	clockevents_register_device(ced);
+
+	return 0;
 }
 
 static int sh_cmt_register(struct sh_cmt_channel *ch, const char *name,
 			   bool clockevent, bool clocksource)
 {
+	int ret;
+
 	if (clockevent) {
 		ch->cmt->has_clockevent = true;
-		sh_cmt_register_clockevent(ch, name);
+		ret = sh_cmt_register_clockevent(ch, name);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (clocksource) {
@@ -825,7 +849,6 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 				unsigned int hwidx, bool clockevent,
 				bool clocksource, struct sh_cmt_device *cmt)
 {
-	int irq;
 	int ret;
 
 	/* Skip unused channels. */
@@ -869,17 +892,6 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 		}
 	}
 
-	if (cmt->legacy)
-		irq = platform_get_irq(cmt->pdev, 0);
-	else
-		irq = platform_get_irq(cmt->pdev, ch->index);
-
-	if (irq < 0) {
-		dev_err(&cmt->pdev->dev, "ch%u: failed to get irq\n",
-			ch->index);
-		return irq;
-	}
-
 	if (cmt->info->width == (sizeof(ch->max_match_value) * 8))
 		ch->max_match_value = ~0;
 	else
@@ -904,15 +916,6 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	}
 	ch->cs_enabled = false;
 
-	ret = request_irq(irq, sh_cmt_interrupt,
-			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
-			  dev_name(&cmt->pdev->dev), ch);
-	if (ret) {
-		dev_err(&cmt->pdev->dev, "ch%u: failed to request irq %d\n",
-			ch->index, irq);
-		return ret;
-	}
-
 	return 0;
 }
 
-- 
1.7.9.5

