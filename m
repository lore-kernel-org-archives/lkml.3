Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaCKWlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:41:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44955 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbaCKWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:05 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 09/17] clocksource: armada-370-xp: Use atomic access for shared registers
Date: Tue, 11 Mar 2014 23:40:45 +0100
Message-Id: <1394577653-8615-9-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Replace the driver-specific thread-safe shared register API
by the recently introduced atomic_io_clear_set().

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/time-armada-370-xp.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index ee8691b..0451e62 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -85,12 +85,6 @@ static u32 ticks_per_jiffy;
 
 static struct clock_event_device __percpu *armada_370_xp_evt;
 
-static void timer_ctrl_clrset(u32 clr, u32 set)
-{
-	writel((readl(timer_base + TIMER_CTRL_OFF) & ~clr) | set,
-		timer_base + TIMER_CTRL_OFF);
-}
-
 static void local_timer_ctrl_clrset(u32 clr, u32 set)
 {
 	writel((readl(local_base + TIMER_CTRL_OFF) & ~clr) | set,
@@ -245,7 +239,7 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 		clr = TIMER0_25MHZ;
 		enable_mask = TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT);
 	}
-	timer_ctrl_clrset(clr, set);
+	atomic_io_modify(timer_base + TIMER_CTRL_OFF, clr | set, set);
 	local_timer_ctrl_clrset(clr, set);
 
 	/*
@@ -263,7 +257,9 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	writel(0xffffffff, timer_base + TIMER0_VAL_OFF);
 	writel(0xffffffff, timer_base + TIMER0_RELOAD_OFF);
 
-	timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
+	atomic_io_modify(timer_base + TIMER_CTRL_OFF,
+		TIMER0_RELOAD_EN | enable_mask,
+		TIMER0_RELOAD_EN | enable_mask);
 
 	/*
 	 * Set scale and timer for sched_clock.
-- 
1.7.9.5

