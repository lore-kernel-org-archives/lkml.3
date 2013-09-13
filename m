Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3IMNCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:02:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45794 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3IMNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:02:53 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, nicolas.ferre@atmel.com, john.stultz@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marc Pignat <marc.pignat@hevs.ch>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: [PATCH] [PATCH] clocksource: tcb: fix min_delta calculation
Date: Fri, 13 Sep 2013 15:02:45 +0200
Message-Id: <1379077365-18458-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit

    77cc982 clocksource: use clockevents_config_and_register() where possible

switches from manually calculating min_delta_ns (and others) and
clockevents_register_device() to automatic calculation via
clockevents_config_and_register(). During this conversation the "+ 1" in

    min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;

was lost. This leads to problems when programming clock events, resuling in
e.g. a sleep(2) sleeping more than 3 seconds. The "+ 1" was added in the
original code to fix a rounding problem in clockevent_delta2ns(), see
http://permalink.gmane.org/gmane.linux.kernel/549744 for background
information.

This patch fixes the problem by increasing the min_delta to "2" ticks.

Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Ronald Wahl <ronald.wahl@raritan.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Changes since v1:
- Improved description. Thanks to Ronald Wahl.

 drivers/clocksource/tcb_clksrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 8a61872..7cf6dc7 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -197,7 +197,7 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
+	clockevents_config_and_register(&clkevt.clkevt, 32768, 2, 0xffff);
 
 	setup_irq(irq, &tc_irqaction);
 }
-- 
1.8.4.rc3

