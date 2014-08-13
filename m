Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaHMSUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:20:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47000 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHMSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:20:37 -0400
Date: Wed, 13 Aug 2014 11:20:30 -0700
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
Message-ID: <20140813182030.GD4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813141217.GU4752@linux.vnet.ibm.com>
 <20140813144219.GQ9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813144219.GQ9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081318-6688-0000-0000-000003FCAF90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 04:42:19PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 07:12:17AM -0700, Paul E. McKenney wrote:
> > > That's not an excuse for doing horrible things. And inventing new infra
> > > that needs to wake all CPUs is horrible.
> > 
> > Does your patch even work? 
> 
> Haven't even tried compiling it, but making it work shouldn't be too
> hard.
> 
> > Looks like it should, and yes, the idle loop
> > seems quite a bit simpler than it was a few years ago, but we really
> > don't need some strange thing that leaves a CPU idle but not visible as
> > such to RCU.
> 
> There's slightly more to it though; things like the x86 mwait idle wait
> functions tend to do far too much; for instance look at:
> 
> drivers/idle/intel_idle.c:intel_idle()

OK, let's see if I can follow the idly bouncing ball.

Looks like most arches call cpu_startup_entry(), which calls
arch_cpu_idle_prepare() followed by cpu_idle_loop().

arch_cpu_idle_prepare() is local_fiq_enable() on ARM and empty elsewhere.

cpu_idle_loop() does tick_nohz_idle_enter(), which does some nohz stuff.
It also checks for offline, and invokes arch_cpu_idle_enter(), which
is empty except on x86 and ARM.  On ARM, it messes with LEDs, and on
x86 it appears to disable an NMI-based watchdog timer.
Interrupts are disabled, and we do either cpu_idle_poll() if specified
or cpuidle_idle_call().  cpu_idle_poll() is the old-time idle loop,
with rcu_idle_enter()/_exit() and enabling interrupts prior to spinning.
No sign of stop_critical_timings(), though.  So let's not bury
rcu_idle_enter() in stop_critical_timings().

cpuidle_idle_call() does a fastpath irq-enable/exit if need-resched,
then does stop_critical_timings() and rcu_idle_enter().  Then we
have the buried complexity with cpuidle_select(), but a negative
return says to check need-resched and enable interrupts or to
invoke arch_cpu_idle(), which executes various sleep instructions
on various architectures.  Some notable variants:

o	ARM has an arm_pm_idle() function pointer so that different
	SoCs can have different idle-power-down sequences.  Alternatively,
	some SoCs have functions named CPUNAME_do_idle(), for example,
	imx5_cpu_do_idle().  These seem to invoke processor.do_idle().

	Pushing rcu_idle_enter() and rcu_idle_exit() down below
	arch_cpu_idle() on ARM looks to be asking for it.

o	ARM64 does cpu_do_idle, which does a wait-for-interrupt instruction.

o	AVR calls into assembly, hand-coding the need-resched check.
	Not sure why that would still be needed.

o	CRIS has one function that just enables interrupts and returns,
	and anohter that enables interrupts and halts.

o	UM times the duration of the idle time based on what appears to
	be the time until the next event.

o	Unicore does a string of what appear to be no-ops.

o	x86 does a couple of levels of indirection, one being the
	x86_idle() function pointer and another being the safe_halt()
	function pointer.

	amd_e400_idle() is a bit ornate, but still does default_idle()
	which wrappers the safe_halt() pointer.

And various other architectures seem to work similarly, but lots of
hair here.  So Steven, you OK with the underlying arch_cpu_idle()
functions being off-limits to tracing?

Now, if cpuidle_select() returns non-negative, we are dealing with
the CPU-idle governor, which is invoked at the later cpuidle_enter().

Hmmm...  On the CPU-idle drivers...

o	apm_idle_driver puts the idle loop into the ->enter() function,
	apm_cpu_idle().

o	ACPI puts the idle loop in acpi_idle_do_entry(), and does call
	stop_critical_timings(), but not rcu_idle_enter().
	So presumably stop_critical_timings() can nest?  Not clear
	from the code.

o	The CPS driver is even stranger...  Is cps_gen_entry_code()
	really depositing assembly instructions into a buffer that is
	passed back as a function?

o	The intel_idle driver is the one with mwait_idle_with_hints(),
	so you covered it below.

Your patch covers the cpuidle_enter() transition, which means
that functions like cpuidle_enter(), acpi_idle_enter_c1(), and
acpi_idle_do_entry() would be off-limits to trampolining.  In the case
of CPS, quite a bit of code.

> We should push the rcu_idle_{enter,exit}() down to around
> mwait_idle_with_hints(), so we don't call half the word with RCU
> disabled.

That would be for the intel_idle.c CPU-idle driver.  The other drivers
also need rcu_idle_{enter,exit}().

> > I have already said that I will be happy to rip out the wakeup code
> > when it is no longer needed, and I agree that it would be way better if
> > not needed.
> 
> I'd prefer to dtrt now and not needing to fix it later.

Once it works, I might consider it "right" and adjust accordingly.
At the moment, speculation.

> Auditing all idle functions will be somewhat of a pain, but its entirely
> doable. Looking at this stuff, it appears we can clean it up massively;
> see how the generic cpuidle code already has the broadcast logic in, so
> we can remove that from the drivers by setting the right flags.

There is certainly quite a bit of hair in a number of these drivers,
no two ways about it.

> We can similarly pull out the leave_mm() call by adding a
> CPUIDLE_FLAG_TLB_FLUSH. At which point all we'd need to do is mark the
> intel_idle (and all other cpuidle_state::enter functions with __notrace.

That one seems to be specific to intel_idle.  But yes, nice to avoid
waking an idle CPU for TLB flushes.

> > But I won't base a patch on hypotheticals.  You have already
> > drawn way too much water from -that- well over the past years!  ;-)
> 
> not entirely sure what you're referring to there ;-)

Heh!

							Thanx, Paul

