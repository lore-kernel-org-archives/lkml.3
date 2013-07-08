Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3GHQww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:52:52 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56432 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3GHQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:52:47 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 2/2] clocksource/cadence_ttc: Reuse clocksource as sched_clock
Date: Mon,  8 Jul 2013 09:51:38 -0700
Message-Id: <1373302298-27957-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse the TTC clocksource timer as sched clock provider.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - #include linux/sched_clock.h instead of asm/sched_clock.h
 - remove Kconfig options and #ifdefs around sched_clock related code
    The reasons for having those are obsolete, since ARM deprecated its
    custom sched_clock framework and migrated to the common one.

 drivers/clocksource/cadence_ttc_timer.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 0eefc8d..b2bb3a4b 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -21,6 +21,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/slab.h>
+#include <linux/sched_clock.h>
 
 /*
  * This driver configures the 2 16-bit count-up timers as follows:
@@ -94,6 +95,8 @@ struct ttc_timer_clockevent {
 #define to_ttc_timer_clkevent(x) \
 		container_of(x, struct ttc_timer_clockevent, ce)
 
+static void __iomem *ttc_sched_clock_val_reg;
+
 /**
  * ttc_set_interval - Set the timer interval value
  *
@@ -155,6 +158,11 @@ static cycle_t __ttc_clocksource_read(struct clocksource *cs)
 				TTC_COUNT_VAL_OFFSET);
 }
 
+static u32 notrace ttc_sched_clock_read(void)
+{
+	return __raw_readl(ttc_sched_clock_val_reg);
+}
+
 /**
  * ttc_set_next_event - Sets the time interval for next event
  *
@@ -296,6 +304,10 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 		kfree(ttccs);
 		return;
 	}
+
+	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
+	setup_sched_clock(ttc_sched_clock_read, 16,
+			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
 }
 
 static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
-- 
1.8.3.2

