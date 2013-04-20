Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470Ab3DTA3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:29:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47892 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184Ab3DTA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:29:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,512,1363158000"; 
   d="scan'208";a="40095502"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] ARM: sched_clock: Return suspended count earlier
Date: Fri, 19 Apr 2013 17:29:04 -0700
Message-Id: <1366417746-24990-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're suspended and sched_clock() is called we're going to
read the hardware one more time and throw away that value and
return back the cached value we saved during the suspend
callback. This is wasteful, let's short circuit all that and
return the cached value if we're suspended as early as possible.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/sched_clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 48ab64a..29ac613 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -55,9 +55,6 @@ static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
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

