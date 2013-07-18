Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847Ab3GRXZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:25:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58722 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab3GRXVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 05/17] arch_timer: Move to generic sched_clock framework
Date: Thu, 18 Jul 2013 16:21:18 -0700
Message-Id: <1374189690-10810-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
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
suspend, 2012-10-23) can happen without this patch. Finally, it
allows us to move the sched_clock setup into drivers clocksource
out of the arch ports.

Cc: Christopher Covington <cov@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/arch_timer.c         | 14 --------------
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/kernel/time.c             | 10 ----------
 drivers/clocksource/arm_arch_timer.c |  4 ++++
 4 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 221f07b..1791f12 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/sched_clock.h>
 
 #include <asm/delay.h>
 
@@ -22,13 +21,6 @@ static unsigned long arch_timer_read_counter_long(void)
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
@@ -48,11 +40,5 @@ int __init arch_timer_arch_init(void)
 
 	arch_timer_delay_timer_register();
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
-	sched_clock_func = arch_timer_sched_clock;
-	pr_info("sched_clock: ARM arch timer >56 bits at %ukHz, resolution %uns\n",
-		arch_timer_rate / 1000, sched_clock_mult);
-
 	return 0;
 }
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9737e97..e32b471 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -14,6 +14,7 @@ config ARM64
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 03dc371..29c39d5 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -61,13 +61,6 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-static u64 sched_clock_mult __read_mostly;
-
-unsigned long long notrace sched_clock(void)
-{
-	return arch_timer_read_counter() * sched_clock_mult;
-}
-
 void __init time_init(void)
 {
 	u32 arch_timer_rate;
@@ -78,9 +71,6 @@ void __init time_init(void)
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
-
 	/* Calibrate the delay loop directly */
 	lpj_fine = arch_timer_rate / HZ;
 }
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 053d846..2facf14 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 #include <linux/io.h>
+#include <linux/sched_clock.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -281,6 +282,9 @@ static int __init arch_timer_register(void)
 	timecounter_init(&timecounter, &cyclecounter,
 			 arch_counter_get_cntvct());
 
+	/* 56 bits minimum, so we assume worst case rollover */
+	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
+
 	if (arch_timer_use_virtual) {
 		ppi = arch_timer_ppi[VIRT_PPI];
 		err = request_percpu_irq(ppi, arch_timer_handler_virt,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

