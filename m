Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaB0Rwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:52:47 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35514 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaB0Rwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:52:45 -0500
Date: Thu, 27 Feb 2014 18:52:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFA][PATCH 2/5] ftrace/x86: One more missing sync after fixup
 of function modification failure
Message-ID: <20140227175239.GE19580@localhost.localdomain>
References: <20140227154616.703252665@goodmis.org>
 <20140227154923.103932155@goodmis.org>
 <20140227163731.GC19580@localhost.localdomain>
 <20140227120014.7ba8b484@gandalf.local.home>
 <20140227171935.GD19580@localhost.localdomain>
 <20140227123553.03ce3c4b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227123553.03ce3c4b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:35:53PM -0500, Steven Rostedt wrote:
> On Thu, 27 Feb 2014 18:19:37 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Feb 27, 2014 at 12:00:14PM -0500, Steven Rostedt wrote:
> > > On Thu, 27 Feb 2014 17:37:32 +0100
> > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > On Thu, Feb 27, 2014 at 10:46:18AM -0500, Steven Rostedt wrote:
> > > > > [Request for Ack]
> > > > > 
> > > > > From: Petr Mladek <pmladek@suse.cz>
> > > > > 
> > > > > If a failure occurs while modifying ftrace function, it bails out and will
> > > > > remove the tracepoints to be back to what the code originally was.
> > > > > 
> > > > > There is missing the final sync run across the CPUs after the fix up is done
> > > > > and before the ftrace int3 handler flag is reset.
> > > > 
> > > > So IIUC the risk is that other CPUs may spuriously ignore non-ftrace traps if we don't sync the
> > > > other cores after reverting the int3 before decrementing the modifying_ftrace_code counter?
> > > 
> > > Actually, the bug is that they will not ignore the ftrace traps after
> > > we decrement modifying_ftrace_code counter. Here's the race:
> > > 
> > > 	CPU0				CPU1
> > > 	----				----
> > >   remove_breakpoint();
> > >   modifying_ftrace_code = 0;
> > > 
> > > 				[still sees breakpoint]
> > > 				<takes trap>
> > > 				[sees modifying_ftrace_code as zero]
> > > 				[no breakpoint handler]
> > > 				[goto failed case]
> > > 				[trap exception - kernel breakpoint, no
> > > 				 handler]
> > > 				BUG()
> > > 
> > > 
> > > Even if we had a smp_wmb() after removing the breakpoint and clearing
> > > the modifying_ftrace_code, we still need the smp_rmb() on the other
> > > CPUS. The run_sync() does a IPI on all CPUs doing the smp_rmb().
> > 
> > Ah ok. My understanding was indeed that it doesn't ignore the ftrace trap,
> > but I thought the consequence was that we return immediately from the trap
> > handler.
> 
> I'll add my above cpu race diagram (is that what we call it?). That
> should make this change more understandable.

Yeah sounds like a good idea!

> 
> 
> > Ok but what I meant is to do this instead:
> > 
> >  fail_update:
> >     probe_kernel_write((void *)ip, &old_code[0], 1);
> > +   run_sync()
> >     goto out;
> > 
> > Because with the current patch we also call run_sync() on add_break() failure.
> 
> Ah ok (my turn to understand). Yeah, if the add_break() fails, then we
> don't need to do the run_sync().
> 
> But this is just for now, to prevent the add_update_code() error from
> crashing. I have more patches that clean this up further. But they are
> for 3.15.

Yeah sure. That was really just nitpicking. It doesn't hurt in a rare failure path
and the fix is there.

Thanks.
