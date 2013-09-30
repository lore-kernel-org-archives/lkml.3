Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3I3NLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab3I3NL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:11:28 -0400
Date: Mon, 30 Sep 2013 15:03:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] introduce synchronize_sched_{enter,exit}()
Message-ID: <20130930130359.GB19560@redhat.com>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de> <1378805550-29949-38-git-send-email-mgorman@suse.de> <20130917143003.GA29354@twins.programming.kicks-ass.net> <20130929183634.GA15563@redhat.com> <20130929173447.14accc5f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929173447.14accc5f@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Steven Rostedt wrote:
>
> On Sun, 29 Sep 2013 20:36:34 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
>
> > Why? Say, percpu_rw_semaphore, or upcoming changes in get_online_cpus(),
> > (Peter, I think they should be unified anyway, but lets ignore this for
> > now). Or freeze_super() (which currently looks buggy), perhaps something
> > else. This pattern
> >
>
> Just so I'm clear to what you are trying to implement... This is to
> handle the case (as Paul said) to see changes to state by RCU and back
> again? That is, it isn't enough to see that the state changed to
> something (like SLOW MODE), but we also need a way to see it change
> back?

Suppose this code was applied as is. Now we can change percpu_rwsem,
see the "patch" below. (please ignore _expedited in the current code).

This immediately makes percpu_up_write() much faster, it no longer
blocks. And the contending writers (or even the same writer which
takes it again) can avoid synchronize_sched() in percpu_down_write().

And to remind, we can add xxx_struct->exclusive (or add the argument
to xxx_enter/exit), and then (with some other changes) we can kill
percpu_rw_semaphore->rw_sem.

> With get_online_cpus(), we need to see the state where it changed to
> "performing hotplug" where holders need to go into the slow path, and
> then also see the state change to "no longe performing hotplug" and the
> holders now go back to fast path. Is this the rational for this email?

The same. cpu_hotplug_begin/end (I mean the code written by Peter) can
be changed to use xxx_enter/exit.

Oleg.

--- x/include/linux/percpu-rwsem.h
+++ x/include/linux/percpu-rwsem.h
@@ -8,8 +8,8 @@
 #include <linux/lockdep.h>
 
 struct percpu_rw_semaphore {
+	xxx_struct		xxx;
 	unsigned int __percpu	*fast_read_ctr;
-	atomic_t		write_ctr;
 	struct rw_semaphore	rw_sem;
 	atomic_t		slow_read_ctr;
 	wait_queue_head_t	write_waitq;
--- x/lib/percpu-rwsem.c
+++ x/lib/percpu-rwsem.c
@@ -17,7 +17,7 @@ int __percpu_init_rwsem(struct percpu_rw
 
 	/* ->rw_sem represents the whole percpu_rw_semaphore for lockdep */
 	__init_rwsem(&brw->rw_sem, name, rwsem_key);
-	atomic_set(&brw->write_ctr, 0);
+	xxx_init(&brw->xxx, ...);
 	atomic_set(&brw->slow_read_ctr, 0);
 	init_waitqueue_head(&brw->write_waitq);
 	return 0;
@@ -25,6 +25,14 @@ int __percpu_init_rwsem(struct percpu_rw
 
 void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
 {
+	might_sleep();
+
+	// pseudo code which needs another simple xxx_ helper
+	if (xxx->gp_state == GP_REPLAY)
+		xxx->gp_state == GP_PENDING;
+	if (xxx->gp_state)
+		synchronize_sched();
+
 	free_percpu(brw->fast_read_ctr);
 	brw->fast_read_ctr = NULL; /* catch use after free bugs */
 }
@@ -57,7 +65,7 @@ static bool update_fast_ctr(struct percp
 	bool success = false;
 
 	preempt_disable();
-	if (likely(!atomic_read(&brw->write_ctr))) {
+	if (likely(xxx_is_idle(&brw->xxx))) {
 		__this_cpu_add(*brw->fast_read_ctr, val);
 		success = true;
 	}
@@ -126,20 +134,7 @@ static int clear_fast_ctr(struct percpu_
  */
 void percpu_down_write(struct percpu_rw_semaphore *brw)
 {
-	/* tell update_fast_ctr() there is a pending writer */
-	atomic_inc(&brw->write_ctr);
-	/*
-	 * 1. Ensures that write_ctr != 0 is visible to any down_read/up_read
-	 *    so that update_fast_ctr() can't succeed.
-	 *
-	 * 2. Ensures we see the result of every previous this_cpu_add() in
-	 *    update_fast_ctr().
-	 *
-	 * 3. Ensures that if any reader has exited its critical section via
-	 *    fast-path, it executes a full memory barrier before we return.
-	 *    See R_W case in the comment above update_fast_ctr().
-	 */
-	synchronize_sched_expedited();
+	xxx_enter(&brw->xxx);
 
 	/* exclude other writers, and block the new readers completely */
 	down_write(&brw->rw_sem);
@@ -159,7 +154,5 @@ void percpu_up_write(struct percpu_rw_se
 	 * Insert the barrier before the next fast-path in down_read,
 	 * see W_R case in the comment above update_fast_ctr().
 	 */
-	synchronize_sched_expedited();
-	/* the last writer unblocks update_fast_ctr() */
-	atomic_dec(&brw->write_ctr);
+	xxx_exit();
 }

