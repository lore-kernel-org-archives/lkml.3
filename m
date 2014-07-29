Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaG2GkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:40:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaG2GkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:40:09 -0400
Date: Tue, 29 Jul 2014 02:39:40 -0400
From: Rik van Riel <riel@redhat.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org, peterz@infradead.org,
        jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140729023940.37b6aebc@annuminas.surriel.com>
In-Reply-To: <53D72FF5.90908@intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
	<53D72FF5.90908@intel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014 13:24:05 +0800
Aaron Lu <aaron.lu@intel.com> wrote:

> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit a43455a1d572daf7b730fe12eb747d1e17411365 ("sched/numa: Ensure task_numa_migrate() checks the preferred node")
> 
> ebe06187bf2aec1  a43455a1d572daf7b730fe12e  
> ---------------  -------------------------  
>      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-threads-pipe
>      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%-threads-socket
>     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_hint_faults_local

Hi Aaron,

Jirka Hladky has reported a regression with that changeset as
well, and I have already spent some time debugging the issue.

I added tracing code to task_numa_compare() and saw a number
of thread swaps with tiny improvements.

Does preventing those help your workload, or am I barking up
the wrong tree again?  (I have been looking at this for a while...)

---8<---

Subject: sched,numa: prevent task moves with marginal benefit

Commit a43455a1d57 makes task_numa_migrate() always check the
preferred node for task placement. This is causing a performance
regression with hackbench, as well as SPECjbb2005.

Tracing task_numa_compare() with a single instance of SPECjbb2005
on a 4 node system, I have seen several thread swaps with tiny
improvements. 

It appears that the hysteresis code that was added to task_numa_compare
is not doing what we needed it to do, and a simple threshold could be
better.

Reported-by: Aaron Lu <aaron.lu@intel.com>
Reported-by: Jirka Hladky <jhladky@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f5e3c2..bedbc3e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -924,10 +924,12 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
 
 /*
  * These return the fraction of accesses done by a particular task, or
- * task group, on a particular numa node.  The group weight is given a
- * larger multiplier, in order to group tasks together that are almost
- * evenly spread out between numa nodes.
+ * task group, on a particular numa node.  The NUMA move threshold
+ * prevents task moves with marginal improvement, and is set to 5%.
  */
+#define NUMA_SCALE 1000
+#define NUMA_MOVE_THRESH 50
+
 static inline unsigned long task_weight(struct task_struct *p, int nid)
 {
 	unsigned long total_faults;
@@ -940,7 +942,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1000 * task_faults(p, nid) / total_faults;
+	return NUMA_SCALE * task_faults(p, nid) / total_faults;
 }
 
 static inline unsigned long group_weight(struct task_struct *p, int nid)
@@ -948,7 +950,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 	if (!p->numa_group || !p->numa_group->total_faults)
 		return 0;
 
-	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
+	return NUMA_SCALE * group_faults(p, nid) / p->numa_group->total_faults;
 }
 
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
@@ -1181,11 +1183,11 @@ static void task_numa_compare(struct task_numa_env *env,
 			imp = taskimp + task_weight(cur, env->src_nid) -
 			      task_weight(cur, env->dst_nid);
 			/*
-			 * Add some hysteresis to prevent swapping the
-			 * tasks within a group over tiny differences.
+			 * Do not swap tasks within a group around unless
+			 * there is a significant improvement.
 			 */
-			if (cur->numa_group)
-				imp -= imp/16;
+			if (cur->numa_group && imp < NUMA_MOVE_THRESH)
+				goto unlock;
 		} else {
 			/*
 			 * Compare the group weights. If a task is all by
@@ -1205,6 +1207,10 @@ static void task_numa_compare(struct task_numa_env *env,
 		goto unlock;
 
 	if (!cur) {
+		/* Only move if there is a significant improvement. */
+		if (imp < NUMA_MOVE_THRESH)
+			goto unlock;
+
 		/* Is there capacity at our destination? */
 		if (env->src_stats.has_free_capacity &&
 		    !env->dst_stats.has_free_capacity)
