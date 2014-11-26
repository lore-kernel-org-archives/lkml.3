Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaKZNI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:08:29 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33773 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaKZNI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:08:26 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ezequiel.garcia@free-electrons.com, yl22@csr.com
Subject: [PATCH 4/4] clocksource: armada-370-xp: Use the reference clock on A375 SoC
Date: Wed, 26 Nov 2014 14:08:14 +0100
Message-Id: <1417007294-19869-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417007294-19869-1-git-send-email-daniel.lezcano@linaro.org>
References: <5475D044.5060607@linaro.org>
 <1417007294-19869-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

The 25 MHz reference clock has better stability so its use is preferred over the
core clock.

This commit takes advantage of the already introduced Armada 375 devicetree
compatible string and adds a new timer initialization. If available, the timer
will use the reference clock (named as 'fixed'). Otherwise, it falls back to the
previous behavior.

Acked-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Wim Van Sebroeck <wim@iguana.be>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../bindings/timer/marvell,armada-370-xp-timer.txt |  9 ++++---
 drivers/clocksource/time-armada-370-xp.c           | 28 ++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
index f455182..e9c78ce 100644
--- a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
+++ b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
@@ -2,8 +2,10 @@ Marvell Armada 370 and Armada XP Timers
 ---------------------------------------
 
 Required properties:
-- compatible: Should be either "marvell,armada-370-timer" or
-  "marvell,armada-xp-timer" as appropriate.
+- compatible: Should be one of the following
+              "marvell,armada-370-timer",
+	      "marvell,armada-375-timer",
+	      "marvell,armada-xp-timer".
 - interrupts: Should contain the list of Global Timer interrupts and
   then local timer interrupts
 - reg: Should contain location and length for timers register. First
@@ -13,7 +15,8 @@ Required properties:
 Clocks required for compatible = "marvell,armada-370-timer":
 - clocks : Must contain a single entry describing the clock input
 
-Clocks required for compatible = "marvell,armada-xp-timer":
+Clocks required for compatibles = "marvell,armada-xp-timer",
+				  "marvell,armada-375-timer":
 - clocks : Must contain an entry for each entry in clock-names.
 - clock-names : Must include the following entries:
   "nbclk" (L2/coherency fabric clock),
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index d8555f9..3a0704b 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -301,6 +301,34 @@ static void __init armada_xp_timer_init(struct device_node *np)
 CLOCKSOURCE_OF_DECLARE(armada_xp, "marvell,armada-xp-timer",
 		       armada_xp_timer_init);
 
+static void __init armada_375_timer_init(struct device_node *np)
+{
+	struct clk *clk;
+
+	clk = of_clk_get_by_name(np, "fixed");
+	if (!IS_ERR(clk)) {
+		clk_prepare_enable(clk);
+		timer_clk = clk_get_rate(clk);
+	} else {
+
+		/*
+		 * This fallback is required in order to retain proper
+		 * devicetree backwards compatibility.
+		 */
+		clk = of_clk_get(np, 0);
+
+		/* Must have at least a clock */
+		BUG_ON(IS_ERR(clk));
+		clk_prepare_enable(clk);
+		timer_clk = clk_get_rate(clk) / TIMER_DIVIDER;
+		timer25Mhz = false;
+	}
+
+	armada_370_xp_timer_common_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(armada_375, "marvell,armada-375-timer",
+		       armada_375_timer_init);
+
 static void __init armada_370_timer_init(struct device_node *np)
 {
 	struct clk *clk = of_clk_get(np, 0);
-- 
1.9.1

