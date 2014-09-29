Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaI2AYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:35342 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaI2AYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:24:03 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] clocksource: arm_arch_timer: Change clocksource name if CP15 unavailable
Date: Mon, 29 Sep 2014 02:23:44 +0200
Message-Id: <1411950226-21598-11-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <nathan_lynch@mentor.com>

The arm and arm64 VDSOs need CP15 access to the architected counter.
If this is unavailable (which is allowed by ARM v7), indicate this by
changing the clocksource name to "arch_mem_counter" before registering
the clocksource.

Suggested by Stephen Boyd.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 7e267e3..e0e7729 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -429,11 +429,19 @@ static void __init arch_counter_register(unsigned type)
 	u64 start_count;
 
 	/* Register the CP15 based counter if we have one */
-	if (type & ARCH_CP15_TIMER)
+	if (type & ARCH_CP15_TIMER) {
 		arch_timer_read_counter = arch_counter_get_cntvct;
-	else
+	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 
+		/* If the clocksource name is "arch_sys_counter" the
+		 * VDSO will attempt to read the CP15-based counter.
+		 * Ensure this does not happen when CP15-based
+		 * counter is not available.
+		 */
+		clocksource_counter.name = "arch_mem_counter";
+	}
+
 	start_count = arch_timer_read_counter();
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 	cyclecounter.mult = clocksource_counter.mult;
-- 
1.9.1

