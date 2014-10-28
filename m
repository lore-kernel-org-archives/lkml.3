Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaJ1IXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:23:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaJ1IXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:23:47 -0400
Date: Tue, 28 Oct 2014 09:23:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141028082335.GM3337@twins.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <1411633803.15810.12.camel@marge.simpson.net>
 <20140925090619.GA5430@worktop>
 <20140925091556.GB5430@worktop>
 <20141002102251.GA6324@worktop.programming.kicks-ass.net>
 <20141002121553.GB6324@worktop.programming.kicks-ass.net>
 <20141027134103.GA10476@twins.programming.kicks-ass.net>
 <20141028000703.GA22964@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028000703.GA22964@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:07:03AM +0100, Oleg Nesterov wrote:
> On 10/27, Peter Zijlstra wrote:
> >
> > On Thu, Oct 02, 2014 at 02:15:53PM +0200, Peter Zijlstra wrote:
> > > On Thu, Oct 02, 2014 at 12:22:51PM +0200, Peter Zijlstra wrote:
> >
> > > > +#define __wait_event_freezable(wq, condition)				\
> > > > +	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
> > > > +			    schedule(); try_to_freeze())
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> see below.

> I was going to say that wait_event_freezable() in kauditd_thread()
> is not friendly wrt kthread_should_stop() and thus we we need
> kthread_freezable_should_stop().

I'm not sure those two would interact, yes, both would first set either
the freezable or stop bit and then wake. If both were to race, all we
need to ensure is to check both before calling schedule again.

A loop like:

	while (!kthread_should_stop()) {
		wait_event_freezable(wq, cond);
	}

Would satisfy that, because even if kthread_should_stop() gets set first
and then freezing happens and we get into try_to_freeze() first, we'd
still to the kthread_should_stop() check right after we thaw.

So I don't se a reason to collect both stop and freeze into a single
thing.

> But in fact we never stop this kauditd_task, so I think we should
> turn the main loop into "for (;;)" and change this code to use
> wait_event_freezable() like your patch does.

Right.

> Perhaps it also makes sense to redefine wait_event_freezable.*()
> via ___wait_event(cmd => freezable_schedule), but I think this needs
> another patch.

So I talked to Rafael yesterday and I'm going to replace all the
wait_event*() stuff, and I suppose also freezable_schedule() because
they're racy.

The moment we call freezer_do_not_count() the freezer will ignore us,
this means the thread could still be running (albeit not for long) when
the freezer reports success.

Ideally I'll be able to kill the entire freezer_do_not_count() stuff.
