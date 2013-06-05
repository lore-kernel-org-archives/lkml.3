Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3FEIN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:13:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39351 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3FEIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:13:26 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2] sched: fix clear NOHZ_BALANCE_KICK
Date: Wed,  5 Jun 2013 10:13:11 +0200
Message-Id: <1370419991-13870-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have faced a sequence where the Idle Load Balance was sometime not
triggered for a while on my platform.

CPU 0 and CPU 1 are running tasks and CPU 2 is idle

CPU 1 kicks the Idle Load Balance
CPU 1 selects CPU 2 as the new Idle Load Balancer
CPU 2 sets NOHZ_BALANCE_KICK for CPU 2
CPU 2 sends a reschedule IPI to CPU 2
While CPU 3 wakes up, CPU 0 or CPU 1 migrates a waking up task A on CPU 2
CPU 2 finally wakes up, runs task A and discards the Idle Load Balance
task A quickly goes back to sleep (before a tick occurs on CPU 2)
CPU 2 goes back to idle with NOHZ_BALANCE_KICK set

Whenever CPU 2 will be selected as the ILB, no reschedule IPI will be sent
because NOHZ_BALANCE_KICK is already set and no Idle Load Balance will be
performed.

We must wait for the sched softirq to be raised on CPU 2 thanks to another
part the kernel to come back to clear NOHZ_BALANCE_KICK.

The proposed solution clears NOHZ_BALANCE_KICK in schedule_ipi if
we can't raise the sched_softirq for the Idle Load Balance.

Change since V1:
- move the clear of NOHZ_BALANCE_KICK in got_nohz_idle_kick if the ILB
can't run on this CPU (as suggested by Peter)

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..919bee6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -633,7 +633,19 @@ void wake_up_nohz_cpu(int cpu)
 static inline bool got_nohz_idle_kick(void)
 {
 	int cpu = smp_processor_id();
-	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+
+	if (!test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
+		return false;
+
+	if (idle_cpu(cpu) && !need_resched())
+		return true;
+
+	/*
+	 * We can't run Idle Load Balance on this CPU for this time so we
+	 * cancel it and clear NOHZ_BALANCE_KICK
+	 */
+	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+	return false;
 }
 
 #else /* CONFIG_NO_HZ_COMMON */
@@ -1393,8 +1405,9 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
-	    && !tick_nohz_full_cpu(smp_processor_id()))
+	if (llist_empty(&this_rq()->wake_list)
+			&& !tick_nohz_full_cpu(smp_processor_id())
+			&& !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -1417,7 +1430,7 @@ void scheduler_ipi(void)
 	/*
 	 * Check if someone kicked us for doing the nohz idle load balance.
 	 */
-	if (unlikely(got_nohz_idle_kick() && !need_resched())) {
+	if (unlikely(got_nohz_idle_kick())) {
 		this_rq()->idle_balance = 1;
 		raise_softirq_irqoff(SCHED_SOFTIRQ);
 	}
-- 
1.7.9.5

