Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FBGkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:40:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35551 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3FBGjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 2/6] ARM: sched_clock: Return suspended count earlier
Date: Sat,  1 Jun 2013 23:39:39 -0700
Message-Id: <1370155183-31421-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're suspended and sched_clock() is called we're going to
read the hardware one more time and throw away that value and
return back the cached value we saved during the suspend
callback. This is wasteful. Let's short circuit all that and
return the cached value as early as possible if we're suspended.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/sched_clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 45efe86..a781c59 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -55,9 +55,6 @@ static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 	u64 epoch_ns;
 	u32 epoch_cyc;
 
-	if (cd.suspended)
-		return cd.epoch_ns;
-
 	/*
 	 * Load the epoch_cyc and epoch_ns atomically.  We do this by
 	 * ensuring that we always write epoch_cyc, epoch_ns and
@@ -174,6 +171,9 @@ unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
 
 unsigned long long notrace sched_clock(void)
 {
+	if (cd.suspended)
+		return cd.epoch_ns;
+
 	return sched_clock_func();
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

