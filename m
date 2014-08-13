Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaHMRhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:37:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaHMRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:37:05 -0400
Date: Wed, 13 Aug 2014 13:35:26 -0400
From: Rik van Riel <riel@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813133526.1eb5526f@cuia.bos.redhat.com>
In-Reply-To: <20140813172230.GA6296@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com>
	<20140812191218.GA15210@redhat.com>
	<53EA94DD.5040900@redhat.com>
	<20140813172230.GA6296@redhat.com>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 19:22:30 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 08/12, Rik van Riel wrote:
> >
> > Any other ideas?
> 
> To simplify, lets suppose that we only need sum_exec_runtime.
> 
> Perhaps we can do something like this

That would probably work, indeed.

However, it turns out that a seqcount doesn't look too badly either.

The following patch has only been compile tested so far, I am about to
give it a real test.

I believe k_getrusage can probably be changed in the same way.

---8<---

Subject: time,signal: protect cpu use statistics with seqcount

Both times() and clock_gettime(CLOCK_PROCESS_CPUTIME_ID) have scalability
issues on large systems, due to both functions being serialized with a
lock.

The lock protects against reporting a wrong value, due to a thread in the
task group exiting, its statistics reporting up to the signal struct, and
that exited task's statistics being counted twice (or not at all).

Protecting that with a lock results in times and clock_gettime being
completely serialized on large systems.

This can be fixed by using a seqcount around the events that gather and
propagate statistics. As an additional benefit, the protection code can
be moved into thread_group_cputime, slightly simplifying the calling
functions.

This way the statistics reporting code can run lockless.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/sched.h          |  1 +
 kernel/exit.c                  |  4 ++++
 kernel/fork.c                  |  1 +
 kernel/sched/cputime.c         | 36 +++++++++++++++++++++---------------
 kernel/sys.c                   |  2 --
 kernel/time/posix-cpu-timers.c |  9 ++++-----
 6 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 857ba40..5670d33 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -461,6 +461,7 @@ struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
+	seqcount_t		stats_seq; /* write nests inside spinlock */
 	wait_queue_head_t	signalfd_wqh;
 };
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..019c263 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -126,6 +126,7 @@ static void __exit_signal(struct task_struct *tsk)
 		 * will have been the last reference on the signal_struct.
 		 */
 		task_cputime(tsk, &utime, &stime);
+		write_seqcount_begin(&sighand->stats_seq);
 		sig->utime += utime;
 		sig->stime += stime;
 		sig->gtime += task_gtime(tsk);
@@ -137,6 +138,7 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
+		write_seqcount_end(&sighand->stats_seq);
 	}
 
 	sig->nr_threads--;
@@ -1041,6 +1043,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 */
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
+		write_seqcount_begin(&p->real_parent->sighand->stats_seq);
 		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime += tgutime + sig->cutime;
@@ -1065,6 +1068,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		write_seqcount_end(&p->real_parent->sighand->stats_seq);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 1380d8a..4681694 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1749,6 +1749,7 @@ static void sighand_ctor(void *data)
 	struct sighand_struct *sighand = data;
 
 	spin_lock_init(&sighand->siglock);
+	seqcount_init(&sighand->stats_seq);
 	init_waitqueue_head(&sighand->signalfd_wqh);
 }
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 72fdf06..370fd67 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -286,25 +286,34 @@ static __always_inline bool steal_account_process_tick(void)
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
 	struct signal_struct *sig = tsk->signal;
+	struct sighand_struct *sighand;
 	cputime_t utime, stime;
 	struct task_struct *t;
-
-	times->utime = sig->utime;
-	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
+	int seq;
 
 	rcu_read_lock();
-	/* make sure we can trust tsk->thread_group list */
-	if (!likely(pid_alive(tsk)))
+	sighand = rcu_dereference(tsk->sighand);
+	if (unlikely(!sighand))
 		goto out;
 
-	t = tsk;
 	do {
-		task_cputime(t, &utime, &stime);
-		times->utime += utime;
-		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
-	} while_each_thread(tsk, t);
+		seq = read_seqcount_begin(&sighand->stats_seq);
+		times->utime = sig->utime;
+		times->stime = sig->stime;
+		times->sum_exec_runtime = sig->sum_sched_runtime;
+
+		/* make sure we can trust tsk->thread_group list */
+		if (!likely(pid_alive(tsk)))
+			goto out;
+
+		t = tsk;
+		do {
+			task_cputime(t, &utime, &stime);
+			times->utime += utime;
+			times->stime += stime;
+			times->sum_exec_runtime += task_sched_runtime(t);
+		} while_each_thread(tsk, t);
+	} while (read_seqcount_retry(&sighand->stats_seq, seq));
 out:
 	rcu_read_unlock();
 }
@@ -617,9 +626,6 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
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
index 3b89464..1bde818 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -781,14 +781,14 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		cpu_clock_sample(timer->it_clock, p, &now);
 	} else {
 		struct sighand_struct *sighand;
-		unsigned long flags;
 
 		/*
 		 * Protect against sighand release/switch in exit/exec and
 		 * also make timer sampling safe if it ends up calling
 		 * thread_group_cputime().
 		 */
-		sighand = lock_task_sighand(p, &flags);
+		rcu_read_lock();
+		sighand = rcu_dereference(p->sighand);
 		if (unlikely(sighand == NULL)) {
 			/*
 			 * The process has been reaped.
@@ -798,10 +798,9 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			timer->it.cpu.expires = 0;
 			sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
 					   &itp->it_value);
-		} else {
+		} else
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			unlock_task_sighand(p, &flags);
-		}
+		rcu_read_unlock();
 	}
 
 	if (now < timer->it.cpu.expires) {
