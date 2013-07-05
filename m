Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3GETfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:35:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51522 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3GETes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:34:48 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 07/10] clocksource: sun4i: Factor out some timer code
Date: Fri,  5 Jul 2013 21:34:34 +0200
Message-Id: <1373052877-29366-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
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
index 6938cf9..00e17d9 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -52,24 +52,46 @@ static void sun4i_clkevt_sync(void)
 		cpu_relax();
 }
 
+static void sun4i_clkevt_time_stop(u8 timer)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
+	sun4i_clkevt_sync();
+}
+
+static void sun4i_clkevt_time_setup(u8 timer, unsigned long delay)
+{
+	writel(delay, timer_base + TIMER_INTVAL_REG(timer));
+}
+
+static void sun4i_clkevt_time_start(u8 timer, bool periodic)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+
+	if (periodic)
+		val &= ~TIMER_CTL_ONESHOT;
+	else
+		val |= TIMER_CTL_ONESHOT;
+
+	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
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
+		sun4i_clkevt_time_stop(0);
+		sun4i_clkevt_time_start(0, true);
 		break;
-
 	case CLOCK_EVT_MODE_ONESHOT:
-		writel(u | TIMER_CTL_ONESHOT, timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop(0);
+		sun4i_clkevt_time_start(0, false);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
-		writel(u & ~(TIMER_CTL_ENABLE), timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop(0);
 		break;
 	}
 }
@@ -77,15 +99,9 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
-	u32 val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
-	sun4i_clkevt_sync();
-
-	writel(evt, timer_base + TIMER_INTVAL_REG(0));
-
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
-	       timer_base + TIMER_CTL_REG(0));
+	sun4i_clkevt_time_stop(0);
+	sun4i_clkevt_time_setup(0, evt);
+	sun4i_clkevt_time_start(0, false);
 
 	return 0;
 }
-- 
1.8.3.2

