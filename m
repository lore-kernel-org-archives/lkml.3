Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaD0MjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 08:39:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65479 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751259AbaD0MjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 08:39:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] cpuidle: Combine cpuidle_enabled() with cpuidle_select()
Date: Sun, 27 Apr 2014 14:54:08 +0200
Message-ID: <6198143.QbTeRSVYv3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2471963.urOyfY8mOG@vostro.rjw.lan>
References: <2471963.urOyfY8mOG@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since both cpuidle_enabled() and cpuidle_select() are only called by
cpuidle_idle_call(), it is not really useful to keep them separate
and combining them will help to avoid complicating cpuidle_idle_call()
even further if governors are changed to return error codes sometimes.

This code modification shouldn't lead to any functional changes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpuidle/cpuidle.c |   26 ++++++--------------------
 include/linux/cpuidle.h   |    5 -----
 kernel/sched/idle.c       |   20 +++++++-------------
 3 files changed, 13 insertions(+), 38 deletions(-)

Index: linux-pm/kernel/sched/idle.c
===================================================================
--- linux-pm.orig/kernel/sched/idle.c
+++ linux-pm/kernel/sched/idle.c
@@ -100,19 +100,13 @@ static void cpuidle_idle_call(void)
 	rcu_idle_enter();
 
 	/*
-	 * Check if the cpuidle framework is ready, otherwise fallback
-	 * to the default arch specific idle method
+	 * Ask the cpuidle framework to choose a convenient idle state.
+	 * Fall back to the default arch specific idle method on errors.
 	 */
-	ret = cpuidle_enabled(drv, dev);
-
-	if (!ret) {
-		/*
-		 * Ask the governor to choose an idle state it thinks
-		 * it is convenient to go to. There is *always* a
-		 * convenient idle state
-		 */
-		next_state = cpuidle_select(drv, dev);
+	next_state = cpuidle_select(drv, dev);
 
+	ret = next_state;
+	if (ret >= 0) {
 		/*
 		 * The idle task must be scheduled, it is pointless to
 		 * go to idle, just update no idle residency and get
@@ -139,7 +133,7 @@ static void cpuidle_idle_call(void)
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 					&dev->cpu);
 
-			if (!ret) {
+			if (ret >= 0) {
 				trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 				/*
@@ -174,7 +168,7 @@ static void cpuidle_idle_call(void)
 	 * We can't use the cpuidle framework, let's use the default
 	 * idle routine
 	 */
-	if (ret)
+	if (ret < 0)
 		arch_cpu_idle();
 
 	__current_set_polling();
Index: linux-pm/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-pm.orig/drivers/cpuidle/cpuidle.c
+++ linux-pm/drivers/cpuidle/cpuidle.c
@@ -65,26 +65,6 @@ int cpuidle_play_dead(void)
 }
 
 /**
- * cpuidle_enabled - check if the cpuidle framework is ready
- * @dev: cpuidle device for this cpu
- * @drv: cpuidle driver for this cpu
- *
- * Return 0 on success, otherwise:
- * -NODEV : the cpuidle framework is not available
- * -EBUSY : the cpuidle framework is not initialized
- */
-int cpuidle_enabled(struct cpuidle_driver *drv, struct cpuidle_device *dev)
-{
-	if (off || !initialized)
-		return -ENODEV;
-
-	if (!drv || !dev || !dev->enabled)
-		return -EBUSY;
-
-	return 0;
-}
-
-/**
  * cpuidle_enter_state - enter the state and update stats
  * @dev: cpuidle device for this cpu
  * @drv: cpuidle driver for this cpu
@@ -138,6 +118,12 @@ int cpuidle_enter_state(struct cpuidle_d
  */
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
+	if (off || !initialized)
+		return -ENODEV;
+
+	if (!drv || !dev || !dev->enabled)
+		return -EBUSY;
+
 	return cpuidle_curr_governor->select(drv, dev);
 }
 
Index: linux-pm/include/linux/cpuidle.h
===================================================================
--- linux-pm.orig/include/linux/cpuidle.h
+++ linux-pm/include/linux/cpuidle.h
@@ -120,8 +120,6 @@ struct cpuidle_driver {
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
 
-extern int cpuidle_enabled(struct cpuidle_driver *drv,
-			  struct cpuidle_device *dev);
 extern int cpuidle_select(struct cpuidle_driver *drv,
 			  struct cpuidle_device *dev);
 extern int cpuidle_enter(struct cpuidle_driver *drv,
@@ -149,9 +147,6 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 #else
 static inline void disable_cpuidle(void) { }
-static inline int cpuidle_enabled(struct cpuidle_driver *drv,
-				  struct cpuidle_device *dev)
-{return -ENODEV; }
 static inline int cpuidle_select(struct cpuidle_driver *drv,
 				 struct cpuidle_device *dev)
 {return -ENODEV; }

