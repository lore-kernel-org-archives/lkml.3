Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbaJ3Un0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:43:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45786 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaJ3UnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:43:25 -0400
Date: Thu, 30 Oct 2014 13:43:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 function
Message-ID: <20141030204318.GR5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
 <20141029124728.GL5718@linux.vnet.ibm.com>
 <20141029134519.GC30198@agordeev.usersys.redhat.com>
 <20141029143439.GN5718@linux.vnet.ibm.com>
 <20141029151622.GD30198@agordeev.usersys.redhat.com>
 <20141029154615.GR5718@linux.vnet.ibm.com>
 <20141029210916.GB13273@agordeev.usersys.redhat.com>
 <20141030000524.GG5718@linux.vnet.ibm.com>
 <20141030175435.GC13273@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030175435.GC13273@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103020-0021-0000-0000-000005CB792F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 05:54:35PM +0000, Alexander Gordeev wrote:
> On Wed, Oct 29, 2014 at 05:05:24PM -0700, Paul E. McKenney wrote:
> > > > Although it is true that tiny RCU cannot hang a synchronize_rcu()
> > > > grace period, it most certainly can hang a call_rcu() grace period
> > > > in exactly the same way.
> > > 
> > > Sorry for being a pain in the neck - just want to make sure I am following.
> > 
> > No worries!
> > 
> > > I only see possibility to cause callbacks not being called for "too long"
> > > in case a system has lots of nested interrupts and rcu_idle_enter_common()
> > > is not being called from hardware interrupt context as result. How could
> > > rcu_is_cpu_rrupt_from_idle() help here?
> > 
> > Let's start assuming that something in the idle loop posts a callback,
> > and then let me see if I understand your reasoning...
> > 
> > 1.	The system is idle and stays that way, no runnable tasks.
> > 
> > 2.	An interrupt occurs.  Upon return from interrupt, rcu_irq_exit()
> > 	is invoked, which calls rcu_idle_enter_common(), which in turn
> > 	calls rcu_sched_qs(), which does a raise_softirq(RCU_SOFTIRQ).
> > 
> > 3.	The softirq happens shortly and invokes rcu_process_callbacks(),
> > 	which invokes __rcu_process_callbacks().
> > 
> > 4.	So now callbacks can be invoked.  At least they can be if
> > 	->donetail has been updated.  Which it will have been because
> > 	rcu_sched_qs() invokes rcu_qsctr_help().
> 
> Yes, that is exactly my reasoning.
> 
> > So your point that rcu_is_cpu_rrupt_from_idle() might be redundant could
> > well be valid -- sorry for being so dismissive earlier.
> >
> > > > > > Now, if you -can- get the userspace-execution indication into
> > > > > > rcu_irq_exit(), this might be of interest.  However, it might be faster
> > > > > > to simply let the scheduling-clock interrupt do the job as it currently
> > > > > > does, especially for workloads with lots of interrupts.
> > > > > > 
> > > > > > Or did you have something else in mind?
> > > > > 
> > > > > Nope. I would even leave as is tiny RCU's rcu_is_cpu_rrupt_from_idle()
> > > > > for clarity then ;)
> > > > 
> > > > Also to avoid userspace execution from preventing RCU callbacks from
> > > > ever being invoked.  ;-)
> > > 
> > > Hmm.. Am I missing something else? I did not remove the userspace check
> > > from the scheduling-clock interrupt:
> > > 
> > > @@ -250,7 +240,7 @@ void rcu_bh_qs(void)
> > >  void rcu_check_callbacks(int cpu, int user)
> > >  {
> > >  	RCU_TRACE(check_cpu_stalls());
> > > -	if (user || rcu_is_cpu_rrupt_from_idle())
> > > +	if (user)
> > >  		rcu_sched_qs();
> > >  	else if (!in_softirq())
> > >  		rcu_bh_qs();
> > 
> > Probably just me being confused.  Hopefully so, as shrinking TINY_RCU
> > further will probably be welcome.
> 
> Should I resend tiny-only patch?

Please, but also expand the commit log to contain the above reasoning.

> > Have you done any testing of this change?
> 
> Just booted to a unicore kernel and dd'ed 1G of /dev/sda to /dev/null.

OK, that is a start. Could I convince you to build a kernel?

							Thanx, Paul

