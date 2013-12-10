Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3LJTQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:16:25 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37905 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3LJTQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:18 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/6] clocksource: sunxi: Stop timer from ticking before enabling interrupts
Date: Tue, 10 Dec 2013 20:16:10 +0100
Message-Id: <1386702972-25565-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
References: <52A767CB.3010501@linaro.org>
 <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

The sun4i timer can still be ticking when we enable the interrupt.
If another timer is actually used (A7 architected timer, for example),
odds are that the interrupt will eventually fire with the event_handler
pointer being NULL.

The obvious fix it to stop the timer before registering the interrupt.

Observed and tested on sun7i (cubietruck).

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/sun4i_timer.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 2fb4695..a4f6119 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -179,6 +179,9 @@ static void __init sun4i_timer_init(struct device_node *node)
 	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
+	/* Make sure timer is stopped before playing with interrupts */
+	sun4i_clkevt_time_stop(0);
+
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
-- 
1.7.9.5

