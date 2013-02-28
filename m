Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3B1B4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:56:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:63020 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3B1B4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:56:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,752,1355126400"; 
   d="scan'208";a="262399826"
From: "Zhang, Jun" <jun.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Jun" <jun.zhang@intel.com>
Subject: [PATCH] At present, function sched_clock_idle_wakeup_event input
 parameter is not necessary, we can remove it.
Thread-Topic: [PATCH] At present, function sched_clock_idle_wakeup_event
 input parameter is not necessary, we can remove it.
Thread-Index: Ac4VVtp1uVRzwE2NSa2KYe3ylPs1mg==
Date: Thu, 28 Feb 2013 01:56:41 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FDB4D1C@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: jzha144 <jun.zhang@intel.com>
---
 arch/x86/kernel/tsc.c         |    2 +-
 drivers/acpi/processor_idle.c |    4 ++--
 include/linux/sched.h         |    6 +++---
 kernel/sched/clock.c          |    4 ++--
 kernel/time/tick-sched.c      |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 4b9ea10..957d32e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -629,7 +629,7 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 	local_irq_restore(flags);
 }
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index fc95308..e725c83 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -809,7 +809,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	sched_clock_idle_sleep_event();
 	acpi_idle_do_entry(cx);
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 
 	if (cx->entry_method != ACPI_CSTATE_FFH)
 		current_thread_info()->status |= TS_POLLING;
@@ -905,7 +905,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		raw_spin_unlock(&c3_lock);
 	}
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 
 	if (cx->entry_method != ACPI_CSTATE_FFH)
 		current_thread_info()->status |= TS_POLLING;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6853bf9..232cca9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1975,7 +1975,7 @@ static inline void sched_clock_idle_sleep_event(void)
 {
 }
 
-static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
+static inline void sched_clock_idle_wakeup_event(void)
 {
 }
 #else
@@ -1989,7 +1989,7 @@ extern int sched_clock_stable;
 
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
-extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+extern void sched_clock_idle_wakeup_event(void);
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -2016,7 +2016,7 @@ extern void sched_exec(void);
 #endif
 
 extern void sched_clock_idle_sleep_event(void);
-extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+extern void sched_clock_idle_wakeup_event(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void idle_task_exit(void);
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..759a5ff 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -266,9 +266,9 @@ void sched_clock_idle_sleep_event(void)
 EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
 
 /*
- * We just idled delta nanoseconds (called with irqs disabled):
+ * We are waking up form idle (called with irqs disabled):
  */
-void sched_clock_idle_wakeup_event(u64 delta_ns)
+void sched_clock_idle_wakeup_event(void)
 {
 	if (timekeeping_suspended)
 		return;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 314b9ee..d358a18 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -221,7 +221,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 	update_ts_time_stats(cpu, ts, now, NULL);
 	ts->idle_active = 0;
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 }
 
 static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
-- 
1.7.6

Best Regards!

Jun Zhang
Inet: 8821-4273
Dir.Tel: 86-21-6116-4273
Email: jun.zhang@intel.com

