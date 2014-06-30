Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaF3Hnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:43:40 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51167 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaF3Hnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:43:39 -0400
Message-ID: <53B1151E.6030603@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2014 15:43:26 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: new feature to spread tasks inside cpu-groups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063007-3568-0000-0000-000005C64C40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently testing show that the cpu-cgroup was failed on managing the mixed
workloads of dbench and stress, by doing:

	mkdir /cgroup/cpu/l1/
	mkdir /cgroup/cpu/l1/A
	mkdir /cgroup/cpu/l1/B
	mkdir /cgroup/cpu/l1/C

	echo $$ > /cgroup/cpu/l1/A/tasks ; dbench 6
	echo $$ > /cgroup/cpu/l1/B/tasks ; stress 6
	echo $$ > /cgroup/cpu/l1/C/tasks ; stress 6

although the cpu-shares was 1:1:1 (A:B:C), the CPU% was around 1:5:5. 

Now by doing:

	echo 102400 > /cgroup/cpu/l1/A/cpu.shares

the cpu-shares become 100:1:1, however, the CPU% was still around 1:5:5.

This testing could be extended to 10000:1:1 on cpu-shares or even more, the
CPU% was still around 1:5:5.

We used to think it was caused by that the dbench only need so many CPU% but
actually that's not true, after we bind each instances to different CPUs, we
could see the CPU% become 3:4:4 with only 10:1:1 on cpu-shares.

However, bind tasks to each CPU is definitely not a good solution, we need
some feature capable to spread tasks inside a group meanwhile following the
current scheduler logical.

This patch introduced a new feature which will meet these requirements, it will
locate idle cfs_rq inside cpu-group when and only when we are going to giveup
on searching idle-CPU, this make the tasks more actively on spreading inside
cpu-cgroup than usual.

Now by doing:

	echo SPREAD_INSIDE_GROUP > /sys/kernel/debug/sched_features

The 10:1:1 on cpu-shares will lead to 3:4:4 on CPU%, also the throughput of
dbench raised, so we finally got the way to help dbench(transaction workload)
to fight with stress(CPU-intensive workload).

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/features.h |    8 ++++++
 2 files changed, 71 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..0e3022c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4409,6 +4409,51 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	return idlest;
 }
 
+static inline int tg_idle_cpu(struct task_group *tg, int cpu)
+{
+	return !tg->cfs_rq[cpu]->nr_running;
+}
+
+/*
+ * Try and locate an idle CPU in the sched_domain from tg's view.
+ */
+static int tg_idle_sibling(struct task_struct *p, int target)
+{
+	struct sched_domain *sd;
+	struct sched_group *sg;
+	int i = task_cpu(p);
+	struct task_group *tg = task_group(p);
+
+	if (tg_idle_cpu(tg, target))
+		goto done;
+
+	sd = rcu_dereference(per_cpu(sd_llc, target));
+	for_each_lower_domain(sd) {
+		sg = sd->groups;
+		do {
+			if (!cpumask_intersects(sched_group_cpus(sg),
+						tsk_cpus_allowed(p)))
+				goto next;
+
+			for_each_cpu(i, sched_group_cpus(sg)) {
+				if (i == target || !tg_idle_cpu(tg, i))
+					goto next;
+			}
+
+			target = cpumask_first_and(sched_group_cpus(sg),
+					tsk_cpus_allowed(p));
+
+			goto done;
+next:
+			sg = sg->next;
+		} while (sg != sd->groups);
+	}
+
+done:
+
+	return target;
+}
+
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
@@ -4417,6 +4462,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i = task_cpu(p);
+	struct sched_entity *se = task_group(p)->se[i];
 
 	if (idle_cpu(target))
 		return target;
@@ -4451,6 +4497,23 @@ next:
 		} while (sg != sd->groups);
 	}
 done:
+
+	if (!idle_cpu(target) && sched_feat(SPREAD_INSIDE_GROUP)) {
+		/*
+		 * Before we arbitrarily return the target, try to locate an
+		 * idle cfs_rq inside task's group with the same logical.
+		 *
+		 * This is try to prevent tasks from gathering, especially for
+		 * those wake-affine rapidly while being balanced rarely, wakeup
+		 * is the only chance to spreading them.
+		 *
+		 * We only need to take care the tasks flip frequently, and
+		 * load-balance routine will take care the others.
+		 */
+		if (p->wakee_flips > this_cpu_read(sd_llc_size))
+			return tg_idle_sibling(p, target);
+	}
+
 	return target;
 }
 
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 90284d1..532d6e9 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -6,6 +6,14 @@
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, true)
 
 /*
+ * Adopt the logical of select_idle_sibling() to pick idle cfs_rq
+ * inside task's cpu-group, this will help to spread the group's
+ * tasks internally and benefit to those who prefer balancing more
+ * than gathering.
+ */
+SCHED_FEAT(SPREAD_INSIDE_GROUP, false)
+
+/*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */
-- 
1.7.9.5

