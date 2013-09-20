Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3ITUOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3ITUOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Cross <ccross@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 40/93] cpuidle: coupled: fix race condition between pokes and safe state
Date: Fri, 20 Sep 2013 13:08:35 -0700
Message-Id: <1379707768-1804-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 9e19b73c30a5fa42a53583a1f7817dd857126156 upstream.

The coupled cpuidle waiting loop clears pending pokes before
entering the safe state.  If a poke arrives just before the
pokes are cleared, but after the while loop condition checks,
the poke will be lost and the cpu will stay in the safe state
until another interrupt arrives.  This may cause the cpu that
sent the poke to spin in the ready loop with interrupts off
until another cpu receives an interrupt, and if no other cpus
have interrupts routed to them it can spin forever.

Change the return value of cpuidle_coupled_clear_pokes to
return if a poke was cleared, and move the need_resched()
checks into the callers.  In the waiting loop, if
a poke was cleared restart the loop to repeat the while
condition checks.

Reported-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpuidle/coupled.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 5d39627..f8a8636 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -408,19 +408,22 @@ static void cpuidle_coupled_set_done(int cpu, struct cpuidle_coupled *coupled)
  * been processed and the poke bit has been cleared.
  *
  * Other interrupts may also be processed while interrupts are enabled, so
- * need_resched() must be tested after turning interrupts off again to make sure
+ * need_resched() must be tested after this function returns to make sure
  * the interrupt didn't schedule work that should take the cpu out of idle.
  *
- * Returns 0 if need_resched was false, -EINTR if need_resched was true.
+ * Returns 0 if no poke was pending, 1 if a poke was cleared.
  */
 static int cpuidle_coupled_clear_pokes(int cpu)
 {
+	if (!cpumask_test_cpu(cpu, &cpuidle_coupled_poke_pending))
+		return 0;
+
 	local_irq_enable();
 	while (cpumask_test_cpu(cpu, &cpuidle_coupled_poke_pending))
 		cpu_relax();
 	local_irq_disable();
 
-	return need_resched() ? -EINTR : 0;
+	return 1;
 }
 
 static bool cpuidle_coupled_any_pokes_pending(struct cpuidle_coupled *coupled)
@@ -464,7 +467,8 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 		return -EINVAL;
 
 	while (coupled->prevent) {
-		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
+		cpuidle_coupled_clear_pokes(dev->cpu);
+		if (need_resched()) {
 			local_irq_enable();
 			return entered_state;
 		}
@@ -503,7 +507,10 @@ retry:
 	 */
 	while (!cpuidle_coupled_cpus_waiting(coupled) ||
 			!cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked)) {
-		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
+		if (cpuidle_coupled_clear_pokes(dev->cpu))
+			continue;
+
+		if (need_resched()) {
 			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
 			goto out;
 		}
@@ -518,7 +525,8 @@ retry:
 		local_irq_disable();
 	}
 
-	if (cpuidle_coupled_clear_pokes(dev->cpu)) {
+	cpuidle_coupled_clear_pokes(dev->cpu);
+	if (need_resched()) {
 		cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
 		goto out;
 	}
-- 
1.8.1.2

