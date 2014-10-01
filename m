Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaJANkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:40:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52011 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaJANkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:40:15 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, riel@redhat.com,
        linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2] sched: fix spurious active migration
Date: Wed,  1 Oct 2014 15:38:55 +0200
Message-Id: <1412170735-5356-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
References: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit caeb178c60f4 ("sched/fair: Make update_sd_pick_busiest() ...")
sd_pick_busiest returns a group that can be neither imbalanced nor overloaded
but is only more loaded than others. This change has been introduced to ensure
a better load balance in system that are not overloaded but as a side effect,
it can also generate useless active migration between groups.

Let take the example of 3 tasks on a quad cores system. We will always have an
idle core so the load balance will find a busiest group (core) whenever an ILB
is triggered and it will force an active migration (once above
nr_balance_failed threshold) so the idle core becomes busy but another core
will become idle. With the next ILB, the freshly idle core will try to pull the
task of a busy CPU.
The number of spurious active migration is not so huge in quad core system
because the ILB is not triggered so much. But it becomes significant as soon as
you have more than one sched_domain level like on a dual cluster of quad cores
where the ILB is triggered every tick when you have more than 1 busy_cpu

We need to ensure that the migration generate a real improveùent and will not
only move the avg_load imbalance on another CPU.

Before caeb178c60f4f93f1b45c0bc056b5cf6d217b67f, the filtering of such use
case was ensured by the following test in f_b_g
if ((local->idle_cpus < busiest->idle_cpus) &&
		    busiest->sum_nr_running  <= busiest->group_weight)

This patch modified the condition to take into account situation where busiest
group is not overloaded: If the diff between the number of idle cpus in 2
groups is less than or equal to 1 and the busiest group is not overloaded,
moving a task will not improve the load balance but just move it.

A test with sysbench on a dual clusters of quad cores gives the following
results:
command: sysbench --test=cpu --num-threads=5 --max-time=5 run

The HZ is 200 which means that 1000 ticks has fired during the test.

-With Mainline, perf gives the following figures

Samples: 727  of event 'sched:sched_migrate_task'
Event count (approx.): 727
  Overhead  Command          Shared Object  Symbol
  ........  ...............  .............  ..............
    12.52%  migration/1      [unknown]      [.] 00000000
    12.52%  migration/5      [unknown]      [.] 00000000
    12.52%  migration/7      [unknown]      [.] 00000000
    12.10%  migration/6      [unknown]      [.] 00000000
    11.83%  migration/0      [unknown]      [.] 00000000
    11.83%  migration/3      [unknown]      [.] 00000000
    11.14%  migration/4      [unknown]      [.] 00000000
    10.87%  migration/2      [unknown]      [.] 00000000
     2.75%  sysbench         [unknown]      [.] 00000000
     0.83%  swapper          [unknown]      [.] 00000000
     0.55%  ktps65090charge  [unknown]      [.] 00000000
     0.41%  mmcqd/1          [unknown]      [.] 00000000
     0.14%  perf             [unknown]      [.] 00000000

-With this patch, perf gives the following figures

Samples: 20  of event 'sched:sched_migrate_task'
Event count (approx.): 20
  Overhead  Command          Shared Object  Symbol
  ........  ...............  .............  ..............
    80.00%  sysbench         [unknown]      [.] 00000000
    10.00%  swapper          [unknown]      [.] 00000000
     5.00%  ktps65090charge  [unknown]      [.] 00000000
     5.00%  migration/1      [unknown]      [.] 00000000

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Rik van Riel <riel@redhat.com>

---

Change since v1:
- reorder and rework the conditions

 kernel/sched/fair.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a1e6ac..3bc67ba 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6425,13 +6425,14 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 
 	if (env->idle == CPU_IDLE) {
 		/*
-		 * This cpu is idle. If the busiest group load doesn't
-		 * have more tasks than the number of available cpu's and
-		 * there is no imbalance between this and busiest group
-		 * wrt to idle cpu's, it is balanced.
+		 * This cpu is idle. If the busiest group is not overloaded
+		 * and there is no imbalance between this and busiest group
+		 * wrt idle cpus, it is balanced. The imbalance becomes
+		 * significant if the diff is greater than 1 otherwise we
+		 * might end up to just move the imbalance on another group
 		 */
-		if ((local->idle_cpus < busiest->idle_cpus) &&
-		    busiest->sum_nr_running <= busiest->group_weight)
+		if ((busiest->group_type != group_overloaded) &&
+				(local->idle_cpus <= (busiest->idle_cpus + 1)))
 			goto out_balanced;
 	} else {
 		/*
-- 
1.9.1

