Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3FZVSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:18:23 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51836 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3FZVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:17:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 8/8] clocksource: sun4i: Fix bug when switching from periodic to oneshot modes
Date: Wed, 26 Jun 2013 23:17:01 +0200
Message-Id: <1372281421-2099-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/clocksource/sun4i_timer.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 98e38a6..b7e1f9e 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -46,6 +46,7 @@
 #define TIMER_CNT64_HIGH_REG	0xa8
 
 static void __iomem *timer_base;
+static u32 ticks_per_jiffy;
 
 static void sun4i_clkevt_time_stop(void)
 {
@@ -68,7 +69,8 @@ static void sun4i_clkevt_time_start(bool periodic)
 	else
 		val |= TIMER_CTL_ONESHOT;
 
-	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
+	       timer_base + TIMER_CTL_REG(0));
 }
 
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
@@ -77,6 +79,7 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		sun4i_clkevt_time_stop();
+		sun4i_clkevt_time_setup(ticks_per_jiffy);
 		sun4i_clkevt_time_start(true);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -166,10 +169,9 @@ static void __init sun4i_timer_init(struct device_node *node)
 			      clk_get_rate(clk), 300, 32,
 			      sun4i_timer_clksrc_read);
 
-	writel(clk_get_rate(clk) / HZ,
-	       timer_base + TIMER_INTVAL_REG(0));
+	ticks_per_jiffy = DIV_ROUND_UP(clk_get_rate(clk), HZ);
 
-	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M) | TIMER_CTL_AUTORELOAD,
+	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sun4i_timer_irq);
-- 
1.8.3.1

