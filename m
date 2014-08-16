Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaHPRko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 13:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaHPRkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 13:40:42 -0400
Date: Sat, 16 Aug 2014 13:40:10 -0400
From: Rik van Riel <riel@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com
Subject: [PATCH v2 2/3] time,signal: protect resource use statistics with
 seqlock
Message-ID: <20140816134010.26a9b572@annuminas.surriel.com>
In-Reply-To: <20140816141159.GA8709@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com>
	<1408133138-22048-3-git-send-email-riel@redhat.com>
	<20140816141159.GA8709@redhat.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2014 16:11:59 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Rik, I do not understand why did you silently ignore my comments about
> this change twice ;)

Here is the version I have actually been running my latest
tests with. This one addresses the forward progress issue
you pointed out.

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
 kernel/exit.c                  |  4 ++++
 kernel/fork.c                  |  1 +
 kernel/sched/cputime.c         | 33 ++++++++++++++++++++-------------
 kernel/sys.c                   |  2 --
 kernel/time/posix-cpu-timers.c | 14 --------------
 6 files changed, 26 insertions(+), 29 deletions(-)

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
index b93d46d..fa09b86 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -127,6 +127,7 @@ static void __exit_signal(struct task_struct *tsk)
 	 * the signal_struct.
 	 */
 	task_cputime(tsk, &utime, &stime);
+	write_seqlock(&sig->stats_lock);
 	sig->utime += utime;
 	sig->stime += stime;
 	sig->gtime += task_gtime(tsk);
@@ -140,6 +141,7 @@ static void __exit_signal(struct task_struct *tsk)
 	sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	sig->nr_threads--;
 	__unhash_process(tsk, group_dead);
+	write_sequnlock(&sig->stats_lock);
 
 	/*
 	 * Do this under ->siglock, we can race with another thread
@@ -1042,6 +1044,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
+		write_seqlock(&psig->stats_lock);
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
 		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
@@ -1064,6 +1067,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
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
index 3e52836..49b7cfe 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -288,18 +288,28 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
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
+		/* If lockless access failed, take the lock. */
+		nextseq = 1;
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry(&sig->stats_lock, seq);
 	rcu_read_unlock();
 }
 
@@ -611,9 +621,6 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
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
