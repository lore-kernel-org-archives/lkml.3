Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085AbaCPGJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 02:09:46 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39784 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaCPGJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 02:09:45 -0400
Message-ID: <1394950182.5470.15.camel@marge.simpson.net>
Subject: Re: cond_resched() and RCU CPU stall warnings
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@elte.hu, josh@joshtriplett.org,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 07:09:42 +0100
In-Reply-To: <20140316015914.GA22102@linux.vnet.ibm.com>
References: <20140316015914.GA22102@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-15 at 18:59 -0700, Paul E. McKenney wrote: 
> So I have been tightening up rcutorture a bit over the past year.
> The other day, I came across what looked like a great opportunity for
> further tightening, namely the schedule() in rcu_torture_reader().
> Why not turn this into a cond_resched(), speeding up the readers a bit
> and placing more stress on RCU?
> 
> And boy does it increase stress!
> 
> Unfortunately, this increased stress sometimes shows up in the form of
> lots of RCU CPU stall warnings.  These can appear when an instance of
> rcu_torture_reader() gets a CPU to itself, in which case it won't ever
> enter the scheduler, and RCU will never see a quiescent state from that
> CPU, which means the grace period never ends.
> 
> So I am taking a more measured approach to cond_resched() in
> rcu_torture_reader() for the moment.
> 
> But longer term, should cond_resched() imply a set of RCU
> quiescent states?  One way to do this would be to add calls to
> rcu_note_context_switch() in each of the various cond_resched() functions.
> Easy change, but of course adds some overhead.  On the other hand,
> there might be more than a few of the 500+ calls to cond_resched() that
> expect that RCU CPU stalls will be prevented (to say nothing of
> might_sleep() and cond_resched_lock()).
> 
> Thoughts?
> 
> (Untested patch below, FWIW.)
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131ef6aab..994d2b0fd0b2 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4075,6 +4075,9 @@ int __sched _cond_resched(void)
>  		__cond_resched();
>  		return 1;
>  	}
> +	preempt_disable();
> +	rcu_note_context_switch(smp_processor_id());
> +	preempt_enable();
>  	return 0;
>  }
>  EXPORT_SYMBOL(_cond_resched);

Hm.  Since you only care about the case where your task is solo, how
about do racy checks, 100% accuracy isn't required is it?  Seems you
wouldn't want to unconditionally do that in tight loops.

-Mike

