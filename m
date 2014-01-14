Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaANGIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:08:46 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52792 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaANGIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:08:43 -0500
Subject: [PATCH] cpuidle/menu: Fail cpuidle_idle_call() if no idle state is
 acceptable
To: deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        tuukka.tikkanen@linaro.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 11:35:16 +0530
Message-ID: <20140114060516.6109.14901.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011406-3532-0000-0000-000004B83633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, in a particular test scenario, all the cpu idle states were disabled.
Inspite of this it was observed that the idle state count of the shallowest
idle state, snooze, was increasing.

This is because the governor returns the idle state index as 0 even in
scenarios when no idle state can be chosen. These scenarios could be when the
latency requirement is 0 or as mentioned above when the user wants to disable
certain cpu idle states at runtime. In the latter case, its possible that no
cpu idle state is valid because the suitable states were disabled
and the rest did not match the menu governor criteria to be chosen as the
next idle state.

This patch adds the code to indicate that a valid cpu idle state could not be
chosen by the menu governor and reports back to arch so that it can take some
default action.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle.c        |    6 +++++-
 drivers/cpuidle/governors/menu.c |    7 ++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..5bf06bb 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -131,8 +131,9 @@ int cpuidle_idle_call(void)
 
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(drv, dev);
+
+	dev->last_residency = 0;
 	if (need_resched()) {
-		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
 		if (cpuidle_curr_governor->reflect)
 			cpuidle_curr_governor->reflect(dev, next_state);
@@ -140,6 +141,9 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
+	if (next_state < 0)
+		return -EINVAL;
+
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index cf7f2f0..6921543 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -283,6 +283,7 @@ again:
  * menu_select - selects the next idle state to enter
  * @drv: cpuidle driver containing state data
  * @dev: the CPU
+ * Returns -1 when no idle state is suitable
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
@@ -292,17 +293,17 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int multiplier;
 	struct timespec t;
 
-	if (data->needs_update) {
+	if (data->last_state_idx >= 0 && data->needs_update) {
 		menu_update(drv, dev);
 		data->needs_update = 0;
 	}
 
-	data->last_state_idx = 0;
+	data->last_state_idx = -1;
 	data->exit_us = 0;
 
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
-		return 0;
+		return data->last_state_idx;
 
 	/* determine the expected residency time, round up */
 	t = ktime_to_timespec(tick_nohz_get_sleep_length());

