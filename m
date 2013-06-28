Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3F1T4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:56:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33705 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3F1T4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:30 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 2/8] clocksource: sun4i: Add clocksource and sched clock drivers
Date: Fri, 28 Jun 2013 21:56:20 +0200
Message-Id: <1372449386-1334-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the second timer found on the Allwinner SoCs as a clock source and
sched clock, that were both not used yet on these platforms.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index bdf34d9..050e94f 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqreturn.h>
+#include <linux/sched_clock.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -33,8 +34,6 @@
 #define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
 
-#define TIMER_SCAL		16
-
 static void __iomem *timer_base;
 
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
@@ -96,6 +95,11 @@ static struct irqaction sun4i_timer_irq = {
 	.dev_id = &sun4i_clockevent,
 };
 
+static u32 sun4i_timer_sched_read(void)
+{
+	return ~readl(timer_base + TIMER_CNTVAL_REG(1));
+}
+
 static void __init sun4i_timer_init(struct device_node *node)
 {
 	unsigned long rate = 0;
@@ -143,6 +147,15 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
 					0x1, 0xff);
+
+	writel(~0, timer_base + TIMER_INTVAL_REG(1));
+	writel(TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD | TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
+	       timer_base + TIMER_CTL_REG(1));
+
+	setup_sched_clock(sun4i_timer_sched_read, 32, clk_get_rate(clk));
+	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
+			      clk_get_rate(clk), 300, 32,
+			      clocksource_mmio_readl_down);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
-- 
1.8.3.1

