Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbaDIQLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:11:37 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33204 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858AbaDIQLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:11:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/5] sched: Convert thread_group_cputime() to use for_each_thread()
Date: Wed,  9 Apr 2014 18:11:18 +0200
Message-Id: <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_each_thread/while_each_thread iterators are deprecated by
for_each_thread/for_each_process_thread() APIs.

Lets convert the callers in the cputime code accounting. The ultimate
goal is to remove the struct task_struct::thread_group field and
the corresponding do_each_thread/while_each_thread iterators that are
RCU unsafe.

It also makes thread_group_cputime() eventually RCU-safe.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/cputime.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a95097c..5d27848 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -281,11 +281,11 @@ static __always_inline bool steal_account_process_tick(void)
 
 /*
  * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
- * tasks (sum on group iteration) belonging to @tsk's group.
+ * tasks (sum on group iteration) belonging to @p's group.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputime(struct task_struct *p, struct task_cputime *times)
 {
-	struct signal_struct *sig = tsk->signal;
+	struct signal_struct *sig = p->signal;
 	cputime_t utime, stime;
 	struct task_struct *t;
 
@@ -295,16 +295,15 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	rcu_read_lock();
 	/* make sure we can trust tsk->thread_group list */
-	if (!likely(pid_alive(tsk)))
+	if (!likely(pid_alive(p)))
 		goto out;
 
-	t = tsk;
-	do {
+	for_each_thread(p, t) {
 		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
-	} while_each_thread(tsk, t);
+	}
 out:
 	rcu_read_unlock();
 }
-- 
1.8.3.1

