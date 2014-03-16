Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaCPG1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 02:27:50 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37990 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaCPG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 02:27:49 -0400
Date: Sat, 15 Mar 2014 23:27:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: peterz@infradead.org, mingo@elte.hu, josh@joshtriplett.org,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140316062743.GY21124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <1394950182.5470.15.camel@marge.simpson.net>
 <1394950455.5470.16.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394950455.5470.16.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031606-1542-0000-0000-00000067676C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2014 at 07:14:15AM +0100, Mike Galbraith wrote:
> On Sun, 2014-03-16 at 07:09 +0100, Mike Galbraith wrote: 
> > On Sat, 2014-03-15 at 18:59 -0700, Paul E. McKenney wrote: 
> 
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index b46131ef6aab..994d2b0fd0b2 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -4075,6 +4075,9 @@ int __sched _cond_resched(void)
> > >  		__cond_resched();
> > >  		return 1;
> > >  	}
> > > +	preempt_disable();
> > > +	rcu_note_context_switch(smp_processor_id());
> > > +	preempt_enable();
> > >  	return 0;
> > >  }
> > >  EXPORT_SYMBOL(_cond_resched);
> > 
> > Hm.  Since you only care about the case where your task is solo, how
> > about do racy checks, 100% accuracy isn't required is it?  Seems you
> > wouldn't want to unconditionally do that in tight loops.
> 
> (or do that in scheduler_tick()?)

There are checks in scheduler_tick(), but they have to assume that
if they interrupt kernel execution, they might have also interrupted
an RCU read-side critical section.  And in fact, the point of having
cond_resched() (sometimes) do a quiescent state is to communicate with
the existing checks invoked from scheduler_tick().

							Thanx, Paul

