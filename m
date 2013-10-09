Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3JIRex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:34:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab3JIReu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:34:50 -0400
Date: Wed, 9 Oct 2013 10:34:11 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-989348b5fc2367d6880d23a1c779a90bbb6f9baf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-63-git-send-email-mgorman@suse.de>
References: <1381141781-10992-63-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Use unsigned longs for numa group fault stats
Git-Commit-ID: 989348b5fc2367d6880d23a1c779a90bbb6f9baf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:34:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  989348b5fc2367d6880d23a1c779a90bbb6f9baf
Gitweb:     http://git.kernel.org/tip/989348b5fc2367d6880d23a1c779a90bbb6f9baf
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:23 +0200

sched/numa: Use unsigned longs for numa group fault stats

As Peter says "If you're going to hold locks you can also do away with all
that atomic_long_*() nonsense". Lock aquisition moved slightly to protect
the updates.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-63-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 49 ++++++++++++++++++++-----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7884dc..5b2208e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -916,8 +916,8 @@ struct numa_group {
 	struct list_head task_list;
 
 	struct rcu_head rcu;
-	atomic_long_t total_faults;
-	atomic_long_t faults[0];
+	unsigned long total_faults;
+	unsigned long faults[0];
 };
 
 pid_t task_numa_group_id(struct task_struct *p)
@@ -944,8 +944,7 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 	if (!p->numa_group)
 		return 0;
 
-	return atomic_long_read(&p->numa_group->faults[2*nid]) +
-	       atomic_long_read(&p->numa_group->faults[2*nid+1]);
+	return p->numa_group->faults[2*nid] + p->numa_group->faults[2*nid+1];
 }
 
 /*
@@ -971,17 +970,10 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 
 static inline unsigned long group_weight(struct task_struct *p, int nid)
 {
-	unsigned long total_faults;
-
-	if (!p->numa_group)
-		return 0;
-
-	total_faults = atomic_long_read(&p->numa_group->total_faults);
-
-	if (!total_faults)
+	if (!p->numa_group || !p->numa_group->total_faults)
 		return 0;
 
-	return 1000 * group_faults(p, nid) / total_faults;
+	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
 }
 
 static unsigned long weighted_cpuload(const int cpu);
@@ -1397,9 +1389,9 @@ static void task_numa_placement(struct task_struct *p)
 			p->total_numa_faults += diff;
 			if (p->numa_group) {
 				/* safe because we can only change our own group */
-				atomic_long_add(diff, &p->numa_group->faults[i]);
-				atomic_long_add(diff, &p->numa_group->total_faults);
-				group_faults += atomic_long_read(&p->numa_group->faults[i]);
+				p->numa_group->faults[i] += diff;
+				p->numa_group->total_faults += diff;
+				group_faults += p->numa_group->faults[i];
 			}
 		}
 
@@ -1475,7 +1467,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 	if (unlikely(!p->numa_group)) {
 		unsigned int size = sizeof(struct numa_group) +
-				    2*nr_node_ids*sizeof(atomic_long_t);
+				    2*nr_node_ids*sizeof(unsigned long);
 
 		grp = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
 		if (!grp)
@@ -1487,9 +1479,9 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		grp->gid = p->pid;
 
 		for (i = 0; i < 2*nr_node_ids; i++)
-			atomic_long_set(&grp->faults[i], p->numa_faults[i]);
+			grp->faults[i] = p->numa_faults[i];
 
-		atomic_long_set(&grp->total_faults, p->total_numa_faults);
+		grp->total_faults = p->total_numa_faults;
 
 		list_add(&p->numa_entry, &grp->task_list);
 		grp->nr_tasks++;
@@ -1543,14 +1535,14 @@ unlock:
 	if (!join)
 		return;
 
+	double_lock(&my_grp->lock, &grp->lock);
+
 	for (i = 0; i < 2*nr_node_ids; i++) {
-		atomic_long_sub(p->numa_faults[i], &my_grp->faults[i]);
-		atomic_long_add(p->numa_faults[i], &grp->faults[i]);
+		my_grp->faults[i] -= p->numa_faults[i];
+		grp->faults[i] += p->numa_faults[i];
 	}
-	atomic_long_sub(p->total_numa_faults, &my_grp->total_faults);
-	atomic_long_add(p->total_numa_faults, &grp->total_faults);
-
-	double_lock(&my_grp->lock, &grp->lock);
+	my_grp->total_faults -= p->total_numa_faults;
+	grp->total_faults += p->total_numa_faults;
 
 	list_move(&p->numa_entry, &grp->task_list);
 	my_grp->nr_tasks--;
@@ -1571,12 +1563,11 @@ void task_numa_free(struct task_struct *p)
 	void *numa_faults = p->numa_faults;
 
 	if (grp) {
+		spin_lock(&grp->lock);
 		for (i = 0; i < 2*nr_node_ids; i++)
-			atomic_long_sub(p->numa_faults[i], &grp->faults[i]);
-
-		atomic_long_sub(p->total_numa_faults, &grp->total_faults);
+			grp->faults[i] -= p->numa_faults[i];
+		grp->total_faults -= p->total_numa_faults;
 
-		spin_lock(&grp->lock);
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock(&grp->lock);
