Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbaISLse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:48:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaISLsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:30 -0400
Date: Fri, 19 Sep 2014 04:47:41 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-65fdac08c264506ff95ee1e34ae066e308c9e6e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de
In-Reply-To: <1409051215-16788-4-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-4-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix avg_load computation
Git-Commit-ID: 65fdac08c264506ff95ee1e34ae066e308c9e6e3
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

Commit-ID:  65fdac08c264506ff95ee1e34ae066e308c9e6e3
Gitweb:     http://git.kernel.org/tip/65fdac08c264506ff95ee1e34ae066e308c9e6e3
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 26 Aug 2014 13:06:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:26 +0200

sched: Fix avg_load computation

The computation of avg_load and avg_load_per_task should only take into
account the number of CFS tasks. The non-CFS tasks are already taken into
account by decreasing the CPU's capacity and they will be tracked in the
CPU's utilization (group_utilization) of the next patches.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: riel@redhat.com
Cc: Morten.Rasmussen@arm.com
Cc: efault@gmx.de
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: dietmar.eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409051215-16788-4-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 391eaf2..eb87229 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4095,7 +4095,7 @@ static unsigned long capacity_of(int cpu)
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
 	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
@@ -5985,7 +5985,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_nr_running += rq->cfs.h_nr_running;
 
 		if (rq->nr_running > 1)
 			*overload = true;
