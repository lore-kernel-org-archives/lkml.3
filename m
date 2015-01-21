Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbbAUK1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:27:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50039 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAUK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:27:32 -0500
Date: Wed, 21 Jan 2015 02:27:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150121102726.GF9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107165223.GA21555@linux.vnet.ibm.com>
 <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com>
 <alpine.DEB.2.11.1501131215380.5526@nanos>
 <20150113184301.GO9719@linux.vnet.ibm.com>
 <20150113211618.GA21498@mail.thefacebook.com>
 <alpine.DEB.2.11.1501201419550.5526@nanos>
 <20150120203022.GR9719@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1501211027540.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501211027540.5526@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0005-0000-0000-00000831B77C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:30:07AM +0100, Thomas Gleixner wrote:
> On Tue, 20 Jan 2015, Paul E. McKenney wrote:
> > On Tue, Jan 20, 2015 at 02:21:51PM +0100, Thomas Gleixner wrote:
> > > The whole rcu_note_context_switch() in run_ksoftirqd() is silly.
> > > 
> > >     cond_resched()
> > > 	__preempt_count_add(PREEMPT_ACTIVE);
> > > 
> > > 	__schedule();
> > > 	     preempt_disable();
> > > 	     rcu_note_context_switch();
> > > 	     ....
> > > 
> > > 	__preempt_count_sub(PREEMPT_ACTIVE);
> > 
> > I agree that if should_resched() returns true as assumed above, then there
> > is no point to invoking rcu_note_context_switch().  However, the case that
> > this code applies to is when should_resched() returns false, but RCU is
> > waiting for a quiescent state from the current CPU.  In that case,
> > cond_resched() won't do anything for RCU, and we do need the
> > rcu_note_context_switch().
> 
> So this should be:
> 
>    if (!cond_resched()) {
	preempt_disable();
>       rcu_note_context_switch();
	preempt_enable();
     }
> 
> Hmm?

Going forward, yes, and cond_resched_rcu_qs() in fact does something
very similar.  For backporting, which is what this patch is for, we are
preserving the same double-quiescent-state behavior that existed earlier,
meaning minimal perturbation of old releases.

Seem reasonable, or do you really feel strongly about pushing this
optimization into -stable?

> > Of course, it would be better to avoid the extra RCU work in the common
> > case where cond_resched() does inovke the scheduler.  And that is the
> > point of the following patch, which uses cond_resched_rcu_qs().
> > However, this use of cond_resched_rcu_qs() doesn't work in older
> > kernels.  So Calvin's patch is for backporting, and the follow-up
> > patch for future kernels.
> 
> I see.

							Thanx, Paul

