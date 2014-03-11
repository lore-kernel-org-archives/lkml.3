Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaCKWn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:43:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33002 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbaCKWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:04 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 08/17] clocksource: orion: Use atomic access for shared registers
Date: Tue, 11 Mar 2014 23:40:44 +0100
Message-Id: <1394577653-8615-8-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Replace the driver-specific thread-safe shared register API
by the recently introduced atomic_io_clear_set().

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Willy Tarreau <w@1wt.eu>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/time-orion.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index 2006622..0b3ce03 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -35,20 +35,6 @@
 #define ORION_ONESHOT_MAX	0xfffffffe
 
 static void __iomem *timer_base;
-static DEFINE_SPINLOCK(timer_ctrl_lock);
-
-/*
- * Thread-safe access to TIMER_CTRL register
- * (shared with watchdog timer)
- */
-void orion_timer_ctrl_clrset(u32 clr, u32 set)
-{
-	spin_lock(&timer_ctrl_lock);
-	writel((readl(timer_base + TIMER_CTRL) & ~clr) | set,
-		timer_base + TIMER_CTRL);
-	spin_unlock(&timer_ctrl_lock);
-}
-EXPORT_SYMBOL(orion_timer_ctrl_clrset);
 
 /*
  * Free-running clocksource handling.
@@ -68,7 +54,8 @@ static int orion_clkevt_next_event(unsigned long delta,
 {
 	/* setup and enable one-shot timer */
 	writel(delta, timer_base + TIMER1_VAL);
-	orion_timer_ctrl_clrset(TIMER1_RELOAD_EN, TIMER1_EN);
+	atomic_io_modify(timer_base + TIMER_CTRL,
+		TIMER1_RELOAD_EN | TIMER1_EN, TIMER1_EN);
 
 	return 0;
 }
@@ -80,10 +67,13 @@ static void orion_clkevt_mode(enum clock_event_mode mode,
 		/* setup and enable periodic timer at 1/HZ intervals */
 		writel(ticks_per_jiffy - 1, timer_base + TIMER1_RELOAD);
 		writel(ticks_per_jiffy - 1, timer_base + TIMER1_VAL);
-		orion_timer_ctrl_clrset(0, TIMER1_RELOAD_EN | TIMER1_EN);
+		atomic_io_modify(timer_base + TIMER_CTRL,
+			TIMER1_RELOAD_EN | TIMER1_EN,
+			TIMER1_RELOAD_EN | TIMER1_EN);
 	} else {
 		/* disable timer */
-		orion_timer_ctrl_clrset(TIMER1_RELOAD_EN | TIMER1_EN, 0);
+		atomic_io_modify(timer_base + TIMER_CTRL,
+			TIMER1_RELOAD_EN | TIMER1_EN, 0);
 	}
 }
 
@@ -131,7 +121,9 @@ static void __init orion_timer_init(struct device_node *np)
 	/* setup timer0 as free-running clocksource */
 	writel(~0, timer_base + TIMER0_VAL);
 	writel(~0, timer_base + TIMER0_RELOAD);
-	orion_timer_ctrl_clrset(0, TIMER0_RELOAD_EN | TIMER0_EN);
+	atomic_io_modify(timer_base + TIMER_CTRL,
+		TIMER0_RELOAD_EN | TIMER0_EN,
+		TIMER0_RELOAD_EN | TIMER0_EN);
 	clocksource_mmio_init(timer_base + TIMER0_VAL, "orion_clocksource",
 			      clk_get_rate(clk), 300, 32,
 			      clocksource_mmio_readl_down);
-- 
1.7.9.5

