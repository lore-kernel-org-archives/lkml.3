Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaISLwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:52:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaISLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:20 -0400
Date: Fri, 19 Sep 2014 04:47:28 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-05bfb65f52cbdabe26ebb629959416a6cffb034d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1409051215-16788-3-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-3-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove a wake_affine() condition
Git-Commit-ID: 05bfb65f52cbdabe26ebb629959416a6cffb034d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05bfb65f52cbdabe26ebb629959416a6cffb034d
Gitweb:     http://git.kernel.org/tip/05bfb65f52cbdabe26ebb629959416a6cffb034d
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 26 Aug 2014 13:06:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:25 +0200

sched: Remove a wake_affine() condition

In wake_affine() I have tried to understand the meaning of the condition:

 (this_load <= load &&
  this_load + target_load(prev_cpu, idx) <= tl_per_task)

but I failed to find a use case that can take advantage of it and I haven't
found clear description in the previous commit's log.

Futhermore, the comment of the condition refers to the task_hot function that
was used before being replaced by the current condition:

/*
 * This domain has SD_WAKE_AFFINE and
 * p is cache cold in this domain, and
 * there is no bad imbalance.
 */

If we look more deeply the below condition:

 this_load + target_load(prev_cpu, idx) <= tl_per_task

When sync is clear, we have:

 tl_per_task = runnable_load_avg / nr_running
 this_load = max(runnable_load_avg, cpuload[idx])
 target_load =  max(runnable_load_avg', cpuload'[idx])

It implies that runnable_load_avg == 0 and nr_running <= 1 in order to match the
condition. This implies that runnable_load_avg == 0 too because of the
condition: this_load <= load.

but if this _load is null, 'balanced' is already set and the test is redundant.

If sync is set, it's not as straight forward as above (especially if cgroup
are involved) but the policy should be similar as we have removed a task that's
going to sleep in order to get a more accurate load and this_load values.

The current conclusion is that these additional condition don't give any benefit
so we can remove them.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: preeti@linux.vnet.ibm.com
Cc: riel@redhat.com
Cc: Morten.Rasmussen@arm.com
Cc: efault@gmx.de
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: dietmar.eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409051215-16788-3-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 01856a8..391eaf2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4285,7 +4285,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
-	unsigned long tl_per_task;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -4343,32 +4342,15 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
-
-	/*
-	 * If the currently running task will sleep within
-	 * a reasonable amount of time then attract this newly
-	 * woken task:
-	 */
-	if (sync && balanced)
-		return 1;
-
 	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
-	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if (balanced ||
-	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
-		/*
-		 * This domain has SD_WAKE_AFFINE and
-		 * p is cache cold in this domain, and
-		 * there is no bad imbalance.
-		 */
-		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.statistics.nr_wakeups_affine);
+	if (!balanced)
+		return 0;
 
-		return 1;
-	}
-	return 0;
+	schedstat_inc(sd, ttwu_move_affine);
+	schedstat_inc(p, se.statistics.nr_wakeups_affine);
+
+	return 1;
 }
 
 /*
