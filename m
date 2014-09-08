Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaIHGlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaIHGlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:41:13 -0400
Date: Sun, 7 Sep 2014 23:39:40 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-90ed9cbe765ad358b3151a12b8bf889a3cbcd573@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        guillaume@morinfr.org, mschmidt@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org, ionut.m.alexa@gmail.com, tglx@linutronix.de,
        oleg@redhat.com, mhocko@suse.cz, rientjes@google.com,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        guillaume@morinfr.org, mschmidt@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org, ionut.m.alexa@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, rientjes@google.com, mhocko@suse.cz,
        lizefan@huawei.com
In-Reply-To: <1408133138-22048-2-git-send-email-riel@redhat.com>
References: <1408133138-22048-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] exit:
  Always reap resource stats in __exit_signal()
Git-Commit-ID: 90ed9cbe765ad358b3151a12b8bf889a3cbcd573
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90ed9cbe765ad358b3151a12b8bf889a3cbcd573
Gitweb:     http://git.kernel.org/tip/90ed9cbe765ad358b3151a12b8bf889a3cbcd573
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 15 Aug 2014 16:05:36 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Sep 2014 08:17:00 +0200

exit: Always reap resource stats in __exit_signal()

Oleg pointed out that wait_task_zombie adds a task's usage statistics
to the parent's signal struct, but the task's own signal struct should
also propagate the statistics at exit time.

This allows thread_group_cputime(reaped_zombie) to get the statistics
after __unhash_process() has made the task invisible to for_each_thread,
but before the thread has actually been rcu freed, making sure no
non-monotonic results are returned inside that window.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Guillaume Morin <guillaume@morinfr.org>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: umgwanakikbuti@gmail.com
Cc: fweisbec@gmail.com
Cc: srao@redhat.com
Cc: lwoodman@redhat.com
Cc: atheurer@redhat.com
Link: http://lkml.kernel.org/r/1408133138-22048-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
