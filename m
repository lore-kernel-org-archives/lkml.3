Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3LISpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:45:01 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37097 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3LISo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:44:58 -0500
Date: Mon, 9 Dec 2013 19:44:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] softirq: Use ffs in __do_softirq
Message-ID: <20131209184454.GA1811@localhost.localdomain>
References: <cover.1384656563.git.joe@perches.com>
 <8d10077333476c5c0e054cf060006999cf150f0c.1384656563.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d10077333476c5c0e054cf060006999cf150f0c.1384656563.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 01:55:10AM -0800, Joe Perches wrote:
> Possible speed improvement of the __do_softirq function by using ffs
> instead of using a while loop with an & 1 test then single bit shift.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  kernel/softirq.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 11025cc..7be95d7 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -219,6 +219,7 @@ asmlinkage void __do_softirq(void)
>  	int cpu;
>  	unsigned long old_flags = current->flags;
>  	int max_restart = MAX_SOFTIRQ_RESTART;
> +	int softirq_bit;
>  
>  	/*
>  	 * Mask out PF_MEMALLOC s current task context is borrowed for the
> @@ -242,30 +243,30 @@ restart:
>  
>  	h = softirq_vec;
>  
> -	do {
> -		if (pending & 1) {
> -			unsigned int vec_nr = h - softirq_vec;
> -			int prev_count = preempt_count();
> -
> -			kstat_incr_softirqs_this_cpu(vec_nr);
> -
> -			trace_softirq_entry(vec_nr);
> -			h->action(h);
> -			trace_softirq_exit(vec_nr);
> -			if (unlikely(prev_count != preempt_count())) {
> -				printk(KERN_ERR "huh, entered softirq %u %s %p"
> -				       "with preempt_count %08x,"
> -				       " exited with %08x?\n", vec_nr,
> -				       softirq_to_name[vec_nr], h->action,
> -				       prev_count, preempt_count());
> -				preempt_count_set(prev_count);
> -			}
> +	while ((softirq_bit = ffs(pending))) {
> +		unsigned int vec_nr;
> +		int prev_count;
> +
> +		h += softirq_bit - 1;

Perhaps using for_each_set_bit() would simplify that more?

> +
> +		vec_nr = h - softirq_vec;
> +		prev_count = preempt_count();
>  
> -			rcu_bh_qs(cpu);
> +		kstat_incr_softirqs_this_cpu(vec_nr);
> +
> +		trace_softirq_entry(vec_nr);
> +		h->action(h);
> +		trace_softirq_exit(vec_nr);
> +		if (unlikely(prev_count != preempt_count())) {
> +			printk(KERN_ERR "huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
> +			       vec_nr, softirq_to_name[vec_nr], h->action,
> +			       prev_count, preempt_count());
> +			preempt_count_set(prev_count);
>  		}
> +		rcu_bh_qs(cpu);
>  		h++;
> -		pending >>= 1;
> -	} while (pending);
> +		pending >>= softirq_bit;
> +	}
>  
>  	local_irq_disable();
>  
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
