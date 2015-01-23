Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbbAWPHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:07:44 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64736 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbbAWPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:07:41 -0500
Date: Fri, 23 Jan 2015 16:07:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] sched: Fix missing preemption opportunity
Message-ID: <20150123150730.GA16254@lerouge>
References: <1421946484-9298-1-git-send-email-fweisbec@gmail.com>
 <20150123091353.GI2896@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123091353.GI2896@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:13:53AM +0100, Peter Zijlstra wrote:
> 
> I picked up the patch; will drop it if Ingo also does ;-)
> 
> On Thu, Jan 22, 2015 at 06:08:04PM +0100, Frederic Weisbecker wrote:
> > +++ b/kernel/sched/core.c
> > @@ -2877,6 +2877,21 @@ void __sched schedule_preempt_disabled(void)
> >  	preempt_disable();
> >  }
> >  
> > +static void preempt_schedule_common(void)
> > +{
> > +	do {
> > +		__preempt_count_add(PREEMPT_ACTIVE);
> > +		__schedule();
> > +		__preempt_count_sub(PREEMPT_ACTIVE);
> > +
> > +		/*
> > +		 * Check again in case we missed a preemption opportunity
> > +		 * between schedule and now.
> > +		 */
> > +		barrier();
> 
> I do however wonder about this barrier() here; why do we think we need
> it?
> 
> Is that because test_bit() it 'broken'? The bitops are typically atomic
> ops and atomic reads should be through a volatile cast (x86
> constant_test_bit doesn't seem to do this).
> 
> Should we go audit and fix that?

I looked up with git blame and this was already there prior the first git commit v2.6.12
without appropriate explanation.

We must make sure that the PREEMPT_ACTIVE decrement is visible before we do the NEED_RESCHED
test or an interrupt could spuriously miss a preempt_schedule_irq() opportunity.

__preempt_count_sub() in asm-generic is an inline, so an implicit barrier(). Only x86
overwrites it yet and it does so through an inline as well.

And __preempt_count_ops() must really imply a barrier() anyway, anything else would
be insane (probably we should specify that in a comment somewhere). Although I see
that responsability is taken from non-underscored callers...
