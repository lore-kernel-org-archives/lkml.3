Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3GEWS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:18:58 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52599 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3GEWSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:18:54 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv4 06/10] clocksource: sun4i: Fix the next event code
Date: Sat,  6 Jul 2013 00:18:41 +0200
Message-Id: <1373062725-19625-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next_event logic was setting the next interval to fire in the
current timer value instead of the interval value register, which is
obviously wrong.

Plus, the logic to set the actual value was wrong as well: the interval
register can only be modified when the timer is disabled, and then
enable it back, otherwise, it'll have no effect. Fix this logic as well
since that code couldn't possibly work.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 8e9c651..7123f65 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -38,6 +38,20 @@
 
 static void __iomem *timer_base;
 
+/*
+ * When we disable a timer, we need to wait at least for 2 cycles of
+ * the timer source clock. We will use for that the clocksource timer
+ * that is already setup and runs at the same frequency than the other
+ * timers, and we never will be disabled.
+ */
+static void sun4i_clkevt_sync(void)
+{
+	u32 old = readl(timer_base + TIMER_CNTVAL_REG(1));
+
+	while ((old - readl(timer_base + TIMER_CNTVAL_REG(1))) < 3)
+		cpu_relax();
+}
+
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
 			      struct clock_event_device *clk)
 {
@@ -63,9 +77,14 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
-	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
+	u32 val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+	sun4i_clkevt_sync();
+
+	writel(evt, timer_base + TIMER_INTVAL_REG(0));
+
+	val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
 	       timer_base + TIMER_CTL_REG(0));
 
 	return 0;
-- 
1.8.3.2

