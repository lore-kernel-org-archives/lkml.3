Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3KOIrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:47:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:64104 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab3KOIrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:47:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435692232"
From: Lan Tianyu <tianyu.lan@intel.com>
To: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        fweisbec@gmail.com, rjw@rjwysocki.net, viresh.kumar@linaro.org,
        rostedt@goodmis.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/2] Tick: Introduce tick_nohz_check() to check nohz enable status
Date: Fri, 15 Nov 2013 16:35:34 +0800
Message-Id: <1384504535-29987-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383036537-30362-1-git-send-email-tianyu.lan@intel.com>
References: <1383036537-30362-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases, nohz enable status needs to be checked. E.G, in RCU and cpufreq
ondemand governor. So add tick_nohz_check() to return tick_nohz_enabled value
And use tick_nohz_check() instead of referencing tick_nohz_enabled in the rcutree_plugin.h.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---

Change since V2:
	Add ACCESS_ONCE to tick_nohz_check().

 include/linux/tick.h     | 2 ++
 kernel/rcutree_plugin.h  | 4 +---
 kernel/time/tick-sched.c | 8 +++++++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5128d33..a9c5374 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -136,6 +136,7 @@ static inline int tick_nohz_tick_stopped(void)
 extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
+extern int tick_nohz_check(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
@@ -155,6 +156,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 
 	return len;
 }
+static inline int tick_nohz_check(void) { return 0; }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !CONFIG_NO_HZ_COMMON */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 130c97b..af167ec 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1627,8 +1627,6 @@ module_param(rcu_idle_gp_delay, int, 0644);
 static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
 module_param(rcu_idle_lazy_gp_delay, int, 0644);
 
-extern int tick_nohz_enabled;
-
 /*
  * Try to advance callbacks for all flavors of RCU on the current CPU.
  * Afterwards, if there are any callbacks ready for immediate invocation,
@@ -1718,7 +1716,7 @@ static void rcu_prepare_for_idle(int cpu)
 	int tne;
 
 	/* Handle nohz enablement switches conservatively. */
-	tne = ACCESS_ONCE(tick_nohz_enabled);
+	tne = tick_nohz_check();
 	if (tne != rdtp->tick_nohz_enabled_snap) {
 		if (rcu_cpu_has_callbacks(cpu, NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..a568845 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -361,7 +361,13 @@ void __init tick_nohz_init(void)
 /*
  * NO HZ enabled ?
  */
-int tick_nohz_enabled __read_mostly  = 1;
+static int tick_nohz_enabled __read_mostly  = 1;
+
+int tick_nohz_check(void)
+{
+	return	ACCESS_ONCE(tick_nohz_enabled);
+}
+EXPORT_SYMBOL_GPL(tick_nohz_check);
 
 /*
  * Enable / Disable tickless mode
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

