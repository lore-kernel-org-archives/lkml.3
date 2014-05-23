Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaEWKcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:19 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:42655 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaEWKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:14 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 30/71] clocksource: sh_tmu: Replace hardcoded register values with macros
Date: Fri, 23 May 2014 12:31:10 +0200
Message-Id: <1400841111-6683-30-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Define symbolic macros for all used registers bits.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_tmu.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 55b7a37..63ed92d 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -69,6 +69,15 @@ static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
 #define TCNT 1 /* channel register */
 #define TCR 2 /* channel register */
 
+#define TCR_UNF			(1 << 8)
+#define TCR_UNIE		(1 << 5)
+#define TCR_TPSC_CLK4		(0 << 0)
+#define TCR_TPSC_CLK16		(1 << 0)
+#define TCR_TPSC_CLK64		(2 << 0)
+#define TCR_TPSC_CLK256		(3 << 0)
+#define TCR_TPSC_CLK1024	(4 << 0)
+#define TCR_TPSC_MASK		(7 << 0)
+
 static inline unsigned long sh_tmu_read(struct sh_tmu_channel *ch, int reg_nr)
 {
 	unsigned long offs;
@@ -140,7 +149,7 @@ static int __sh_tmu_enable(struct sh_tmu_channel *ch)
 
 	/* configure channel to parent clock / 4, irq off */
 	ch->rate = clk_get_rate(ch->tmu->clk) / 4;
-	sh_tmu_write(ch, TCR, 0x0000);
+	sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
 
 	/* enable channel */
 	sh_tmu_start_stop_ch(ch, 1);
@@ -165,7 +174,7 @@ static void __sh_tmu_disable(struct sh_tmu_channel *ch)
 	sh_tmu_start_stop_ch(ch, 0);
 
 	/* disable interrupts in TMU block */
-	sh_tmu_write(ch, TCR, 0x0000);
+	sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
 
 	/* stop clock */
 	clk_disable(ch->tmu->clk);
@@ -195,7 +204,7 @@ static void sh_tmu_set_next(struct sh_tmu_channel *ch, unsigned long delta,
 	sh_tmu_read(ch, TCR);
 
 	/* enable interrupt */
-	sh_tmu_write(ch, TCR, 0x0020);
+	sh_tmu_write(ch, TCR, TCR_UNIE | TCR_TPSC_CLK4);
 
 	/* reload delta value in case of periodic timer */
 	if (periodic)
@@ -215,9 +224,9 @@ static irqreturn_t sh_tmu_interrupt(int irq, void *dev_id)
 
 	/* disable or acknowledge interrupt */
 	if (ch->ced.mode == CLOCK_EVT_MODE_ONESHOT)
-		sh_tmu_write(ch, TCR, 0x0000);
+		sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
 	else
-		sh_tmu_write(ch, TCR, 0x0020);
+		sh_tmu_write(ch, TCR, TCR_UNIE | TCR_TPSC_CLK4);
 
 	/* notify clockevent layer */
 	ch->ced.event_handler(&ch->ced);
-- 
1.7.9.5

