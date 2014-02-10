Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBJJ2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:28:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaBJJ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:28:45 -0500
Date: Mon, 10 Feb 2014 10:30:11 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kent Overstreet <kmo@daterainc.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140210093011.GA2077@dhcp-26-207.brq.redhat.com>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
 <20140123132829.GE889@kmo-pixel>
 <20140123135003.GU30183@twins.programming.kicks-ass.net>
 <20140123135539.GF889@kmo-pixel>
 <20140123154312.GX30183@twins.programming.kicks-ass.net>
 <20140123162254.GK3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123162254.GK3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 05:22:54PM +0100, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 05:28:29AM -0800, Kent Overstreet wrote:
> > pool->lock is also going to be fairly badly contended in the worst case,
> > and that can get real bad real fast... now that I think about it we
> > probably want to avoid the __alloc_global_tag() double call just because
> > of that, pool->lock is going to be quite a bit more contended than the
> > waitlist lock just because fo the amount of work done under it.
> 
> On top of the two previous; I think we can reduce pool->lock contention
> by not holding it while doing steal_tags().
> 
> By dropping pool->lock around steal_tags() we loose serialization over:
> 
>   pool->cpus_have_tags is an atomic bitmask, and
>   pool->cpu_last_stolem, that's a heuristic anyway, so sod it.
> 
> We further loose the guarantee relied upon by percpu_ida_free(), so have
> it also acquire the tags->lock, which should be a far less contended
> resource.
> 
> Now everything modifying percpu_ida_cpu state holds
> percpu_ida_cpu::lock, everything that modifies the actual percpu_ida
> freelists holds percpu_ida::lock, and percpu_ida_cpu::lock nests inside
> percpu_ida::lock.
> 
> 
> The only annoying thing is that we're still holding IRQs over
> steal_tags(), we should be able to make that a preempt_disable() without
> too much effort, or very much cheat and drop even that and rely on the
> percpu_ida_cpu::lock to serialize everything and just hope that we don't
> migrate too often.
> 
> But that's for another patch.
> 
> ---
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -68,8 +68,6 @@ static inline void steal_tags(struct per
>  	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
>  	struct percpu_ida_cpu *remote;
>  
> -	lockdep_assert_held(&pool->lock);
> -
>  	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
>  	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
>  	     cpus_have_tags--) {

Two concurrent threads find and unset the very same bit few lines below

		cpu = cpumask_next(cpu, &pool->cpus_have_tags);

		[...]

		cpumask_clear_cpu(cpu, &pool->cpus_have_tags);

The second's thread unset races with cpumask_set_cpu() in percpu_ida_free()
or alloc_global_tag()

	if (nr_free == 1) {
		cpumask_set_cpu(smp_processor_id(),
				&pool->cpus_have_tags);
		wake_up(&pool->wait);
	}

Which results in the woken thread does not find the (illegitimately) unset
bit while looping over the mask in steal_tags(). I suspect this or another
thread might enter an unwakable sleep as the number of bits in the mask
and number of threads in the waitqueue became unbalanced.

Hope, I am wrong here.

> @@ -141,18 +139,24 @@ static inline int alloc_global_tag(struc
>  			  min(pool->nr_free, pool->percpu_batch_size));
>  	}
>  
> +	spin_unlock(&pool->lock);
> +
>  	if (!tags->nr_free)
>  		steal_tags(pool, tags);
>  
>  	if (tags->nr_free) {
> -		tag = tags->freelist[--tags->nr_free];
> +		spin_lock(&tags->lock);
>  		if (tags->nr_free) {
> -			cpumask_set_cpu(smp_processor_id(),
> -					&pool->cpus_have_tags);
> +			tag = tags->freelist[--tags->nr_free];
> +			if (tags->nr_free) {
> +				cpumask_set_cpu(smp_processor_id(),
> +						&pool->cpus_have_tags);
> +			}
>  		}
> +		spin_unlock(&tags->lock);
>  	}
>  
> -	spin_unlock_irqrestore(&pool->lock, flags);
> +	local_irq_restore(flags);
>  
>  	return tag;
>  }
> @@ -238,12 +242,8 @@ void percpu_ida_free(struct percpu_ida *
>  
>  	if (nr_free == pool->percpu_max_size) {
>  		spin_lock(&pool->lock);
> +		spin_lock(&tags->lock);
>  
> -		/*
> -		 * Global lock held and irqs disabled, don't need percpu lock
> -		 * because everybody accessing remote @tags will hold
> -		 * pool->lock -- steal_tags().
> -		 */
>  		if (tags->nr_free == pool->percpu_max_size) {
>  			move_tags(pool->freelist, &pool->nr_free,
>  				  tags->freelist, &tags->nr_free,
> @@ -251,6 +251,8 @@ void percpu_ida_free(struct percpu_ida *
>  
>  			wake_up(&pool->wait);
>  		}
> +
> +		spin_unlock(&tags->lock);
>  		spin_unlock(&pool->lock);
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
