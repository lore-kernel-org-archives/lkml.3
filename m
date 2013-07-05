Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3GEWTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:19:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52619 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3GEWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:18:56 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv4 10/10] clocksource: sun4i: Fix bug when switching from periodic to oneshot modes
Date: Sat,  6 Jul 2013 00:18:45 +0200
Message-Id: <1373062725-19625-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interval was firing at was set up at probe time, and only changed in
the set_next_event, and never changed back, which is not really what is
expected.

When enabling the periodic mode, now set an interval to tick every
jiffy.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 2fadb3b..d00d50a 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -38,6 +38,7 @@
 #define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
 
 static void __iomem *timer_base;
+static u32 ticks_per_jiffy;
 
 /*
  * When we disable a timer, we need to wait at least for 2 cycles of
@@ -74,7 +75,8 @@ static void sun4i_clkevt_time_start(u8 timer, bool periodic)
 	else
 		val |= TIMER_CTL_ONESHOT;
 
-	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
+	       timer_base + TIMER_CTL_REG(timer));
 }
 
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
@@ -83,6 +85,7 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		sun4i_clkevt_time_stop(0);
+		sun4i_clkevt_time_setup(0, ticks_per_jiffy);
 		sun4i_clkevt_time_start(0, true);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -169,9 +172,9 @@ static void __init sun4i_timer_init(struct device_node *node)
 	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
 			      rate, 300, 32, clocksource_mmio_readl_down);
 
-	writel(rate / HZ, timer_base + TIMER_INTVAL_REG(0));
+	ticks_per_jiffy = DIV_ROUND_UP(clk_get_rate(clk), HZ);
 
-	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M) | TIMER_CTL_RELOAD,
+	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sun4i_timer_irq);
-- 
1.8.3.2

