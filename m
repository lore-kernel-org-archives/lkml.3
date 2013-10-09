Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3JIRdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:33:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3JIRcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:32:51 -0400
Date: Wed, 9 Oct 2013 10:32:12 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-82727018b0d33d188e9916bcf76f18387484cb04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-51-git-send-email-mgorman@suse.de>
References: <1381141781-10992-51-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Call task_numa_free() from do_execve
 ()
Git-Commit-ID: 82727018b0d33d188e9916bcf76f18387484cb04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:32:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82727018b0d33d188e9916bcf76f18387484cb04
Gitweb:     http://git.kernel.org/tip/82727018b0d33d188e9916bcf76f18387484cb04
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:00 +0200

sched/numa: Call task_numa_free() from do_execve()

It is possible for a task in a numa group to call exec, and
have the new (unrelated) executable inherit the numa group
association from its former self.

This has the potential to break numa grouping, and is trivial
to fix.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-51-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/exec.c             | 1 +
 include/linux/sched.h | 4 ++++
 kernel/sched/fair.c   | 9 ++++++++-
 kernel/sched/sched.h  | 5 -----
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8875dd1..2ea437e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1547,6 +1547,7 @@ static int do_execve_common(const char *filename,
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	acct_update_integrals(current);
+	task_numa_free(current);
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7244822..f638510 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1458,6 +1458,7 @@ struct task_struct {
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
+extern void task_numa_free(struct task_struct *p);
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -1470,6 +1471,9 @@ static inline pid_t task_numa_group_id(struct task_struct *p)
 static inline void set_numabalancing_state(bool enabled)
 {
 }
+static inline void task_numa_free(struct task_struct *p)
+{
+}
 #endif
 
 static inline struct pid *task_pid(struct task_struct *task)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4c40e13..c4df2de 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1418,6 +1418,7 @@ void task_numa_free(struct task_struct *p)
 {
 	struct numa_group *grp = p->numa_group;
 	int i;
+	void *numa_faults = p->numa_faults;
 
 	if (grp) {
 		for (i = 0; i < 2*nr_node_ids; i++)
@@ -1433,7 +1434,9 @@ void task_numa_free(struct task_struct *p)
 		put_numa_group(grp);
 	}
 
-	kfree(p->numa_faults);
+	p->numa_faults = NULL;
+	p->numa_faults_buffer = NULL;
+	kfree(numa_faults);
 }
 
 /*
@@ -1452,6 +1455,10 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 	if (!p->mm)
 		return;
 
+	/* Do not worry about placement if exiting */
+	if (p->state == TASK_DEAD)
+		return;
+
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults)) {
 		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8037b10..eeb1923 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -559,11 +559,6 @@ static inline u64 rq_clock_task(struct rq *rq)
 #ifdef CONFIG_NUMA_BALANCING
 extern int migrate_task_to(struct task_struct *p, int cpu);
 extern int migrate_swap(struct task_struct *, struct task_struct *);
-extern void task_numa_free(struct task_struct *p);
-#else /* CONFIG_NUMA_BALANCING */
-static inline void task_numa_free(struct task_struct *p)
-{
-}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_SMP
