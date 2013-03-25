Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3CYNam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:30:42 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46859 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab3CYNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:30:41 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] clocksource: sunxi: Cleanup the timer code
Date: Mon, 25 Mar 2013 14:30:25 +0100
Message-Id: <1364218233-29636-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer code was not exact to some aspects, since most of this code
was written wihout any datasheet. Make the needed corrections to match
the datasheet.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sunxi_timer.c |   48 ++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
index 0ce85e2..7a3ea23 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sunxi_timer.c
@@ -25,15 +25,15 @@
 #include <linux/sunxi_timer.h>
 #include <linux/clk/sunxi.h>
 
-#define TIMER_CTL_REG		0x00
-#define TIMER_CTL_ENABLE		(1 << 0)
+#define TIMER_IRQ_EN_REG	0x00
+#define TIMER_IRQ_EN(val)		(1 << val)
 #define TIMER_IRQ_ST_REG	0x04
-#define TIMER0_CTL_REG		0x10
-#define TIMER0_CTL_ENABLE		(1 << 0)
-#define TIMER0_CTL_AUTORELOAD		(1 << 1)
-#define TIMER0_CTL_ONESHOT		(1 << 7)
-#define TIMER0_INTVAL_REG	0x14
-#define TIMER0_CNTVAL_REG	0x18
+#define TIMER_CTL_REG(val)	(0x10 * val + 0x10)
+#define TIMER_CTL_ENABLE		(1 << 0)
+#define TIMER_CTL_AUTORELOAD		(1 << 1)
+#define TIMER_CTL_ONESHOT		(1 << 7)
+#define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
+#define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
 
 #define TIMER_SCAL		16
 
@@ -42,21 +42,21 @@ static void __iomem *timer_base;
 static void sunxi_clkevt_mode(enum clock_event_mode mode,
 			      struct clock_event_device *clk)
 {
-	u32 u = readl(timer_base + TIMER0_CTL_REG);
+	u32 u = readl(timer_base + TIMER_CTL_REG(0));
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		u &= ~(TIMER0_CTL_ONESHOT);
-		writel(u | TIMER0_CTL_ENABLE, timer_base + TIMER0_CTL_REG);
+		u &= ~(TIMER_CTL_ONESHOT);
+		writel(u | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		writel(u | TIMER0_CTL_ONESHOT, timer_base + TIMER0_CTL_REG);
+		writel(u | TIMER_CTL_ONESHOT, timer_base + TIMER_CTL_REG(0));
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
-		writel(u & ~(TIMER0_CTL_ENABLE), timer_base + TIMER0_CTL_REG);
+		writel(u & ~(TIMER_CTL_ENABLE), timer_base + TIMER_CTL_REG(0));
 		break;
 	}
 }
@@ -64,10 +64,10 @@ static void sunxi_clkevt_mode(enum clock_event_mode mode,
 static int sunxi_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
-	u32 u = readl(timer_base + TIMER0_CTL_REG);
-	writel(evt, timer_base + TIMER0_CNTVAL_REG);
-	writel(u | TIMER0_CTL_ENABLE | TIMER0_CTL_AUTORELOAD,
-	       timer_base + TIMER0_CTL_REG);
+	u32 u = readl(timer_base + TIMER_CTL_REG(0));
+	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
+	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
+	       timer_base + TIMER_CTL_REG(0));
 
 	return 0;
 }
@@ -132,26 +132,26 @@ void __init sunxi_timer_init(void)
 	rate = clk_get_rate(clk);
 
 	writel(rate / (TIMER_SCAL * HZ),
-	       timer_base + TIMER0_INTVAL_REG);
+	       timer_base + TIMER_INTVAL_REG(0));
 
 	/* set clock source to HOSC, 16 pre-division */
-	val = readl(timer_base + TIMER0_CTL_REG);
+	val = readl(timer_base + TIMER_CTL_REG(0));
 	val &= ~(0x07 << 4);
 	val &= ~(0x03 << 2);
 	val |= (4 << 4) | (1 << 2);
-	writel(val, timer_base + TIMER0_CTL_REG);
+	writel(val, timer_base + TIMER_CTL_REG(0));
 
 	/* set mode to auto reload */
-	val = readl(timer_base + TIMER0_CTL_REG);
-	writel(val | TIMER0_CTL_AUTORELOAD, timer_base + TIMER0_CTL_REG);
+	val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val | TIMER_CTL_AUTORELOAD, timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sunxi_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
 
 	/* Enable timer0 interrupt */
-	val = readl(timer_base + TIMER_CTL_REG);
-	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG);
+	val = readl(timer_base + TIMER_IRQ_EN_REG);
+	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
 
 	sunxi_clockevent.cpumask = cpumask_of(0);
 
-- 
1.7.10.4

