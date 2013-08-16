Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab3HPX5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:57:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51835 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3HPWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 063/133] Revert "cpuidle: Quickly notice prediction failure in general case"
Date: Fri, 16 Aug 2013 15:33:25 -0700
Message-Id: <1376692475-28413-64-git-send-email-kamal@canonical.com>
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

commit 228b30234f258a193317874854eee1ca7807186e upstream.

Revert commit e11538d1 (cpuidle: Quickly notice prediction failure in
general case), since it depends on commit 69a37be (cpuidle: Quickly
notice prediction failure for repeat mode) that has been identified
as the source of a significant performance regression in v3.8 and
later.

Requested-by: Jeremy Eder <jeder@redhat.com>
Tested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpuidle/governors/menu.c | 35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index fe343a0..b69a87e 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -34,7 +34,7 @@
 static DEFINE_PER_CPU(struct hrtimer, menu_hrtimer);
 static DEFINE_PER_CPU(int, hrtimer_status);
 /* menu hrtimer mode */
-enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT, MENU_HRTIMER_GENERAL};
+enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT};
 
 /*
  * Concepts and ideas behind the menu governor
@@ -116,13 +116,6 @@ enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT, MENU_HRTIMER_GENERAL};
  *
  */
 
-/*
- * The C-state residency is so long that is is worthwhile to exit
- * from the shallow C-state and re-enter into a deeper C-state.
- */
-static unsigned int perfect_cstate_ms __read_mostly = 30;
-module_param(perfect_cstate_ms, uint, 0000);
-
 struct menu_device {
 	int		last_state_idx;
 	int             needs_update;
@@ -223,16 +216,6 @@ EXPORT_SYMBOL_GPL(menu_hrtimer_cancel);
 static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
 {
 	int cpu = smp_processor_id();
-	struct menu_device *data = &per_cpu(menu_devices, cpu);
-
-	/* In general case, the expected residency is much larger than
-	 *  deepest C-state target residency, but prediction logic still
-	 *  predicts a small predicted residency, so the prediction
-	 *  history is totally broken if the timer is triggered.
-	 *  So reset the correction factor.
-	 */
-	if (per_cpu(hrtimer_status, cpu) == MENU_HRTIMER_GENERAL)
-		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
 
 	per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_STOP;
 
@@ -389,7 +372,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	/* not deepest C-state chosen for low predicted residency */
 	if (low_predicted) {
 		unsigned int timer_us = 0;
-		unsigned int perfect_us = 0;
 
 		/*
 		 * Set a timer to detect whether this sleep is much
@@ -400,28 +382,13 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		 */
 		timer_us = 2 * (data->predicted_us + MAX_DEVIATION);
 
-		perfect_us = perfect_cstate_ms * 1000;
-
 		if (repeat && (4 * timer_us < data->expected_us)) {
 			RCU_NONIDLE(hrtimer_start(hrtmr,
 				ns_to_ktime(1000 * timer_us),
 				HRTIMER_MODE_REL_PINNED));
 			/* In repeat case, menu hrtimer is started */
 			per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_REPEAT;
-		} else if (perfect_us < data->expected_us) {
-			/*
-			 * The next timer is long. This could be because
-			 * we did not make a useful prediction.
-			 * In that case, it makes sense to re-enter
-			 * into a deeper C-state after some time.
-			 */
-			RCU_NONIDLE(hrtimer_start(hrtmr,
-				ns_to_ktime(1000 * timer_us),
-				HRTIMER_MODE_REL_PINNED));
-			/* In general case, menu hrtimer is started */
-			per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_GENERAL;
 		}
-
 	}
 
 	return data->last_state_idx;
-- 
1.8.1.2

