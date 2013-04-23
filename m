Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3DWNIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:08:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3DWNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:08:48 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
Date: Tue, 23 Apr 2013 15:08:44 +0200
Message-Id: <1366722524-25991-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <517687AB.1040309@pengutronix.de>
References: <517687AB.1040309@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
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

was lost. This leads to problems with schedule_delayed_work() with a delay of
"1". Resulting in the work not scheduled in time.

This patch fixes the problem by increasing the min_delta to "2" ticks.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
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
1.8.2.rc2

