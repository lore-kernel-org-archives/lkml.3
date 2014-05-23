Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaEWKja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:39:30 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56695 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaEWKcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:42 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 53/71] clocksource: arm_global_timer: Only check for unusable timer on A9
Date: Fri, 23 May 2014 12:31:33 +0200
Message-Id: <1400841111-6683-53-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew.leach@arm.com>

The check for a usable global timer in the probe code does not enquire
which CPU we are currently running on. This can cause the driver to
incorrectly assume we have an unusable global timer if we are running
on a CPU other than A9.

Before checking the CPU revision, ensure we are running on an A9 CPU.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/arm_global_timer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index 0fc31d0..60e5a170 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -246,11 +246,12 @@ static void __init global_timer_of_register(struct device_node *np)
 	int err = 0;
 
 	/*
-	 * In r2p0 the comparators for each processor with the global timer
+	 * In A9 r2p0 the comparators for each processor with the global timer
 	 * fire when the timer value is greater than or equal to. In previous
 	 * revisions the comparators fired when the timer value was equal to.
 	 */
-	if ((read_cpuid_id() & 0xf0000f) < 0x200000) {
+	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9
+	    && (read_cpuid_id() & 0xf0000f) < 0x200000) {
 		pr_warn("global-timer: non support for this cpu version.\n");
 		return;
 	}
-- 
1.7.9.5

