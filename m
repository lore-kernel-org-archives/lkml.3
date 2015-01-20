Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbbATUbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:31:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46336 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbATUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:31:23 -0500
Date: Tue, 20 Jan 2015 12:30:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150120203022.GR9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107014906.GA27996@mail.thefacebook.com>
 <20150107021926.GT5280@linux.vnet.ibm.com>
 <20150107165223.GA21555@linux.vnet.ibm.com>
 <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com>
 <alpine.DEB.2.11.1501131215380.5526@nanos>
 <20150113184301.GO9719@linux.vnet.ibm.com>
 <20150113211618.GA21498@mail.thefacebook.com>
 <alpine.DEB.2.11.1501201419550.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501201419550.5526@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012020-0017-0000-0000-000008188B9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 02:21:51PM +0100, Thomas Gleixner wrote:
> On Tue, 13 Jan 2015, Calvin Owens wrote:
> 
> > While debugging an issue with excessive softirq usage, I encountered the
> > following note in commit 3e339b5dae24a706 ("softirq: Use hotplug thread
> > infrastructure"):
> > 
> >     [ paulmck: Call rcu_note_context_switch() with interrupts enabled. ]
> > 
> > ...but despite this note, the patch still calls RCU with IRQs disabled.
> > 
> > This seemingly innocuous change caused a significant regression in softirq
> > CPU usage on the sending side of a large TCP transfer (~1 GB/s): when
> > introducing 0.01% packet loss, the softirq usage would jump to around 25%,
> > spiking as high as 50%. Before the change, the usage would never exceed 5%.
> > 
> > Moving the call to rcu_note_context_switch() after the cond_sched() call,
> > as it was originally before the hotplug patch, completely eliminated this
> > problem.
> > 
> > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > Cc: stable@vger.kernel.org
> > ---
> > This version includes the "cpu" argument to rcu_note_context_switch() in
> > order to apply cleanly to stable kernels. It will need to be removed to
> > apply to 3.18+ and 3.19 (upstream commit 38200cf2 removed the argument).
> > 
> >  kernel/softirq.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index 501baa9..9e787d8 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -656,9 +656,13 @@ static void run_ksoftirqd(unsigned int cpu)
> >  		 * in the task stack here.
> >  		 */
> >  		__do_softirq();
> > -		rcu_note_context_switch(cpu);
> >  		local_irq_enable();
> >  		cond_resched();
> > +
> > +		preempt_disable();
> > +		rcu_note_context_switch(cpu);
> > +		preempt_enable();
> > +
> 
> The whole rcu_note_context_switch() in run_ksoftirqd() is silly.
> 
>     cond_resched()
> 	__preempt_count_add(PREEMPT_ACTIVE);
> 
> 	__schedule();
> 	     preempt_disable();
> 	     rcu_note_context_switch();
> 	     ....
> 
> 	__preempt_count_sub(PREEMPT_ACTIVE);

I agree that if should_resched() returns true as assumed above, then there
is no point to invoking rcu_note_context_switch().  However, the case that
this code applies to is when should_resched() returns false, but RCU is
waiting for a quiescent state from the current CPU.  In that case,
cond_resched() won't do anything for RCU, and we do need the
rcu_note_context_switch().

Of course, it would be better to avoid the extra RCU work in the common
case where cond_resched() does inovke the scheduler.  And that is the
point of the following patch, which uses cond_resched_rcu_qs().
However, this use of cond_resched_rcu_qs() doesn't work in older
kernels.  So Calvin's patch is for backporting, and the follow-up
patch for future kernels.

Make sense, or am I missing something?

							Thanx, Paul

