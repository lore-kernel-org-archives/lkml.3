Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaCMXG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:06:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaCMXG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:06:27 -0400
Date: Thu, 13 Mar 2014 16:06:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/6] printk: Hand over printing to console if printing
 too long
Message-Id: <20140313160625.1c62ca6bba080286194aa868@linux-foundation.org>
In-Reply-To: <1394726318-2757-6-git-send-email-jack@suse.cz>
References: <1394726318-2757-1-git-send-email-jack@suse.cz>
	<1394726318-2757-6-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 16:58:37 +0100 Jan Kara <jack@suse.cz> wrote:

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
> doing printing asks for help by setting PRINTK_HANDOVER_B bit in
> printk_handover_state variable and wakes up one of dedicated kthreads.
> As soon as the printing CPU notices kthread got scheduled and is
> spinning on console_sem, it drops console_sem and exits
> console_unlock(). kthread then takes over printing instead.  This way no
> CPU should spend printing too long even if there is heavy printk
> traffic.

Sigh ;)

Creating yet more kernel threads to solve this problem is a bit sad. 
Is there no way in which we can borrow one of the existing threads?

Do we need those threads (or this code) at all on uniprocessor builds?

I wonder if we should make printk_offload_chars=0 the default, so only
those people with a squillion disks incur the overhead.  But we'd still
have the "print" kernel threads, so maybe a different knob to enable the
feature?  If we do this we should set the knob to "true" for a month or
two to get testing coverage.

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2621,6 +2621,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
>  			default: disabled
>  
> +	printk.offload_chars=
> +			Printing to console can be relatively slow especially
> +			in case of serial console. When there is intensive
> +			printing happening from several cpus (as is the case
> +			during boot), a cpu can be spending significant time
> +			(seconds or more) doing printing. To avoid softlockups,
> +			lost interrupts, and similar problems other cpus
> +			will take over printing after the currently printing
> +			cpu has printed 'printk.offload_chars' characters.
> +			Higher value means possibly longer interrupt and other
> +			latencies but lower latency of printing and lower
> +			chance something goes wrong during system crash and
> +			important message is not printed.
> +			Format: <number>
> +			default: 0 (disabled)

The default is 1000!

>  	printk.time=	Show timing data prefixed to each printk message line
>  			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
>  
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
>
> ...
>
> +/*
> + * Returns true iff there is other cpu waiting to take over printing. This
> + * function also takes are of setting PRINTK_HANDOVER_B if we want to hand over
> + * printing to some other cpu.
> + */
> +static bool cpu_stop_printing(int printed_chars)
> +{
> +	/* Oops? Print everything now to maximize chances user will see it */
> +	if (oops_in_progress)
> +		return false;
> +	if (!printk_offload_chars || printed_chars < printk_offload_chars)
> +		return false;
> +	/* Someone is spinning on console_sem? Give away to him. */
> +	if (test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
> +		return true;
> +	if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state)) {
> +		set_bit(PRINTK_HANDOVER_B, &printk_handover_state);
> +		/*
> +		 * Paired with barrier in prepare_to_wait_exclusive() in
> +		 * printing_task()
> +		 */
> +		smp_mb();
> +		wake_up(&print_queue);
> +	}
> +	return false;
> +}

What happens if someone does a massive printk really early, perhaps
before the CPU scheduler is up and running?  Presumably things still
work OK, and the output will appear later in boot?

It might be sane to return false until system_state==something, unsure.

>  /**
>   * console_unlock - unlock the console system
>   *
>   * Releases the console_lock which the caller holds on the console system
>   * and the console driver list.
>   *
> - * While the console_lock was held, console output may have been buffered
> - * by printk().  If this is the case, console_unlock(); emits
> - * the output prior to releasing the lock.
> + * While the console_lock was held, console output may have been buffered by
> + * printk(). If this is the case, console_unlock() emits the output prior to
> + * releasing the lock. However we need not write all the data in the buffer if
> + * we would hog the CPU for too long. In such case we try to hand over printing
> + * to a different cpu.
>   *
>   * If there is output waiting, we wake /dev/kmsg and syslog() users.
>   *
> @@ -2025,6 +2127,8 @@ void console_unlock(void)
>  	unsigned long flags;
>  	bool wake_klogd = false;
>  	bool retry;
> +	bool hand_over = false;
> +	int printed_chars = 0;
>  
>  	if (console_suspended) {
>  		up(&console_sem);
> @@ -2041,6 +2145,11 @@ again:
>  		size_t len;
>  		int level;
>  
> +		if (cpu_stop_printing(printed_chars)) {
> +			hand_over = true;
> +			break;
> +		}
> +
>  		raw_spin_lock_irqsave(&logbuf_lock, flags);
>  		if (seen_seq != log_next_seq) {
>  			wake_klogd = true;
> @@ -2054,8 +2163,10 @@ again:
>  			console_prev = 0;
>  		}
>  skip:
> -		if (console_seq == log_next_seq)
> +		if (console_seq == log_next_seq) {
> +			raw_spin_unlock(&logbuf_lock);
>  			break;
> +		}
>  
>  		msg = log_from_idx(console_idx);
>  		if (msg->flags & LOG_NOCONS) {
> @@ -2086,31 +2197,39 @@ skip:
>  		stop_critical_timings();	/* don't trace print latency */
>  		call_console_drivers(level, text, len);
>  		start_critical_timings();
> +		printed_chars += len;
>  		local_irq_restore(flags);
>  	}
> -	console_locked = 0;
> -	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
>  
>  	/* Release the exclusive_console once it is used */
>  	if (unlikely(exclusive_console))
>  		exclusive_console = NULL;
>  
> -	raw_spin_unlock(&logbuf_lock);
> -
> +	/* Save modification of printk_handover_state in the common fast path */
> +	if (test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
> +		clear_bit(PRINTK_HANDOVER_B, &printk_handover_state);

If this is safe then we can use __clear_bit() ;)

> +	console_locked = 0;
> +	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
>  	up(&console_sem);
>  
>  	/*
> -	 * Someone could have filled up the buffer again, so re-check if there's
> -	 * something to flush. In case we cannot trylock the console_sem again,
> -	 * there's a new owner and the console_unlock() from them will do the
> -	 * flush, no worries.
> +	 * Subtlety: We have interrupts disabled iff hand_over == false (to
> +	 * save one cli/sti pair in the fast path.
>  	 */
> -	raw_spin_lock(&logbuf_lock);
> -	retry = console_seq != log_next_seq;
> -	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
> +	if (!hand_over) {
> +		/*
> +		 * Someone could have filled up the buffer again, so re-check
> +		 * if there's something to flush. In case we cannot trylock the
> +		 * console_sem again, there's a new owner and the
> +		 * console_unlock() from them will do the flush, no worries.
> +		 */
> +		raw_spin_lock(&logbuf_lock);
> +		retry = console_seq != log_next_seq;
> +		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
>  
> -	if (retry && console_trylock())
> -		goto again;
> +		if (retry && console_trylock())
> +			goto again;
> +	}
>  
>  	if (wake_klogd)
>  		wake_up_klogd();
>
> ...
>
> @@ -2434,6 +2583,19 @@ static int __init printk_late_init(void)
>  		}
>  	}
>  	hotcpu_notifier(console_cpu_notify, 0);
> +
> +	/* Does any handover of printing have any sence? */

"Does handover of printing make any sense?"

> +	if (num_possible_cpus() <= 1)
> +		return 0;
> +
> +	for (i = 0; i < PRINTING_TASKS; i++) {
> +		task = kthread_run(printing_task, NULL, "print/%d", i);
> +		if (IS_ERR(task)) {
> +			pr_err("printk: Cannot create printing thread: %ld\n",
> +			       PTR_ERR(task));
> +		}
> +	}
> +

