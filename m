Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3LJTRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:17:52 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:56309 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3LJTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:16 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/6] clocksource: armada-370-xp: Register sched_clock after the counter reset
Date: Tue, 10 Dec 2013 20:16:08 +0100
Message-Id: <1386702972-25565-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
References: <52A767CB.3010501@linaro.org>
 <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

This commit registers the sched_clock _after_ the counter reset
(instead of before). This removes the timestamp 'jump' in kernel
log messages.

Before this change:

[    0.000000] sched_clock: 32 bits at 25MHz, resolution 40ns, wraps every 171798691800ns
[    0.000000] Initializing Coherency fabric
[    0.000000] Aurora cache controller enabled
[    0.000000] l2x0: 16 ways, CACHE_ID 0x00000100, AUX_CTRL 0x1a696b12, Cache size: 1024 kB
[  163.507447] Calibrating delay loop... 1325.05 BogoMIPS (lpj=662528)
[  163.521419] pid_max: default: 32768 minimum: 301
[  163.526185] Mount-cache hash table entries: 512
[  163.531095] CPU: Testing write buffer coherency: ok

After this change:

[    0.000000] sched_clock: 32 bits at 25MHz, resolution 40ns, wraps every 171798691800ns
[    0.000000] Initializing Coherency fabric
[    0.000000] Aurora cache controller enabled
[    0.000000] l2x0: 16 ways, CACHE_ID 0x00000100, AUX_CTRL 0x1a696b12, Cache size: 1024 kB
[    0.016849] Calibrating delay loop... 1325.05 BogoMIPS (lpj=662528)
[    0.030820] pid_max: default: 32768 minimum: 301
[    0.035588] Mount-cache hash table entries: 512
[    0.040500] CPU: Testing write buffer coherency: ok

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/clocksource/time-armada-370-xp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index d8e47e5..4e7f680 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -256,11 +256,6 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	ticks_per_jiffy = (timer_clk + HZ / 2) / HZ;
 
 	/*
-	 * Set scale and timer for sched_clock.
-	 */
-	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
-
-	/*
 	 * Setup free-running clocksource timer (interrupts
 	 * disabled).
 	 */
@@ -270,6 +265,11 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	timer_ctrl_clrset(0, TIMER0_EN | TIMER0_RELOAD_EN |
 			     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
 
+	/*
+	 * Set scale and timer for sched_clock.
+	 */
+	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
+
 	clocksource_mmio_init(timer_base + TIMER0_VAL_OFF,
 			      "armada_370_xp_clocksource",
 			      timer_clk, 300, 32, clocksource_mmio_readl_down);
-- 
1.7.9.5

