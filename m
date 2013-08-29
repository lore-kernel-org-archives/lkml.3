Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3H2Rxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:53:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49536 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3H2Rxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:53:42 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 2/3] clocksource/cadence_ttc: Make clocksource optional
Date: Thu, 29 Aug 2013 10:53:09 -0700
Message-Id: <1377798790-28927-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms, like Zynq, the input clock for the TTC is directly
derived from the CPU clock, which means it scales when cpufreq adjusts
the CPU frequency.
At the same time the clocksource core expects a clocksource to be
stable and doesn't allow frequency adjustments.

Therefore a new flag - 'input-clock-unstable' - is added to the DT
bindings for this driver. In case the flag is present the driver does
not register the timer as clocksource.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt | 4 ++++
 drivers/clocksource/cadence_ttc_timer.c                       | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
index 993695c..a936c0a 100644
--- a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
+++ b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
@@ -6,6 +6,10 @@ Required properties:
 - interrupts : A list of 3 interrupts; one per timer channel.
 - clocks: phandle to the source clock
 
+Optional properties:
+- input-clock-unstable : Mark the timer's input clock as unstable. E.g. it
+			 scales with cpufreq.
+
 Example:
 
 ttc0: ttc0@f8001000 {
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 99ec898..66aaf6a 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -407,7 +407,8 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
-	ttc_setup_clocksource(clk_cs, timer_baseaddr);
+	if (!of_property_read_bool(timer, "input-clock-unstable"))
+		ttc_setup_clocksource(clk_cs, timer_baseaddr);
 	ttc_setup_clockevent(clk_ce, timer_baseaddr + 4, irq);
 
 	pr_info("%s #0 at %p, irq=%d\n", timer->name, timer_baseaddr, irq);
-- 
1.8.4

