Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3JIRcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:32:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3JIRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:32:31 -0400
Date: Wed, 9 Oct 2013 10:31:52 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-5e1576ed0e54d419286a8096133029062b6ad456@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-49-git-send-email-mgorman@suse.de>
References: <1381141781-10992-49-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Stay on the same node if CLONE_VM
Git-Commit-ID: 5e1576ed0e54d419286a8096133029062b6ad456
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:31:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e1576ed0e54d419286a8096133029062b6ad456
Gitweb:     http://git.kernel.org/tip/5e1576ed0e54d419286a8096133029062b6ad456
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:26 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:47:57 +0200

sched/numa: Stay on the same node if CLONE_VM

A newly spawned thread inside a process should stay on the same
NUMA node as its parent. This prevents processes from being "torn"
across multiple NUMA nodes every time they spawn a new thread.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-49-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  2 +-
 kernel/fork.c         |  2 +-
 kernel/sched/core.c   | 14 +++++++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ff54385..8563e3d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2021,7 +2021,7 @@ extern void wake_up_new_task(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(struct task_struct *p);
+extern void sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index 7192d91..c93be06 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1310,7 +1310,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p);
+	sched_fork(clone_flags, p);
 
 	retval = perf_event_init_task(p);
 	if (retval)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 51092d5..3e2c893 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1696,7 +1696,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  *
  * __sched_fork() is basic setup used by init_idle() too:
  */
-static void __sched_fork(struct task_struct *p)
+static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	p->on_rq			= 0;
 
@@ -1725,11 +1725,15 @@ static void __sched_fork(struct task_struct *p)
 		p->mm->numa_scan_seq = 0;
 	}
 
+	if (clone_flags & CLONE_VM)
+		p->numa_preferred_nid = current->numa_preferred_nid;
+	else
+		p->numa_preferred_nid = -1;
+
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_migrate_seq = 1;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
-	p->numa_preferred_nid = -1;
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults = NULL;
 	p->numa_faults_buffer = NULL;
@@ -1761,12 +1765,12 @@ void set_numabalancing_state(bool enabled)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(struct task_struct *p)
+void sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long flags;
 	int cpu = get_cpu();
 
-	__sched_fork(p);
+	__sched_fork(clone_flags, p);
 	/*
 	 * We mark the process as running here. This guarantees that
 	 * nobody will actually run it, and a signal or other external
@@ -4287,7 +4291,7 @@ void init_idle(struct task_struct *idle, int cpu)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
-	__sched_fork(idle);
+	__sched_fork(0, idle);
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
