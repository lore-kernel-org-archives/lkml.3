Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaHMTyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:54:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50655 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:54:09 -0400
Date: Wed, 13 Aug 2014 12:54:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, rafael@kernel.org
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813195402.GO4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813141217.GU4752@linux.vnet.ibm.com>
 <20140813144219.GQ9918@twins.programming.kicks-ass.net>
 <20140813182030.GD4752@linux.vnet.ibm.com>
 <20140813185529.GA16043@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813185529.GA16043@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081319-9332-0000-0000-000001AEAB1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 08:55:29PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 11:20:30AM -0700, Paul E. McKenney wrote:
> > cpuidle_idle_call() does a fastpath irq-enable/exit if need-resched,
> > then does stop_critical_timings() and rcu_idle_enter().  Then we
> > have the buried complexity with cpuidle_select(), but a negative
> > return says to check need-resched and enable interrupts or to
> > invoke arch_cpu_idle(), which executes various sleep instructions
> > on various architectures.  Some notable variants:
> 
> > And various other architectures seem to work similarly, but lots of
> > hair here.  So Steven, you OK with the underlying arch_cpu_idle()
> > functions being off-limits to tracing?
> 
> I didn't find anything particularly hairy in the arch_cpu_idle()
> implementations, lots of simple 'go sleep' or 'spin' like things.

"Hairy" in terms of lots of assembly, in many cases apparently tightly
coupled to a given SoC.

> > Now, if cpuidle_select() returns non-negative, we are dealing with
> > the CPU-idle governor, which is invoked at the later cpuidle_enter().
> > 
> > Hmmm...  On the CPU-idle drivers...
> > 
> > o	apm_idle_driver puts the idle loop into the ->enter() function,
> > 	apm_cpu_idle().
> 
> Yes, this one is creative. The best I came up with is
> adding CPUIDLE_FLAG_RCU_IDLE which indicates that the driver will do the
> rcu_idle calls and place them in apm_do_idle() around the
> apm_bios_call_simple() thing.
> 
> Now, that apm_bios_call_simple() thing uses on_cpu0(), which schedules
> work on cpu0, which to me seems to guarantee this won't be used on any
> SMP system, because that simply _cannot_ work for idle.
> 
> And on UP its a few more function calls, we could sprinkle some
> __always_inline()s around if we really care I suppose.

Heh, I missed the UP-only pieces.

> > o	ACPI puts the idle loop in acpi_idle_do_entry(), and does call
> > 	stop_critical_timings(), but not rcu_idle_enter().
> > 	So presumably stop_critical_timings() can nest?  Not clear
> > 	from the code.
> 
> Yeah, so I'm not sure I see that they nest properly..
> 
> Still ACPI does a lot of weird crap in the busmaster idle function,
> again I'd suggest that CPUIDLE_FLAG_RCU_IDLE which would let the driver
> do rcu_idle itself, and place it in appropriate sites.
> 
> Not too hard I think in this case.

My main concern is avoiding situations where the driver manages to loop
without passing through the rcu_idle_enter() and rcu_idle_exit().
In case someone manages to misconfigure things so that the driver
just endlessly shuttles among states without actually ever really
going idle.

> > o	The CPS driver is even stranger...  Is cps_gen_entry_code()
> > 	really depositing assembly instructions into a buffer that is
> > 	passed back as a function?
> 
> I had not yet looked at this one; its got that cpu_pm_{enter,exit}()
> thing going.. we could do the same and place the manual RCU_IDLE around
> cps_pm_enter_state()

Again, as long as it avoids loops that don't include code under
rcu_idle_enter().

> > o	The intel_idle driver is the one with mwait_idle_with_hints(),
> > 	so you covered it below.
> 
> Yeah, fairly straight fwd driver that, _lots_ saner than the ACPI one.

Now -that- is damning with faint praise!  ;-)

> > Your patch covers the cpuidle_enter() transition, which means
> > that functions like cpuidle_enter(), acpi_idle_enter_c1(), and
> > acpi_idle_do_entry() would be off-limits to trampolining.  In the case
> > of CPS, quite a bit of code.
> 
> So I think we can do this; sure lots of code, but typically 'simpler'
> than RCU stuff.

For some definition of "simpler".  ;-)

> > > We should push the rcu_idle_{enter,exit}() down to around
> > > mwait_idle_with_hints(), so we don't call half the word with RCU
> > > disabled.
> > 
> > That would be for the intel_idle.c CPU-idle driver.  The other drivers
> > also need rcu_idle_{enter,exit}().
> 
> Right, so simple drivers can use the generic rcu_idle bits from
> kernel/sched/idle.c and difficult drivers can use CPUIDLE_FLAG_RCU_IDLE
> and do some manual cleverness.

OK, but in this case the relevant definition of "simple" is "never will
need a trampoline".  Steven, thoughts?

> > > > I have already said that I will be happy to rip out the wakeup code
> > > > when it is no longer needed, and I agree that it would be way better if
> > > > not needed.
> > > 
> > > I'd prefer to dtrt now and not needing to fix it later.
> > 
> > Once it works, I might consider it "right" and adjust accordingly.
> > At the moment, speculation.
> 
> I think its simpler than doing RCU, maybe a little more work, but hey,
> I'm the idiot that does full arch/ sweeps on a semi regular basis.

Hmmm...  Exactly what are you thinking could be enabled by this
proposed change to the idle code?  From what I can see at the moment,
it would allow me to drop the schedule-on-holdout-idle code and allow
synchronize_sched() to be substituted on !CONFIG_PREEMPT kernels.

							Thanx, Paul

