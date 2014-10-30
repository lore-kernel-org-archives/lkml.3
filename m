Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbaJ3AFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:05:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35651 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaJ3AF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:05:29 -0400
Date: Wed, 29 Oct 2014 17:05:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 function
Message-ID: <20141030000524.GG5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
 <20141029124728.GL5718@linux.vnet.ibm.com>
 <20141029134519.GC30198@agordeev.usersys.redhat.com>
 <20141029143439.GN5718@linux.vnet.ibm.com>
 <20141029151622.GD30198@agordeev.usersys.redhat.com>
 <20141029154615.GR5718@linux.vnet.ibm.com>
 <20141029210916.GB13273@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029210916.GB13273@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103000-0029-0000-0000-00000540FE68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 09:09:16PM +0000, Alexander Gordeev wrote:
> On Wed, Oct 29, 2014 at 08:46:15AM -0700, Paul E. McKenney wrote:
> > On Wed, Oct 29, 2014 at 03:16:23PM +0000, Alexander Gordeev wrote:
> > > On Wed, Oct 29, 2014 at 07:34:39AM -0700, Paul E. McKenney wrote:
> > > > On Wed, Oct 29, 2014 at 01:45:19PM +0000, Alexander Gordeev wrote:
> > > > > On Wed, Oct 29, 2014 at 05:47:29AM -0700, Paul E. McKenney wrote:
> > > > > > On Wed, Oct 29, 2014 at 12:07:07PM +0100, Alexander Gordeev wrote:
> > > > > > > Function rcu_is_cpu_rrupt_from_idle() is called from scheduling-
> > > > > > > clock interrupt handler to check if the current CPU was interrupted
> > > > > > > from idle. If true, it results in invocation of RCU callbacks. But
> > > > > > > the common hardware interrupt exit path also contains similar check
> > > > > > > and therefore the call to rcu_is_cpu_rrupt_from_idle() is redundant.
> > > > > > 
> > > > > > By common hardware interrupt exit path, you are meaning the calls
> > > > > > to rcu_irq_exit()?  If not, please let me know exactly what you
> > > > > > mean here.
> > > > > 
> > > > > Yes, I mean rcu_irq_exit().
> > > > 
> > > > Unless you can get the indication of whether or not the original interrupt
> > > > came from userspace execution into rcu_irq_exit(), this will not work.
> > > > It will result in grace-period hangs on some configurations.
> > > 
> > > Okay, that was my concern wrt tree RCU. By contrast, tiny RCU does not seem
> > > able to hang a grace-period, isn't it?
> > 
> > Although it is true that tiny RCU cannot hang a synchronize_rcu()
> > grace period, it most certainly can hang a call_rcu() grace period
> > in exactly the same way.
> 
> Sorry for being a pain in the neck - just want to make sure I am following.

No worries!

> I only see possibility to cause callbacks not being called for "too long"
> in case a system has lots of nested interrupts and rcu_idle_enter_common()
> is not being called from hardware interrupt context as result. How could
> rcu_is_cpu_rrupt_from_idle() help here?

Let's start assuming that something in the idle loop posts a callback,
and then let me see if I understand your reasoning...

1.	The system is idle and stays that way, no runnable tasks.

2.	An interrupt occurs.  Upon return from interrupt, rcu_irq_exit()
	is invoked, which calls rcu_idle_enter_common(), which in turn
	calls rcu_sched_qs(), which does a raise_softirq(RCU_SOFTIRQ).

3.	The softirq happens shortly and invokes rcu_process_callbacks(),
	which invokes __rcu_process_callbacks().

4.	So now callbacks can be invoked.  At least they can be if
	->donetail has been updated.  Which it will have been because
	rcu_sched_qs() invokes rcu_qsctr_help().

So your point that rcu_is_cpu_rrupt_from_idle() might be redundant could
well be valid -- sorry for being so dismissive earlier.

> > > > Now, if you -can- get the userspace-execution indication into
> > > > rcu_irq_exit(), this might be of interest.  However, it might be faster
> > > > to simply let the scheduling-clock interrupt do the job as it currently
> > > > does, especially for workloads with lots of interrupts.
> > > > 
> > > > Or did you have something else in mind?
> > > 
> > > Nope. I would even leave as is tiny RCU's rcu_is_cpu_rrupt_from_idle()
> > > for clarity then ;)
> > 
> > Also to avoid userspace execution from preventing RCU callbacks from
> > ever being invoked.  ;-)
> 
> Hmm.. Am I missing something else? I did not remove the userspace check
> from the scheduling-clock interrupt:
> 
> @@ -250,7 +240,7 @@ void rcu_bh_qs(void)
>  void rcu_check_callbacks(int cpu, int user)
>  {
>  	RCU_TRACE(check_cpu_stalls());
> -	if (user || rcu_is_cpu_rrupt_from_idle())
> +	if (user)
>  		rcu_sched_qs();
>  	else if (!in_softirq())
>  		rcu_bh_qs();

Probably just me being confused.  Hopefully so, as shrinking TINY_RCU
further will probably be welcome.

Have you done any testing of this change?

							Thanx, Paul

