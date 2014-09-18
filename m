Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaIRPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:00:13 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48840 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaIRPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:00:10 -0400
From: Nathan Lynch <nathan_lynch@mentor.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] clocksource: arm_arch_timer: change clocksource name if CP15 unavailable
Date: Thu, 18 Sep 2014 09:59:33 -0500
Message-ID: <1411052390-27238-2-git-send-email-nathan_lynch@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arm and arm64 VDSOs need CP15 access to the architected counter.
If this is unavailable (which is allowed by ARM v7), indicate this by
changing the clocksource name to "arch_mem_counter" before registering
the clocksource.

Suggested by Stephen Boyd.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
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
1.9.3

