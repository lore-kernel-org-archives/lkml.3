Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab3CMVf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:35:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46100 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab3CMVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:35:24 -0400
Date: Wed, 13 Mar 2013 14:35:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Threaded irqs + 100% CPU RT task = RCU stall
Message-ID: <20130313213511.GA15969@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130306154917.GA15249@windriver.com>
 <alpine.LFD.2.02.1303061651360.22263@ionos>
 <20130306171648.GO3268@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1303062010060.22263@ionos>
 <20130306214502.GC3268@linux.vnet.ibm.com>
 <20130313210307.GA22448@windriver.com>
 <20130313212802.GA3725@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313212802.GA3725@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031321-3620-0000-0000-0000019DAD04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 02:28:02PM -0700, Paul E. McKenney wrote:
> On Wed, Mar 13, 2013 at 05:03:07PM -0400, Paul Gortmaker wrote:
> > [Re: Threaded irqs + 100% CPU RT task = RCU stall] On 06/03/2013 (Wed 13:45) Paul E. McKenney wrote:
> > 
> > [...]
> > 
> > > 
> > > Is this behavior OK?  If so, the following (untested) patch might do
> > > what you want.  ;-)
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > rcu: Add softirq-stall indications to stall-warning messages
> > 
> > [...]
> > 
> > > 
> > > +The "softirq=" portion of the message tracks the number of RCU softirq
> > > +handlers that the stalled CPU has executed.  The number before the "/"
> > > +is the number that had executed since boot at the time that this CPU
> > > +last noted the beginning of a grace period, which might be the current
> > > +(stalled) grace period, or it might be some earlier grace period (for
> > > +example, if the CPU might have been in dyntick-idle mode for an extended
> > > +time period.  The number after the "/" is the number that have executed
> > > +since boot until the current time.  If this latter number stays constant
> > > +across repeated stall-warning messages, it is possible that RCU's softirq
> > > +handlers are no longer able to execute on this CPU.  This can happen if
> > > +the stalled CPU is spinning with interrupts are disabled, or, in -rt
> > > +kernels, if a high-priority process is starving RCU's softirq handler.
> > 
> > Here is the output of two consecutive stalls (triggered exactly as I'd
> > described before) after applying the commit and enabling the new config
> > option for RCU_CPU_STALL_INFO (btw, do we need this?  we already have
> > the RCU_CPU_STALL_VERBOSE option, and the distinction isn't clear.)

I won't argue that the choice of names is particularly inspired.

RCU_CPU_STALL_VERBOSE prints per-task information for any tasks stalling
the current RCU grace period.

RCU_CPU_STALL_INFO prints additional debug info for each CPU.

Perhaps I should merge them or rename them.  I will give it some thought.

							Thanx, Paul

> > Looking at the output, it doesn't necessarily scream out "you are an
> > idiot" in a way that Joe Average can immediately parse and understand,
> > but I guess it does at least arm us with more information so that we
> > can tell Joe Average that he is an idiot (assuming he posts more than
> > just a single stall instance).
> 
> OK, will queue this patch for 3.10, then, with your Tested-by.
> 
> > Also note right after the <EOI> below, it looks like two stall
> > messages got interleavedi, or a carriage return got dropped...
> > (not suggesting that this patch caused that.).
> 
> No idea...  Will recheck synchronization.  Oh, wait...  The stall warnings
> for self-detected stalls are not synchronized.  This is a tradeoff.
> If I synchronize them, and there are multiple CPUs stalling concurrently
> and self-detecting those stalls, then I randomly lose stalls from some
> of the CPUs.  I could let the winner complain on behalf of all currently
> stalled CPUs, but remote stack tracing is inaccurate.
> 
> My thought is to leave it, unless someone has a cute idea for making it
> all work nicely.
> 
> 							Thanx, Paul
> 
> > Paul.
> > --
> > 
> > INFO: rcu_preempt self-detected stall on CPU
> > INFO: rcu_preempt detected stalls on CPUs/tasks:
> > 	1: (1 GPs behind) idle=f4f/140000000000001/0 softirq=2256/2257 
> > 	(detected by 5, t=60002 jiffies, g=324, c=323, q=1368)
> > Task dump for CPU 1:
> > eatme-simple    R  running task        0  1487   1433 0x00000000
> >  ffff88042ef47f60 ffffffff81316de1 ffff88042e5f5810 ffff88042ef47fd8
> >  0000000000010c00 ffff88042ef47fd8 ffff88042f994210 ffff88042e5f5810
> >  0000000000000000 ffff88043f4fe980 ffffffff810a56e4 0000000000000203
> > Call Trace:
> >  [<ffffffff81316de1>] ? __schedule+0x62a/0x75e
> >  [<ffffffff810a56e4>] ? dput+0x20/0x15c
> >  [<ffffffff81096070>] ? __fput+0x1a1/0x1c8
> >  [<ffffffff810ab833>] ? mntput_no_expire+0x13/0x11f
> >  [<ffffffff8101c55c>] ? do_page_fault+0x1f/0x3b
> > 
> > 	1: (1 GPs behind) idle=f4f/140000000000001/0 softirq=2256/2257 
> > 	 (t=60082 jiffies g=324 c=323 q=1368)
> > Pid: 1487, comm: eatme-simple Not tainted 3.9.0-rc2+ #2
> > Call Trace:
> >  <IRQ>  [<ffffffff8105cac6>] ? rcu_check_callbacks+0x215/0x61a
> >  [<ffffffff8102cffc>] ? update_process_times+0x31/0x5c
> >  [<ffffffff8104bb5b>] ? tick_handle_periodic+0x18/0x52
> >  [<ffffffff81016328>] ? smp_apic_timer_interrupt+0x7d/0x8f
> >  [<ffffffff8131944a>] ? apic_timer_interrupt+0x6a/0x70
> >  <EOI> 
> > INFO: rcu_preempt self-detected stall on CPUINFO: rcu_preempt detected stalls on CPUs/tasks:
> > 	1: (1 GPs behind) idle=f4f/140000000000001/0 softirq=2256/2257 
> > 	(detected by 5, t=240007 jiffies, g=324, c=323, q=9386)
> > Task dump for CPU 1:
> > eatme-simple    R  running task        0  1487   1433 0x00000000
> >  ffff88042ef47f60 ffffffff81316dfd ffff88042e5f5810 ffff88042ef47fd8
> >  0000000000010c00 ffff88042ef47fd8 ffff88042e5f5810 ffff88042e5f5810
> >  0000000000000000 ffff88043f4fe980 ffffffff810a56e4 0000000000000203
> > Call Trace:
> >  [<ffffffff81316dfd>] ? __schedule+0x646/0x75e
> >  [<ffffffff810a56e4>] ? dput+0x20/0x15c
> >  [<ffffffff81096070>] ? __fput+0x1a1/0x1c8
> >  [<ffffffff810ab833>] ? mntput_no_expire+0x13/0x11f
> >  [<ffffffff8101c55c>] ? do_page_fault+0x1f/0x3b
> > 
> > 	1: (1 GPs behind) idle=f4f/140000000000001/0 softirq=2256/2257 
> > 	 (t=240087 jiffies g=324 c=323 q=9386)
> > Pid: 1487, comm: eatme-simple Not tainted 3.9.0-rc2+ #2
> > Call Trace:
> >  <IRQ>  [<ffffffff8105cac6>] ? rcu_check_callbacks+0x215/0x61a
> >  [<ffffffff8102cffc>] ? update_process_times+0x31/0x5c
> >  [<ffffffff8104bb5b>] ? tick_handle_periodic+0x18/0x52
> >  [<ffffffff81016328>] ? smp_apic_timer_interrupt+0x7d/0x8f
> >  [<ffffffff8131944a>] ? apic_timer_interrupt+0x6a/0x70
> > 

