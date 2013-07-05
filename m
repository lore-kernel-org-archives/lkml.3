Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3GEJNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:13:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3GEJNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:13:44 -0400
Date: Fri, 5 Jul 2013 02:13:08 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-332962f2c88868ed3cdab466870baaa34dd58612@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        tim.c.chen@linux.intel.com, alex.shi@intel.com, andi.kleen@intel.com,
        john.stultz@linaro.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        tim.c.chen@linux.intel.com, alex.shi@intel.com, andi.kleen@intel.com,
        john.stultz@linaro.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.02.1307042239150.11637@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1307042239150.11637@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource:
  Reselect clocksource when watchdog validated high-res capability
Git-Commit-ID: 332962f2c88868ed3cdab466870baaa34dd58612
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 02:13:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  332962f2c88868ed3cdab466870baaa34dd58612
Gitweb:     http://git.kernel.org/tip/332962f2c88868ed3cdab466870baaa34dd58612
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 4 Jul 2013 22:46:45 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 5 Jul 2013 11:09:28 +0200

clocksource: Reselect clocksource when watchdog validated high-res capability

Up to commit 5d33b883a (clocksource: Always verify highres capability)
we had no sanity check when selecting a clocksource, which prevented
that a non highres capable clocksource is used when the system already
switched to highres/nohz mode.

The new sanity check works as Alex and Tim found out. It prevents the
TSC from being used. This happens because on x86 the boot process
looks like this:

 tsc_start_freqency_validation(TSC);
 clocksource_register(HPET);
 clocksource_done_booting();
	clocksource_select()
		Selects HPET which is valid for high-res

 switch_to_highres();

 clocksource_register(TSC);
 	TSC is not selected, because it is not yet
	flagged as VALID_HIGH_RES

 clocksource_watchdog()
	Validates TSC for highres, but that does not make TSC
	the current clocksource.

Before the sanity check was added, we installed TSC unvalidated which
worked most of the time. If the TSC was really detected as unstable,
then the unstable logic removed it and installed HPET again.

The sanity check is correct and needed. So the watchdog needs to kick
a reselection of the clocksource, when it qualifies TSC as a valid
high res clocksource.

To solve this, we mark the clocksource which got the flag
CLOCK_SOURCE_VALID_FOR_HRES set by the watchdog with an new flag
CLOCK_SOURCE_RESELECT and trigger the watchdog thread. The watchdog
thread evaluates the flag and invokes clocksource_select() when set.

To avoid that the clocksource_done_booting() code, which is about to
install the first real clocksource anyway, needs to go through
clocksource_select and tick_oneshot_notify() pointlessly, split out
the clocksource_watchdog_kthread() list walk code and invoke the
select/notify only when called from clocksource_watchdog_kthread().

So clocksource_done_booting() can utilize the same splitout code
without the select/notify invocation and the clocksource_mutex
unlock/relock dance.

Reported-and-tested-by: Alex Shi <alex.shi@intel.com>
Cc: Hans Peter Anvin <hpa@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1307042239150.11637@ionos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |  1 +
 kernel/time/clocksource.c   | 57 +++++++++++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 2f39a49..dbbf8aa 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -210,6 +210,7 @@ struct clocksource {
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 #define CLOCK_SOURCE_UNSTABLE			0x40
 #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
+#define CLOCK_SOURCE_RESELECT			0x100
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e713ef7..50a8736 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -181,6 +181,7 @@ static int finished_booting;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static void clocksource_watchdog_work(struct work_struct *work);
+static void clocksource_select(void);
 
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
@@ -301,13 +302,30 @@ static void clocksource_watchdog(unsigned long data)
 		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
 		    (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
 		    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
+			/* Mark it valid for high-res. */
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+
+			/*
+			 * clocksource_done_booting() will sort it if
+			 * finished_booting is not set yet.
+			 */
+			if (!finished_booting)
+				continue;
+
 			/*
-			 * We just marked the clocksource as highres-capable,
-			 * notify the rest of the system as well so that we
-			 * transition into high-res mode:
+			 * If this is not the current clocksource let
+			 * the watchdog thread reselect it. Due to the
+			 * change to high res this clocksource might
+			 * be preferred now. If it is the current
+			 * clocksource let the tick code know about
+			 * that change.
 			 */
-			tick_clock_notify();
+			if (cs != curr_clocksource) {
+				cs->flags |= CLOCK_SOURCE_RESELECT;
+				schedule_work(&watchdog_work);
+			} else {
+				tick_clock_notify();
+			}
 		}
 	}
 
@@ -404,19 +422,25 @@ static void clocksource_dequeue_watchdog(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-static int clocksource_watchdog_kthread(void *data)
+static int __clocksource_watchdog_kthread(void)
 {
 	struct clocksource *cs, *tmp;
 	unsigned long flags;
 	LIST_HEAD(unstable);
+	int select = 0;
 
-	mutex_lock(&clocksource_mutex);
 	spin_lock_irqsave(&watchdog_lock, flags);
-	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
+	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
 			list_del_init(&cs->wd_list);
 			list_add(&cs->wd_list, &unstable);
+			select = 1;
+		}
+		if (cs->flags & CLOCK_SOURCE_RESELECT) {
+			cs->flags &= ~CLOCK_SOURCE_RESELECT;
+			select = 1;
 		}
+	}
 	/* Check if the watchdog timer needs to be stopped. */
 	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
@@ -426,6 +450,14 @@ static int clocksource_watchdog_kthread(void *data)
 		list_del_init(&cs->wd_list);
 		__clocksource_change_rating(cs, 0);
 	}
+	return select;
+}
+
+static int clocksource_watchdog_kthread(void *data)
+{
+	mutex_lock(&clocksource_mutex);
+	if (__clocksource_watchdog_kthread())
+		clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
@@ -445,7 +477,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
-static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+static inline int __clocksource_watchdog_kthread(void) { return 0; }
 static bool clocksource_is_watchdog(struct clocksource *cs) { return false; }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
@@ -647,16 +679,11 @@ static int __init clocksource_done_booting(void)
 {
 	mutex_lock(&clocksource_mutex);
 	curr_clocksource = clocksource_default_clock();
-	mutex_unlock(&clocksource_mutex);
-
 	finished_booting = 1;
-
 	/*
 	 * Run the watchdog first to eliminate unstable clock sources
 	 */
-	clocksource_watchdog_kthread(NULL);
-
-	mutex_lock(&clocksource_mutex);
+	__clocksource_watchdog_kthread();
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
@@ -789,7 +816,6 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating)
 	list_del(&cs->list);
 	cs->rating = rating;
 	clocksource_enqueue(cs);
-	clocksource_select();
 }
 
 /**
@@ -801,6 +827,7 @@ void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	mutex_lock(&clocksource_mutex);
 	__clocksource_change_rating(cs, rating);
+	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_change_rating);
