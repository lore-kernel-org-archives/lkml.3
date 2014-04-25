Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaDYNaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:30:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42552 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbaDYNaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:30:10 -0400
Date: Fri, 25 Apr 2014 14:29:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 1/2] printk: print initial logbuf contents before
 re-enabling interrupts
Message-ID: <20140425132937.GB10484@arm.com>
References: <1397734570-12748-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397734570-12748-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, Apr 17, 2014 at 12:36:09PM +0100, Will Deacon wrote:
> When running on a hideously slow system (~10Mhz FPGA) with a bunch of
> debug printk invocations on the timer interrupt path, we end up filling
> the log buffer faster than we can drain it.
> 
> The reason is that console_unlock (which is responsible for moving
> messages out of logbuf to hand over to the console driver) removes one
> message at a time, briefly re-enabling interrupts between each of them.
> If the interrupt path prints more than a single message, then we can
> easily generate more messages than we can print for a regular, recurring
> interrupt (e.g. a 1khz timer). This results in messages getting silently
> dropped, leading to counter-intuitive, incomplete printk traces on the
> console.
> 
> Rather than run the console_unlock loop with interrupts disabled (which
> has obvious latency problems), this patch records the sequence number of
> the last message in the log buffer after taking the logbuf_lock. We can
> then print this fixed amount of work before re-enabling interrupts again,
> making sure we keep up with ourself. Other CPUs could still potentially
> flood the buffer, but there's little that we can do to protect against
> that.

Any thoughts on these two patches? I can understand the reluctance to make
changes to printk, but I had a horrible time debugging timers without these
patches!

Cheers,

Will

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  kernel/printk/printk.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index a45b50962295..721a7d8fb853 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2033,10 +2033,13 @@ void console_unlock(void)
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
> @@ -2081,6 +2084,12 @@ skip:
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
> -- 
> 1.9.1
> 
