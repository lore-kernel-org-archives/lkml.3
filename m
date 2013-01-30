Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3A3VUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:20:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:52988 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab3A3VT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:19:56 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
Date: Wed, 30 Jan 2013 22:19:17 +0100
Message-Id: <1359580757-4121-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a new CPU has to be choosen for a task, then the scheduler first selects
the group with the least load. This group is returned if its load is lower
compared to the group to which the task is currently assigned.
If there are several groups with completely idle CPU(s) (the CPU is in
an idle state like C1) then the first group is returned.
This patch extends this decision by considering the idle state of CPU(s)
in the group and the first group with a CPU in the lowest idle state
wins (C1 is prefered over C2). If there is a CPU which is not in an idle
state (C0) but has no tasks assigned then it is consider as a valid target.
Should there be no CPU in an idle state at disposal then the loadavg is
used as a fallback.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    6 ++++--
 kernel/sched/fair.c   |   24 ++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..c2f6a44 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -934,6 +934,7 @@ struct sched_domain {
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
+	unsigned int prefer_lp;
 	int flags;			/* See SD_* */
 	int level;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..fad16e6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4971,7 +4971,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(13);
+	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
 	if (table == NULL)
 		return NULL;
@@ -5001,7 +5001,9 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[11], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[12] is terminator */
+	set_table_entry(&table[12], "prefer_lp", &sd->prefer_lp,
+		sizeof(int), 0644, proc_dointvec_minmax, false);
+	/* &table[13] is terminator */
 
 	return table;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..bff9800 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -23,6 +23,7 @@
 #include <linux/latencytop.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
@@ -3181,8 +3182,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
+	struct sched_group *idle_group = NULL;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
+	int least_idle_cpu = INT_MAX;
 
 	do {
 		unsigned long load, avg_load;
@@ -3208,6 +3211,25 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 				load = target_load(i, load_idx);
 
 			avg_load += load;
+			if (!local_group && sd->prefer_lp && least_idle_cpu) {
+				int idle_level;
+
+				idle_level = cpuidle_get_state(i);
+				/*
+				 * Select the CPU which is in the lowest
+				 * possible power state. Take the active
+				 * CPU only if its run queue is empty.
+				 */
+				if (!idle_level) {
+					if (idle_cpu(i)) {
+						least_idle_cpu = idle_level;
+						idle_group = group;
+					}
+				} else if (least_idle_cpu > idle_level) {
+					least_idle_cpu = idle_level;
+					idle_group = group;
+				}
+			}
 		}
 
 		/* Adjust by relative CPU power of the group */
@@ -3221,6 +3243,8 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 	} while (group = group->next, group != sd->groups);
 
+	if (idle_group)
+		return idle_group;
 	if (!idlest || 100*this_load < imbalance*min_load)
 		return NULL;
 	return idlest;
-- 
1.7.10.4

