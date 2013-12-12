Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3LLRKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:10:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:45437 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751656Ab3LLRKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:10:17 -0500
Date: Thu, 12 Dec 2013 12:10:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212121015.139ebe8c@gandalf.local.home>
In-Reply-To: <20131212115137.4e5d156f@gandalf.local.home>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
	<1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
	<20131212114447.GH21999@twins.programming.kicks-ass.net>
	<20131212094227.0a227f6f@gandalf.local.home>
	<20131212160323.GJ21999@twins.programming.kicks-ass.net>
	<20131212115137.4e5d156f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 11:51:37 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > 
> > Typically such a barrier comes from set_current_state(), the normal
> > pattern is something like:
> > 
> >   set_current_state(TASK_UNINTERRUPTIBLE)
> >   if (!cond)
> >   	schedule();
> >   __set_current_state(TASK_RUNNING);
> > 
> > vs
> > 
> >   cond = true;
> >   wake_up_process(&foo);
> 
> Hmm, that __set_current_state() in swait_prepare() does indeed seem
> buggy. I'm surprised that I didn't catch that, as I'm usually a
> stickler with set_current_state() (and I'm very paranoid when it comes
> to using __set_current_state()).
> 
> I'll have to dig deeper to see why I didn't change that.

OK, looking at my irc logs discussing this with Paul McKenney, this was
an optimization:

<rostedt> as set_current_state() may be too big of a heavy weight
<rostedt> It's usually to synchronize between wake ups and state stet
<rostedt> set
<rostedt> but both the set state and the wakeup is within the same spin
lock


So if we break up your code above, we have:

	raw_spin_lock_irqsave(&head->lock, flags);
	w->task = current;
	if (list_empty(&w->node)) {
		list_add(&w->node, &head->list);
		smp_mb();
	}
	__set_current_state(state);
	raw_spin_unlock_irqrestore(&head->lock, flags);

	if (!cond)
		schedule();


vs

	cond = true;

	raw_spin_lock_irqsave(&head->lock, flags);
	woken = __swait_wake_locked(head, state, num);
	raw_spin_unlock_irqrestore(&head->lock, flags);


That is, the change of state with respect to the list is synchronized
by the head->lock. We only need to synchronize seeing the condition
with the adding to the list. Once we are on the list, we get woken up
regardless.

But I think this is a micro optimization, and probably still buggy, as
I can imagine a race if we are already on the list, and we don't call
the memory barrier and miss seeing the condition after being woken up
and resetting ourselves back to a sleeping state.

Paul,

You can remove the smp_mb() from __swait_enqueue() and instead replace
the __set_current_state() to set_current_state() in
swait_prepare_locked().

Thanks!

-- Steve
