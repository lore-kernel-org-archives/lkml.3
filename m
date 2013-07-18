Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863Ab3GRXXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:23:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58806 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934802Ab3GRXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH v4 15/17] clocksource: sirf: Switch to sched_clock_register() and use 64 bits
Date: Thu, 18 Jul 2013 16:21:28 -0700
Message-Id: <1374189690-10810-16-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface and use all 64 bits of this timer.

Cc: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/timer-prima2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index ef3cfb2..8a492d3 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -165,9 +165,9 @@ static struct irqaction sirfsoc_timer_irq = {
 };
 
 /* Overwrite weak default sched_clock with more precise one */
-static u32 notrace sirfsoc_read_sched_clock(void)
+static u64 notrace sirfsoc_read_sched_clock(void)
 {
-	return (u32)(sirfsoc_timer_read(NULL) & 0xffffffff);
+	return sirfsoc_timer_read(NULL);
 }
 
 static void __init sirfsoc_clockevent_init(void)
@@ -206,7 +206,7 @@ static void __init sirfsoc_prima2_timer_init(struct device_node *np)
 
 	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE));
 
-	setup_sched_clock(sirfsoc_read_sched_clock, 32, CLOCK_TICK_RATE);
+	sched_clock_register(sirfsoc_read_sched_clock, 64, CLOCK_TICK_RATE);
 
 	BUG_ON(setup_irq(sirfsoc_timer_irq.irq, &sirfsoc_timer_irq));
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

