Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbbAXOEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:16 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:55779 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbbAXOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:12 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 15/32] sched: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:21 -0500
Message-Id: <1422108218-25398-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  | 10 ++++------
 kernel/sched/stats.c | 11 ++---------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0accc0..b7be48e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5408,9 +5408,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
-	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -5423,7 +5421,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span %*pbl level %s\n",
+	       cpumask_pr_args(sched_domain_span(sd)), sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -5468,9 +5467,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %*pbl",
+		       cpumask_pr_args(sched_group_cpus(group)));
 		if (group->sgc->capacity != SCHED_CAPACITY_SCALE) {
 			printk(KERN_CONT " (cpu_capacity = %d)",
 				group->sgc->capacity);
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index a476bea..87e2c9f 100644
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
+			seq_printf(seq, "domain%d %*pb", dcount++,
+				   cpumask_pr_args(sched_domain_span(sd)));
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

