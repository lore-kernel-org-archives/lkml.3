Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3GETew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:34:52 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51516 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3GETer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:34:47 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 04/10] clocksource: sun4i: Add clocksource and sched clock drivers
Date: Fri,  5 Jul 2013 21:34:31 +0200
Message-Id: <1373052877-29366-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the second timer found on the Allwinner SoCs as a clock source and
sched clock, that were both not used yet on these platforms.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index f5e227b..224c855 100644
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
@@ -96,6 +97,11 @@ static struct irqaction sun4i_timer_irq = {
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
@@ -117,6 +123,16 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	rate = clk_get_rate(clk);
 
+	writel(~0, timer_base + TIMER_INTVAL_REG(1));
+	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD |
+	       TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
+	       timer_base + TIMER_CTL_REG(1));
+
+	setup_sched_clock(sun4i_timer_sched_read, 32, clk_get_rate(clk));
+	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
+			      clk_get_rate(clk), 300, 32,
+			      clocksource_mmio_readl_down);
+
 	writel(rate / (TIMER_SCAL * HZ),
 	       timer_base + TIMER_INTVAL_REG(0));
 
-- 
1.8.3.2

