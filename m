Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaEBWq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:46:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbaEBWqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:46:54 -0400
Date: Sat, 3 May 2014 00:46:51 +0200
From: Jan Kara <jack@suse.cz>
To: will.deacon@arm.com
Cc: mm-commits@vger.kernel.org, peterz@infradead.org, kay@vrfy.org,
        jack@suse.cz, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140502224651.GG23636@quack.suse.cz>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-05-14 14:22:20, Andrew Morton wrote:
> From: Will Deacon <will.deacon@arm.com>
> Subject: printk: print initial logbuf contents before re-enabling interrupts
> 
> When running on a hideously slow system (~10Mhz FPGA) with a bunch of
> debug printk invocations on the timer interrupt path, we end up filling
> the log buffer faster than we can drain it.
> 
> The reason is that console_unlock (which is responsible for moving
> messages out of logbuf to hand over to the console driver) removes one
> message at a time, briefly re-enabling interrupts between each of them. 
> If the interrupt path prints more than a single message, then we can
> easily generate more messages than we can print for a regular, recurring
> interrupt (e.g.  a 1khz timer).  This results in messages getting silently
> dropped, leading to counter-intuitive, incomplete printk traces on the
> console.
> 
> Rather than run the console_unlock loop with interrupts disabled (which
> has obvious latency problems), this patch records the sequence number of
> the last message in the log buffer after taking the logbuf_lock.  We can
> then print this fixed amount of work before re-enabling interrupts again,
> making sure we keep up with ourself.  Other CPUs could still potentially
> flood the buffer, but there's little that we can do to protect against
> that.
  I really dislike this patch. It goes completely against my efforts of
lowering irq latency caused by printing to console (which are the
problems I have observed ;). My opinion is that when you are printing from
each and every interrupt which happens so often, then you have a problem and
disabling IRQs in printk so that your interrupt doesn't happen that often
seems like a poor solution to me. You could as well just ratelimit your
debug messages, couldn't you?

								Honza

> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/printk/printk.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff -puN kernel/printk/printk.c~printk-print-initial-logbuf-contents-before-re-enabling-interrupts kernel/printk/printk.c
> --- a/kernel/printk/printk.c~printk-print-initial-logbuf-contents-before-re-enabling-interrupts
> +++ a/kernel/printk/printk.c
> @@ -2147,10 +2147,13 @@ void console_unlock(void)
>  again:
>  	for (;;) {
>  		struct printk_log *msg;
> +		u64 console_end_seq;
>  		size_t len;
>  		int level;
>  
>  		raw_spin_lock_irqsave(&logbuf_lock, flags);
> +		console_end_seq = log_next_seq;
> +again_noirq:
>  		if (seen_seq != log_next_seq) {
>  			wake_klogd = true;
>  			seen_seq = log_next_seq;
> @@ -2195,6 +2198,12 @@ skip:
>  		stop_critical_timings();	/* don't trace print latency */
>  		call_console_drivers(level, text, len);
>  		start_critical_timings();
> +
> +		if (console_seq < console_end_seq) {
> +			raw_spin_lock(&logbuf_lock);
> +			goto again_noirq;
> +		}
> +
>  		local_irq_restore(flags);
>  	}
>  	console_locked = 0;
> _
> 
> Patches currently in -mm which might be from will.deacon@arm.com are
> 
> origin.patch
> printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
> printk-report-dropping-of-messages-from-logbuf.patch
> documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
> drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
> arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
> linux-next.patch
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
