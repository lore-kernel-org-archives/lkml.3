Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaHTUzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:55:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54763 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaHTUzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:55:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] PM / sleep: Fix racing timers
Date: Wed, 20 Aug 2014 13:55:09 -0700
Message-Id: <1408568109-30297-1-git-send-email-soren.brinkmann@xilinx.com>
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

  1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
     ...
  2. syscore_suspend()
      -> timekeeping_suspend()
       -> clockevents_notify(SUSPEND)
        -> tick_suspend()   	(timers are turned off here)
     ...
  3. wfi            		(wait for wake-IRQ here)

Between steps 1 and 2 the timers can still generate interrupts that are
not handled and stay pending until step 3. That pending IRQ causes an
immediate - spurious - wake.

The solution is to move the clockevents suspend/resume notification
out of the syscore_suspend step and explictly call them at the appropriate
time in the suspend/hibernation paths. I.e. timers are suspend _before_
IRQs get disabled. And accordingly in the resume path.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi,

there was a little of an dicussion on the RFC for this patch, but that
eventually ended (https://lkml.org/lkml/2014/7/21/493).
In the meantime I found one small flaw that is fixed in this patch (changelog
below).
This resolves the issues I see on my Zynq (ARM) platform and I also patched my
Laptop's (x86_64) kernel with this where it looks good as well. Though, in both
cases only suspend is used. Any testing - especially of hibernation - would
be much appreciated.

	Thanks,
	Sören

Changes since RFC:
 - remove resume notification from syscore_resume path.
---
 kernel/power/hibernate.c  | 9 +++++++++
 kernel/power/suspend.c    | 5 +++++
 kernel/time/timekeeping.c | 3 ---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a9dfa79b6bab..76f15644aec8 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -285,6 +285,8 @@ static int create_image(int platform_mode)
 	if (error || hibernation_test(TEST_CPUS))
 		goto Enable_cpus;
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
 	local_irq_disable();
 
 	error = syscore_suspend();
@@ -316,6 +318,7 @@ static int create_image(int platform_mode)
 	syscore_resume();
 
  Enable_irqs:
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 	local_irq_enable();
 
  Enable_cpus:
@@ -438,6 +441,8 @@ static int resume_target_kernel(bool platform_mode)
 	if (error)
 		goto Enable_cpus;
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
 	local_irq_disable();
 
 	error = syscore_suspend();
@@ -472,6 +477,7 @@ static int resume_target_kernel(bool platform_mode)
 	syscore_resume();
 
  Enable_irqs:
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 	local_irq_enable();
 
  Enable_cpus:
@@ -550,6 +556,8 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Platform_finish;
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
 	local_irq_disable();
 	syscore_suspend();
 	if (pm_wakeup_pending()) {
@@ -563,6 +571,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 	local_irq_enable();
 	enable_nonboot_cpus();
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6dadb25cb0d8..6bba2f907bcb 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/clockchips.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
@@ -294,6 +295,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 	if (error || suspend_test(TEST_CPUS))
 		goto Enable_cpus;
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
 	arch_suspend_disable_irqs();
 	BUG_ON(!irqs_disabled());
 
@@ -311,6 +314,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 		syscore_resume();
 	}
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb4a9c2cf8d9..f13332185b07 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1188,8 +1188,6 @@ static void timekeeping_resume(void)
 
 	touch_softlockup_watchdog();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
-
 	/* Resume hrtimers */
 	hrtimers_resume();
 }
@@ -1242,7 +1240,6 @@ static int timekeeping_suspend(void)
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
 	clockevents_suspend();
 
-- 
2.0.1.1.gfbfc394

