Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbaLNTn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 14:43:28 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55625 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaLNTnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:43:19 -0500
Date: Sun, 14 Dec 2014 20:43:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Fix lost reschedule in __cond_resched()
Message-ID: <20141214194314.GA4398@gmail.com>
References: <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213073634.GD32572@gmail.com>
 <20141214180409.GB12622@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214180409.GB12622@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Dec 13, 2014 at 08:36:34AM +0100, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > I'm also not sure if the bug ever happens with preemption 
> > > disabled. Sasha, was that you who reported that you cannot 
> > > reproduce it without preemption? It strikes me that there's a 
> > > race condition in __cond_resched() wrt preemption, for example: 
> > > we do
> > > 
> > >         __preempt_count_add(PREEMPT_ACTIVE);
> > >         __schedule();
> > >         __preempt_count_sub(PREEMPT_ACTIVE);
> > > 
> > > and in between the __schedule() and __preempt_count_sub(), if 
> > > an interrupt comes in and wakes up some important process, it 
> > > won't reschedule (because preemption is active), but then we 
> > > enable preemption again and don't check whether we should 
> > > reschedule (again), and we just go on our merry ways.
> > 
> > Indeed, that's a really good find regardless of whether it's the 
> > source of these lockups - the (untested) patch below ought to 
> > cure that.
> > 
> > > Now, I don't see how that could really matter for a long time - 
> > > returning to user space will check need_resched, and sleeping 
> > > will obviously force a reschedule anyway, so these kinds of 
> > > races should at most delay things by just a tiny amount, but 
> > > maybe there is some case where we screw up in a bigger way. So 
> > > I do *not* believe that the one in __cond_resched() matters, 
> > > but I'm giving it as an example of the kind of things that 
> > > could go wrong.
> > 
> > (as you later note) NOHZ is somewhat special in this regard, 
> > because there we try really hard not to run anything 
> > periodically, so a lost reschedule will matter more.
> > 
> > But ... I'd be surprised if this patch made a difference: it 
> > should normally not be possible to go idle with tasks on the 
> > runqueue (even with this bug present), and with at least one busy 
> > task on the CPU we get the regular scheduler tick which ought to 
> > hide such latencies.
> > 
> > It's nevertheless a good thing to fix, I'm just not sure it's the 
> > root cause of the observed lockup here.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > --
> > 
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org> 
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index bb398c0c5f08..532809aa0544 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4207,6 +4207,8 @@ static void __cond_resched(void)
> >  	__preempt_count_add(PREEMPT_ACTIVE);
> >  	__schedule();
> >  	__preempt_count_sub(PREEMPT_ACTIVE);
> > +	if (need_resched())
> > +		__schedule();
> >  }
> 
> Nice catch! This indeed matters a lot for full nohz where a lost reschedule
> interrupt might be ignored and not fixed with a near tick. Although even if
> it is fixed by a tick, a missed reschedule delayed by HZ involves latency issue.
> 
> Anyway, probably the above __schedule() should stay as a preemption point
> to make sure that a TASK_[UN]INTERRUPTIBLE is handled as expected and avoids
> early task deactivation.
> 
> Such as:
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 240157c..6e942f3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2922,6 +2922,21 @@ void __sched schedule_preempt_disabled(void)
>  	preempt_disable();
>  }
>  
> +static void __preempt_schedule(void)
> +{
> +	do {
> +		__preempt_count_add(PREEMPT_ACTIVE);
> +		__schedule();
> +		__preempt_count_sub(PREEMPT_ACTIVE);
> +
> +		/*
> +		 * Check again in case we missed a preemption opportunity
> +		 * between schedule and now.
> +		 */
> +		barrier();
> +	} while (need_resched());
> +}
> +
>  #ifdef CONFIG_PREEMPT
>  /*
>   * this is the entry point to schedule() from in-kernel preemption
> @@ -2937,17 +2952,7 @@ asmlinkage __visible void __sched notrace preempt_schedule(void)
>  	if (likely(!preemptible()))
>  		return;
>  
> -	do {
> -		__preempt_count_add(PREEMPT_ACTIVE);
> -		__schedule();
> -		__preempt_count_sub(PREEMPT_ACTIVE);
> -
> -		/*
> -		 * Check again in case we missed a preemption opportunity
> -		 * between schedule and now.
> -		 */
> -		barrier();
> -	} while (need_resched());
> +	__preempt_schedule();
>  }
>  NOKPROBE_SYMBOL(preempt_schedule);
>  EXPORT_SYMBOL(preempt_schedule);
> @@ -4249,9 +4254,7 @@ SYSCALL_DEFINE0(sched_yield)
>  
>  static void __cond_resched(void)
>  {
> -	__preempt_count_add(PREEMPT_ACTIVE);
> -	__schedule();
> -	__preempt_count_sub(PREEMPT_ACTIVE);
> +	__preempt_schedule();
>  }

Yeah, agreed, your variant is even nicer.

Thanks,

	Ingo
