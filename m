Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaLJPx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:28 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54197 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbaLJPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:24 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 10/12] sched: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:52 -0500
Message-Id: <1418226774-30215-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  | 11 +++++------
 kernel/sched/stats.c | 11 ++---------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 03fa7dd..7446963 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5403,9 +5403,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
-	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -5418,7 +5416,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span ");
+	cpulist_pr_cont(sched_domain_span(sd));
+	printk(KERN_CONT " level %s\n", sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -5463,9 +5463,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " ");
+		cpulist_pr_cont(sched_group_cpus(group));
 		if (group->sgc->capacity != SCHED_CAPACITY_SCALE) {
 			printk(KERN_CONT " (cpu_capacity = %d)",
 				group->sgc->capacity);
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index a476bea..c2ae710 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -15,11 +15,6 @@
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
-	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
-
-	if (mask_str == NULL)
-		return -ENOMEM;
 
 	if (v == (void *)1) {
 		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
@@ -50,9 +45,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len,
-					  sched_domain_span(sd));
-			seq_printf(seq, "domain%d %s", dcount++, mask_str);
+			seq_printf(seq, "domain%d ", dcount++);
+			seq_cpumask(seq, sched_domain_span(sd));
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
 				seq_printf(seq, " %u %u %u %u %u %u %u %u",
@@ -76,7 +70,6 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		rcu_read_unlock();
 #endif
 	}
-	kfree(mask_str);
 	return 0;
 }
 
-- 
2.1.0

