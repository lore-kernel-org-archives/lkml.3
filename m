Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaGNQIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:08:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55310 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755615AbaGNQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:08:43 -0400
Date: Mon, 14 Jul 2014 12:08:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140714120840.1fb65a7d@gandalf.local.home>
In-Reply-To: <1405348378-10370-1-git-send-email-pmladek@suse.cz>
References: <1405348378-10370-1-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 16:32:58 +0200
Petr Mladek <pmladek@suse.cz> wrote:

> The trace/ring_buffer allows to swap the entire ring buffer. Everything has to
> be done lockless. I think that I have found a race when trying to understand
> the code. The problematic situation is the following:
> 
> CPU 1 (write/reserve event)		CPU 2 (swap the cpu buffer)
> -------------------------------------------------------------------------
> ring_buffer_write()
>   if (cpu_buffer->record_disabled)
>   ^^^ test fails and write continues
> 
> 					ring_buffer_swap_cpu()
> 
> 					  inc(&cpu_buffer_a->record_disabled);
> 					  inc(&cpu_buffer_b->record_disabled);
> 
> 					  if (cpu_buffer_a->committing)
> 					  ^^^ test fails and swap continues
> 					  if (cpu_buffer_b->committing)
> 					  ^^^ test fails and swap continues
> 
>   rb_reserve_next_event()
>     rb_start_commit()
>       local_inc(&cpu_buffer->committing);
>       local_inc(&cpu_buffer->commits);
> 
>     if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
>     ^^^ test fails and reserve_next continues
> 
> 					  buffer_a->buffers[cpu] = cpu_buffer_b;
> 					  buffer_b->buffers[cpu] = cpu_buffer_a;
> 					  cpu_buffer_b->buffer = buffer_a;
> 					  cpu_buffer_a->buffer = buffer_b;
> 
>   Pheeee, reservation continues in the removed buffer.
> 
> This patch solves the problem by swapping the CPU buffer on the same CPU. It
> helps to avoid memory barriers and keep both writing and swapping fast.
> 
> Also it adds some comments about why the reserve and swap operations are safe.
> I hope that I have got it right :-)
> 
> Changes v1 -> v2:
> 	+ do the swap on the same CPU instead of using memory barriers;
> 	  idea by Steven Rostedt
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  kernel/trace/ring_buffer.c | 97 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 74 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7c56c3d06943..f86d258fce8d 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2529,10 +2529,14 @@ rb_reserve_next_event(struct ring_buffer *buffer,
>  
>  #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
>  	/*
> -	 * Due to the ability to swap a cpu buffer from a buffer
> -	 * it is possible it was swapped before we committed.
> -	 * (committing stops a swap). We check for it here and
> -	 * if it happened, we have to fail the write.
> +	 * The cpu buffer cannot be swapped when committing is set. But we might
> +	 * have been interrupted and the swap might had happened before
> +	 * the committing was set. In this case, we have to fail the write
> +	 * to avoid an inconsistency with ring_buffer_unlock_commit().
> +	 *
> +	 * Note that the cpu buffer swapping is done on this CPU with disabled
> +	 * interrupts. So, we will never be here in the middle of a swap
> +	 * operation.

And this means we can remove this #ifdef block completely. Since the
swap will always be on the same CPU as the write, I don't believe this
can ever happen. Although your above comment is wrong. We can most
definitely be in the middle of a swap operation. You forget that
tracing is NMI safe.

But the swap does disable tracing, then if a NMI were to preempt the
swap, it will either be outside the critical part where it is still safe
to perform the trace or it will be where the swap is happening and the
tracing will be disabled.

-- Steve



>  	 */
>  	barrier();
>  	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
> @@ -4280,23 +4284,35 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
>  EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
>  
>  #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
> +struct ring_buffer_swap_info {
> +	struct ring_buffer *buffer_a;	/* One buffer to swap with */
> +	struct ring_buffer *buffer_b;	/* The other buffer to swap with */
> +	int ret;			/* return value from the swap op. */
> +};
> +
>  /**
> - * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> - * @buffer_a: One buffer to swap with
> - * @buffer_b: The other buffer to swap with
> + * ring_buffer_swap_this_cpu - swap CPU buffer, related to this CPU,
> + *	between two ring buffers.
> + * @arg: arguments and return value is passed via struct ring_buffer_swap_info.
> + *	The function is called via smp_call_function_single()
>   *
> - * This function is useful for tracers that want to take a "snapshot"
> - * of a CPU buffer and has another back up buffer lying around.
> - * it is expected that the tracer handles the cpu buffer not being
> - * used at the moment.
> + * The swapping of a CPU buffer is done on the same CPU. It helps to avoid
> + * memory barriers and keep writing fast. We can't use synchronize_sched
> + * here because this function can be called in atomic context.
>   */
> -int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> -			 struct ring_buffer *buffer_b, int cpu)
> +static void ring_buffer_swap_this_cpu(void *arg)
>  {
> +	struct ring_buffer_swap_info *rb_swap_info = arg;
> +	struct ring_buffer *buffer_a;
> +	struct ring_buffer *buffer_b;
>  	struct ring_buffer_per_cpu *cpu_buffer_a;
>  	struct ring_buffer_per_cpu *cpu_buffer_b;
> -	int ret = -EINVAL;
> +	int cpu = smp_processor_id();
> +
> +	buffer_a = rb_swap_info->buffer_a;
> +	buffer_b = rb_swap_info->buffer_b;
>  
> +	rb_swap_info->ret = -EINVAL;
>  	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
>  	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
>  		goto out;
> @@ -4308,7 +4324,8 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
>  		goto out;
>  
> -	ret = -EAGAIN;
> +	/* Also check if the buffers can be manipulated */
> +	rb_swap_info->ret = -EAGAIN;
>  
>  	if (ring_buffer_flags != RB_BUFFERS_ON)
>  		goto out;
> @@ -4326,15 +4343,19 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  		goto out;
>  
>  	/*
> -	 * We can't do a synchronize_sched here because this
> -	 * function can be called in atomic context.
> -	 * Normally this will be called from the same CPU as cpu.
> -	 * If not it's up to the caller to protect this.
> +	 * Recording has to be disabled. Otherwise, ring_buffer_lock_reserve()
> +	 * and ring_buffer_unlock_commit() might operate with different
> +	 * cpu buffers.
> +	 *
> +	 * All other operations are safe. Read gets the CPU buffer only once
> +	 * and then works with it. Resize does the critical operation on the
> +	 * same CPU with disabled interrupts.
>  	 */
>  	atomic_inc(&cpu_buffer_a->record_disabled);
>  	atomic_inc(&cpu_buffer_b->record_disabled);
>  
> -	ret = -EBUSY;
> +	/* Bail out if we interrupted some recording */
> +	rb_swap_info->ret = -EBUSY;
>  	if (local_read(&cpu_buffer_a->committing))
>  		goto out_dec;
>  	if (local_read(&cpu_buffer_b->committing))
> @@ -4346,13 +4367,43 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	cpu_buffer_b->buffer = buffer_a;
>  	cpu_buffer_a->buffer = buffer_b;
>  
> -	ret = 0;
> -
> +	rb_swap_info->ret = 0;
>  out_dec:
>  	atomic_dec(&cpu_buffer_a->record_disabled);
>  	atomic_dec(&cpu_buffer_b->record_disabled);
>  out:
> -	return ret;
> +	return;
> +}
> +
> +/**
> + * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> + * @buffer_a: One buffer to swap with
> + * @buffer_b: The other buffer to swap with
> + *
> + * This function is useful for tracers that want to take a "snapshot"
> + * of a CPU buffer and has another back up buffer lying around.
> + * It is expected that the tracer handles the cpu buffer not being
> + * used at the moment.
> + */
> +int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> +			 struct ring_buffer *buffer_b, int cpu)
> +{
> +	struct ring_buffer_swap_info rb_swap_info = {
> +		.buffer_a = buffer_a,
> +		.buffer_b = buffer_b,
> +	};
> +	int ret;
> +
> +	/*
> +	 * Swap the CPU buffer on the same CPU. Recording has to be fast
> +	 * and and this helps to avoid memory barriers.
> +	 */
> +	ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
> +				       (void *)&rb_swap_info, 1);
> +	if (ret)
> +		return ret;
> +
> +	return rb_swap_info.ret;
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
>  #endif /* CONFIG_RING_BUFFER_ALLOW_SWAP */

