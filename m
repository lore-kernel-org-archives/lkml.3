Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3FYHTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:19:18 -0400
Received: from ozlabs.org ([203.10.76.45]:47296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3FYHTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:19:17 -0400
Date: Tue, 25 Jun 2013 17:19:14 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Rojhalat Ibrahim <imr@rtschenk.de>, linux-kernel@vger.kernel.org
Subject: Re: Regression in RCU subsystem in latest mainline kernel
Message-ID: <20130625071914.GA29957@concordia>
References: <1626500.7WAVXjfS9F@pcimr>
 <20130614122800.GL5146@linux.vnet.ibm.com>
 <1645938.As0LR1yeVd@pcimr>
 <1371243967.9844.338.camel@gandalf.local.home>
 <1371261741.21896.20.camel@pasglop>
 <20130617074213.GA3589@concordia>
 <20130619040906.GA5146@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619040906.GA5146@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:09:06PM -0700, Paul E. McKenney wrote:
> On Mon, Jun 17, 2013 at 05:42:13PM +1000, Michael Ellerman wrote:
> > On Sat, Jun 15, 2013 at 12:02:21PM +1000, Benjamin Herrenschmidt wrote:
> > > On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> > > > I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> > > > thing is, when I type on the console, it makes progress. Anyway, it
> > > > seems that powerpc has an issue with irq_work(). I'll try to get some
> > > > time either tonight or next week to figure it out.
> > > 
> > > Does this help ?
> > > 
> > > diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> > > index 5cbcf4d..ea185e0 100644
> > > --- a/arch/powerpc/kernel/irq.c
> > > +++ b/arch/powerpc/kernel/irq.c
> > > @@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(void)
> > >  	 * in case we also had a rollover while hard disabled
> > >  	 */
> > >  	local_paca->irq_happened &= ~PACA_IRQ_DEC;
> > > -	if (decrementer_check_overflow())
> > > +	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
> > >  		return 0x900;
> > >  
> > >  	/* Finally check if an external interrupt happened */
> > > 
> > 
> > This seems to help, but doesn't elminate the RCU stall warnings I am
> > seeing. I now see them less often, but not never.
> > 
> > Stack trace is something like:
 
Hi Paul,

Sorry I've been distracted with other stuff the last week.

> Hmmm...  How many CPUs are on your system?  And how much work is
> perf_event_for_each_child() having to do here?

I'm not 100% sure which system this trace is from. But it would have
~100-128 cpus.

I don't think perf_event_for_each_child() is doing much, there should
only be a single event and the smp_call_function_single() should be
degrading to a local function call.

> If the amount of work is large and your kernel is built with
> CONFIG_PREEMPT=n, the RCU CPU stall warning would be expected behavior.
> If so, we might need a preemption point in perf_event_for_each_child().

I'm using CONFIG_PREEMPT_NONE=y, which I think is what you mean.

Here's another trace from 3.10-rc7 plus a few local patches.

We suspect that the perf enable could be causing a flood of interrupts, but why
that's clogging things up so badly who knows.

INFO: rcu_sched self-detected stall on CPU { 38}  (t=2600 jiffies g=1 c=0 q=9)
cpu 0x26: Vector: 0  at [c0000007ed952b60]
    pc: c00000000014f500: .rcu_check_callbacks+0x400/0x8e0
    lr: c00000000014f500: .rcu_check_callbacks+0x400/0x8e0
    sp: c0000007ed952cd0
   msr: 9000000000009032
  current = 0xc0000007ed8b4a80
  paca    = 0xc00000000fdcab00	 softe: 0	 irq_happened: 0x00
    pid   = 2492, comm = power8-events
enter ? for help
[c0000007ed952e00] c0000000000a3e88 .update_process_times+0x48/0xa0
[c0000007ed952e90] c0000000000fd600 .tick_sched_handle.isra.13+0x40/0xd0
[c0000007ed952f20] c0000000000fd8b4 .tick_sched_timer+0x64/0xa0
[c0000007ed952fc0] c0000000000ca074 .__run_hrtimer+0x94/0x250
[c0000007ed953060] c0000000000cb0f8 .hrtimer_interrupt+0x138/0x3a0
[c0000007ed953150] c00000000001ef54 .timer_interrupt+0x124/0x2f0
[c0000007ed953200] c00000000000a5fc restore_check_irq_replay+0x68/0xa8
--- Exception: 901 (Decrementer) at c0000000000105ec .arch_local_irq_restore+0xc/0x10
[link register   ] c000000000096dac .__do_softirq+0x13c/0x380
[c0000007ed9534f0] c000000000096da0 .__do_softirq+0x130/0x380 (unreliable)
[c0000007ed953610] c000000000097228 .irq_exit+0xd8/0x120
[c0000007ed953690] c00000000001ef88 .timer_interrupt+0x158/0x2f0
[c0000007ed953740] c00000000000a5fc restore_check_irq_replay+0x68/0xa8
--- Exception: 901 (Decrementer) at c00000000010e16c .smp_call_function_single+0x13c/0x230
[c0000007ed953a30] c000000000189c64 .task_function_call+0x54/0x70 (unreliable)
[c0000007ed953ad0] c000000000189d4c .perf_event_enable+0xcc/0x150
[c0000007ed953b70] c000000000187ea0 .perf_event_for_each_child+0x60/0x100
[c0000007ed953c00] c00000000018c5e8 .perf_ioctl+0x108/0x3c0
[c0000007ed953ca0] c000000000226e94 .do_vfs_ioctl+0xc4/0x740
[c0000007ed953d90] c000000000227570 .SyS_ioctl+0x60/0xb0
[c0000007ed953e30] c000000000009e60 syscall_exit+0x0/0x98
--- Exception: c01 (System Call) at 00001fffffee03d0
SP (3fffdf0d2700) is in userspace


cheers
