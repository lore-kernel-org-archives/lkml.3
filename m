Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3HWTpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:45:20 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42696 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab3HWTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:45:16 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Neil Zhang <zhangwm@marvell.com>,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3/3] cpuidle: coupled: fix race condition between pokes and safe state
Date: Fri, 23 Aug 2013 12:45:12 -0700
Message-Id: <1377287112-12018-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1377287112-12018-1-git-send-email-ccross@android.com>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: stable@vger.kernel.org
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/coupled.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index bbc4ba5..c91230b 100644
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
1.8.3

