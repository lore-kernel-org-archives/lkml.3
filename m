Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBNA7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:59:53 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBNA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:10 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/27] clocksource: sh_cmt: Add index to struct sh_cmt_channel
Date: Fri, 14 Feb 2014 01:59:44 +0100
Message-Id: <1392339605-20691-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the index when printing messages to identify the channel.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index ec10cf4..0796460 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -39,6 +39,7 @@ struct sh_cmt_device;
 
 struct sh_cmt_channel {
 	struct sh_cmt_device *cmt;
+	unsigned int index;
 
 	void __iomem *base;
 	struct irqaction irqaction;
@@ -217,7 +218,8 @@ static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
 	/* enable clock */
 	ret = clk_enable(ch->cmt->clk);
 	if (ret) {
-		dev_err(&ch->cmt->pdev->dev, "cannot enable clock\n");
+		dev_err(&ch->cmt->pdev->dev, "ch%u: cannot enable clock\n",
+			ch->index);
 		goto err0;
 	}
 
@@ -254,7 +256,8 @@ static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
 	}
 
 	if (sh_cmt_read_cmcnt(ch)) {
-		dev_err(&ch->cmt->pdev->dev, "cannot clear CMCNT\n");
+		dev_err(&ch->cmt->pdev->dev, "ch%u: cannot clear CMCNT\n",
+			ch->index);
 		ret = -ETIMEDOUT;
 		goto err1;
 	}
@@ -372,7 +375,8 @@ static void sh_cmt_clock_event_program_verify(struct sh_cmt_channel *ch,
 			delay = 1;
 
 		if (!delay)
-			dev_warn(&ch->cmt->pdev->dev, "too long delay\n");
+			dev_warn(&ch->cmt->pdev->dev, "ch%u: too long delay\n",
+				 ch->index);
 
 	} while (delay);
 }
@@ -380,7 +384,8 @@ static void sh_cmt_clock_event_program_verify(struct sh_cmt_channel *ch,
 static void __sh_cmt_set_next(struct sh_cmt_channel *ch, unsigned long delta)
 {
 	if (delta > ch->max_match_value)
-		dev_warn(&ch->cmt->pdev->dev, "delta out of range\n");
+		dev_warn(&ch->cmt->pdev->dev, "ch%u: delta out of range\n",
+			 ch->index);
 
 	ch->next_match_value = delta;
 	sh_cmt_clock_event_program_verify(ch, 0);
@@ -566,7 +571,8 @@ static int sh_cmt_register_clocksource(struct sh_cmt_channel *ch,
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	dev_info(&ch->cmt->pdev->dev, "used as clock source\n");
+	dev_info(&ch->cmt->pdev->dev, "ch%u: used as clock source\n",
+		 ch->index);
 
 	/* Register with dummy 1 Hz value, gets updated in ->enable() */
 	clocksource_register_hz(cs, 1);
@@ -615,12 +621,12 @@ static void sh_cmt_clock_event_mode(enum clock_event_mode mode,
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		dev_info(&ch->cmt->pdev->dev,
-			 "used for periodic clock events\n");
+			 "ch%u: used for periodic clock events\n", ch->index);
 		sh_cmt_clock_event_start(ch, 1);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		dev_info(&ch->cmt->pdev->dev,
-			 "used for oneshot clock events\n");
+			 "ch%u: used for oneshot clock events\n", ch->index);
 		sh_cmt_clock_event_start(ch, 0);
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
@@ -679,7 +685,8 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 	ced->suspend = sh_cmt_clock_event_suspend;
 	ced->resume = sh_cmt_clock_event_resume;
 
-	dev_info(&ch->cmt->pdev->dev, "used for clock events\n");
+	dev_info(&ch->cmt->pdev->dev, "ch%u: used for clock events\n",
+		 ch->index);
 	clockevents_register_device(ced);
 }
 
@@ -696,7 +703,7 @@ static int sh_cmt_register(struct sh_cmt_channel *ch, char *name,
 	return 0;
 }
 
-static int sh_cmt_setup_channel(struct sh_cmt_channel *ch,
+static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 				struct sh_cmt_device *cmt)
 {
 	struct sh_timer_config *cfg = cmt->pdev->dev.platform_data;
@@ -706,6 +713,7 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch,
 	memset(ch, 0, sizeof(*ch));
 	ch->cmt = cmt;
 	ch->base = cmt->mapbase_ch;
+	ch->index = index;
 
 	/* Request irq using setup_irq() (too early for request_irq()). */
 	irq = platform_get_irq(cmt->pdev, 0);
@@ -820,7 +828,7 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		cmt->clear_bits = ~0xc000;
 	}
 
-	ret = sh_cmt_setup_channel(&cmt->channel, cmt);
+	ret = sh_cmt_setup_channel(&cmt->channel, cfg->timer_bit, cmt);
 	if (ret < 0)
 		goto err4;
 
-- 
1.8.3.2

