Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaCRJZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:25:46 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64746 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaCRJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:25:44 -0400
Message-ID: <1395134743.4883.72.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: Initialize rq->age_stamp on processor start
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Date: Tue, 18 Mar 2014 10:25:43 +0100
In-Reply-To: <20140318085612.GP25546@laptop.programming.kicks-ass.net>
References: <1395101149-10097-1-git-send-email-minyard@acm.org>
	 <1395115586.4883.36.camel@marge.simpson.net>
	 <20140318085612.GP25546@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 09:56 +0100, Peter Zijlstra wrote: 
> On Tue, Mar 18, 2014 at 05:06:26AM +0100, Mike Galbraith wrote:

> > > +static void __cpuinit set_cpu_rq_start_time(void)
> > > +{
> > > +	int cpu = smp_processor_id();
> > > +	struct rq *rq = cpu_rq(cpu);
> > > +	rq->age_stamp = sched_clock_cpu(cpu);
> > > +}
> > 
> > rq->age_stamp must lag rq->clock.  See scale_rt_power(), and what
> > happens when it munches magic timewarp mushrooms.
> > 
> > > +
> > >  static int sched_cpu_active(struct notifier_block *nfb,
> > >  				      unsigned long action, void *hcpu)
> > >  {
> > >  	switch (action & ~CPU_TASKS_FROZEN) {
> > >  	case CPU_STARTING:
> > > +		set_cpu_rq_start_time();
> > > +		/* fall through */
> > >  	case CPU_DOWN_FAILED:
> > >  		set_cpu_active((long)hcpu, true);
> > >  		return NOTIFY_OK;
> > > @@ -6922,6 +6931,7 @@ void __init sched_init(void)
> > >  	init_sched_fair_class();
> > >  
> > >  	scheduler_running = 1;
> > > +	set_cpu_rq_start_time();
> 
> I would put it one line up; that scheduler_running=1 is the last thing
> we should do.

And set clock and age, dazed scale_rt_power() is butt ugly.

-Mike

