Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3GEThC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:37:02 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51537 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825Ab3GETeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:34:50 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 08/10] clocksource: sun4i: Remove TIMER_SCAL variable
Date: Fri,  5 Jul 2013 21:34:35 +0200
Message-Id: <1373052877-29366-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prescaler is only used when using the internal low frequency
oscillator (at 32kHz). Since we're using the higher frequency oscillator
at 24MHz, we can just remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 00e17d9..2f84075 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -34,8 +34,6 @@
 #define TIMER_INTVAL_REG(val)	(0x10 * (val) + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
 
-#define TIMER_SCAL		16
-
 static void __iomem *timer_base;
 
 /*
@@ -139,7 +137,6 @@ static u32 sun4i_timer_sched_read(void)
 
 static void __init sun4i_timer_init(struct device_node *node)
 {
-	unsigned long rate = 0;
 	struct clk *clk;
 	int ret, irq;
 	u32 val;
@@ -157,8 +154,6 @@ static void __init sun4i_timer_init(struct device_node *node)
 		panic("Can't get timer clock");
 	clk_prepare_enable(clk);
 
-	rate = clk_get_rate(clk);
-
 	writel(~0, timer_base + TIMER_INTVAL_REG(1));
 	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD |
 	       TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
@@ -169,7 +164,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 			      clk_get_rate(clk), 300, 32,
 			      clocksource_mmio_readl_down);
 
-	writel(rate / (TIMER_SCAL * HZ),
+	writel(clk_get_rate(clk) / HZ,
 	       timer_base + TIMER_INTVAL_REG(0));
 
 	/* set clock source to HOSC, 16 pre-division */
@@ -193,8 +188,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	sun4i_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
-					0x1, 0xff);
+	clockevents_config_and_register(&sun4i_clockevent, clk_get_rate(clk),
+					0x1, 0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
-- 
1.8.3.2

