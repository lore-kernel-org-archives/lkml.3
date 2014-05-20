Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaETQYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:24:41 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54143 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaETQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:24:39 -0400
Date: Tue, 20 May 2014 18:24:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140520162433.GE17741@localhost.localdomain>
References: <20140514154459.GE4570@linux.vnet.ibm.com>
 <1400123931.5175.38.camel@marge.simpson.net>
 <1400386954.5140.36.camel@marge.simpson.net>
 <20140518052039.GF4570@linux.vnet.ibm.com>
 <1400402201.5166.13.camel@marge.simpson.net>
 <20140518155815.GK4570@linux.vnet.ibm.com>
 <1400467481.5211.48.camel@marge.simpson.net>
 <20140519053401.GP4570@linux.vnet.ibm.com>
 <20140520145350.GC17741@localhost.localdomain>
 <20140520155324.GD4570@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520155324.GD4570@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 08:53:24AM -0700, Paul E. McKenney wrote:
> On Tue, May 20, 2014 at 04:53:52PM +0200, Frederic Weisbecker wrote:
> > I'm not sure that I really understand what you want here.
> > 
> > The current state of the art is that when you enable CONFIG_NO_HZ_FULL=y, full dynticks
> > is actually off by default. This is only overriden by "nohz_full=" boot parameter.
> 
> If I understand correctly, if there is no nohz_full= boot parameter,
> then the context-tracking code takes the early exit via the
> context_tracking_is_enabled() check in context_tracking_user_enter().

Exactly. It's even jump labeled. So it should, in the better arch support case,
resume to a single unconditional jump when it's off.

> I would not expect this to cause much in the way of syscall performance
> degradation.

Now the jump label concern all cases but syscalls (exceptions and irq). Syscalls
are even better off-case optimized with a TIF_NOHZ flag. So it goes down to the
slow path all-in-one condition. At least in x86.

> However, it looks like having even one CPU in nohz_full
> mode causes all CPUs to enable context tracking.

True unfortunately. It's necessary to track down syscalls and exceptions
entry exit across CPUs.

So if CPU 1 is full nohz and a task enters in userspace on CPU 0 and then migrates
to CPU 1, we must know there that it's resuming in userspace in order to stop the tick
confidently. So CPU 0 must do context tracking as well.

Of course one can argue that we can find out that the task is resuming in userspace from
CPU 0 scheduler entry without the need for previous context tracking, but I couldn't find safe
solution for that. This is because probing on user/kernel boundaries can only be done
in the soft way, throught explicit function calls. So there is an inevitable shift
between soft and hard boundaries, between what we probe and what we can guess.

> 
> My guess is that Mike wants to have (say) half of his CPUs running
> nohz_full, and the other half having fast system calls.  So my guess
> also is that he would like some way of having the non-nohz_full CPUs
> to opt out of the context-tracking overhead, including the memory
> barriers and atomic ops in rcu_user_enter() and rcu_user_exit().  ;-)

I see. So we could possibly restrict the context tracking to a bunch of
CPUs but only iff the tasks running there can't run on non-tracking CPUs.

Ah one possible thing is to rely on the NOHZ flag for that and check which
task needs to be tracked.

> > Now if what you need is to enable or disable it at runtime instead of boottime,
> > I must warn you that this is going to complicate the nohz code a lot (and also perhaps sched
> > and RCU).
> 
> What Frederic said!  Making RCU deal with this is possible, but a bit on
> the complicated side.  Given that I haven't heard too many people complaining
> that RCU is too simple, I would like to opt out of runtime changes to the
> nohz_full mask.

Agreed.

> 
> > I've already been eyed by vulturous frozen sharks flying in circles above me lately
> > after a few overengineering visions.
> 
> Nothing like the icy glare of a frozen shark, is there?  ;-)

I think they were even three-eyed!!!

> 
> > And given that the full nohz code is still in a baby shape, it's probably not the right
> > time to expand it that way. I haven't even yet heard about users who crossed the testing
> > stage of full nohz.
> > 
> > We'll probably extend it that way in the future. But likely not in a near future.
> 
> My guess is that Mike would be OK with making nohz_full choice of CPUs
> still at boot time, but that he would like the CPUs that are not to be
> in nohz_full state be able to opt out of the context-tracking overhead.

Ok that might be possible. Although still require a bit of complication.
Lets wait for Mike input.

Thanks.

