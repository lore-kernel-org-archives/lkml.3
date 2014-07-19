Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbaGSNS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:18:59 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:44039 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbaGSNS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:18:56 -0400
Date: Sat, 19 Jul 2014 15:18:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 02/10] nohz: Kick full dynticks timer targets with an
 empty IPI
Message-ID: <20140719131844.GA16673@localhost.localdomain>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-3-git-send-email-fweisbec@gmail.com>
 <20140719071951.GS9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140719071951.GS9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 09:19:51AM +0200, Peter Zijlstra wrote:
> On Sat, Jul 19, 2014 at 02:44:13AM +0200, Frederic Weisbecker wrote:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 7f3063c..f3e48b8 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -693,7 +693,7 @@ static bool wake_up_full_nohz_cpu(int cpu)
> >  	if (tick_nohz_full_cpu(cpu)) {
> >  		if (cpu != smp_processor_id() ||
> >  		    tick_nohz_tick_stopped())
> > -			tick_nohz_full_kick_cpu(cpu);
> > +			irq_work_void_on(cpu);
> 
> So no, while the previous function name was descriptive, the new one
> leave one wondering.

Yeah, I suppose I can wrap that to some new function: tick_nohz_full_reschedule_cpu()
for example (although that looks a bit like a sched thing).

That said I plan to gather tick stop and tick restart in the same place, in the
end of the interrupt. So in the end we'll have only one tick_nohz_full_kick_cpu()
for all kick uses, and this will just wrapp to irq_work_void_on().
