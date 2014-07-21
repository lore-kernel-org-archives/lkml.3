Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaGURgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:36:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52539 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaGURgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:36:13 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC] suspend/hibernation: Fix racing timers
Date: Mon, 21 Jul 2014 10:35:52 -0700
Message-Id: <1405964152-17865-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms that do not power off during suspend, successfully entering
suspend races with timers.

The race happening in a couple of location is:

  1. disable IRQs 	(e.g. arch_suspend_disable_irqs())
     ...
  2. syscore_suspend()
        -> tick_suspend() 	(timers are turned off here)
     ...
  3. wfi		(wait for wake-IRQ here)

Between steps 1 and 2 the timers can still generate interrupts that are
not handled and stay pending until step 3. That pending IRQ causes an
immediate - spurious - wake.

The solution is to remove the timekeeping suspend/resume functions from
the syscore functions and explictly call them at the appropriate time in
the suspend/hibernation patchs. I.e. timers are suspend _before_ IRQs
get disabled. And accordingly in the resume path.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi,

I think I found the cause of spurious wakes that I'm observing
(https://lkml.org/lkml/2014/6/30/609). This patch seems
to work well for me.

	Sören

 include/linux/time.h      |  2 ++
 kernel/power/hibernate.c  |  9 +++++++++
 kernel/power/suspend.c    |  4 ++++
 kernel/time/timekeeping.c | 20 ++------------------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b2e5af..6ef10c0cb35a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -127,6 +127,8 @@ extern void read_boot_clock(struct timespec *ts);
 extern int persistent_clock_is_local;
 extern int update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
+void timekeeping_suspend(void);
+void timekeeping_resume(void);
 extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fcc2611d3f14..a4e3375318a6 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -285,6 +285,8 @@ static int create_image(int platform_mode)
 	if (error || hibernation_test(TEST_CPUS))
 		goto Enable_cpus;
 
+	timekeeping_suspend();
+
 	local_irq_disable();
 
 	error = syscore_suspend();
@@ -316,6 +318,7 @@ static int create_image(int platform_mode)
 	syscore_resume();
 
  Enable_irqs:
+	timekeeping_resume();
 	local_irq_enable();
 
  Enable_cpus:
@@ -440,6 +443,8 @@ static int resume_target_kernel(bool platform_mode)
 	if (error)
 		goto Enable_cpus;
 
+	timekeeping_suspend();
+
 	local_irq_disable();
 
 	error = syscore_suspend();
@@ -474,6 +479,7 @@ static int resume_target_kernel(bool platform_mode)
 	syscore_resume();
 
  Enable_irqs:
+	timekeeping_resume();
 	local_irq_enable();
 
  Enable_cpus:
@@ -555,6 +561,8 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Platform_finish;
 
+	timekeeping_suspend();
+
 	local_irq_disable();
 	syscore_suspend();
 	if (pm_wakeup_pending()) {
@@ -568,6 +576,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+	timekeeping_resume();
 	local_irq_enable();
 	enable_nonboot_cpus();
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index ed35a4790afe..fcc47bae35d3 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -253,6 +253,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 	if (error || suspend_test(TEST_CPUS))
 		goto Enable_cpus;
 
+	timekeeping_suspend();
+
 	arch_suspend_disable_irqs();
 	BUG_ON(!irqs_disabled());
 
@@ -270,6 +272,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 		syscore_resume();
 	}
 
+	timekeeping_resume();
+
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 32d8d6aaedb8..96c14996da68 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -908,7 +908,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  * xtime/wall_to_monotonic/jiffies/etc are
  * still managed by arch specific suspend/resume code.
  */
-static void timekeeping_resume(void)
+void timekeeping_resume(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct clocksource *clock = tk->clock;
@@ -986,7 +986,7 @@ static void timekeeping_resume(void)
 	hrtimers_resume();
 }
 
-static int timekeeping_suspend(void)
+void timekeeping_suspend(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
@@ -1035,24 +1035,8 @@ static int timekeeping_suspend(void)
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
 	clockevents_suspend();
-
-	return 0;
-}
-
-/* sysfs resume/suspend bits for timekeeping */
-static struct syscore_ops timekeeping_syscore_ops = {
-	.resume		= timekeeping_resume,
-	.suspend	= timekeeping_suspend,
-};
-
-static int __init timekeeping_init_ops(void)
-{
-	register_syscore_ops(&timekeeping_syscore_ops);
-	return 0;
 }
 
-device_initcall(timekeeping_init_ops);
-
 /*
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
-- 
2.0.1.1.gfbfc394

