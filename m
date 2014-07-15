Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaGOJHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:07:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbaGOJHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:07:38 -0400
Date: Tue, 15 Jul 2014 11:07:35 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140715090712.GI6774@pathway.suse.cz>
References: <1405348378-10370-1-git-send-email-pmladek@suse.cz>
 <20140714120840.1fb65a7d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714120840.1fb65a7d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-07-14 12:08:40, Steven Rostedt wrote:
> On Mon, 14 Jul 2014 16:32:58 +0200
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > The trace/ring_buffer allows to swap the entire ring buffer. Everything has to
> > be done lockless. I think that I have found a race when trying to understand
> > the code. The problematic situation is the following:
> > 
> > CPU 1 (write/reserve event)		CPU 2 (swap the cpu buffer)
> > -------------------------------------------------------------------------
> > ring_buffer_write()
> >   if (cpu_buffer->record_disabled)
> >   ^^^ test fails and write continues
> > 
> > 					ring_buffer_swap_cpu()
> > 
> > 					  inc(&cpu_buffer_a->record_disabled);
> > 					  inc(&cpu_buffer_b->record_disabled);
> > 
> > 					  if (cpu_buffer_a->committing)
> > 					  ^^^ test fails and swap continues
> > 					  if (cpu_buffer_b->committing)
> > 					  ^^^ test fails and swap continues
> > 
> >   rb_reserve_next_event()
> >     rb_start_commit()
> >       local_inc(&cpu_buffer->committing);
> >       local_inc(&cpu_buffer->commits);
> > 
> >     if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
> >     ^^^ test fails and reserve_next continues
> > 
> > 					  buffer_a->buffers[cpu] = cpu_buffer_b;
> > 					  buffer_b->buffers[cpu] = cpu_buffer_a;
> > 					  cpu_buffer_b->buffer = buffer_a;
> > 					  cpu_buffer_a->buffer = buffer_b;
> > 
> >   Pheeee, reservation continues in the removed buffer.
> > 
> > This patch solves the problem by swapping the CPU buffer on the same CPU. It
> > helps to avoid memory barriers and keep both writing and swapping fast.
> > 
> > Also it adds some comments about why the reserve and swap operations are safe.
> > I hope that I have got it right :-)
> > 
> > Changes v1 -> v2:
> > 	+ do the swap on the same CPU instead of using memory barriers;
> > 	  idea by Steven Rostedt
> > 
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > ---
> >  kernel/trace/ring_buffer.c | 97 +++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 74 insertions(+), 23 deletions(-)
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index 7c56c3d06943..f86d258fce8d 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -2529,10 +2529,14 @@ rb_reserve_next_event(struct ring_buffer *buffer,
> >  
> >  #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
> >  	/*
> > -	 * Due to the ability to swap a cpu buffer from a buffer
> > -	 * it is possible it was swapped before we committed.
> > -	 * (committing stops a swap). We check for it here and
> > -	 * if it happened, we have to fail the write.
> > +	 * The cpu buffer cannot be swapped when committing is set. But we might
> > +	 * have been interrupted and the swap might had happened before
> > +	 * the committing was set. In this case, we have to fail the write
> > +	 * to avoid an inconsistency with ring_buffer_unlock_commit().
> > +	 *
> > +	 * Note that the cpu buffer swapping is done on this CPU with disabled
> > +	 * interrupts. So, we will never be here in the middle of a swap
> > +	 * operation.
> 
> And this means we can remove this #ifdef block completely. Since the
> swap will always be on the same CPU as the write, I don't believe this
> can ever happen.

Just to be sure. Should I remove RING_BUFFER_ALLOW_SWAP config
option completely?

> Although your above comment is wrong. We can most
> definitely be in the middle of a swap operation. You forget that
> tracing is NMI safe.
> 
> But the swap does disable tracing, then if a NMI were to preempt the
> swap, it will either be outside the critical part where it is still safe
> to perform the trace or it will be where the swap is happening and the
> tracing will be disabled.

I probably did not use precise enough sentence. I wanted to explain
why we do not check for "cpu_buffer->record_disabled" here. I added
this test in the 1st version of the patch but then I realized that it
was not needed.

As you say, there are two possibilities when swap is interrupted by
NMI. Either it is outside of the critical section and then the write is
completed before we continue with swapping. Or the interrupt is inside
the critical section and then the nested write fails early in
ring_buffer_write() or ring_buffer_lock_reserve() before this
code is called.

A better comment might be:

	* Note that we will never be in the middle of a swap critical
	* section here. If the swapping is interrupted when recording
	* is disabled, the nested write will fail earlier in
	* ring_buffer_write() or ring_buffer_lock_reserve().
	*/


Note that I am still learning about the preferred practice with comments inside
the kernel code. I have spent a lot of time trying to understand the
ring buffer. I think that more comments like this would have
helped me to get the picture faster. Another possibility would be to
create Documentation/trace/ring-buffer.txt.

I have more notes here. Let me know if I should cook up some patches
that would extend the ring buffer documentation according to my
experience.

Thanks for patience.

Best Regards,
Petr

> >  	 */
> >  	barrier();
> >  	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
> > @@ -4280,23 +4284,35 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
> >  EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
> >  
> >  #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
> > +struct ring_buffer_swap_info {
> > +	struct ring_buffer *buffer_a;	/* One buffer to swap with */
> > +	struct ring_buffer *buffer_b;	/* The other buffer to swap with */
> > +	int ret;			/* return value from the swap op. */
> > +};
> > +
> >  /**
> > - * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> > - * @buffer_a: One buffer to swap with
> > - * @buffer_b: The other buffer to swap with
> > + * ring_buffer_swap_this_cpu - swap CPU buffer, related to this CPU,
> > + *	between two ring buffers.
> > + * @arg: arguments and return value is passed via struct ring_buffer_swap_info.
> > + *	The function is called via smp_call_function_single()
> >   *
> > - * This function is useful for tracers that want to take a "snapshot"
> > - * of a CPU buffer and has another back up buffer lying around.
> > - * it is expected that the tracer handles the cpu buffer not being
> > - * used at the moment.
> > + * The swapping of a CPU buffer is done on the same CPU. It helps to avoid
> > + * memory barriers and keep writing fast. We can't use synchronize_sched
> > + * here because this function can be called in atomic context.
> >   */
> > -int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> > -			 struct ring_buffer *buffer_b, int cpu)
> > +static void ring_buffer_swap_this_cpu(void *arg)
> >  {
> > +	struct ring_buffer_swap_info *rb_swap_info = arg;
> > +	struct ring_buffer *buffer_a;
> > +	struct ring_buffer *buffer_b;
> >  	struct ring_buffer_per_cpu *cpu_buffer_a;
> >  	struct ring_buffer_per_cpu *cpu_buffer_b;
> > -	int ret = -EINVAL;
> > +	int cpu = smp_processor_id();
> > +
> > +	buffer_a = rb_swap_info->buffer_a;
> > +	buffer_b = rb_swap_info->buffer_b;
> >  
> > +	rb_swap_info->ret = -EINVAL;
> >  	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
> >  	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
> >  		goto out;
> > @@ -4308,7 +4324,8 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> >  	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
> >  		goto out;
> >  
> > -	ret = -EAGAIN;
> > +	/* Also check if the buffers can be manipulated */
> > +	rb_swap_info->ret = -EAGAIN;
> >  
> >  	if (ring_buffer_flags != RB_BUFFERS_ON)
> >  		goto out;
> > @@ -4326,15 +4343,19 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> >  		goto out;
> >  
> >  	/*
> > -	 * We can't do a synchronize_sched here because this
> > -	 * function can be called in atomic context.
> > -	 * Normally this will be called from the same CPU as cpu.
> > -	 * If not it's up to the caller to protect this.
> > +	 * Recording has to be disabled. Otherwise, ring_buffer_lock_reserve()
> > +	 * and ring_buffer_unlock_commit() might operate with different
> > +	 * cpu buffers.
> > +	 *
> > +	 * All other operations are safe. Read gets the CPU buffer only once
> > +	 * and then works with it. Resize does the critical operation on the
> > +	 * same CPU with disabled interrupts.
> >  	 */
> >  	atomic_inc(&cpu_buffer_a->record_disabled);
> >  	atomic_inc(&cpu_buffer_b->record_disabled);
> >  
> > -	ret = -EBUSY;
> > +	/* Bail out if we interrupted some recording */
> > +	rb_swap_info->ret = -EBUSY;
> >  	if (local_read(&cpu_buffer_a->committing))
> >  		goto out_dec;
> >  	if (local_read(&cpu_buffer_b->committing))
> > @@ -4346,13 +4367,43 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> >  	cpu_buffer_b->buffer = buffer_a;
> >  	cpu_buffer_a->buffer = buffer_b;
> >  
> > -	ret = 0;
> > -
> > +	rb_swap_info->ret = 0;
> >  out_dec:
> >  	atomic_dec(&cpu_buffer_a->record_disabled);
> >  	atomic_dec(&cpu_buffer_b->record_disabled);
> >  out:
> > -	return ret;
> > +	return;
> > +}
> > +
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
> >  }
> >  EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
> >  #endif /* CONFIG_RING_BUFFER_ALLOW_SWAP */
> 
