Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3GKQbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:31:44 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46531 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3GKQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:31:43 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv5 10/10] clocksource: sun4i: Fix bug when switching from periodic to oneshot modes
Date: Thu, 11 Jul 2013 18:31:22 +0200
Message-Id: <1373560282-15184-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373560282-15184-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373560282-15184-1-git-send-email-maxime.ripard@free-electrons.com>
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
index 2fadb3b..8ead025 100644
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
+	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
 
-	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M) | TIMER_CTL_RELOAD,
+	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sun4i_timer_irq);
-- 
1.8.3.2

