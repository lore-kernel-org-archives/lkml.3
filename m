Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaLCXt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:49:28 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43738 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLCXt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:49:27 -0500
Date: Thu, 4 Dec 2014 00:49:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Jones <davej@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: audit: rcu_read_lock() used illegally while idle
Message-ID: <20141203234922.GD31369@lerouge>
References: <20141203181922.GA26916@redhat.com>
 <20141203192919.GP25340@linux.vnet.ibm.com>
 <547F6D60.5050007@amacapital.net>
 <20141203201947.GA4931@redhat.com>
 <CALCETrVtKcwWsN4q7kp-K7kEfQyebKfSbBQy4iAhfP0WPVZNpQ@mail.gmail.com>
 <20141203220836.GC31369@lerouge>
 <CALCETrU321dBwOgeQOO9aao4D-exmFHBFSoWKJJ6yoCgufofzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU321dBwOgeQOO9aao4D-exmFHBFSoWKJJ6yoCgufofzQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 02:12:43PM -0800, Andy Lutomirski wrote:
> On Wed, Dec 3, 2014 at 2:08 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > I don't know. It's possible that something went wrong with the recent entry_64.S
> > and ptrace.c rework.
> >
> > Previously we expected to set context tracking to user state from syscall_trace_exit()
> > and to kernel state from syscall_trace_enter(). And if anything using RCU
> > was called between syscall_trace_exit() and the actual return to userspace, the code
> > had to be wrapped between user_exit() *code* user_enter().
> >
> > So it looked like this:
> >
> >
> >            syscall {
> >                 //enter kernel
> >                 syscall_trace_enter() {
> >                     user_exit();
> >                 }
> >
> >                 syscall()
> >
> >                 syscall_trace_enter() {
> 
> Do you mean syscall_trace_leave()?  But syscall_trace_leave isn't called here...

Right :-)

> 
> >                     user_enter();
> >                 }
> >
> >                 while (test_thread_flag(TIF_EXIT_WORK)) {
> >                     if (need_resched()) {
> >                         schedule_user() {
> >                             user_exit();
> >                             schedule()
> >                             user_enter();
> >                         }
> >                     }
> >
> >                     if ( need signal ) {
> >                          do_notify_resume() {
> >                             user_exit()
> >                             handle signal and stuff
> >                             user_enter()
> >                          }
> >                     }
> 
> ... it's called hereabouts or so.
> 
> >                  }
> >             }
> >
> > This is suboptimal but it doesn't impact the syscall fastpath
> > and it's correct from cputime accounting and RCU point of views.
> >
> > Now maybe the recent logic rework broke the above assumptions?
> 
> The big rework was entry, not exit, so I don't see the issue.

And you're right actually :-) I just rewinded to the times when I added
SCHEDULE_USER and actually things happen a bit differently than I thought
and it looks like things haven't changed much since then

            syscall {
                 //enter kernel
                 syscall_trace_enter() {
                     user_exit();
                 }

                 syscall()

                 while (test_thread_flag(TIF_ALLWORK_MASK)) {
                     if (need_resched()) {
                         schedule_user() {
                             user_exit();
                             schedule()
                             user_enter();
                         }
                     } else {
                         if (test_thread_flag(TIF_WORK_SYSCALL_EXIT)) {
                             syscall_trace_leave() {
                                 user_enter();
                             }
                         } else if (test_thread_flag(TIF_DO_NOTIFY_MASK) {)
                             do_notify_resume() {
                                 user_exit()
                                 handle signal and stuff
                                 user_enter()
                          } else {
                             //ignored but unexpected, should we warn?
                          }
                     }

             }

So schedule_user() may well be called before syscall_trace_leave() after all.
This mean that schedule_user() can call user_exit() whereas we are already in
the kernel from context tracking POV. Hence we have a context tracking imbalance
or a double call to user_exit() if you prefer.

Things probably happened to work somehow because double user_foo() calls are simply ignored,
and we've been lucky enough that it didn't explode is most scenarios.

The fix would be to change schedule_user() to handle random context tracking states.
exception_enter/exit() act like context_tracking_save()/context_tracking_restore()
so they fit pretty well there:

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24beb9b..6fe82fb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2869,15 +2869,18 @@ EXPORT_SYMBOL(schedule);
 #ifdef CONFIG_CONTEXT_TRACKING
 asmlinkage __visible void __sched schedule_user(void)
 {
+	enum ctx_state prev_ctx;
+
 	/*
 	 * If we come here after a random call to set_need_resched(),
 	 * or we have been woken up remotely but the IPI has not yet arrived,
-	 * we haven't yet exited the RCU idle mode. Do it here manually until
-	 * we find a better solution.
+	 * the context tracking is in a random state depending on which stage
+	 * we are on resuming to userspace. Exception_enter/exit() handle that
+	 * well by saving and restoring the current context tracking state.
 	 */
-	user_exit();
+	prev_ctx = exception_enter();
 	schedule();
-	user_enter();
+	exception_exit(prev_ctx);
 }
 #endif
 
 
> In any case, might it make sense to add warnings to user_exit and
> user_enter to ensure that they're called in the state in which they
> should be called?

Yeah I think we need to do that. We'll detect more easily issues like this
one.
