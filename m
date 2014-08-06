Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaHFNTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:19:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaHFNT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:19:26 -0400
From: Mel Gorman <mgorman@suse.de>
To: Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>
Cc: Mike Galbraith <mgalbraith@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/4] cpuidle: menu: Call nr_iowait_cpu less times
Date: Wed,  6 Aug 2014 14:19:20 +0100
Message-Id: <1407331161-4642-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407331161-4642-1-git-send-email-mgorman@suse.de>
References: <1407331161-4642-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menu_select() via inline functions calls nr_iowait_cpu() twice as much
as necessary.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 drivers/cpuidle/governors/menu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 373278a..90d8109 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -143,7 +143,7 @@ static int get_loadavg(void)
 	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
 }
 
-static inline int which_bucket(unsigned int duration)
+static inline int which_bucket(unsigned int duration, unsigned long nr_iowaiters)
 {
 	int bucket = 0;
 
@@ -153,7 +153,7 @@ static inline int which_bucket(unsigned int duration)
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowait_cpu(smp_processor_id()))
+	if (nr_iowaiters)
 		bucket = BUCKETS/2;
 
 	if (duration < 10)
@@ -176,7 +176,7 @@ static inline int which_bucket(unsigned int duration)
  * to be, the higher this multiplier, and thus the higher
  * the barrier to go to an expensive C state.
  */
-static inline int performance_multiplier(void)
+static inline int performance_multiplier(unsigned long nr_iowaiters)
 {
 	int mult = 1;
 
@@ -185,7 +185,7 @@ static inline int performance_multiplier(void)
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu(smp_processor_id());
+	mult += 10 * nr_iowaiters;
 
 	return mult;
 }
@@ -297,6 +297,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	unsigned int interactivity_req;
+	unsigned long nr_iowaiters;
 
 	if (data->needs_update) {
 		menu_update(drv, dev);
@@ -312,8 +313,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	/* determine the expected residency time, round up */
 	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
 
-
-	data->bucket = which_bucket(data->next_timer_us);
+	nr_iowaiters = nr_iowait_cpu(smp_processor_id());
+	data->bucket = which_bucket(data->next_timer_us, nr_iowaiters);
 
 	/*
 	 * Force the result of multiplication to be 64 bits even if both
@@ -331,7 +332,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * duration / latency ratio. Adjust the latency limit if
 	 * necessary.
 	 */
-	interactivity_req = data->predicted_us / performance_multiplier();
+	interactivity_req = data->predicted_us / performance_multiplier(nr_iowaiters);
 	if (latency_req > interactivity_req)
 		latency_req = interactivity_req;
 
-- 
1.8.4.5

