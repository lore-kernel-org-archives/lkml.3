Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaIIUQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:16:51 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36866 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaIIUQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:16:49 -0400
Date: Tue, 9 Sep 2014 13:14:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Hugh Dickins <hughd@google.com>, Chintan Pandya <cpandya@codeaurora.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] ksm: provide support to use deferrable timers
 for scanner thread
In-Reply-To: <20140908093949.GZ6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.11.1409091225310.8432@eggly.anvils>
References: <1408536628-29379-1-git-send-email-cpandya@codeaurora.org> <1408536628-29379-2-git-send-email-cpandya@codeaurora.org> <alpine.LSU.2.11.1408272258050.10518@eggly.anvils> <20140903095815.GK4783@worktop.ger.corp.intel.com>
 <alpine.LSU.2.11.1409080023100.1610@eggly.anvils> <20140908093949.GZ6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 01:25:36AM -0700, Hugh Dickins wrote:
> > 
> > --- 3.17-rc4/include/linux/ksm.h	2014-03-30 20:40:15.000000000 -0700
> > +++ linux/include/linux/ksm.h	2014-09-07 11:54:41.528003316 -0700
> 
> > @@ -87,6 +96,11 @@ static inline void ksm_exit(struct mm_st
> >  {
> >  }
> >  
> > +static inline wait_queue_head_t *ksm_switch(struct mm_struct *mm)
> 
> s/ksm_switch/__&/

I don't think so (and I did try building with CONFIG_KSM off too).

> 
> > +{
> > +	return NULL;
> > +}
> > +
> >  static inline int PageKsm(struct page *page)
> >  {
> >  	return 0;
> 
> > --- 3.17-rc4/kernel/sched/core.c	2014-08-16 16:00:54.062189063 -0700
> > +++ linux/kernel/sched/core.c	2014-09-07 11:54:41.528003316 -0700
> 
> > @@ -2304,6 +2305,7 @@ context_switch(struct rq *rq, struct tas
> >  	       struct task_struct *next)
> >  {
> >  	struct mm_struct *mm, *oldmm;
> > +	wait_queue_head_t *wake_ksm = NULL;
> >  
> >  	prepare_task_switch(rq, prev, next);
> >  
> > @@ -2320,8 +2322,10 @@ context_switch(struct rq *rq, struct tas
> >  		next->active_mm = oldmm;
> >  		atomic_inc(&oldmm->mm_count);
> >  		enter_lazy_tlb(oldmm, next);
> > -	} else
> > +	} else {
> >  		switch_mm(oldmm, mm, next);
> > +		wake_ksm = ksm_switch(mm);
> 
> Is this the right mm?

It's next->mm, that's the one I intended (though the patch might
be equally workable using prev->mm instead: given free rein, I'd
have opted for hooking into both prev and next, but free rein is
definitely not what should be granted around here!).

> We've just switched the stack,

I thought that came in switch_to() a few lines further down,
but don't think it matters for this.

> so we're looing at next->mm when we switched away from current.
> That might not exist anymore.

I fail to see how that can be.  Looking at the x86 switch_mm(),
I can see it referencing (unsurprisingly!) both old and new mms
at this point, and no reference to an mm is dropped before the
ksm_switch().  oldmm (there called mm) is mmdropped later in
finish_task_switch().

> 
> > +	}
> >  
> >  	if (!prev->mm) {
> >  		prev->active_mm = NULL;
> > @@ -2348,6 +2352,9 @@ context_switch(struct rq *rq, struct tas
> >  	 * frame will be invalid.
> >  	 */
> >  	finish_task_switch(this_rq(), prev);
> > +
> > +	if (wake_ksm)
> > +		wake_up_interruptible(wake_ksm);
> >  }
> 
> Quite horrible for sure. I really hate seeing KSM cruft all the way down

Yes, I expected that, and I would certainly feel the same way.

And even worse, imagine if this were successful, we might come along
and ask to do something similar for khugepaged.  Though if it comes to
that, I'm sure we would generalize into one hook which does not say
"ksm" or "khugepaged" on it, but would still a present a single unlikely
flag to be tested at this level.  Maybe you would even prefer the
generalized version, but I don't want to complicate the prototype yet.

If it weren't for the "we already have the mm cachelines here" argument,
I by now feel fairly sure that I would be going for hooking into timer
tick instead (where Thomas could then express his horror!).

Do you think I should just forget about cacheline micro-optimizations
and go in that direction instead?

> here. Can't we create a new (timer) infrastructure that does the right
> thing? Surely this isn't the only such case.

A sleep-walking timer, that goes to sleep in one bed, but may wake in
another; and defers while beds are empty?  I'd be happy to try using
that for KSM if it already existed, and no doubt Chintan would too

But I don't think KSM presents a very good case for developing it.
I think KSM's use of a sleep_millisecs timer is really just an apology
for the amount of often wasted work that it does, and dates from before
we niced it down 5.  I prefer the idea of a KSM which waits on activity
amongst the restricted set of tasks it is tracking: as this patch tries.

But my preference may be naive: doing lots of unnecessary work doesn't
matter as much as waking cpus from deep sleep.

> 
> I know both RCU and some NOHZ_FULL muck already track when the system is
> completely idle. This is yet another case of that.

Hugh
