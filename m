Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaFZN6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:58:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:35067 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752751AbaFZN6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:58:33 -0400
Date: Thu, 26 Jun 2014 09:58:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Race when writing and swapping cpu buffer
 in parallel
Message-ID: <20140626095831.667f834f@gandalf.local.home>
In-Reply-To: <1403788958-6751-1-git-send-email-pmladek@suse.cz>
References: <1403788958-6751-1-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 15:22:38 +0200
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

This is a per cpu swap, not a full ring buffer swap.

> 
> 					  inc(&cpu_buffer_a->record_disabled);
> 					  inc(&cpu_buffer_b->record_disabled);
> 
> 					  if (cpu_buffer_a->committing)
> 					  ^^^ test fails and swap continues
> 					  if (cpu_buffer_b->committing)
> 					  ^^^ test fails and swap continues

Grumble, this was originally written such that the swap can only be
done on the CPU that it is running on.


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
> This can be solved by a better check in rb_reserve_next_event(). The reservation
> could continue only when "committing" is enabled and there is no swap in
> progress or when any swap was not finished in the meantime.
> 
> Note that the solution is not perfect. It stops writing also in this situation:
> 
> CPU 1 (write/reserve event)		CPU 2 (swap the cpu buffer)
> ----------------------------------------------------------------------------
> ring_buffer_write()
>   if (cpu_buffer->record_disabled)
>   ^^^ test fails and write continues
> 
> 					ring_buffer_swap_cpu()
> 
> 					  inc(&cpu_buffer_a->record_disabled);
> 					  inc(&cpu_buffer_b->record_disabled);
> 
>   rb_reserve_next_event()
>     rb_start_commit()
>       local_inc(&cpu_buffer->committing);
>       local_inc(&cpu_buffer->commits);
> 
> 					  if (cpu_buffer_a->committing)
> 					  ^^^ test passes and swap is canceled
> 
>     if (cpu_buffer->record_disabled)
>     ^^^ test passes and reserve is canceled
> 
> 					  dec(&cpu_buffer_a->record_disabled);
> 					  dec(&cpu_buffer_b->record_disabled);
> 
>   Pheeee, both actions were canceled. The write/reserve could have continued
>   if the recording was enabled in time.
> 
> Well, it is the price for using lockless algorithms. I think that it happens
> in more situations here, it is not worth more complicated code, and we could
> live with it.
> 
> The patch also adds some missing memory barriers. Note that compiler barriers
> are not enough because the data can be accessed by different CPUs.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  kernel/trace/ring_buffer.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7c56c3d06943..3020060ded7e 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2529,13 +2529,15 @@ rb_reserve_next_event(struct ring_buffer *buffer,
>  
>  #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
>  	/*
> -	 * Due to the ability to swap a cpu buffer from a buffer
> -	 * it is possible it was swapped before we committed.
> -	 * (committing stops a swap). We check for it here and
> -	 * if it happened, we have to fail the write.
> +	 * The cpu buffer swap could have started before we managed to stop it
> +	 * by incrementing the "committing" values. If the swap is in progress,
> +	 * we see disabled recording. If the swap has finished, we see the new
> +	 * cpu buffer. In both cases, we should go back and stop committing
> +	 * to the old buffer. See also ring_buffer_swap_cpu()
>  	 */
> -	barrier();
> -	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
> +	smp_mb();
> +	if (unlikely(atomic_read(&cpu_buffer->record_disabled) ||
> +		     ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
>  		local_dec(&cpu_buffer->committing);
>  		local_dec(&cpu_buffer->commits);
>  		return NULL;
> @@ -4334,6 +4336,13 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	atomic_inc(&cpu_buffer_a->record_disabled);
>  	atomic_inc(&cpu_buffer_b->record_disabled);
>  
> +	/*
> +	 * We could not swap if a commit is in progress. Also any commit could
> +	 * not start after we have stopped recording. Keep both checks in sync.
> +	 * The counter part is in rb_reserve_next_event()
> +	 */
> +	smp_mb();

This will kill ring buffer performance. So I will not allow this fix.

What we can do is force ring_buffer_swap_cpu() to only work for the CPU
that it is on. As we have snapshot in per_cpu buffers, to make that
work, we will need to change the per_cpu version of snapshot to do a
smp_call_function_single() to the CPU that it wants to take a snapshot
of, and run the swap there.

To force this, we can remove the cpu parameter from the
ring_buffer_swap_cpu(). By doing this, we may be able to remove some of
the CONFIG_RING_BUFFER_ALLOW_SWAP hacks too!

I'm not going to sacrifice the general performance of the ring buffer
for a feature that is seldom (if ever) used.

-- Steve

> +
>  	ret = -EBUSY;
>  	if (local_read(&cpu_buffer_a->committing))
>  		goto out_dec;
> @@ -4348,6 +4357,12 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  
>  	ret = 0;
>  
> +	/*
> +	 * Mare sure that rb_reserve_next_event() see the right
> +	 * buffer before we enable recording.
> +	 */
> +	smp_wmb();
> +
>  out_dec:
>  	atomic_dec(&cpu_buffer_a->record_disabled);
>  	atomic_dec(&cpu_buffer_b->record_disabled);

