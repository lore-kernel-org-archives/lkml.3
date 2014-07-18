Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbaGRPes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:34:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781AbaGRPeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:34:46 -0400
Date: Fri, 18 Jul 2014 17:34:43 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140718153443.GC6774@pathway.suse.cz>
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
 <20140716124356.398e21f4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716124356.398e21f4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-16 12:43:56, Steven Rostedt wrote:
> On Wed, 16 Jul 2014 10:58:04 +0200
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> 
> > +/**
> > + * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> > + * @buffer_a: One buffer to swap with
> > + * @buffer_b: The other buffer to swap with
> > + *
> > + * This function is useful for tracers that want to take a "snapshot"
> > + * of a CPU buffer and has another back up buffer lying around.
> > + * It is expected that the tracer handles the cpu buffer not being
> > + * used at the moment.
> > + */
> > +int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> > +			 struct ring_buffer *buffer_b, int cpu)
> > +{
> > +	struct ring_buffer_swap_info rb_swap_info = {
> > +		.buffer_a = buffer_a,
> > +		.buffer_b = buffer_b,
> > +	};
> > +	int ret;
> > +
> > +	/*
> > +	 * Swap the CPU buffer on the same CPU. Recording has to be fast
> > +	 * and and this helps to avoid memory barriers.
> > +	 */
> > +	ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
> > +				       (void *)&rb_swap_info, 1);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return rb_swap_info.ret;
> 
> We need to check if the cpu is on the current CPU and if so, just call
> the function directly. Otherwise this can't be done from interrupt
> disabled context.

I see, my testing was not good enough :-(

So, I tried to use:

	if (cpu == smp_processor_id())
		ring_buffer_swap_this_cpu(&rb_swap_info);
	else
		ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
					       (void *)&rb_swap_info, 1);

It solved the problem with enabled IRQSOFF_TRACER and
FTRACE_STARTUP_TEST because there the swap was called from the same CPU.

But there is still the problem when the function is called from another
CPU. I manage to trigger it by:

     echo 1 >/sys/kernel/debug/tracing/per_cpu/cpu0/snapshot

It produces:

[ 1594.060650] ------------[ cut here ]------------
[ 1594.060664] WARNING: CPU: 3 PID: 1558 at kernel/smp.c:242 smp_call_function_single+0xa4/0xb0()
[ 1594.060666] Modules linked in:
[ 1594.060673] CPU: 3 PID: 1558 Comm: bash Not tainted 3.16.0-rc1-2-default+ #2404
[ 1594.060676] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
[ 1594.060679]  00000000000000f2 ffff880815b93db8 ffffffff818d34e6 ffff880815b93df8
[ 1594.060685]  ffffffff810cf28c ffff880813658150 0000000000000001 ffff880815b93e48
[ 1594.060691]  ffffffff8118b7e0 0000000000000000 0000000000000002 ffff880815b93e08
[ 1594.060696] Call Trace:
[ 1594.060705]  [<ffffffff818d34e6>] dump_stack+0x6a/0x7c
[ 1594.060713]  [<ffffffff810cf28c>] warn_slowpath_common+0x8c/0xc0
[ 1594.060720]  [<ffffffff8118b7e0>] ? ring_buffer_size+0x40/0x40
[ 1594.060725]  [<ffffffff810cf2da>] warn_slowpath_null+0x1a/0x20
[ 1594.060730]  [<ffffffff81149cc4>] smp_call_function_single+0xa4/0xb0
[ 1594.060735]  [<ffffffff8118c72f>] ring_buffer_swap_cpu+0x5f/0x70
[ 1594.060742]  [<ffffffff811981ea>] update_max_tr_single+0x8a/0x180
[ 1594.060747]  [<ffffffff8119843a>] tracing_snapshot_write+0x15a/0x1a0
[ 1594.060754]  [<ffffffff8123cf95>] vfs_write+0xd5/0x180
[ 1594.060759]  [<ffffffff8123d969>] SyS_write+0x59/0xc0
[ 1594.060766]  [<ffffffff818d8569>] system_call_fastpath+0x16/0x1b
[ 1594.060769] ---[ end trace 662a3aa81711f30e ]---


No clever idea comes to my mind now. Maybe Monday will bring some
fresh thinking.

I think about using IPI but this is what smp_call_function_single()
does and it warns about possible deadlocks. I am not sure if it is
because it is a generic function or if it is dangerous even in this
particular situation.

Have a nice weekend,
Petr


PS: I am sorry that it took me so much time to respond. I wanted to
have free mind when looking into it.
