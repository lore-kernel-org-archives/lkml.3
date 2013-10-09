Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3JIR1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:27:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3JIR07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:26:59 -0400
Date: Wed, 9 Oct 2013 10:26:22 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-b726b7dfb400c937546fa91cf8523dcb1aa2fc6e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-16-git-send-email-mgorman@suse.de>
References: <1381141781-10992-16-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Revert "mm: sched: numa:
  Delay PTE scanning until a task is scheduled on a new node"
Git-Commit-ID: b726b7dfb400c937546fa91cf8523dcb1aa2fc6e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:26:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b726b7dfb400c937546fa91cf8523dcb1aa2fc6e
Gitweb:     http://git.kernel.org/tip/b726b7dfb400c937546fa91cf8523dcb1aa2fc6e
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:17 +0200

Revert "mm: sched: numa: Delay PTE scanning until a task is scheduled on a new node"

PTE scanning and NUMA hinting fault handling is expensive so commit
5bca2303 ("mm: sched: numa: Delay PTE scanning until a task is scheduled
on a new node") deferred the PTE scan until a task had been scheduled on
another node. The problem is that in the purely shared memory case that
this may never happen and no NUMA hinting fault information will be
captured. We are not ruling out the possibility that something better
can be done here but for now, this patch needs to be reverted and depend
entirely on the scan_delay to avoid punishing short-lived processes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-16-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h | 10 ----------
 kernel/fork.c            |  3 ---
 kernel/sched/fair.c      | 18 ------------------
 kernel/sched/features.h  |  4 +---
 4 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d9851ee..b7adf1d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -428,20 +428,10 @@ struct mm_struct {
 
 	/* numa_scan_seq prevents two threads setting pte_numa */
 	int numa_scan_seq;
-
-	/*
-	 * The first node a task was scheduled on. If a task runs on
-	 * a different node than Make PTE Scan Go Now.
-	 */
-	int first_nid;
 #endif
 	struct uprobes_state uprobes_state;
 };
 
-/* first nid will either be a valid NID or one of these values */
-#define NUMA_PTE_SCAN_INIT	-1
-#define NUMA_PTE_SCAN_ACTIVE	-2
-
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 #ifdef CONFIG_CPUMASK_OFFSTACK
diff --git a/kernel/fork.c b/kernel/fork.c
index 086fe73..7192d91 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -817,9 +817,6 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	mm->pmd_huge_pte = NULL;
 #endif
-#ifdef CONFIG_NUMA_BALANCING
-	mm->first_nid = NUMA_PTE_SCAN_INIT;
-#endif
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 464207f..49b11fa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -901,24 +901,6 @@ void task_numa_work(struct callback_head *work)
 		return;
 
 	/*
-	 * We do not care about task placement until a task runs on a node
-	 * other than the first one used by the address space. This is
-	 * largely because migrations are driven by what CPU the task
-	 * is running on. If it's never scheduled on another node, it'll
-	 * not migrate so why bother trapping the fault.
-	 */
-	if (mm->first_nid == NUMA_PTE_SCAN_INIT)
-		mm->first_nid = numa_node_id();
-	if (mm->first_nid != NUMA_PTE_SCAN_ACTIVE) {
-		/* Are we running on a new node yet? */
-		if (numa_node_id() == mm->first_nid &&
-		    !sched_feat_numa(NUMA_FORCE))
-			return;
-
-		mm->first_nid = NUMA_PTE_SCAN_ACTIVE;
-	}
-
-	/*
 	 * Reset the scan period if enough time has gone by. Objective is that
 	 * scanning will be reduced if pages are properly placed. As tasks
 	 * can enter different phases this needs to be re-examined. Lacking
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..cba5c61 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -63,10 +63,8 @@ SCHED_FEAT(LB_MIN, false)
 /*
  * Apply the automatic NUMA scheduling policy. Enabled automatically
  * at runtime if running on a NUMA machine. Can be controlled via
- * numa_balancing=. Allow PTE scanning to be forced on UMA machines
- * for debugging the core machinery.
+ * numa_balancing=
  */
 #ifdef CONFIG_NUMA_BALANCING
 SCHED_FEAT(NUMA,	false)
-SCHED_FEAT(NUMA_FORCE,	false)
 #endif
