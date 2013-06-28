Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3F1T4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:56:37 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33716 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3F1T4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 4/8] clocksource: sun4i: Fix the next event code
Date: Fri, 28 Jun 2013 21:56:22 +0200
Message-Id: <1372449386-1334-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next_event logic was setting the next interval to fire in the
current timer value instead of the interval value register, which is
obviously wrong. Plus the logic to set the actual value was wrong as
well, so this code has always been broken.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 84ace76..695c8c8 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -16,6 +16,7 @@
 
 #include <linux/clk.h>
 #include <linux/clockchips.h>
+#include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqreturn.h>
@@ -61,9 +62,14 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
-	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
+	u32 val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+	udelay(1);
+
+	writel(evt, timer_base + TIMER_INTVAL_REG(0));
+
+	val = readl(timer_base + TIMER_CTL_REG(0));
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
 	       timer_base + TIMER_CTL_REG(0));
 
 	return 0;
-- 
1.8.3.1

