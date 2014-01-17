Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaAQG1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:27:52 -0500
Received: from shelob.surriel.com ([74.92.59.67]:44859 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaAQG1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:27:50 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        chegu_vinod@hp.com, mgorman@suse.de, Rik van Riel <riel@surriel.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 4/6] numa,sched: tracepoints for NUMA balancing active nodemask changes
Date: Fri, 17 Jan 2014 01:17:34 -0500
Message-Id: <1389939456-9541-5-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389939456-9541-1-git-send-email-riel@redhat.com>
References: <1389939456-9541-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

Being able to see how the active nodemask changes over time, and why,
can be quite useful.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 include/trace/events/sched.h | 34 ++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |  8 ++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67e1bbf..91726b6 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -530,6 +530,40 @@ TRACE_EVENT(sched_swap_numa,
 			__entry->dst_pid, __entry->dst_tgid, __entry->dst_ngid,
 			__entry->dst_cpu, __entry->dst_nid)
 );
+
+TRACE_EVENT(update_numa_active_nodes_mask,
+
+	TP_PROTO(int pid, int gid, int nid, int set, long faults, long max_faults),
+
+	TP_ARGS(pid, gid, nid, set, faults, max_faults),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,		pid)
+		__field(	pid_t,		gid)
+		__field(	int,		nid)
+		__field(	int,		set)
+		__field(	long,		faults)
+		__field(	long,		max_faults);
+	),
+
+	TP_fast_assign(
+		__entry->pid = pid;
+		__entry->gid = gid;
+		__entry->nid = nid;
+		__entry->set = set;
+		__entry->faults = faults;
+		__entry->max_faults = max_faults;
+	),
+
+	TP_printk("pid=%d gid=%d nid=%d set=%d faults=%ld max_faults=%ld",
+		__entry->pid,
+		__entry->gid,
+		__entry->nid,
+		__entry->set,
+		__entry->faults,
+		__entry->max_faults)
+
+);
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index aa680e2..3551009 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1300,10 +1300,14 @@ static void update_numa_active_node_mask(struct task_struct *p)
 		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
 			 numa_group->faults_from[task_faults_idx(nid, 1)];
 		if (!node_isset(nid, numa_group->active_nodes)) {
-			if (faults > max_faults * 4 / 10)
+			if (faults > max_faults * 4 / 10) {
+				trace_update_numa_active_nodes_mask(current->pid, numa_group->gid, nid, true, faults, max_faults);
 				node_set(nid, numa_group->active_nodes);
-		} else if (faults < max_faults * 2 / 10)
+			}
+		} else if (faults < max_faults * 2 / 10) {
+			trace_update_numa_active_nodes_mask(current->pid, numa_group->gid, nid, false, faults, max_faults);
 			node_clear(nid, numa_group->active_nodes);
+		}
 	}
 }
 
-- 
1.8.4.2

