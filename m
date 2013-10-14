Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab3JNUuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:50:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35306 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758486Ab3JNUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:50:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/3] clocksource: sun4i: Report the minimum tick that we can program
Date: Mon, 14 Oct 2013 21:07:47 +0200
Message-Id: <1381777668-32565-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to wait for at least 2 clock cycles whenever we reprogram our
clockevent timer. Report that the minimum number of ticks we can handle
is 3 ticks, and remove 3 ticks to the interval programmed to reflect
this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 8ead025..46008f9 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -37,6 +37,8 @@
 #define TIMER_INTVAL_REG(val)	(0x10 * (val) + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
 
+#define TIMER_SYNC_TICKS	3
+
 static void __iomem *timer_base;
 static u32 ticks_per_jiffy;
 
@@ -50,7 +52,7 @@ static void sun4i_clkevt_sync(void)
 {
 	u32 old = readl(timer_base + TIMER_CNTVAL_REG(1));
 
-	while ((old - readl(timer_base + TIMER_CNTVAL_REG(1))) < 3)
+	while ((old - readl(timer_base + TIMER_CNTVAL_REG(1))) < TIMER_SYNC_TICKS)
 		cpu_relax();
 }
 
@@ -104,7 +106,7 @@ static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
 	sun4i_clkevt_time_stop(0);
-	sun4i_clkevt_time_setup(0, evt);
+	sun4i_clkevt_time_setup(0, evt - TIMER_SYNC_TICKS);
 	sun4i_clkevt_time_start(0, false);
 
 	return 0;
@@ -187,8 +189,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	sun4i_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&sun4i_clockevent, rate, 0x1,
-					0xffffffff);
+	clockevents_config_and_register(&sun4i_clockevent, rate,
+					TIMER_SYNC_TICKS, 0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
-- 
1.8.4

