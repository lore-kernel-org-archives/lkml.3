Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaAYH05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:26:57 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64445 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:26:55 -0500
Date: Sat, 25 Jan 2014 08:26:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140125072649.GA8476@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 5e3c1afd4587e70c201bf7224b51f747c9a3dfa8 sched/x86/tsc: Initialize multiplier to 0

A couple of regression fixes mostly hitting virtualized setups, but 
also some bare metal systems.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (3):
      sched/preempt/x86: Fix voluntary preempt for x86
      sched/clock: Fixup early initialization
      sched/x86/tsc: Initialize multiplier to 0

Vincent Guittot (1):
      Revert "sched: Fix sleep time double accounting in enqueue entity"


 arch/x86/kernel/tsc.c   |  2 +-
 include/linux/preempt.h |  5 -----
 kernel/sched/clock.c    | 53 ++++++++++++++++++++++++++++++++++++++-----------
 kernel/sched/fair.c     |  8 +-------
 4 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a3acbac..19e5adb 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -180,7 +180,7 @@ static void cyc2ns_write_end(int cpu, struct cyc2ns_data *data)
 
 static void cyc2ns_data_init(struct cyc2ns_data *data)
 {
-	data->cyc2ns_mul = 1U << CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_mul = 0;
 	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
 	data->cyc2ns_offset = 0;
 	data->__count = 0;
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 59749fc..de83b4e 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -134,7 +134,6 @@ do { \
 #undef preempt_check_resched
 #endif
 
-#ifdef CONFIG_PREEMPT
 #define preempt_set_need_resched() \
 do { \
 	set_preempt_need_resched(); \
@@ -144,10 +143,6 @@ do { \
 	if (tif_need_resched()) \
 		set_preempt_need_resched(); \
 } while (0)
-#else
-#define preempt_set_need_resched() do { } while (0)
-#define preempt_fold_need_resched() do { } while (0)
-#endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 6bd6a67..43c2bcc 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -77,35 +77,50 @@ __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
+static int __sched_clock_stable_early;
 
 int sched_clock_stable(void)
 {
-	if (static_key_false(&__sched_clock_stable))
-		return false;
-	return true;
+	return static_key_false(&__sched_clock_stable);
 }
 
-void set_sched_clock_stable(void)
+static void __set_sched_clock_stable(void)
 {
 	if (!sched_clock_stable())
-		static_key_slow_dec(&__sched_clock_stable);
+		static_key_slow_inc(&__sched_clock_stable);
+}
+
+void set_sched_clock_stable(void)
+{
+	__sched_clock_stable_early = 1;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
+	__set_sched_clock_stable();
 }
 
 static void __clear_sched_clock_stable(struct work_struct *work)
 {
 	/* XXX worry about clock continuity */
 	if (sched_clock_stable())
-		static_key_slow_inc(&__sched_clock_stable);
+		static_key_slow_dec(&__sched_clock_stable);
 }
 
 static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
 
 void clear_sched_clock_stable(void)
 {
-	if (keventd_up())
-		schedule_work(&sched_clock_work);
-	else
-		__clear_sched_clock_stable(&sched_clock_work);
+	__sched_clock_stable_early = 0;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
+	schedule_work(&sched_clock_work);
 }
 
 struct sched_clock_data {
@@ -140,6 +155,20 @@ void sched_clock_init(void)
 	}
 
 	sched_clock_running = 1;
+
+	/*
+	 * Ensure that it is impossible to not do a static_key update.
+	 *
+	 * Either {set,clear}_sched_clock_stable() must see sched_clock_running
+	 * and do the update, or we must see their __sched_clock_stable_early
+	 * and do the update, or both.
+	 */
+	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
+
+	if (__sched_clock_stable_early)
+		__set_sched_clock_stable();
+	else
+		__clear_sched_clock_stable(NULL);
 }
 
 /*
@@ -340,7 +369,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
  */
 u64 cpu_clock(int cpu)
 {
-	if (static_key_false(&__sched_clock_stable))
+	if (!sched_clock_stable())
 		return sched_clock_cpu(cpu);
 
 	return sched_clock();
@@ -355,7 +384,7 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	if (static_key_false(&__sched_clock_stable))
+	if (!sched_clock_stable())
 		return sched_clock_cpu(raw_smp_processor_id());
 
 	return sched_clock();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b24b6cf..efe6457 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2356,13 +2356,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		}
 		wakeup = 0;
 	} else {
-		/*
-		 * Task re-woke on same cpu (or else migrate_task_rq_fair()
-		 * would have made count negative); we must be careful to avoid
-		 * double-accounting blocked time after synchronizing decays.
-		 */
-		se->avg.last_runnable_update += __synchronize_entity_decay(se)
-							<< 20;
+		__synchronize_entity_decay(se);
 	}
 
 	/* migrated tasks did not contribute to our blocked load */
