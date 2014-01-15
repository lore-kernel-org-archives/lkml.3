Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaAOWXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:23:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaAOWXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:23:49 -0500
Date: Wed, 15 Jan 2014 14:23:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] printk: Hand over printing to console if printing
 too long
Message-Id: <20140115142347.34a3239184a989df141154f2@linux-foundation.org>
In-Reply-To: <1387831171-5264-10-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
	<1387831171-5264-10-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013 21:39:30 +0100 Jan Kara <jack@suse.cz> wrote:

> Currently, console_unlock() prints messages from kernel printk buffer to
> console while the buffer is non-empty. When serial console is attached,
> printing is slow and thus other CPUs in the system have plenty of time
> to append new messages to the buffer while one CPU is printing. Thus the
> CPU can spend unbounded amount of time doing printing in console_unlock().
> This is especially serious problem if the printk() calling
> console_unlock() was called with interrupts disabled.
> 
> In practice users have observed a CPU can spend tens of seconds printing
> in console_unlock() (usually during boot when hundreds of SCSI devices
> are discovered) resulting in RCU stalls (CPU doing printing doesn't
> reach quiescent state for a long time), softlockup reports (IPIs for the
> printing CPU don't get served and thus other CPUs are spinning waiting
> for the printing CPU to process IPIs), and eventually a machine death
> (as messages from stalls and lockups append to printk buffer faster than
> we are able to print). So these machines are unable to boot with serial
> console attached. Also during artificial stress testing SATA disk
> disappears from the system because its interrupts aren't served for too
> long.
> 
> This patch implements a mechanism where after printing specified number
> of characters (tunable as a kernel parameter printk.offload_chars), CPU
> doing printing asks for help by setting a 'hand over' state. The CPU
> still keeps printing until another CPU running printk() or a CPU being
> pinged by an IPI comes and takes over printing.  This way no CPU should
> spend printing too long if there is heavy printk traffic.
> 
> ...
>
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -84,6 +84,45 @@ static DEFINE_SEMAPHORE(console_sem);
>  struct console *console_drivers;
>  EXPORT_SYMBOL_GPL(console_drivers);
>  
> +/*
> + * State of printing to console.
> + * 0 - noone is printing
> + * 1 - the CPU doing printing is happy doing so
> + * 2 - the printing CPU wants some other CPU to take over
> + * 3 - some CPU is waiting to take over printing
> + *
> + * Allowed state transitions are:
> + * 0 -> 1, 1 -> 0, 1 -> 2, 2 -> 0, 2 -> 3, 3 -> 0
> + * All state transitions except for 2 -> 3 are done by the holder of
> + * console_sem. Transition 2 -> 3 happens using cmpxchg from a task not owning
> + * console_sem. Thus it can race with other state transitions from state 2.
> + * However these races are harmless since the only transition we can race with
> + * is 2 -> 0. If cmpxchg comes after we have moved from state 2, it does
> + * nothing and we end in state 0. If cmpxchg comes before, we end in state 0 as
> + * desired.
> + */

This comment is great, but would be much better if "0"-"3" were
replaced with their PS_foo representations.

The locking issue is regrettable.  What's the problem with getting full
console_sem coverage?

The mixture of cmpxchg with non-atomic reads and writes makes things
significantly more difficult.

> +static enum {
> +	PS_NONE,
> +	PS_PRINTING,
> +	PS_HANDOVER,
> +	PS_WAITING
> +} printing_state;
> +/* CPU which is handing over printing */
> +static unsigned int hand_over_cpu;
> +/*
> + * Structure for IPI to hand printing to another CPU. We have actually two
> + * structures for the case we need to send IPI from an IPI handler...
> + */
> +static void printk_take_over(void *info);
> +static struct call_single_data hand_over_csd[2] = {
> +	{ .func = printk_take_over, },
> +	{ .func = printk_take_over, }
> +};
> +/* Index of csd to use for sending IPI now */
> +static int current_csd;

Locking for this?

> +/* Set if there is IPI pending to take over printing */
> +static bool printk_ipi_sent;

And this?

>  #ifdef CONFIG_LOCKDEP
>  static struct lockdep_map console_lock_dep_map = {
>  	.name = "console_lock"
> 
> ...
>
> @@ -1342,8 +1393,40 @@ static int console_trylock_for_printk(void)
>  {
>  	unsigned int cpu = smp_processor_id();
>  
> -	if (!console_trylock())
> -		return 0;
> +	if (!console_trylock()) {
> +		int state;
> +
> +		if (printing_state != PS_HANDOVER || console_suspended)
> +			return 0;
> +		smp_rmb();	/* Paired with smp_wmb() in cpu_stop_printing */
> +		/*
> +		 * Avoid deadlocks when CPU holding console_sem takes an
> +		 * interrupt which does printk.
> +		 */
> +		if (hand_over_cpu == cpu)
> +			return 0;
> +
> +		state = cmpxchg(&printing_state, PS_HANDOVER, PS_WAITING);
> +		if (state != PS_HANDOVER)
> +			return 0;
> +
> +		/*
> +		 * Since PS_HANDOVER state is set only in console_unlock()
> +		 * we shouldn't spin for long here.

"shouldn't" is ambiguous here.  Suggest replacing it with "won't".

>		    And we cannot sleep because
> +		 * the printk() might be called from atomic context.
> +		 */

console_trylock_for_printk() is called under logbuf_lock, isn't it? 
We're atomic here regardless of the printk() caller's state.  That's
why smp_processor_id() was OK.

> +		while (!console_trylock()) {
> +			if (console_suspended)
> +				return 0;
> +			/*
> +			 * Someone else took console_sem? Exit as we don't want
> +			 * to spin for a long time here.
> +			 */
> +			if (ACCESS_ONCE(printing_state) == PS_PRINTING)

Is this appropriate use of ACCESS_ONCE?  What is the ACCESS_ONCE()
trying to achieve?

> +				return 0;
> +			__delay(1);
> +		}
> +	}
>  	/*
>  	 * If we can't use the console, we need to release the console
>  	 * semaphore by hand to avoid flushing the buffer. We need to hold the
> 
> ...
>
> @@ -2005,15 +2091,77 @@ out:
>  	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
>  }
>  
> +/* Handler for IPI to take over printing from another CPU */
> +static void printk_take_over(void *info)
> +{
> +	/*
> +	 * We have to clear printk_ipi_sent only after we succeed / fail the
> +	 * trylock. That way we make sure there is at most one IPI spinning
> +	 * on console_sem and thus we cannot deadlock on csd_lock
> +	 */
> +	if (console_trylock_for_printk()) {

erk, scared.  We're in interrupt and console_trylock_for_printk() can
loop for arbitrarily long durations.  printk_take_over() is called
asynchronously and the system could be in any state at all.

> +		printk_ipi_sent = false;
> +		/* Switch csd as the current one is locked until we finish */
> +		current_csd ^= 1;

So current_csd is protected by console_sem?  As is printk_ipi_sent?

> +		console_unlock();

So it's via this console_unlock() that the current CPU starts printing?
Within IPI context?  It's worth documenting this a bit.

> +	} else
> +		printk_ipi_sent = false;
> +}
> +
> +/*
> + * Returns true iff there is other cpu waiting to take over printing. This
> + * function also takes are of changing printing_state if we want to hand over

"care"

> + * printing to some other cpu.
> + */
> +static bool cpu_stop_printing(int printed_chars)
> +{
> +	cpumask_var_t mask;
> +
> +	/* Oops? Print everything now to maximize chances user will see it */
> +	if (oops_in_progress)
> +		return false;
> +	/* Someone is waiting. Stop printing. */
> +	if (printing_state == PS_WAITING)
> +		return true;
> +	if (!printk_offload_chars || printed_chars <= printk_offload_chars)

Off-by-one?  Should that be "<"?

> +		return false;
> +	if (printing_state == PS_PRINTING) {
> +		hand_over_cpu = smp_processor_id();
> +		/* Paired with smp_rmb() in console_trylock_for_printk() */
> +		smp_wmb();
> +		printing_state = PS_HANDOVER;

So console_sem must be held by the caller?  Worth documenting this.

Again, the race with cmpxchg is worrisome.  Perhaps document its
(non-)effects here?

> +		return false;
> +	}
> +	/*
> +	 * We ping another CPU with IPI only if noone took over printing for a
> +	 * long time - we prefer other printk() to take over printing since it
> +	 * has chances to happen from a better context than IPI handler.
> +	 */
> +	if (!printk_ipi_sent && printed_chars > 2 * printk_offload_chars) {

What is the "2 *" doing?  I don't recall seeing a description of this.

> +		struct call_single_data *csd = &hand_over_csd[current_csd];

I didn't really understand why we need two call_single_data's.

> +
> +		/* Ping another cpu to take printing from us */
> +		cpumask_copy(mask, cpu_online_mask);
> +		cpumask_clear_cpu(hand_over_cpu, mask);
> +		if (!cpumask_empty(mask)) {

So what happens if this was the only online CPU?  We blow a chunk of
CPU time in cpu_stop_printing() for each printed char?  Not a problem I
guess.

> +			printk_ipi_sent = true;
> +			__smp_call_function_any(mask, csd, 0);

The IPI is sent to all other online CPUs.  I wonder if that was overkill.

> +		}
> +	}
> +	return false;
> +}
> +
> 
> ...
>

