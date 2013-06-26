Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3FZVSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:18:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51836 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3FZVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:17:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/8] clocksource: sun4i: Factor out some timer code
Date: Wed, 26 Jun 2013 23:16:58 +0200
Message-Id: <1372281421-2099-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set_next_event and set_mode callbacks share a lot of common code we
can easily factor to avoid duplication and mistakes.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 48 ++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 032e504..7f3b248 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -45,24 +45,46 @@
 
 static void __iomem *timer_base;
 
+static void sun4i_clkevt_time_stop(void)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+	udelay(1);
+}
+
+static void sun4i_clkevt_time_setup(unsigned long delay)
+{
+	writel(delay, timer_base + TIMER_INTVAL_REG(0));
+}
+
+static void sun4i_clkevt_time_start(bool periodic)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(0));
+
+	if (periodic)
+		val &= ~TIMER_CTL_ONESHOT;
+	else
+		val |= TIMER_CTL_ONESHOT;
+
+	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+}
+
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
 			      struct clock_event_device *clk)
 {
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		u &= ~(TIMER_CTL_ONESHOT);
-		writel(u | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop();
+		sun4i_clkevt_time_start(true);
 		break;
-
 	case CLOCK_EVT_MODE_ONESHOT:
-		writel(u | TIMER_CTL_ONESHOT, timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop();
+		sun4i_clkevt_time_start(false);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
-		writel(u & ~(TIMER_CTL_ENABLE), timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop();
 		break;
 	}
 }
@@ -70,15 +92,9 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
-	u32 val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
-	udelay(1);
-
-	writel(evt, timer_base + TIMER_INTVAL_REG(0));
-
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
-	       timer_base + TIMER_CTL_REG(0));
+	sun4i_clkevt_time_stop();
+	sun4i_clkevt_time_setup(evt);
+	sun4i_clkevt_time_start(false);
 
 	return 0;
 }
-- 
1.8.3.1

