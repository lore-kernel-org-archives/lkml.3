Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaHOUHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaHOUHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:07:18 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: oleg@redhat.com, peterz@infradead.org, umgwanakikbuti@gmail.com,
        fweisbec@gmail.com, akpm@linux-foundation.org, srao@redhat.com,
        lwoodman@redhat.com, atheurer@redhat.com
Subject: [PATCH 1/3] exit: always reap resource stats in __exit_signal
Date: Fri, 15 Aug 2014 16:05:36 -0400
Message-Id: <1408133138-22048-2-git-send-email-riel@redhat.com>
In-Reply-To: <1408133138-22048-1-git-send-email-riel@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Oleg pointed out that wait_task_zombie adds a task's usage statistics
to the parent's signal struct, but the task's own signal struct should
also propagate the statistics at exit time.

This allows thread_group_cputime(reaped_zombie) to get the statistics
after __unhash_process() has made the task invisible to for_each_thread,
but before the thread has actually been rcu freed, making sure no
non-monotonic results are returned inside that window.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/exit.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..b93d46d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -115,30 +115,29 @@ static void __exit_signal(struct task_struct *tsk)
 
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
-		/*
-		 * Accumulate here the counters for all threads but the
-		 * group leader as they die, so they can be added into
-		 * the process-wide totals when those are taken.
-		 * The group leader stays around as a zombie as long
-		 * as there are other threads.  When it gets reaped,
-		 * the exit.c code will add its counts into these totals.
-		 * We won't ever get here for the group leader, since it
-		 * will have been the last reference on the signal_struct.
-		 */
-		task_cputime(tsk, &utime, &stime);
-		sig->utime += utime;
-		sig->stime += stime;
-		sig->gtime += task_gtime(tsk);
-		sig->min_flt += tsk->min_flt;
-		sig->maj_flt += tsk->maj_flt;
-		sig->nvcsw += tsk->nvcsw;
-		sig->nivcsw += tsk->nivcsw;
-		sig->inblock += task_io_get_inblock(tsk);
-		sig->oublock += task_io_get_oublock(tsk);
-		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
+	/*
+	 * Accumulate here the counters for all threads but the group leader
+	 * as they die, so they can be added into the process-wide totals
+	 * when those are taken.  The group leader stays around as a zombie as
+	 * long as there are other threads.  When it gets reaped, the exit.c
+	 * code will add its counts into these totals.  We won't ever get here
+	 * for the group leader, since it will have been the last reference on
+	 * the signal_struct.
+	 */
+	task_cputime(tsk, &utime, &stime);
+	sig->utime += utime;
+	sig->stime += stime;
+	sig->gtime += task_gtime(tsk);
+	sig->min_flt += tsk->min_flt;
+	sig->maj_flt += tsk->maj_flt;
+	sig->nvcsw += tsk->nvcsw;
+	sig->nivcsw += tsk->nivcsw;
+	sig->inblock += task_io_get_inblock(tsk);
+	sig->oublock += task_io_get_oublock(tsk);
+	task_io_accounting_add(&sig->ioac, &tsk->ioac);
+	sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	sig->nr_threads--;
 	__unhash_process(tsk, group_dead);
 
-- 
1.8.3.1

