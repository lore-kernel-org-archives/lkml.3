Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaKSJt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:49:29 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34156 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaKSJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:49:26 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, maxime.ripard@free-electrons.com
Subject: [PATCH] clockevent: sun4i: Fix race condition in the probe code
Date: Wed, 19 Nov 2014 10:49:23 +0100
Message-Id: <1416390563-17138-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <546C673F.8000502@linaro.org>
References: <546C673F.8000502@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

The interrupts were activated and the handler registered before the clockevent
was registered in the probe function.

The interrupt handler, however, was making the assumption that the clockevent
device was registered.

That could cause a null pointer dereference if the timer interrupt was firing
during this narrow window.

Fix that by moving the clockevent registration before the interrupt is enabled.

Reported-by: Roman Byshko <rbyshko@gmail.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/sun4i_timer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index efb17c3..f4a9c00 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -182,6 +182,12 @@ static void __init sun4i_timer_init(struct device_node *node)
 	/* Make sure timer is stopped before playing with interrupts */
 	sun4i_clkevt_time_stop(0);
 
+	sun4i_clockevent.cpumask = cpu_possible_mask;
+	sun4i_clockevent.irq = irq;
+
+	clockevents_config_and_register(&sun4i_clockevent, rate,
+					TIMER_SYNC_TICKS, 0xffffffff);
+
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
@@ -189,12 +195,6 @@ static void __init sun4i_timer_init(struct device_node *node)
 	/* Enable timer0 interrupt */
 	val = readl(timer_base + TIMER_IRQ_EN_REG);
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
-
-	sun4i_clockevent.cpumask = cpu_possible_mask;
-	sun4i_clockevent.irq = irq;
-
-	clockevents_config_and_register(&sun4i_clockevent, rate,
-					TIMER_SYNC_TICKS, 0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-a10-timer",
 		       sun4i_timer_init);
-- 
1.9.1

