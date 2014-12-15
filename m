Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaLOO1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaLOO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 040/168] clockevent: sun4i: Fix race condition in the probe code
Date: Mon, 15 Dec 2014 14:24:54 +0000
Message-Id: <1418653622-21105-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 6bab4a8a1888729f17f4923cc5867e4674f66333 upstream.

The interrupts were activated and the handler registered before the clockevent
was registered in the probe function.

The interrupt handler, however, was making the assumption that the clockevent
device was registered.

That could cause a null pointer dereference if the timer interrupt was firing
during this narrow window.

Fix that by moving the clockevent registration before the interrupt is enabled.

Reported-by: Roman Byshko <rbyshko@gmail.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.3

