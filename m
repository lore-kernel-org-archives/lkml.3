Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3F1T4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:56:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3F1T4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:32 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 7/8] clocksource: sun4i: Cleanup parent clock setup
Date: Fri, 28 Jun 2013 21:56:25 +0200
Message-Id: <1372449386-1334-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current bring-up code for the timer was overly complicated. The only
thing we need is actually which clock we want to use as source and
that's pretty much all. Let's keep it that way.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index d6621c5..a77fa29 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -31,6 +31,9 @@
 #define TIMER_CTL_REG(val)	(0x10 * val + 0x10)
 #define TIMER_CTL_ENABLE		BIT(0)
 #define TIMER_CTL_AUTORELOAD		BIT(1)
+#define TIMER_CTL_CLK_SRC(val)		(((val) & 0x3) << 2)
+#define TIMER_CTL_CLK_SRC_OSC24M		(1)
+#define TIMER_CTL_CLK_PRES(val)		(((val) & 0x7) << 4)
 #define TIMER_CTL_ONESHOT		BIT(7)
 #define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
@@ -144,16 +147,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 	writel(clk_get_rate(clk) / HZ,
 	       timer_base + TIMER_INTVAL_REG(0));
 
-	/* set clock source to HOSC, 16 pre-division */
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	val &= ~(0x07 << 4);
-	val &= ~(0x03 << 2);
-	val |= (4 << 4) | (1 << 2);
-	writel(val, timer_base + TIMER_CTL_REG(0));
-
-	/* set mode to auto reload */
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val | TIMER_CTL_AUTORELOAD, timer_base + TIMER_CTL_REG(0));
+	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M) | TIMER_CTL_AUTORELOAD,
+	       timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
-- 
1.8.3.1

