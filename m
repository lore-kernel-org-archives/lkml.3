Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaHOCPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 22:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaHOCPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 22:15:21 -0400
Date: Thu, 14 Aug 2014 22:14:47 -0400
From: Rik van Riel <riel@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
Message-ID: <20140814221447.7b8cf03f@annuminas.surriel.com>
In-Reply-To: <20140814161247.GA32715@redhat.com>
References: <20140812191218.GA15210@redhat.com>
	<53EA94DD.5040900@redhat.com>
	<20140813172230.GA6296@redhat.com>
	<20140813133526.1eb5526f@cuia.bos.redhat.com>
	<20140813180807.GA8098@redhat.com>
	<53EBADB1.2020403@redhat.com>
	<20140813184511.GA9663@redhat.com>
	<20140813170324.544aaf2d@cuia.bos.redhat.com>
	<20140814142404.GA28211@redhat.com>
	<53ECD7C8.6040202@redhat.com>
	<20140814161247.GA32715@redhat.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 18:12:47 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Or you can expand the scope of write_seqlock/write_sequnlock, so that
> __unhash_process in called from inside the critical section. This looks
> simpler at first glance.
> 
> Hmm, wait, it seems there is yet another problem ;) Afaics, you also
> need to modify __exit_signal() so that ->sum_sched_runtime/etc are
> accounted unconditionally, even if the group leader exits.

OK, this is what I have now.

I am still getting backwards time sometimes, but only tiny
increments. This suggests that cputime_adjust() may be the
culprit, and I have no good idea on how to fix that yet...

Should task_cputime_adjusted and thread_group_cputime_adjusted
pass in the address of a seqlock to use in case the values in
prev need to be updated?

Should we check whether the values in prev changed during the
time spent in the function?

Is this a race between task_cputime_adjusted and other writers
of signal->utime and signal->stime, instead of task_cputime_adjusted
racing with itself?

I am not sure what the best approach here is...

---8<---

Subject: time,signal: protect resource use statistics with seqlock

Both times() and clock_gettime(CLOCK_PROCESS_CPUTIME_ID) have scalability
issues on large systems, due to both functions being serialized with a
lock.

The lock protects against reporting a wrong value, due to a thread in the
task group exiting, its statistics reporting up to the signal struct, and
that exited task's statistics being counted twice (or not at all).

Protecting that with a lock results in times and clock_gettime being
completely serialized on large systems.

This can be fixed by using a seqlock around the events that gather and
propagate statistics. As an additional benefit, the protection code can
be moved into thread_group_cputime, slightly simplifying the calling
functions.

In the case of posix_cpu_clock_get_task things can be simplified a
lot, because the calling function already ensures tsk sticks around,
and the rest is now taken care of in thread_group_cputime.

This way the statistics reporting code can run lockless.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/sched.h          |  1 +
 kernel/exit.c                  | 48 +++++++++++++++++++++++-------------------
 kernel/fork.c                  |  1 +
 kernel/sched/cputime.c         | 36 +++++++++++++++++++------------
 kernel/sys.c                   |  2 --
 kernel/time/posix-cpu-timers.c | 14 ------------
 6 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 857ba40..91f9209 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -646,6 +646,7 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
+	seqlock_t stats_lock;
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..c1a0ef2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -115,32 +115,34 @@ static void __exit_signal(struct task_struct *tsk)
 
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
+	 * Accumulate here the counters for all threads but the
+	 * group leader as they die, so they can be added into
+	 * the process-wide totals when those are taken.
+	 * The group leader stays around as a zombie as long
+	 * as there are other threads.  When it gets reaped,
+	 * the exit.c code will add its counts into these totals.
+	 * We won't ever get here for the group leader, since it
+	 * will have been the last reference on the signal_struct.
+	 */
+	task_cputime(tsk, &utime, &stime);
+	write_seqlock(&sig->stats_lock);
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
+	write_sequnlock(&sig->stats_lock);
 
 	/*
 	 * Do this under ->siglock, we can race with another thread
@@ -1043,6 +1045,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
+		write_seqlock(&psig->stats_lock);
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
 		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
@@ -1065,6 +1068,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		write_sequnlock(&psig->stats_lock);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 1380d8a..5d7cf2b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1068,6 +1068,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
+	seqlock_init(&sig->stats_lock);
 
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->real_timer.function = it_real_fn;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 3e52836..b5f1c58 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -288,18 +288,31 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	struct signal_struct *sig = tsk->signal;
 	cputime_t utime, stime;
 	struct task_struct *t;
-
-	times->utime = sig->utime;
-	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
+	unsigned int seq, nextseq;
 
 	rcu_read_lock();
-	for_each_thread(tsk, t) {
-		task_cputime(t, &utime, &stime);
-		times->utime += utime;
-		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
-	}
+	/* Attempt a lockless read on the first round. */
+	nextseq = 0;
+	do {
+		seq = nextseq;
+		read_seqbegin_or_lock(&sig->stats_lock, &seq);
+		times->utime = sig->utime;
+		times->stime = sig->stime;
+		times->sum_exec_runtime = sig->sum_sched_runtime;
+
+		for_each_thread(tsk, t) {
+			task_cputime(t, &utime, &stime);
+			times->utime += utime;
+			times->stime += stime;
+			times->sum_exec_runtime += task_sched_runtime(t);
+		}
+		/*
+		 * If a writer is currently active, seq will be odd, and
+		 * read_seqbegin_or_lock will take the lock.
+		 */
+		nextseq = raw_read_seqcount(&sig->stats_lock.seqcount);
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry(&sig->stats_lock, seq);
 	rcu_read_unlock();
 }
 
@@ -611,9 +624,6 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
-/*
- * Must be called with siglock held.
- */
 void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct task_cputime cputime;
diff --git a/kernel/sys.c b/kernel/sys.c
index ce81291..b663664 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -862,11 +862,9 @@ void do_sys_times(struct tms *tms)
 {
 	cputime_t tgutime, tgstime, cutime, cstime;
 
-	spin_lock_irq(&current->sighand->siglock);
 	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
-	spin_unlock_irq(&current->sighand->siglock);
 	tms->tms_utime = cputime_to_clock_t(tgutime);
 	tms->tms_stime = cputime_to_clock_t(tgstime);
 	tms->tms_cutime = cputime_to_clock_t(cutime);
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 3b89464..492b986 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -272,22 +272,8 @@ static int posix_cpu_clock_get_task(struct task_struct *tsk,
 		if (same_thread_group(tsk, current))
 			err = cpu_clock_sample(which_clock, tsk, &rtn);
 	} else {
-		unsigned long flags;
-		struct sighand_struct *sighand;
-
-		/*
-		 * while_each_thread() is not yet entirely RCU safe,
-		 * keep locking the group while sampling process
-		 * clock for now.
-		 */
-		sighand = lock_task_sighand(tsk, &flags);
-		if (!sighand)
-			return err;
-
 		if (tsk == current || thread_group_leader(tsk))
 			err = cpu_clock_sample_group(which_clock, tsk, &rtn);
-
-		unlock_task_sighand(tsk, &flags);
 	}
 
 	if (!err)
