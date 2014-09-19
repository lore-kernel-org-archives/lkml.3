Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaISLtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:49:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbaISLtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:49:10 -0400
Date: Fri, 19 Sep 2014 04:48:22 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-bd61c98f9b3f142cd63f9e15acfe203bec9e5f5a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1409051215-16788-8-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-8-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Test the CPU's capacity in wake_affine()
Git-Commit-ID: bd61c98f9b3f142cd63f9e15acfe203bec9e5f5a
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

Commit-ID:  bd61c98f9b3f142cd63f9e15acfe203bec9e5f5a
Gitweb:     http://git.kernel.org/tip/bd61c98f9b3f142cd63f9e15acfe203bec9e5f5a
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 26 Aug 2014 13:06:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:28 +0200

sched: Test the CPU's capacity in wake_affine()

Currently the task always wakes affine on this_cpu if the latter is idle.
Before waking up the task on this_cpu, we check that this_cpu capacity is not
significantly reduced because of RT tasks or irq activity.

Use case where the number of irq and/or the time spent under irq is important
will take benefit of this because the task that is woken up by irq or softirq
will not use the same CPU than irq (and softirq) but a idle one.

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
Link: http://lkml.kernel.org/r/1409051215-16788-8-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be530e4..74fa2c2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4284,6 +4284,7 @@ static int wake_wide(struct task_struct *p)
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
+	s64 this_eff_load, prev_eff_load;
 	int idx, this_cpu, prev_cpu;
 	struct task_group *tg;
 	unsigned long weight;
@@ -4327,21 +4328,21 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load > 0) {
-		s64 this_eff_load, prev_eff_load;
+	this_eff_load = 100;
+	this_eff_load *= capacity_of(prev_cpu);
+
+	prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
+	prev_eff_load *= capacity_of(this_cpu);
 
-		this_eff_load = 100;
-		this_eff_load *= capacity_of(prev_cpu);
+	if (this_load > 0) {
 		this_eff_load *= this_load +
 			effective_load(tg, this_cpu, weight, weight);
 
-		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
-		prev_eff_load *= capacity_of(this_cpu);
 		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+	}
+
+	balanced = this_eff_load <= prev_eff_load;
 
-		balanced = this_eff_load <= prev_eff_load;
-	} else
-		balanced = true;
 	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
 
 	if (!balanced)
