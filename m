Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936527Ab3DRTaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:30:21 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:39102 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3DRTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:30:19 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arm@kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 1/2] clocksource: arm_arch_timer: unify sched_clock init
Date: Thu, 18 Apr 2013 14:30:09 -0500
Message-Id: <1366313410-16692-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In preparation to fix initial time and suspend/resume handling, unify
the sched_clock init and implementation for arch timer on arm and arm64.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/arch_timer.c         |   12 ------------
 arch/arm64/kernel/time.c             |   10 ----------
 drivers/clocksource/arm_arch_timer.c |   14 ++++++++++++++
 include/clocksource/arm_arch_timer.h |    1 +
 4 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 59dcdce..df6825e 100644
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
@@ -48,11 +41,6 @@ int __init arch_timer_arch_init(void)
 
 	arch_timer_delay_timer_register();
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
 	sched_clock_func = arch_timer_sched_clock;
-	pr_info("sched_clock: ARM arch timer >56 bits at %ukHz, resolution %uns\n",
-		arch_timer_rate / 1000, sched_clock_mult);
-
 	return 0;
 }
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index a551f88..3a369aa 100644
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
 int read_current_timer(unsigned long *timer_value)
 {
 	*timer_value = arch_timer_read_counter();
@@ -84,9 +77,6 @@ void __init time_init(void)
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
-
 	/* Calibrate the delay loop directly */
 	lpj_fine = arch_timer_rate / HZ;
 }
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 122ff05..17ed8e4 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -266,6 +266,15 @@ static struct notifier_block arch_timer_cpu_nb __cpuinitdata = {
 	.notifier_call = arch_timer_cpu_notify,
 };
 
+static u64 sched_clock_mult __read_mostly;
+
+unsigned long long notrace arch_timer_sched_clock(void)
+{
+	return arch_timer_read_counter() * sched_clock_mult;
+}
+unsigned long long sched_clock(void) \
+	__attribute__((weak, alias("arch_timer_sched_clock")));
+
 static int __init arch_timer_register(void)
 {
 	int err;
@@ -318,6 +327,11 @@ static int __init arch_timer_register(void)
 	/* Immediately configure the timer on the boot CPU */
 	arch_timer_setup(this_cpu_ptr(arch_timer_evt));
 
+	/* Cache the sched_clock multiplier to save a divide in the hot path. */
+	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
+	pr_info("sched_clock: ARM arch timer >56 bits at %ukHz, resolution %lluns\n",
+		arch_timer_rate / 1000, sched_clock_mult);
+
 	return 0;
 
 out_free_irq:
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index e6c9c4c..ded7c77 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -34,6 +34,7 @@
 extern u32 arch_timer_get_rate(void);
 extern u64 (*arch_timer_read_counter)(void);
 extern struct timecounter *arch_timer_get_timecounter(void);
+extern unsigned long long notrace arch_timer_sched_clock(void);
 
 #else
 
-- 
1.7.10.4

