Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbbAZJzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:55:41 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33599 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbbAZJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:55:39 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 1/5] clocksource: sun5i: Switch to request_irq
Date: Mon, 26 Jan 2015 10:50:52 +0100
Message-Id: <1422265856-27631-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code uses setup_irq, while it could perfectly use the much simpler
request_irq. Switch to that.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/timer-sun5i.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index 02268448dc85..836f92ac0ffd 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -130,13 +130,6 @@ static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction sun5i_timer_irq = {
-	.name = "sun5i_timer0",
-	.flags = IRQF_TIMER | IRQF_IRQPOLL,
-	.handler = sun5i_timer_interrupt,
-	.dev_id = &sun5i_clockevent,
-};
-
 static u64 sun5i_timer_sched_read(void)
 {
 	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
@@ -178,7 +171,8 @@ static void __init sun5i_timer_init(struct device_node *node)
 
 	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
 
-	ret = setup_irq(irq, &sun5i_timer_irq);
+	ret = request_irq(irq, sun5i_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
+			  "sun5i_timer0", &sun5i_clockevent);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
 
-- 
2.2.2

