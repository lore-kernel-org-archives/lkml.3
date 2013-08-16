Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3HPX7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:59:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3HPWkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 064/133] Revert "cpuidle: Quickly notice prediction failure for repeat mode"
Date: Fri, 16 Aug 2013 15:33:26 -0700
Message-Id: <1376692475-28413-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 148519120c6d1f19ad53349683aeae9f228b0b8d upstream.

Revert commit 69a37bea (cpuidle: Quickly notice prediction failure for
repeat mode), because it has been identified as the source of a
significant performance regression in v3.8 and later as explained by
Jeremy Eder:

  We believe we've identified a particular commit to the cpuidle code
  that seems to be impacting performance of variety of workloads.
  The simplest way to reproduce is using netperf TCP_RR test, so
  we're using that, on a pair of Sandy Bridge based servers.  We also
  have data from a large database setup where performance is also
  measurably/positively impacted, though that test data isn't easily
  share-able.

  Included below are test results from 3 test kernels:

  kernel       reverts
  -----------------------------------------------------------
  1) vanilla   upstream (no reverts)

  2) perfteam2 reverts e11538d1f03914eb92af5a1a378375c05ae8520c

  3) test      reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4
                       e11538d1f03914eb92af5a1a378375c05ae8520c

  In summary, netperf TCP_RR numbers improve by approximately 4%
  after reverting 69a37beabf1f0a6705c08e879bdd5d82ff6486c4.  When
  69a37beabf1f0a6705c08e879bdd5d82ff6486c4 is included, C0 residency
  never seems to get above 40%.  Taking that patch out gets C0 near
  100% quite often, and performance increases.

  The below data are histograms representing the %c0 residency @
  1-second sample rates (using turbostat), while under netperf test.

  - If you look at the first 4 histograms, you can see %c0 residency
    almost entirely in the 30,40% bin.
  - The last pair, which reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4,
    shows %c0 in the 80,90,100% bins.

  Below each kernel name are netperf TCP_RR trans/s numbers for the
  particular kernel that can be disclosed publicly, comparing the 3
  test kernels.  We ran a 4th test with the vanilla kernel where
  we've also set /dev/cpu_dma_latency=0 to show overall impact
  boosting single-threaded TCP_RR performance over 11% above
  baseline.

  3.10-rc2 vanilla RX + c0 lock (/dev/cpu_dma_latency=0):
  TCP_RR trans/s 54323.78

  -----------------------------------------------------------
  3.10-rc2 vanilla RX (no reverts)
  TCP_RR trans/s 48192.47

  Receiver %c0
      0.0000 -    10.0000 [     1]: *
     10.0000 -    20.0000 [     0]:
     20.0000 -    30.0000 [     0]:
     30.0000 -    40.0000 [    59]:
  ***********************************************************
     40.0000 -    50.0000 [     1]: *
     50.0000 -    60.0000 [     0]:
     60.0000 -    70.0000 [     0]:
     70.0000 -    80.0000 [     0]:
     80.0000 -    90.0000 [     0]:
     90.0000 -   100.0000 [     0]:

  Sender %c0
      0.0000 -    10.0000 [     1]: *
     10.0000 -    20.0000 [     0]:
     20.0000 -    30.0000 [     0]:
     30.0000 -    40.0000 [    11]: ***********
     40.0000 -    50.0000 [    49]:
  *************************************************
     50.0000 -    60.0000 [     0]:
     60.0000 -    70.0000 [     0]:
     70.0000 -    80.0000 [     0]:
     80.0000 -    90.0000 [     0]:
     90.0000 -   100.0000 [     0]:

  -----------------------------------------------------------
  3.10-rc2 perfteam2 RX (reverts commit
  e11538d1f03914eb92af5a1a378375c05ae8520c)
  TCP_RR trans/s 49698.69

  Receiver %c0
      0.0000 -    10.0000 [     1]: *
     10.0000 -    20.0000 [     1]: *
     20.0000 -    30.0000 [     0]:
     30.0000 -    40.0000 [    59]:
  ***********************************************************
     40.0000 -    50.0000 [     0]:
     50.0000 -    60.0000 [     0]:
     60.0000 -    70.0000 [     0]:
     70.0000 -    80.0000 [     0]:
     80.0000 -    90.0000 [     0]:
     90.0000 -   100.0000 [     0]:

  Sender %c0
      0.0000 -    10.0000 [     1]: *
     10.0000 -    20.0000 [     0]:
     20.0000 -    30.0000 [     0]:
     30.0000 -    40.0000 [     2]: **
     40.0000 -    50.0000 [    58]:
  **********************************************************
     50.0000 -    60.0000 [     0]:
     60.0000 -    70.0000 [     0]:
     70.0000 -    80.0000 [     0]:
     80.0000 -    90.0000 [     0]:
     90.0000 -   100.0000 [     0]:

  -----------------------------------------------------------
  3.10-rc2 test RX (reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4
  and e11538d1f03914eb92af5a1a378375c05ae8520c)
  TCP_RR trans/s 47766.95

  Receiver %c0
      0.0000 -    10.0000 [     1]: *
     10.0000 -    20.0000 [     1]: *
     20.0000 -    30.0000 [     0]:
     30.0000 -    40.0000 [    27]: ***************************
     40.0000 -    50.0000 [     2]: **
     50.0000 -    60.0000 [     0]:
     60.0000 -    70.0000 [     2]: **
     70.0000 -    80.0000 [     0]:
     80.0000 -    90.0000 [     0]:
     90.0000 -   100.0000 [    28]: ****************************

  Sender:
      0.0000 -    10.0000 [     1]: *
     10.0000 -    20.0000 [     0]:
     20.0000 -    30.0000 [     0]:
     30.0000 -    40.0000 [    11]: ***********
     40.0000 -    50.0000 [     0]:
     50.0000 -    60.0000 [     1]: *
     60.0000 -    70.0000 [     0]:
     70.0000 -    80.0000 [     3]: ***
     80.0000 -    90.0000 [     7]: *******
     90.0000 -   100.0000 [    38]: **************************************

  These results demonstrate gaining back the tendency of the CPU to
  stay in more responsive, performant C-states (and thus yield
  measurably better performance), by reverting commit
  69a37beabf1f0a6705c08e879bdd5d82ff6486c4.

Requested-by: Jeremy Eder <jeder@redhat.com>
Tested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: revert 69a37bea from 3.8 instead of upstream revert ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpuidle/governors/menu.c | 65 ++--------------------------------------
 include/linux/tick.h             |  6 ----
 kernel/time/tick-sched.c         |  4 ---
 3 files changed, 2 insertions(+), 73 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index b69a87e..322967f 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -28,13 +28,6 @@
 #define MAX_INTERESTING 50000
 #define STDDEV_THRESH 400
 
-/* 60 * 60 > STDDEV_THRESH * INTERVALS = 400 * 8 */
-#define MAX_DEVIATION 60
-
-static DEFINE_PER_CPU(struct hrtimer, menu_hrtimer);
-static DEFINE_PER_CPU(int, hrtimer_status);
-/* menu hrtimer mode */
-enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT};
 
 /*
  * Concepts and ideas behind the menu governor
@@ -198,30 +191,6 @@ static u64 div_round64(u64 dividend, u32 divisor)
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
-/* Cancel the hrtimer if it is not triggered yet */
-void menu_hrtimer_cancel(void)
-{
-	int cpu = smp_processor_id();
-	struct hrtimer *hrtmr = &per_cpu(menu_hrtimer, cpu);
-
-	/* The timer is still not time out*/
-	if (per_cpu(hrtimer_status, cpu)) {
-		hrtimer_cancel(hrtmr);
-		per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_STOP;
-	}
-}
-EXPORT_SYMBOL_GPL(menu_hrtimer_cancel);
-
-/* Call back for hrtimer is triggered */
-static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
-{
-	int cpu = smp_processor_id();
-
-	per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_STOP;
-
-	return HRTIMER_NORESTART;
-}
-
 /*
  * Try detecting repeating patterns by keeping track of the last 8
  * intervals, and checking if the standard deviation of that set
@@ -298,9 +267,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int i;
 	int multiplier;
 	struct timespec t;
-	int repeat = 0, low_predicted = 0;
-	int cpu = smp_processor_id();
-	struct hrtimer *hrtmr = &per_cpu(menu_hrtimer, cpu);
 
 	if (data->needs_update) {
 		menu_update(drv, dev);
@@ -335,7 +301,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
-	repeat = get_typical_interval(data);
+	get_typical_interval(data);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
@@ -356,10 +322,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 		if (s->disabled || su->disable)
 			continue;
-		if (s->target_residency > data->predicted_us) {
-			low_predicted = 1;
+		if (s->target_residency > data->predicted_us)
 			continue;
-		}
 		if (s->exit_latency > latency_req)
 			continue;
 		if (s->exit_latency * multiplier > data->predicted_us)
@@ -369,28 +333,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		data->exit_us = s->exit_latency;
 	}
 
-	/* not deepest C-state chosen for low predicted residency */
-	if (low_predicted) {
-		unsigned int timer_us = 0;
-
-		/*
-		 * Set a timer to detect whether this sleep is much
-		 * longer than repeat mode predicted.  If the timer
-		 * triggers, the code will evaluate whether to put
-		 * the CPU into a deeper C-state.
-		 * The timer is cancelled on CPU wakeup.
-		 */
-		timer_us = 2 * (data->predicted_us + MAX_DEVIATION);
-
-		if (repeat && (4 * timer_us < data->expected_us)) {
-			RCU_NONIDLE(hrtimer_start(hrtmr,
-				ns_to_ktime(1000 * timer_us),
-				HRTIMER_MODE_REL_PINNED));
-			/* In repeat case, menu hrtimer is started */
-			per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_REPEAT;
-		}
-	}
-
 	return data->last_state_idx;
 }
 
@@ -481,9 +423,6 @@ static int menu_enable_device(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
 	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
-	struct hrtimer *t = &per_cpu(menu_hrtimer, dev->cpu);
-	hrtimer_init(t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	t->function = menu_hrtimer_notify;
 
 	memset(data, 0, sizeof(struct menu_device));
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 1a6567b..f37fceb 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -142,10 +142,4 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
-# ifdef CONFIG_CPU_IDLE_GOV_MENU
-extern void menu_hrtimer_cancel(void);
-# else
-static inline void menu_hrtimer_cancel(void) {}
-# endif /* CONFIG_CPU_IDLE_GOV_MENU */
-
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8853dab..b28e112 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -572,8 +572,6 @@ void tick_nohz_irq_exit(void)
 
 	local_irq_save(flags);
 
-	/* Cancel the timer because CPU already waken up from the C-states */
-	menu_hrtimer_cancel();
 	__tick_nohz_idle_enter(ts);
 
 	local_irq_restore(flags);
@@ -671,8 +669,6 @@ void tick_nohz_idle_exit(void)
 
 	ts->inidle = 0;
 
-	/* Cancel the timer because CPU already waken up from the C-states*/
-	menu_hrtimer_cancel();
 	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
-- 
1.8.1.2

