Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3FZVSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:18:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51830 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3FZVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:17:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 6/8] clocksource: sun4i: Remove TIMER_SCAL variable
Date: Wed, 26 Jun 2013 23:16:59 +0200
Message-Id: <1372281421-2099-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prescaler is only used when using the internal low frequency
oscillator (at 32kHz). Since we're using the higher frequency oscillator
at 24MHz, we can just remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 7f3b248..912d3e0 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -36,7 +36,6 @@
 #define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
 
-#define TIMER_SCAL		16
 #define TIMER_CNT64_CTL_REG	0xa0
 #define TIMER_CNT64_CTL_CLR		BIT(0)
 #define TIMER_CNT64_CTL_RL		BIT(1)
@@ -141,7 +140,6 @@ static cycle_t sun4i_timer_clksrc_read(struct clocksource *c)
 
 static void __init sun4i_timer_init(struct device_node *node)
 {
-	unsigned long rate = 0;
 	struct clk *clk;
 	int ret, irq;
 	u32 val;
@@ -159,15 +157,13 @@ static void __init sun4i_timer_init(struct device_node *node)
 		panic("Can't get timer clock");
 	clk_prepare_enable(clk);
 
-	rate = clk_get_rate(clk);
-
 	writel(TIMER_CNT64_CTL_CLR, timer_base + TIMER_CNT64_CTL_REG);
 	setup_sched_clock(sun4i_timer_sched_read, 32, clk_get_rate(clk));
 	clocksource_mmio_init(timer_base + TIMER_CNT64_LOW_REG, node->name,
 			      clk_get_rate(clk), 300, 32,
 			      sun4i_timer_clksrc_read);
 
-	writel(rate / (TIMER_SCAL * HZ),
+	writel(clk_get_rate(clk) / HZ,
 	       timer_base + TIMER_INTVAL_REG(0));
 
 	/* set clock source to HOSC, 16 pre-division */
@@ -191,8 +187,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	sun4i_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
-					0x1, 0xff);
+	clockevents_config_and_register(&sun4i_clockevent, clk_get_rate(clk),
+					0x1, 0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
-- 
1.8.3.1

