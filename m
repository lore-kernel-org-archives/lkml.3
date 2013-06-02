Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3FBGk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:40:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35585 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3FBGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:50 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 6/6] arm64: Move to generic sched_clock infrastructure
Date: Sat,  1 Jun 2013 23:39:43 -0700
Message-Id: <1370155183-31421-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic sched_clock infrastructure instead of rolling our
own. This has the added benefit of fixing suspend/resume as
outlined in 6a4dae5 (ARM: 7565/1: sched: stop sched_clock()
during suspend, 2012-10-23) and correcting the timestamps when
the hardware returns a value instead of 0 upon the first read.

Tested-by: Christopher Covington <cov@codeaurora.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm64/Kconfig       |  1 +
 arch/arm64/kernel/time.c | 11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 56b3f6d..f9c6e92 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -13,6 +13,7 @@ config ARM64
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index a551f88..fd07ef9 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/clocksource.h>
+#include <linux/sched_clock.h>
 
 #include <clocksource/arm_arch_timer.h>
 
@@ -61,13 +62,6 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-static u64 sched_clock_mult __read_mostly;
-
-unsigned long long notrace sched_clock(void)
-{
-	return arch_timer_read_counter() * sched_clock_mult;
-}
-
 int read_current_timer(unsigned long *timer_value)
 {
 	*timer_value = arch_timer_read_counter();
@@ -84,8 +78,7 @@ void __init time_init(void)
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
+	setup_sched_clock_64(arch_timer_read_counter, 56, arch_timer_rate);
 
 	/* Calibrate the delay loop directly */
 	lpj_fine = arch_timer_rate / HZ;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

