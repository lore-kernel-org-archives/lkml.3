Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaEWKcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:10 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52080 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaEWKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:03 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 21/71] clocksource: sh_tmu: Use request_irq() instead of setup_irq()
Date: Fri, 23 May 2014 12:31:01 +0200
Message-Id: <1400841111-6683-21-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The driver claims it needs to register an interrupt handler too early
for request_irq(). This might have been true in the past, but the only
meaningful difference between request_irq() and setup_irq() today is an
additional kzalloc() call in request_irq(). As the driver calls
kmalloc() itself we know that the slab allocator is available, we can
thus switch to request_irq().

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_tmu.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index ecd7b60..8613cc9 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -38,7 +38,7 @@
 struct sh_tmu_priv {
 	void __iomem *mapbase;
 	struct clk *clk;
-	struct irqaction irqaction;
+	int irq;
 	struct platform_device *pdev;
 	unsigned long rate;
 	unsigned long periodic;
@@ -401,10 +401,11 @@ static void sh_tmu_register_clockevent(struct sh_tmu_priv *p,
 
 	clockevents_config_and_register(ced, 1, 0x300, 0xffffffff);
 
-	ret = setup_irq(p->irqaction.irq, &p->irqaction);
+	ret = request_irq(p->irq, sh_tmu_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&p->pdev->dev), p);
 	if (ret) {
-		dev_err(&p->pdev->dev, "failed to request irq %d\n",
-			p->irqaction.irq);
+		dev_err(&p->pdev->dev, "failed to request irq %d\n", p->irq);
 		return;
 	}
 }
@@ -425,7 +426,7 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	struct resource *res;
-	int irq, ret;
+	int ret;
 	ret = -ENXIO;
 
 	memset(p, 0, sizeof(*p));
@@ -444,8 +445,8 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 		goto err0;
 	}
 
-	irq = platform_get_irq(p->pdev, 0);
-	if (irq < 0) {
+	p->irq = platform_get_irq(p->pdev, 0);
+	if (p->irq < 0) {
 		dev_err(&p->pdev->dev, "failed to get irq\n");
 		goto err0;
 	}
@@ -457,13 +458,6 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 		goto err0;
 	}
 
-	/* setup data for setup_irq() (too early for request_irq()) */
-	p->irqaction.name = dev_name(&p->pdev->dev);
-	p->irqaction.handler = sh_tmu_interrupt;
-	p->irqaction.dev_id = p;
-	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
-
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "tmu_fck");
 	if (IS_ERR(p->clk)) {
-- 
1.7.9.5

