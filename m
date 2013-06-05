Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3FEXzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:55:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60380 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3FEXyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:54:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCHv3 2/3] ARM: arch_timer: Move to generic sched_clock framework
Date: Wed,  5 Jun 2013 16:54:44 -0700
Message-Id: <1370476485-468-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370476485-468-1-git-send-email-sboyd@codeaurora.org>
References: <1370476485-468-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with the generic sched_clock framework now that it
supports 64 bits. This fixes two problems with the current
sched_clock support for machines using the architected timers.
First off, we don't subtract the start value from subsequent
sched_clock calls so we can potentially start off with
sched_clock returning gigantic numbers. Second, there is no
support for suspend/resume handling so problems such as discussed
in 6a4dae5 (ARM: 7565/1: sched: stop sched_clock() during
suspend, 2012-10-23) can happen without this patch.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/arch_timer.c | 14 ++------------
 include/linux/sched_clock.h  |  2 --
 kernel/time/sched_clock.c    | 13 ++++---------
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 221f07b..2966288 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -22,13 +22,6 @@ static unsigned long arch_timer_read_counter_long(void)
 	return arch_timer_read_counter();
 }
 
-static u32 sched_clock_mult __read_mostly;
-
-static unsigned long long notrace arch_timer_sched_clock(void)
-{
-	return arch_timer_read_counter() * sched_clock_mult;
-}
-
 static struct delay_timer arch_delay_timer;
 
 static void __init arch_timer_delay_timer_register(void)
@@ -48,11 +41,8 @@ int __init arch_timer_arch_init(void)
 
 	arch_timer_delay_timer_register();
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
-	sched_clock_func = arch_timer_sched_clock;
-	pr_info("sched_clock: ARM arch timer >56 bits at %ukHz, resolution %uns\n",
-		arch_timer_rate / 1000, sched_clock_mult);
+	/* 56 bits minimum, so we assume worst case rollover */
+	sched_clock_setup(arch_timer_read_counter, 56, arch_timer_rate);
 
 	return 0;
 }
diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index 81baaef..04cee83 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -17,6 +17,4 @@ static inline void sched_clock_postinit(void) { }
 extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 extern void sched_clock_setup(u64 (*read)(void), int bits, unsigned long rate);
 
-extern unsigned long long (*sched_clock_func)(void);
-
 #endif
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 3478b6d..f69addf 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -173,20 +173,15 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	sched_clock_setup(read_sched_clock_32_wrapper, bits, rate);
 }
 
-static unsigned long long notrace sched_clock_32(void)
-{
-	u64 cyc = read_sched_clock();
-	return cyc_to_sched_clock(cyc, sched_clock_mask);
-}
-
-unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
-
 unsigned long long notrace sched_clock(void)
 {
+	u64 cyc;
+
 	if (cd.suspended)
 		return cd.epoch_ns;
 
-	return sched_clock_func();
+	cyc = read_sched_clock();
+	return cyc_to_sched_clock(cyc, sched_clock_mask);
 }
 
 void __init sched_clock_postinit(void)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

