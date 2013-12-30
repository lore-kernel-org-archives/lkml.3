Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3L3KUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:20:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59801 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3L3KUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:20:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/20] clocksource: armada-370-xp: Enable timer divider only when needed
Date: Mon, 30 Dec 2013 11:19:32 +0100
Message-Id: <1388398779-11222-13-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

The current code sets the timer divider bits always. However, when
the 25 MHz timer is enabled, this is not needed and has no effect.
As this causes some confusion, rework the code so the divider is
set only when needed, i.e. when the 25 MHz timer is not in use.

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/time-armada-370-xp.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index d8e47e5..0450f6b 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -76,6 +76,7 @@
 static void __iomem *timer_base, *local_base;
 static unsigned int timer_clk;
 static bool timer25Mhz = true;
+static u32 enable_mask;
 
 /*
  * Number of timer ticks per jiffy.
@@ -121,8 +122,7 @@ armada_370_xp_clkevt_next_event(unsigned long delta,
 	/*
 	 * Enable the timer.
 	 */
-	local_timer_ctrl_clrset(TIMER0_RELOAD_EN,
-				TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+	local_timer_ctrl_clrset(TIMER0_RELOAD_EN, enable_mask);
 	return 0;
 }
 
@@ -141,9 +141,7 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 		/*
 		 * Enable timer.
 		 */
-		local_timer_ctrl_clrset(0, TIMER0_RELOAD_EN |
-					   TIMER0_EN |
-					   TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+		local_timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
 	} else {
 		/*
 		 * Disable timer.
@@ -240,10 +238,13 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	WARN_ON(!timer_base);
 	local_base = of_iomap(np, 1);
 
-	if (timer25Mhz)
+	if (timer25Mhz) {
 		set = TIMER0_25MHZ;		
-	else
+		enable_mask = TIMER0_EN;
+	} else {
 		clr = TIMER0_25MHZ;
+		enable_mask = TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT);
+	}
 	timer_ctrl_clrset(clr, set);
 	local_timer_ctrl_clrset(clr, set);
 
@@ -267,8 +268,7 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	writel(0xffffffff, timer_base + TIMER0_VAL_OFF);
 	writel(0xffffffff, timer_base + TIMER0_RELOAD_OFF);
 
-	timer_ctrl_clrset(0, TIMER0_EN | TIMER0_RELOAD_EN |
-			     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+	timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
 
 	clocksource_mmio_init(timer_base + TIMER0_VAL_OFF,
 			      "armada_370_xp_clocksource",
-- 
1.7.9.5

