Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaFMX1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:27:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38117 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMX1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:27:21 -0400
Date: Fri, 13 Jun 2014 16:27:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613232715.GB4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140613124714.GC6635@localhost.localdomain>
 <20140613155233.GM4581@linux.vnet.ibm.com>
 <20140613160002.GL6635@localhost.localdomain>
 <20140613161630.GQ4581@linux.vnet.ibm.com>
 <20140613162130.GP6635@localhost.localdomain>
 <20140613164441.GA14232@thin>
 <20140613204822.GT4581@linux.vnet.ibm.com>
 <20140613211034.GA10651@jtriplet-mobl1>
 <20140613224926.GW4581@linux.vnet.ibm.com>
 <20140613231033.GR6635@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613231033.GR6635@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061323-8236-0000-0000-0000031825E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 01:10:35AM +0200, Frederic Weisbecker wrote:
> On Fri, Jun 13, 2014 at 03:49:26PM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 13, 2014 at 02:10:35PM -0700, Josh Triplett wrote:
> > > On Fri, Jun 13, 2014 at 01:48:22PM -0700, Paul E. McKenney wrote:
> > > > On Fri, Jun 13, 2014 at 09:44:41AM -0700, Josh Triplett wrote:
> > > > > On Fri, Jun 13, 2014 at 06:21:32PM +0200, Frederic Weisbecker wrote:
> > > > > > On Fri, Jun 13, 2014 at 09:16:30AM -0700, Paul E. McKenney wrote:
> > > > > > > > Is it because we have dynticks CPUs staying too long in the kernel without
> > > > > > > > taking any quiescent states? Are we perhaps missing some rcu_user_enter() or
> > > > > > > > things?
> > > > > > > 
> > > > > > > Sort of the former, but combined with the fact that in-kernel CPUs still
> > > > > > > need scheduling-clock interrupts for RCU to make progress.  I could
> > > > > > > move this to RCU's context-switch hook, but that could be very bad for
> > > > > > > workloads that do lots of context switching.
> > > > > > 
> > > > > > Or I can restart the tick if the CPU stays in the kernel for too long without
> > > > > > a tick. I think that's what we were doing before but we removed that because
> > > > > > we never implemented it correctly (we sent scheduler IPI that did nothing...)
> > > > > 
> > > > > I wonder if timer slack would make sense here: when you have at least
> > > > > one RCU callback pending, set a timer with a huge amount of timer slack,
> > > > > and cancel it if you end up handling the callback via a trip through the
> > > > > scheduler.
> > > > 
> > > > But in this case, we need the tick even if the current CPU has no callbacks
> > > > because it might be in an RCU read-side critical section.
> > > 
> > > Don't we handle that case via the slowpath of rcu_read_unlock, and a
> > > flag set via IPI?  ("Oh, that CPU has taken too long to note a quiescent
> > > state; send it an IPI to set the special flag that makes unlock do the
> > > work.")
> > 
> > There was once such logic on the force-quiescent-state path, and making
> > that handle this new case was my first proposal.  As Frederic pointed
> > out, that change requires rcu_needs_cpu()'s cooperation, because otherwise
> > the CPU will take the IPI, see that it still has but one runnable task,
> > and then keep its scheduling-clock interrupt off.
> 
> Exactly. So that's what happens currently, we call rcu_kick_nohz_cpu()
> on extended grace periods but the IPI doesn't reconsider the tick.
> 
> In fact it doesn't do anything at all because the scheduler IPI,
> when invoked without a reason, doesn't even call irq_enter()/irq_exit(),
> so rcu_needs_cpu() isn't quite called from there.
> 
> Now that's going to change with https://lwn.net/Articles/601836/ if
> we convert rcu_kick_nohz_cpu() to tick_nohz_full_kick_cpu().
> 
> Then we have the choice between two options:
> 
> * We can add a check in tick_nohz_full_check() and restart the tick if
> necessary.
> 
> * Extend rcu_needs_cpu() to restore a similar periodic mode until the
> grace periods get some progress.

If I was to extend rcu_needs_cpu(), I would add a flag and another counter
to the rcu_data structure.  If rcu_needs_cpu() saw the flag set and the
counter equal to the current ->completed value, it would return true.

I already have the rcu_kick_nohz_cpu() in rcu_implicit_dynticks_qs(),
so it is just a matter of also setting the flag and copying ->completed
to the new counter at that point.  I currently get to this point if the
CPU has managed to run for more than one jiffy without hitting either
idle or userspace execution.  Fair enough?

							Thanx, Paul

