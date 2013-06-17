Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FQWlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:41:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60979 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3FQWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:41:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2] ARM: sched_clock: Load cycle count after epoch stabilizes
Date: Mon, 17 Jun 2013 15:40:58 -0700
Message-Id: <1371508858-23371-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small race between when the cycle count is read from
the hardware and when the epoch stabilizes. Consider this
scenario:

 CPU0                           CPU1
 ----                           ----
 cyc = read_sched_clock()
 cyc_to_sched_clock()
                                 update_sched_clock()
                                  ...
                                  cd.epoch_cyc = cyc;
  epoch_cyc = cd.epoch_cyc;
  ...
  epoch_ns + cyc_to_ns((cyc - epoch_cyc)

The cyc on cpu0 was read before the epoch changed. But we
calculate the nanoseconds based on the new epoch by subtracting
the new epoch from the old cycle count. Since epoch is most likely
larger than the old cycle count we calculate a large number that
will be converted to nanoseconds and added to epoch_ns, causing
time to jump forward too much.

Fix this problem by reading the hardware after the epoch has
stabilized.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/sched_clock.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index aad1ae6..a326f27 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -49,10 +49,14 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace sched_clock_32(void)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
+	u32 cyc;
+
+	if (cd.suspended)
+		return cd.epoch_ns;
 
 	/*
 	 * Load the epoch_cyc and epoch_ns atomically.  We do this by
@@ -68,7 +72,9 @@ static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 		smp_rmb();
 	} while (epoch_cyc != cd.epoch_cyc_copy);
 
-	return epoch_ns + cyc_to_ns((cyc - epoch_cyc) & mask, cd.mult, cd.shift);
+	cyc = read_sched_clock();
+	cyc = (cyc - epoch_cyc) & sched_clock_mask;
+	return epoch_ns + cyc_to_ns(cyc, cd.mult, cd.shift);
 }
 
 /*
@@ -160,19 +166,10 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
-static unsigned long long notrace sched_clock_32(void)
-{
-	u32 cyc = read_sched_clock();
-	return cyc_to_sched_clock(cyc, sched_clock_mask);
-}
-
 unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
 
 unsigned long long notrace sched_clock(void)
 {
-	if (cd.suspended)
-		return cd.epoch_ns;
-
 	return sched_clock_func();
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

