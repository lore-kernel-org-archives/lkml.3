Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3FDLxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:53:42 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54098 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3FDLxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:53:41 -0400
Date: Tue, 4 Jun 2013 13:53:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
Message-ID: <20130604115335.GC14973@somewhere>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
 <20130603224836.GA9388@somewhere>
 <CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
 <20130604093611.GJ8923@twins.programming.kicks-ass.net>
 <20130604102620.GB14012@somewhere>
 <20130604111510.GO8923@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604111510.GO8923@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 01:15:10PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 04, 2013 at 12:26:22PM +0200, Frederic Weisbecker wrote:
> > @@ -1393,8 +1392,12 @@ static void sched_ttwu_pending(void)
> >  
> >  void scheduler_ipi(void)
> >  {
> > -	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
> > -	    && !tick_nohz_full_cpu(smp_processor_id()))
> > +	int cpu = smp_processor_id();
> > +	bool idle_kick = got_nohz_idle_kick(cpu);
> 
> This puts an unconditional atomic instruction in the IPI path. 
>  if (test) clear();
> is lots cheaper, esp. since most IPIs won't have this flag set.

Agreed but I'm a bit worried about ordering:

CPU 0                                           CPU 1

test_and_set_bit(nohz_kick, CPU 1)              scheduler_ipi
smp_send_reschedule(CPU 1)                      if (test_and_clear_bit(nohz_kick))
                                                   do_something

I'm not sure what base guarantee we have with ordering against raw IPIs such as the
the scheduler ipi. But unless both IPI trigger and IPI receive imply a full barrier
(or just IPI receive implies read barrier, it seems that's all we need), we need
test_and_set_bit() or smp_rmb()/smp_mb__before_clear_bit() && smp_mb__after_clear_bit().

> 
> > +
> > +	if (!(idle_kick && idle_cpu(cpu))
> > +	    && llist_empty(&this_rq()->wake_list)
> > +	    && !tick_nohz_full_cpu(cpu)
> 
> What's with this weird operator first split style?

Yeah ugly, I'll fix.

> 
> >  		return;
> >  
> >  	/*
>   
> > +enum idle_balance_type {
> > +	IDLE_BALANCE = 1,
> > +	IDLE_NOHZ_BALANCE = 2,
> > +};
> 
> You might want to update the rq->idle_balance assignment in
> scheduler_tick() to make sure it uses the right value (it does now, but
> there's nothing stopping people from changing the values).

Agreed!

Thanks.
