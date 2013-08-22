Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3HVH6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:58:09 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53819 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3HVH6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:58:06 -0400
Message-ID: <5215C484.5010407@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:57:56 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 08/11] sched/cleanup: remove the extra parm of sched_clock_idle_wakeup_event()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-9264-0000-0000-0000045F710F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'delta_ns' has not been used, remove it to make code clean.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: John Stultz <john.stultz@linaro.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 arch/x86/kernel/tsc.c         |    2 +-
 drivers/acpi/processor_idle.c |    4 ++--
 include/linux/sched.h         |    7 ++-----
 kernel/sched/clock.c          |    2 +-
 kernel/time/tick-sched.c      |    2 +-
 5 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d4..4a40402 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -635,7 +635,7 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 	local_irq_restore(flags);
 }
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f98dd00..2bb49f8 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -817,7 +817,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	sched_clock_idle_sleep_event();
 	acpi_idle_do_entry(cx);
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 
 	if (cx->entry_method != ACPI_CSTATE_FFH)
 		current_thread_info()->status |= TS_POLLING;
@@ -913,7 +913,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		raw_spin_unlock(&c3_lock);
 	}
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 
 	if (cx->entry_method != ACPI_CSTATE_FFH)
 		current_thread_info()->status |= TS_POLLING;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 45a1a88..800c57f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1809,7 +1809,7 @@ static inline void sched_clock_idle_sleep_event(void)
 {
 }
 
-static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
+static inline void sched_clock_idle_wakeup_event(void)
 {
 }
 #else
@@ -1823,7 +1823,7 @@ extern int sched_clock_stable;
 
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
-extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+extern void sched_clock_idle_wakeup_event(void);
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -1849,9 +1849,6 @@ extern void sched_exec(void);
 #define sched_exec()   {}
 #endif
 
-extern void sched_clock_idle_sleep_event(void);
-extern void sched_clock_idle_wakeup_event(u64 delta_ns);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void idle_task_exit(void);
 #else
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c3ae144..d111c58 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -294,7 +294,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
 /*
  * We just idled delta nanoseconds (called with irqs disabled):
  */
-void sched_clock_idle_wakeup_event(u64 delta_ns)
+void sched_clock_idle_wakeup_event(void)
 {
 	if (timekeeping_suspended)
 		return;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..4b24d9e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -433,7 +433,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 	update_ts_time_stats(cpu, ts, now, NULL);
 	ts->idle_active = 0;
 
-	sched_clock_idle_wakeup_event(0);
+	sched_clock_idle_wakeup_event();
 }
 
 static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
-- 
1.7.9.5

