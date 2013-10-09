Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3JIRdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:33:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab3JIRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:33:47 -0400
Date: Wed, 9 Oct 2013 10:32:53 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-ca28aa53dd95868c9e38917b9881c09dacfacf1a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-55-git-send-email-mgorman@suse.de>
References: <1381141781-10992-55-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix task or group comparison
Git-Commit-ID: ca28aa53dd95868c9e38917b9881c09dacfacf1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:32:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca28aa53dd95868c9e38917b9881c09dacfacf1a
Gitweb:     http://git.kernel.org/tip/ca28aa53dd95868c9e38917b9881c09dacfacf1a
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:32 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:08 +0200

sched/numa: Fix task or group comparison

This patch separately considers task and group affinities when
searching for swap candidates during NUMA placement. If tasks
are part of the same group, or no group at all, the task weights
are considered.

Some hysteresis is added to prevent tasks within one group from
getting bounced between NUMA nodes due to tiny differences.

If tasks are part of different groups, the code compares group
weights, in order to favor grouping task groups together.

The patch also changes the group weight multiplier to be the
same as the task weight multiplier, since the two are no longer
added up like before.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-55-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6f45461..423316c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -962,7 +962,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1200 * group_faults(p, nid) / total_faults;
+	return 1000 * group_faults(p, nid) / total_faults;
 }
 
 static unsigned long weighted_cpuload(const int cpu);
@@ -1068,16 +1068,34 @@ static void task_numa_compare(struct task_numa_env *env,
 
 		/*
 		 * If dst and source tasks are in the same NUMA group, or not
-		 * in any group then look only at task weights otherwise give
-		 * priority to the group weights.
+		 * in any group then look only at task weights.
 		 */
-		if (!cur->numa_group || !env->p->numa_group ||
-		    cur->numa_group == env->p->numa_group) {
+		if (cur->numa_group == env->p->numa_group) {
 			imp = taskimp + task_weight(cur, env->src_nid) -
 			      task_weight(cur, env->dst_nid);
+			/*
+			 * Add some hysteresis to prevent swapping the
+			 * tasks within a group over tiny differences.
+			 */
+			if (cur->numa_group)
+				imp -= imp/16;
 		} else {
-			imp = groupimp + group_weight(cur, env->src_nid) -
-			       group_weight(cur, env->dst_nid);
+			/*
+			 * Compare the group weights. If a task is all by
+			 * itself (not part of a group), use the task weight
+			 * instead.
+			 */
+			if (env->p->numa_group)
+				imp = groupimp;
+			else
+				imp = taskimp;
+
+			if (cur->numa_group)
+				imp += group_weight(cur, env->src_nid) -
+				       group_weight(cur, env->dst_nid);
+			else
+				imp += task_weight(cur, env->src_nid) -
+				       task_weight(cur, env->dst_nid);
 		}
 	}
 
