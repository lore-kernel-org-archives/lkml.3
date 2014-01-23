Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaAWNyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:54:13 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48196 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaAWNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:54:11 -0500
Date: Thu, 23 Jan 2014 05:55:39 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123135539.GF889@kmo-pixel>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
 <20140123132829.GE889@kmo-pixel>
 <20140123135003.GU30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123135003.GU30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 02:50:03PM +0100, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 05:28:29AM -0800, Kent Overstreet wrote:
> > pool->lock is also going to be fairly badly contended in the worst case,
> > and that can get real bad real fast... now that I think about it we
> > probably want to avoid the __alloc_global_tag() double call just because
> > of that, pool->lock is going to be quite a bit more contended than the
> > waitlist lock just because fo the amount of work done under it.
> 
> OK, how about this then.. Not quite at pretty though

Heh, I suppose that is a solution. Let me screw around to see what I can
come up with tomorrow, but if I can't come up with anything I like I'm
not opposed to this.

> ---
>  lib/percpu_ida.c | 128 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 65 insertions(+), 63 deletions(-)
> 
> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index 9d054bf91d0f..a1279622436a 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -68,6 +68,8 @@ static inline void steal_tags(struct percpu_ida *pool,
>  	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
>  	struct percpu_ida_cpu *remote;
>  
> +	lockdep_assert_held(&pool->lock);
> +
>  	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
>  	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
>  	     cpus_have_tags--) {
> @@ -105,26 +107,52 @@ static inline void steal_tags(struct percpu_ida *pool,
>  	}
>  }
>  
> -/*
> - * Pop up to IDA_PCPU_BATCH_MOVE IDs off the global freelist, and push them onto
> - * our percpu freelist:
> - */
> -static inline void alloc_global_tags(struct percpu_ida *pool,
> -				     struct percpu_ida_cpu *tags)
> +static inline int alloc_local_tag(struct percpu_ida *pool)
>  {
> -	move_tags(tags->freelist, &tags->nr_free,
> -		  pool->freelist, &pool->nr_free,
> -		  min(pool->nr_free, pool->percpu_batch_size));
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
> +	int tag = -ENOSPC;
> +
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +	spin_lock(&tags->lock);
> +	if (tags->nr_free)
> +		tag = tags->freelist[--tags->nr_free];
> +	spin_unlock_irqrestore(&tags->lock, flags);
> +
> +	return tag;
>  }
>  
> -static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
> +static inline int alloc_global_tag(struct percpu_ida *pool)
>  {
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
>  	int tag = -ENOSPC;
>  
> -	spin_lock(&tags->lock);
> -	if (tags->nr_free)
> +	spin_lock_irqsave(&pool->lock, flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +
> +	if (!tags->nr_free) {
> +		/*
> +		 * Move tags from the global-, onto our percpu-freelist.
> +		 */
> +		move_tags(tags->freelist, &tags->nr_free,
> +			  pool->freelist, &pool->nr_free,
> +			  min(pool->nr_free, pool->percpu_batch_size));
> +	}
> +
> +	if (!tags->nr_free)
> +		steal_tags(pool, tags);
> +
> +	if (tags->nr_free) {
>  		tag = tags->freelist[--tags->nr_free];
> -	spin_unlock(&tags->lock);
> +		if (tags->nr_free) {
> +			cpumask_set_cpu(smp_processor_id(),
> +					&pool->cpus_have_tags);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&pool->lock, flags);
>  
>  	return tag;
>  }
> @@ -147,61 +175,28 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
>   *
>   * Will not fail if passed __GFP_WAIT.
>   */
> -int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
> +int percpu_ida_alloc(struct percpu_ida *pool, int state)
>  {
> -	DEFINE_WAIT(wait);
> -	struct percpu_ida_cpu *tags;
> -	unsigned long flags;
> -	int tag;
> -
> -	local_irq_save(flags);
> -	tags = this_cpu_ptr(pool->tag_cpu);
> -
> -	/* Fastpath */
> -	tag = alloc_local_tag(tags);
> -	if (likely(tag >= 0)) {
> -		local_irq_restore(flags);
> -		return tag;
> -	}
> -
> -	while (1) {
> -		spin_lock(&pool->lock);
> +	int ret;
>  
> -		/*
> -		 * prepare_to_wait() must come before steal_tags(), in case
> -		 * percpu_ida_free() on another cpu flips a bit in
> -		 * cpus_have_tags
> -		 *
> -		 * global lock held and irqs disabled, don't need percpu lock
> -		 */
> -		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> +	ret = alloc_local_tag(pool);
> +	if (likely(ret >= 0))
> +		return ret;
>  
> -		if (!tags->nr_free)
> -			alloc_global_tags(pool, tags);
> -		if (!tags->nr_free)
> -			steal_tags(pool, tags);
> +	if (state != TASK_RUNNING) {
> +		int tag;
>  
> -		if (tags->nr_free) {
> -			tag = tags->freelist[--tags->nr_free];
> -			if (tags->nr_free)
> -				cpumask_set_cpu(smp_processor_id(),
> -						&pool->cpus_have_tags);
> -		}
> +		ret = ___wait_event(pool->wait,
> +				(tag = alloc_global_tag(pool)) >= 0,
> +				state, 0, 0, schedule());
>  
> -		spin_unlock(&pool->lock);
> -		local_irq_restore(flags);
> -
> -		if (tag >= 0 || !(gfp & __GFP_WAIT))
> -			break;
> -
> -		schedule();
> -
> -		local_irq_save(flags);
> -		tags = this_cpu_ptr(pool->tag_cpu);
> +		if (tag >= 0)
> +			ret = tag;
> +	} else {
> +		ret = alloc_global_tag(pool);
>  	}
>  
> -	finish_wait(&pool->wait, &wait);
> -	return tag;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(percpu_ida_alloc);
>  
> @@ -235,12 +230,19 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
>  		wake_up(&pool->wait);
>  	}
>  
> +	/*
> +	 * No point in waking when 1 < n < max_size free, because steal_tags()
> +	 * will assume max_size per set bit, having more free will not make it
> +	 * more or less likely it will visit this cpu.
> +	 */
> +
>  	if (nr_free == pool->percpu_max_size) {
>  		spin_lock(&pool->lock);
>  
>  		/*
> -		 * Global lock held and irqs disabled, don't need percpu
> -		 * lock
> +		 * Global lock held and irqs disabled, don't need percpu lock
> +		 * because everybody accessing remote @tags will hold
> +		 * pool->lock -- steal_tags().
>  		 */
>  		if (tags->nr_free == pool->percpu_max_size) {
>  			move_tags(pool->freelist, &pool->nr_free,
