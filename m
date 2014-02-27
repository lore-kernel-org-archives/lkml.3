Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaB0RTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:19:42 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35866 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaB0RTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:19:41 -0500
Date: Thu, 27 Feb 2014 18:19:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFA][PATCH 2/5] ftrace/x86: One more missing sync after fixup
 of function modification failure
Message-ID: <20140227171935.GD19580@localhost.localdomain>
References: <20140227154616.703252665@goodmis.org>
 <20140227154923.103932155@goodmis.org>
 <20140227163731.GC19580@localhost.localdomain>
 <20140227120014.7ba8b484@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227120014.7ba8b484@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:00:14PM -0500, Steven Rostedt wrote:
> On Thu, 27 Feb 2014 17:37:32 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Feb 27, 2014 at 10:46:18AM -0500, Steven Rostedt wrote:
> > > [Request for Ack]
> > > 
> > > From: Petr Mladek <pmladek@suse.cz>
> > > 
> > > If a failure occurs while modifying ftrace function, it bails out and will
> > > remove the tracepoints to be back to what the code originally was.
> > > 
> > > There is missing the final sync run across the CPUs after the fix up is done
> > > and before the ftrace int3 handler flag is reset.
> > 
> > So IIUC the risk is that other CPUs may spuriously ignore non-ftrace traps if we don't sync the
> > other cores after reverting the int3 before decrementing the modifying_ftrace_code counter?
> 
> Actually, the bug is that they will not ignore the ftrace traps after
> we decrement modifying_ftrace_code counter. Here's the race:
> 
> 	CPU0				CPU1
> 	----				----
>   remove_breakpoint();
>   modifying_ftrace_code = 0;
> 
> 				[still sees breakpoint]
> 				<takes trap>
> 				[sees modifying_ftrace_code as zero]
> 				[no breakpoint handler]
> 				[goto failed case]
> 				[trap exception - kernel breakpoint, no
> 				 handler]
> 				BUG()
> 
> 
> Even if we had a smp_wmb() after removing the breakpoint and clearing
> the modifying_ftrace_code, we still need the smp_rmb() on the other
> CPUS. The run_sync() does a IPI on all CPUs doing the smp_rmb().

Ah ok. My understanding was indeed that it doesn't ignore the ftrace trap,
but I thought the consequence was that we return immediately from the trap
handler.

> 
> > 
> > > 
> > > Link: http://lkml.kernel.org/r/1393258342-29978-2-git-send-email-pmladek@suse.cz
> > > 
> > > Fixes: 8a4d0a687a5 "ftrace: Use breakpoint method to update ftrace caller"
> > > Cc: stable@vger.kernel.org # 3.5+
> > > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  arch/x86/kernel/ftrace.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > > index 6b566c8..69885e2 100644
> > > --- a/arch/x86/kernel/ftrace.c
> > > +++ b/arch/x86/kernel/ftrace.c
> > > @@ -660,8 +660,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
> > >  		ret = -EPERM;
> > >  		goto out;
> > >  	}
> > > -	run_sync();
> > >   out:
> > > +	run_sync();
> > >  	return ret;
> > >  
> > >   fail_update:
> > 
> > This could be further optimized by rather calling run_sync() in the end of the
> > fail_update block (after the probe_kernel_write revert) otherwise even failure on
> > setting the break will result in run_sync(), which doesn't appear to be needed. But
> > that's really just nitpicking as it's a rare failure codepath and shouldn't hurt.
> 
> No, the run_sync() must be done after removing the breakpoint. Again,
> we don't want one of these breakpoints to be called on another CPU and
> then see modifying_ftrace_code as zero. That is bad. The final
> run_sync() is required.

Ok but what I meant is to do this instead:

 fail_update:
    probe_kernel_write((void *)ip, &old_code[0], 1);
+   run_sync()
    goto out;

Because with the current patch we also call run_sync() on add_break() failure.

> 
> I think I'll update the change log to include my race flow graph from
> above.
> 
> -- Steve
> 
> 
> > 
> > In any case, the fix looks correct.
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > > -- 
> > > 1.8.5.3
> > > 
> > > 
> 
