Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab3FSSjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:39:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab3FSSjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:39:51 -0400
Date: Wed, 19 Jun 2013 11:39:15 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-873b4c65b519fd769940eb281f77848227d4e5c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1370419991-13870-1-git-send-email-vincent.guittot@linaro.org>
References: <1370419991-13870-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix clear NOHZ_BALANCE_KICK
Git-Commit-ID: 873b4c65b519fd769940eb281f77848227d4e5c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:39:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  873b4c65b519fd769940eb281f77848227d4e5c1
Gitweb:     http://git.kernel.org/tip/873b4c65b519fd769940eb281f77848227d4e5c1
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Wed, 5 Jun 2013 10:13:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:55:09 +0200

sched: Fix clear NOHZ_BALANCE_KICK

I have faced a sequence where the Idle Load Balance was sometime not
triggered for a while on my platform, in the following scenario:

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1370419991-13870-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 21 +++++++++++++++++----
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
