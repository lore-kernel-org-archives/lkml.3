Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaGUPn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:43:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57122 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaGUPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:43:25 -0400
Date: Mon, 21 Jul 2014 08:43:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140721154317.GS8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
 <20140716124356.398e21f4@gandalf.local.home>
 <20140718153443.GC6774@pathway.suse.cz>
 <20140721144324.GG20751@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140721144324.GG20751@pathway.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072115-9332-0000-0000-000001735D74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 04:43:24PM +0200, Petr Mládek wrote:
> On Fri 2014-07-18 17:34:43, Petr Mládek wrote:
> > On Wed 2014-07-16 12:43:56, Steven Rostedt wrote:
> > > On Wed, 16 Jul 2014 10:58:04 +0200
> > > Petr Mladek <pmladek@suse.cz> wrote:
> > > 
> > > 
> > > > +/**
> > > > + * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> > > > + * @buffer_a: One buffer to swap with
> > > > + * @buffer_b: The other buffer to swap with
> > > > + *
> > > > + * This function is useful for tracers that want to take a "snapshot"
> > > > + * of a CPU buffer and has another back up buffer lying around.
> > > > + * It is expected that the tracer handles the cpu buffer not being
> > > > + * used at the moment.
> > > > + */
> > > > +int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> > > > +			 struct ring_buffer *buffer_b, int cpu)
> > > > +{
> > > > +	struct ring_buffer_swap_info rb_swap_info = {
> > > > +		.buffer_a = buffer_a,
> > > > +		.buffer_b = buffer_b,
> > > > +	};
> > > > +	int ret;
> > > > +
> > > > +	/*
> > > > +	 * Swap the CPU buffer on the same CPU. Recording has to be fast
> > > > +	 * and and this helps to avoid memory barriers.
> > > > +	 */
> > > > +	ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
> > > > +				       (void *)&rb_swap_info, 1);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	return rb_swap_info.ret;
> > > 
> > > We need to check if the cpu is on the current CPU and if so, just call
> > > the function directly. Otherwise this can't be done from interrupt
> > > disabled context.
> > 
> > I see, my testing was not good enough :-(
> > 
> > So, I tried to use:
> > 
> > 	if (cpu == smp_processor_id())
> > 		ring_buffer_swap_this_cpu(&rb_swap_info);
> > 	else
> > 		ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
> > 					       (void *)&rb_swap_info, 1);
> > 
> > It solved the problem with enabled IRQSOFF_TRACER and
> > FTRACE_STARTUP_TEST because there the swap was called from the same CPU.
> > 
> > But there is still the problem when the function is called from another
> > CPU. I manage to trigger it by:
> > 
> >      echo 1 >/sys/kernel/debug/tracing/per_cpu/cpu0/snapshot
> > 
> > It produces:
> > 
> > [ 1594.060650] ------------[ cut here ]------------
> > [ 1594.060664] WARNING: CPU: 3 PID: 1558 at kernel/smp.c:242 smp_call_function_single+0xa4/0xb0()
> > [ 1594.060666] Modules linked in:
> > [ 1594.060673] CPU: 3 PID: 1558 Comm: bash Not tainted 3.16.0-rc1-2-default+ #2404
> > [ 1594.060676] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
> > [ 1594.060679]  00000000000000f2 ffff880815b93db8 ffffffff818d34e6 ffff880815b93df8
> > [ 1594.060685]  ffffffff810cf28c ffff880813658150 0000000000000001 ffff880815b93e48
> > [ 1594.060691]  ffffffff8118b7e0 0000000000000000 0000000000000002 ffff880815b93e08
> > [ 1594.060696] Call Trace:
> > [ 1594.060705]  [<ffffffff818d34e6>] dump_stack+0x6a/0x7c
> > [ 1594.060713]  [<ffffffff810cf28c>] warn_slowpath_common+0x8c/0xc0
> > [ 1594.060720]  [<ffffffff8118b7e0>] ? ring_buffer_size+0x40/0x40
> > [ 1594.060725]  [<ffffffff810cf2da>] warn_slowpath_null+0x1a/0x20
> > [ 1594.060730]  [<ffffffff81149cc4>] smp_call_function_single+0xa4/0xb0
> > [ 1594.060735]  [<ffffffff8118c72f>] ring_buffer_swap_cpu+0x5f/0x70
> > [ 1594.060742]  [<ffffffff811981ea>] update_max_tr_single+0x8a/0x180
> > [ 1594.060747]  [<ffffffff8119843a>] tracing_snapshot_write+0x15a/0x1a0
> > [ 1594.060754]  [<ffffffff8123cf95>] vfs_write+0xd5/0x180
> > [ 1594.060759]  [<ffffffff8123d969>] SyS_write+0x59/0xc0
> > [ 1594.060766]  [<ffffffff818d8569>] system_call_fastpath+0x16/0x1b
> > [ 1594.060769] ---[ end trace 662a3aa81711f30e ]---
> > 
> > 
> > No clever idea comes to my mind now. Maybe Monday will bring some
> > fresh thinking.
> > 
> > I think about using IPI but this is what smp_call_function_single()
> > does and it warns about possible deadlocks. I am not sure if it is
> > because it is a generic function or if it is dangerous even in this
> > particular situation.
> 
> I have two more ideas but both are ugly :-(
> 
> 
> 1. I wonder if we really need to call ring_buffer_swap_cpu() with IRQs
>    disabled. It is used "only" in update_max_tr_single().
> 
>    The disabled IRQs might be needed only inside __update_max_tr()
>    when we do something with "current" task.
> 
>    Otherwise, update_max_tr_single() is already called with IRQs
>    disabled from:
> 
>        + tracing_snapshot_write() - here the IRQs are disabled only to
> 		call the function update_max_tr_single()/
> 
>        + check_critical_timing() - it looks to me the IRQs could get
> 		enabled before calling update_max_tr_single()
> 
> 
> 
> 2. Go back, do the swap on any CPU, and do memory barriers via IPI.
> 
>    I wonder if the needed memory barrier in rb_reserve_next_event()
>    could be avoided by calling IPI from ring_buffer_swap_cpu().
> 
>    I mean that rb_reserve_next_event() will include the current check
>    for swapped ring buffer without barriers. But
>    ring_buffer_swap_cpu() will interrupt the affected CPU and
>    basically do the barrier there only when needed.
> 
>    But I am not sure how this is different from calling
>    smp_call_function_single() from ring_buffer_swap_cpu().
>    And I am back on the question why it is dangerous with disabled
>    interrupts. I can't find any clue in git history. And I miss this
>    part of the picture :-(

IIRC, deadlock in the case where two CPUs attempt to invoke
smp_call_function_single() at each other, but both have
interrupts disabled.  It might be possible to avoid this by telling
smp_call_function_single() not to wait for a response, but this often
just re-introduces the deadlock at a higher level.

> Any pointers or ideas are welcome.

Not immediately.  Mark Batty (mark.batty@cl.cam.ac.uk) has come up with
cute ring-buffer tricks in the past, but would need a clear statement of
the problem.  I would be happy to bring him into the discussion if it
would help.

And yes, my knee-jerk reaction of suggesting RCU runs into the problem
that it is not so good to invoke synchronize_rcu() with interrupts
disabled.  Might be able to use call_rcu(), but if that worked, then
just telling smp_call_function_single() not to wait would probably
be a lot simpler.

							Thanx, Paul

