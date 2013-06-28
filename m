Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3F1T6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:58:12 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33723 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3F1T4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:33 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 8/8] clocksource: sun4i: Fix bug when switching from periodic to oneshot modes
Date: Fri, 28 Jun 2013 21:56:26 +0200
Message-Id: <1372449386-1334-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/clocksource/sun4i_timer.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index a77fa29..a2a9088 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -39,6 +39,7 @@
 #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
 
 static void __iomem *timer_base;
+static u32 ticks_per_jiffy;
 
 static void sun4i_clkevt_time_stop(u8 timer)
 {
@@ -61,7 +62,8 @@ static void sun4i_clkevt_time_start(u8 timer, bool periodic)
 	else
 		val |= TIMER_CTL_ONESHOT;
 
-	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
+	       timer_base + TIMER_CTL_REG(timer));
 }
 
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
@@ -70,6 +72,7 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		sun4i_clkevt_time_stop(0);
+		sun4i_clkevt_time_setup(0, ticks_per_jiffy);
 		sun4i_clkevt_time_start(0, true);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -144,10 +147,10 @@ static void __init sun4i_timer_init(struct device_node *node)
 		panic("Can't get timer clock");
 	clk_prepare_enable(clk);
 
-	writel(clk_get_rate(clk) / HZ,
-	       timer_base + TIMER_INTVAL_REG(0));
 
-	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M) | TIMER_CTL_AUTORELOAD,
+	ticks_per_jiffy = DIV_ROUND_UP(clk_get_rate(clk), HZ);
+
+	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sun4i_timer_irq);
-- 
1.8.3.1

