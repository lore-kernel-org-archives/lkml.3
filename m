Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3E0JyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:54:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab3E0JyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:54:15 -0400
Date: Mon, 27 May 2013 02:54:00 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8c53daf63f56791ed47fc585206ef3049489612f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.235746557@linutronix.de>
References: <20130425143436.235746557@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Move the tick_notify()
  switch case to clockevents_notify()
Git-Commit-ID: 8c53daf63f56791ed47fc585206ef3049489612f
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

Commit-ID:  8c53daf63f56791ed47fc585206ef3049489612f
Gitweb:     http://git.kernel.org/tip/8c53daf63f56791ed47fc585206ef3049489612f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:16 +0200

clockevents: Move the tick_notify() switch case to clockevents_notify()

No need to call another function and have duplicated cases.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.235746557@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c   | 28 ++++++++++++++++++++++++-
 kernel/time/tick-common.c   | 50 ++++-----------------------------------------
 kernel/time/tick-internal.h |  5 ++++-
 3 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index dd70b48..0e3a844 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -404,10 +404,36 @@ void clockevents_notify(unsigned long reason, void *arg)
 	int cpu;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	tick_notify(reason, arg);
 
 	switch (reason) {
+	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
+	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
+	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		tick_broadcast_on_off(reason, arg);
+		break;
+
+	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
+	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
+		tick_broadcast_oneshot_control(reason);
+		break;
+
+	case CLOCK_EVT_NOTIFY_CPU_DYING:
+		tick_handover_do_timer(arg);
+		break;
+
+	case CLOCK_EVT_NOTIFY_SUSPEND:
+		tick_suspend();
+		tick_suspend_broadcast();
+		break;
+
+	case CLOCK_EVT_NOTIFY_RESUME:
+		tick_resume();
+		break;
+
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
+		tick_shutdown_broadcast_oneshot(arg);
+		tick_shutdown_broadcast(arg);
+		tick_shutdown(arg);
 		/*
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 170a4bd..84c7cfc 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -284,7 +284,7 @@ out_bc:
  *
  * Called with interrupts disabled.
  */
-static void tick_handover_do_timer(int *cpup)
+void tick_handover_do_timer(int *cpup)
 {
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = cpumask_first(cpu_online_mask);
@@ -301,7 +301,7 @@ static void tick_handover_do_timer(int *cpup)
  * access the hardware device itself.
  * We just set the mode and remove it from the lists.
  */
-static void tick_shutdown(unsigned int *cpup)
+void tick_shutdown(unsigned int *cpup)
 {
 	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
 	struct clock_event_device *dev = td->evtdev;
@@ -319,14 +319,14 @@ static void tick_shutdown(unsigned int *cpup)
 	}
 }
 
-static void tick_suspend(void)
+void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 
 	clockevents_shutdown(td->evtdev);
 }
 
-static void tick_resume(void)
+void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	int broadcast = tick_resume_broadcast();
@@ -341,48 +341,6 @@ static void tick_resume(void)
 	}
 }
 
-/*
- * Called with clockevents_lock held and interrupts disabled
- */
-void tick_notify(unsigned long reason, void *dev)
-{
-	switch (reason) {
-
-	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
-	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		tick_broadcast_on_off(reason, dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
-	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
-		break;
-
-	case CLOCK_EVT_NOTIFY_CPU_DYING:
-		tick_handover_do_timer(dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_CPU_DEAD:
-		tick_shutdown_broadcast_oneshot(dev);
-		tick_shutdown_broadcast(dev);
-		tick_shutdown(dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_SUSPEND:
-		tick_suspend();
-		tick_suspend_broadcast();
-		break;
-
-	case CLOCK_EVT_NOTIFY_RESUME:
-		tick_resume();
-		break;
-
-	default:
-		break;
-	}
-}
-
 /**
  * tick_init - initialize the tick control
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 60742fe..06bfc88 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -18,8 +18,11 @@ extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
-extern void tick_notify(unsigned long reason, void *dev);
 extern void tick_check_new_device(struct clock_event_device *dev);
+extern void tick_handover_do_timer(int *cpup);
+extern void tick_shutdown(unsigned int *cpup);
+extern void tick_suspend(void);
+extern void tick_resume(void);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 
