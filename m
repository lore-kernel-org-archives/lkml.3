Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781Ab3JPTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:36:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57335 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3JPTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:36:47 -0400
Date: Wed, 16 Oct 2013 12:36:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131016193632.GH4553@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131015163906.342d8ffa@gandalf.local.home>
 <20131016114036.GB12773@localhost.localdomain>
 <20131016084518.44eaf61a@gandalf.local.home>
 <20131016130856.GE12773@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016130856.GE12773@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101619-1542-0000-0000-00000255F5E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:08:57PM +0200, Frederic Weisbecker wrote:
> On Wed, Oct 16, 2013 at 08:45:18AM -0400, Steven Rostedt wrote:
> > On Wed, 16 Oct 2013 13:40:37 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Tue, Oct 15, 2013 at 04:39:06PM -0400, Steven Rostedt wrote:
> > > > Since the NMI iretq nesting has been fixed, there's no reason that
> > > > an NMI handler can not take a page fault for vmalloc'd code. No locks
> > > > are taken in that code path, and the software now handles nested NMIs
> > > > when the fault re-enables NMIs on iretq.
> > > > 
> > > > Not only that, if the vmalloc_fault() WARN_ON_ONCE() is hit, and that
> > > > warn on triggers a vmalloc fault for some reason, then we can go into
> > > > an infinite loop (the WARN_ON_ONCE() does the WARN() before updating
> > > > the variable to make it happen "once").
> > > > 
> > > > Reported-by: "Liu, Chuansheng" <chuansheng.liu@intel.com>
> > > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > Thanks! For now we probably indeed want this patch. But I hope it's only
> > > for the short term.
> > 
> > Why?
> > 
> > > 
> > > I still think that allowing faults in NMIs is very nasty, as we expect NMIs to never
> > > be disturbed.
> > 
> > We do faults (well, breakpoints really) in NMI to enable tracing.
> > 
> > > I'm not even sure if that interacts correctly with the rcu_nmi_enter()
> > > and preempt_count & NMI_MASK things. Not sure how perf is ready for that either (now
> > > hardware events can be interrupted by fault trace events).
> > 
> > I'm a bit confused. What doesn't interact correctly with
> > rcu_nmi_enter()?
> 
> Faults can call rcu_user_exit() / rcu_user_enter(). This is not supposed to happen
> between rcu_nmi_enter() and rcu_nmi_exit(). rdtp->dynticks would be incremented in the
> wrong way.

I can attest to this!  NMIs check for being nested within
process/irq-based non-idle sojourns, but not the other way around.
The result is that RCU will be ignoring you during that time, and not
even disabling interrupts will save you.  It will check rdtp->dynticks,
see that its value is even, and register a quiescent state on behalf of
the hapless CPU.

> Ah but we have an in_interrupt() check in context_tracking_user_enter() that protects
> us against that.

Here you are relying on the exception being treated as an interrupt,
correct?

							Thanx, Paul

> > > So I hope we can think about something else for the long term.
> > 
> > I still don't understand what's wrong with it. As long as the faulting
> > code does not grab any locks there shouldn't be anything wrong with
> > faulting in NMI. For vmalloc, it is just updating page tables.
> 
> NMI code is written with the idea that it can't be interrupted. May be that
> paranoia (again), you know. And I can't point you any problem in practice.
> I just think that allowing such a thing is asking for troubles.
> 
> But I'm ok with your patch, it fixes a real bug and as long as we don't have
> a better solution, we should keep that.
> 
> BTW, does faulting in NMIs re-enable NMIs?
> 

