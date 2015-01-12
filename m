Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbbALSGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57702 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbbALSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nathan Lynch <nathan_lynch@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 087/216] clocksource: arm_arch_timer: Change clocksource name if CP15 unavailable
Date: Mon, 12 Jan 2015 18:03:24 +0000
Message-Id: <1421085933-32536-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan_lynch@mentor.com>

commit 423bd69e69f565167ba14e2fe61df76c3c4a0d26 upstream.

The arm and arm64 VDSOs need CP15 access to the architected counter.
If this is unavailable (which is allowed by ARM v7), indicate this by
changing the clocksource name to "arch_mem_counter" before registering
the clocksource.

Suggested by Stephen Boyd.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clocksource/arm_arch_timer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec13429d..c99afdf12e98 100644
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
2.1.4

