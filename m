Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3HXPfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:35:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54629 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755307Ab3HXPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:35:52 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH v4 3/4] clocksource: orion: Use atomic access for shared registers
Date: Sat, 24 Aug 2013 12:35:31 -0300
Message-Id: <1377358532-23802-4-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the driver-specific thread-safe shared register API
by the recently introduced atomic_io_modify().

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/clocksource/time-orion.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index ecbeb68..f69f697 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/io.h>
 #include <linux/spinlock.h>
 #include <asm/sched_clock.h>
 
@@ -35,20 +36,6 @@
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
@@ -68,7 +55,8 @@ static int orion_clkevt_next_event(unsigned long delta,
 {
 	/* setup and enable one-shot timer */
 	writel(delta, timer_base + TIMER1_VAL);
-	orion_timer_ctrl_clrset(TIMER1_RELOAD_EN, TIMER1_EN);
+	atomic_io_modify(timer_base + TIMER_CTRL,
+		TIMER1_RELOAD_EN | TIMER1_EN, TIMER1_EN);
 
 	return 0;
 }
@@ -80,10 +68,13 @@ static void orion_clkevt_mode(enum clock_event_mode mode,
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
 
@@ -131,7 +122,9 @@ static void __init orion_timer_init(struct device_node *np)
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
1.8.1.5

