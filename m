Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3JIR2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:28:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab3JIR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:28:07 -0400
Date: Wed, 9 Oct 2013 10:27:01 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-f809ca9a554dda49fb264c79e31c722e0b063ff8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-20-git-send-email-mgorman@suse.de>
References: <1381141781-10992-20-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Track NUMA hinting faults on per-node basis
Git-Commit-ID: f809ca9a554dda49fb264c79e31c722e0b063ff8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:27:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f809ca9a554dda49fb264c79e31c722e0b063ff8
Gitweb:     http://git.kernel.org/tip/f809ca9a554dda49fb264c79e31c722e0b063ff8
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:22 +0200

sched/numa: Track NUMA hinting faults on per-node basis

This patch tracks what nodes numa hinting faults were incurred on.
This information is later used to schedule a task on the node storing
the pages most frequently faulted by the task.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-20-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   |  3 +++
 kernel/sched/fair.c   | 11 ++++++++++-
 kernel/sched/sched.h  | 12 ++++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fdcb4c8..a810e95 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1342,6 +1342,8 @@ struct task_struct {
 	unsigned int numa_scan_period_max;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
+
+	unsigned long *numa_faults;
 #endif /* CONFIG_NUMA_BALANCING */
 
 	struct rcu_head rcu;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aee7e4d..6808d35 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1634,6 +1634,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
+	p->numa_faults = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
 }
 
@@ -1892,6 +1893,8 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		task_numa_free(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c6c3302..0bb3e0a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -902,7 +902,14 @@ void task_numa_fault(int node, int pages, bool migrated)
 	if (!numabalancing_enabled)
 		return;
 
-	/* FIXME: Allocate task-specific structure for placement policy here */
+	/* Allocate buffer to track faults on a per-node basis */
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(*p->numa_faults) * nr_node_ids;
+
+		p->numa_faults = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		if (!p->numa_faults)
+			return;
+	}
 
 	/*
 	 * If pages are properly placed (did not migrate) then scan slower.
@@ -918,6 +925,8 @@ void task_numa_fault(int node, int pages, bool migrated)
 	}
 
 	task_numa_placement(p);
+
+	p->numa_faults[node] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e82484d..199099c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
 #include <linux/tick.h>
+#include <linux/slab.h>
 
 #include "cpupri.h"
 #include "cpuacct.h"
@@ -555,6 +556,17 @@ static inline u64 rq_clock_task(struct rq *rq)
 	return rq->clock_task;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+static inline void task_numa_free(struct task_struct *p)
+{
+	kfree(p->numa_faults);
+}
+#else /* CONFIG_NUMA_BALANCING */
+static inline void task_numa_free(struct task_struct *p)
+{
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
