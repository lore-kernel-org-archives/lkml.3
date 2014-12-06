Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaLFPIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:08:14 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47672 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751373AbaLFPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 20/66] clockevent: sun4i: Fix race condition in the probe code
Date: Sat,  6 Dec 2014 16:07:12 +0100
Message-Id: <1b0a21003bd3b81a0b935f51f4e6988910cb0ae1.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/clocksource/sun4i_timer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 8ead0258740a..4fe6ac85ea1d 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -177,6 +177,11 @@ static void __init sun4i_timer_init(struct device_node *node)
 	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
+	sun4i_clockevent.cpumask = cpumask_of(0);
+
+	clockevents_config_and_register(&sun4i_clockevent, rate, 0x1,
+					0xffffffff);
+
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
@@ -184,11 +189,6 @@ static void __init sun4i_timer_init(struct device_node *node)
 	/* Enable timer0 interrupt */
 	val = readl(timer_base + TIMER_IRQ_EN_REG);
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
-
-	sun4i_clockevent.cpumask = cpumask_of(0);
-
-	clockevents_config_and_register(&sun4i_clockevent, rate, 0x1,
-					0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
-- 
2.1.3

