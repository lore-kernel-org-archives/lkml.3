Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3ALLub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:50:31 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:32443
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab3ALLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:50:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dh8275chz2dh87h2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: John Stultz <john.stultz@linaro.org>, <arm@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Andres Salomon <dilinger@queued.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 3/3] clocksource: use clockevents_config_and_register() where possible
Date: Sat, 12 Jan 2013 19:50:06 +0800
Message-ID: <1357991406-22778-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clockevent core is able to figure out the best mult and shift,
calculate min_delta_ns and max_delta_ns, with the necessary info passed
into clockevents_config_and_register().  Use this combined configure
and register function where possible to make the codes less error prone
and gain some positive diff stat.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/cs5535-clockevt.c |   11 ++---------
 drivers/clocksource/sunxi_timer.c     |   11 ++---------
 drivers/clocksource/tcb_clksrc.c      |    7 +------
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index d927938..ea21048 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -100,7 +100,6 @@ static struct clock_event_device cs5535_clockevent = {
 	.set_mode = mfgpt_set_mode,
 	.set_next_event = mfgpt_next_event,
 	.rating = 250,
-	.shift = 32
 };
 
 static irqreturn_t mfgpt_tick(int irq, void *dev_id)
@@ -169,17 +168,11 @@ static int __init cs5535_mfgpt_init(void)
 	cs5535_mfgpt_write(cs5535_event_clock, MFGPT_REG_SETUP, val);
 
 	/* Set up the clock event */
-	cs5535_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC,
-			cs5535_clockevent.shift);
-	cs5535_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
-			&cs5535_clockevent);
-	cs5535_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,
-			&cs5535_clockevent);
-
 	printk(KERN_INFO DRV_NAME
 		": Registering MFGPT timer as a clock event, using IRQ %d\n",
 		timer_irq);
-	clockevents_register_device(&cs5535_clockevent);
+	clockevents_config_and_register(&cs5535_clockevent, MFGPT_HZ,
+					0xF, 0xFFFE);
 
 	return 0;
 
diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
index 3cd1bd3..f911866 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sunxi_timer.c
@@ -74,7 +74,6 @@ static int sunxi_clkevt_next_event(unsigned long evt,
 
 static struct clock_event_device sunxi_clockevent = {
 	.name = "sunxi_tick",
-	.shift = 32,
 	.rating = 300,
 	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode = sunxi_clkevt_mode,
@@ -154,16 +153,10 @@ static void __init sunxi_timer_init(void)
 	val = readl(timer_base + TIMER_CTL_REG);
 	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG);
 
-	sunxi_clockevent.mult = div_sc(rate / TIMER_SCAL,
-				NSEC_PER_SEC,
-				sunxi_clockevent.shift);
-	sunxi_clockevent.max_delta_ns = clockevent_delta2ns(0xff,
-							    &sunxi_clockevent);
-	sunxi_clockevent.min_delta_ns = clockevent_delta2ns(0x1,
-							    &sunxi_clockevent);
 	sunxi_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_register_device(&sunxi_clockevent);
+	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
+					0x1, 0xff);
 }
 
 struct sys_timer sunxi_timer = {
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 32cb929..8a61872 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -157,7 +157,6 @@ static struct tc_clkevt_device clkevt = {
 		.name		= "tc_clkevt",
 		.features	= CLOCK_EVT_FEAT_PERIODIC
 					| CLOCK_EVT_FEAT_ONESHOT,
-		.shift		= 32,
 		/* Should be lower than at91rm9200's system timer */
 		.rating		= 125,
 		.set_next_event	= tc_next_event,
@@ -196,13 +195,9 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	timer_clock = clk32k_divisor_idx;
 
-	clkevt.clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.clkevt.shift);
-	clkevt.clkevt.max_delta_ns
-		= clockevent_delta2ns(0xffff, &clkevt.clkevt);
-	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	clockevents_register_device(&clkevt.clkevt);
+	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
 
 	setup_irq(irq, &tc_irqaction);
 }
-- 
1.7.9.5


