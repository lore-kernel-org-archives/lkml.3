Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaFFDTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:19:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:44462 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751953AbaFFDTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:19:42 -0400
Date: Thu, 5 Jun 2014 23:19:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140605231940.1fc277a4@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406041623170.3319@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
	<20140603210609.62de6451@gandalf.local.home>
	<alpine.DEB.2.10.1406041623170.3319@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 17:32:37 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 3 Jun 2014, Steven Rostedt wrote:
> > On Fri, 23 May 2014 09:30:10 -0500
> > "Brad Mouring" <bmouring@ni.com> wrote:
> > >  	/* Deadlock detection */
> > >  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> > > +		/*
> > > +		 * If the prio chain has changed out from under us, set the task
> > > +		 * to the current owner of the lock in the current waiter and
> > > +		 * continue walking the prio chain
> > > +		 */
> > > +		if (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task) {
> 
> No, sorry. That's wrong.
> 
> Your change wreckages the rt_mutex_owner(lock) == top_task test
> simply because in that case:
> 
>    (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task)
> 
> evaluates to true.

I'm not so sure that's true. Because if this is a deadlock in the case
that rt_mutex_owner(lock) == top_task, then task == top_task should
also be true.

> 
> Aside of that we need to figure out whether the lock chain changed
> while we dropped the locks even in the non dead lock case. Otherwise
> we follow up the wrong chain there.
> 
> T0 blocked on L1 held by T1
> T1 blocked on L2 held by T2
> T2 blocked on L3 held by T3
> 
> So we walk the chain and do:
> 
>    T1 -> L2 -> T2
> 
> Now here we get preempted.
> 
> T3 releases L3
> T2 gets L3
> T2 drops L3 and L2
> T2 blocks on L4 held by T4
> T4 blocked on L5 held by T5
> 
> So we happily boost T4 and T5. Not what we really want to do.
> 
> Nasty, isn't it ?

As I stated before, it just wastes cycles. But looking at both your
next_lock code and this, I'm thinking we can simply break out if we
find that rt_mutex_owner(lock) != task. Because that means when we let
go of the locks, the current lock we are going up was released and
retaken. That would mean the chain walk should stop. It's similar to
the next lock being what we expected.

Perhaps something like this:

---
 kernel/locking/rtmutex.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-rt.git/kernel/locking/rtmutex.c
===================================================================
--- linux-rt.git.orig/kernel/locking/rtmutex.c	2014-06-05 23:00:56.197855465 -0400
+++ linux-rt.git/kernel/locking/rtmutex.c	2014-06-05 23:14:44.164414857 -0400
@@ -284,7 +284,7 @@
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex *lock;
+	struct rt_mutex *lock = orig_lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
 	int detect_deadlock, ret = 0, depth = 0;
 	unsigned long flags;
@@ -322,6 +322,16 @@
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
+	/*
+	 * When we dropped the spinlocks, if the owner of the lock we
+	 * are currently processing changed since we chain walked
+	 * to that lock, we are done with the chain walk. The previous
+	 * owner was obviously running to release it.
+	 */
+	if (lock && rt_mutex_owner(lock) != task)
+		goto out_unlock_pi;
+
+
 	waiter = task->pi_blocked_on;
 	/*
 	 * Check whether the end of the boosting chain has been
