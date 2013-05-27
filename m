Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3E0JxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:53:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3E0Jw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:52:59 -0400
Date: Mon, 27 May 2013 02:52:43 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-7126cac426137633e470167524e7bcb590fd49b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.162888472@linutronix.de>
References: <20130425143436.162888472@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Simplify locking
Git-Commit-ID: 7126cac426137633e470167524e7bcb590fd49b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7126cac426137633e470167524e7bcb590fd49b3
Gitweb:     http://git.kernel.org/tip/7126cac426137633e470167524e7bcb590fd49b3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:16 +0200

clockevents: Simplify locking

Now that the notifier chain is gone there are no other users and it's
pointless to nest tick_device_lock inside of clockevents_lock because
there is no other use case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.162888472@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index dbf4e18..170a4bd 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -33,7 +33,6 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
 ktime_t tick_next_period;
 ktime_t tick_period;
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
-static DEFINE_RAW_SPINLOCK(tick_device_lock);
 
 /*
  * Debugging: see timer_list.c
@@ -206,16 +205,14 @@ static void tick_setup_device(struct tick_device *td,
 }
 
 /*
- * Check, if the new registered device should be used.
+ * Check, if the new registered device should be used. Called with
+ * clockevents_lock held and interrupts disabled.
  */
 void tick_check_new_device(struct clock_event_device *newdev)
 {
 	struct clock_event_device *curdev;
 	struct tick_device *td;
 	int cpu;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
@@ -273,8 +270,6 @@ void tick_check_new_device(struct clock_event_device *newdev)
 	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
-
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 	return;
 
 out_bc:
@@ -282,7 +277,6 @@ out_bc:
 	 * Can the new device be used as a broadcast device ?
 	 */
 	tick_install_broadcast_device(newdev);
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
 /*
@@ -311,9 +305,7 @@ static void tick_shutdown(unsigned int *cpup)
 {
 	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
 	struct clock_event_device *dev = td->evtdev;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	td->mode = TICKDEV_MODE_PERIODIC;
 	if (dev) {
 		/*
@@ -325,26 +317,20 @@ static void tick_shutdown(unsigned int *cpup)
 		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
 static void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_shutdown(td->evtdev);
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
 static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
 	int broadcast = tick_resume_broadcast();
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
 
 	if (!broadcast) {
@@ -353,9 +339,11 @@ static void tick_resume(void)
 		else
 			tick_resume_oneshot();
 	}
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
+/*
+ * Called with clockevents_lock held and interrupts disabled
+ */
 void tick_notify(unsigned long reason, void *dev)
 {
 	switch (reason) {
