Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaKRXAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:00:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34444 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932648AbaKRXAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:00:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Roman Byshko <rbyshko@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        stable@vger.kernel.org
Subject: [PATCH] clockevent: sun4i: Fix race condition in the probe code
Date: Tue, 18 Nov 2014 23:59:33 +0100
Message-Id: <1416351573-5815-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupts were activated and the handler registered before the clockevent
was registered in the probe function.

The interrupt handler, however, was making the assumption that the clockevent
device was registered.

That could cause a null pointer dereferenc if the timer interrupt was firing
during this narrow window.

Fix that by moving the clockevent registration before the interrupt is enabled.

Reported-by: Roman Byshko <rbyshko@gmail.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: stable@vger.kernel.org
---
 drivers/clocksource/sun4i_timer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index efb17c3ee120..f4a9c0058b4d 100644
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
2.1.1

