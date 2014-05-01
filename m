Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaEAWD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaEAWD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:03:26 -0400
Date: Fri, 2 May 2014 00:04:17 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
Message-ID: <20140501220417.GB17436@dhcp-26-207.brq.redhat.com>
References: <cover.1395840483.git.agordeev@redhat.com>
 <20140422115629.GI11182@twins.programming.kicks-ass.net>
 <20140501212442.GA17436@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501212442.GA17436@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:24:42PM +0200, Alexander Gordeev wrote:
> On Tue, Apr 22, 2014 at 01:56:29PM +0200, Peter Zijlstra wrote:
> > I've not had time to revisit/finish them, but you should definitely
> > clean up the percpu_ida stuff and reduce existing contention before
> > going overboard.
> 
> Hi Peter,
> 
> I tried to combine your series into a single patch against 3.15-rc3.
> 
> I hope, it looks like you intended and my comments in follow-up
> message make sense.
> 
> Thanks!
> 
> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index 93d145e..14f5151 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -51,6 +51,15 @@ static inline void move_tags(unsigned *dst, unsigned *dst_nr,
>  	*dst_nr += nr;
>  }
>  
> +static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
> +{
> +	if (l1 > l2)
> +		swap(l1, l2);
> +
> +	spin_lock(l1);
> +	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
> +}
> +
>  /*
>   * Try to steal tags from a remote cpu's percpu freelist.
>   *
> @@ -84,7 +93,7 @@ static inline void steal_tags(struct percpu_ida *pool,
>  		if (remote == tags)
>  			continue;
>  
> -		spin_lock(&remote->lock);
> +		double_lock(&tags->lock, &remote->lock);
>  
>  		if (remote->nr_free) {
>  			memcpy(tags->freelist,
> @@ -96,36 +105,81 @@ static inline void steal_tags(struct percpu_ida *pool,
>  		}
>  
>  		spin_unlock(&remote->lock);
> +		spin_unlock(&tags->lock);
>  
>  		if (tags->nr_free)
>  			break;
>  	}
>  }
>  
> -/*
> - * Pop up to IDA_PCPU_BATCH_MOVE IDs off the global freelist, and push them onto
> - * our percpu freelist:
> - */
> -static inline void alloc_global_tags(struct percpu_ida *pool,
> -				     struct percpu_ida_cpu *tags)
> +static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
>  {
> -	move_tags(tags->freelist, &tags->nr_free,
> -		  pool->freelist, &pool->nr_free,
> -		  min(pool->nr_free, pool->percpu_batch_size));
> +	int tag = -ENOSPC;
> +
> +	spin_lock(&tags->lock);
> +	if (tags->nr_free)
> +		tag = tags->freelist[--tags->nr_free];
> +	spin_unlock(&tags->lock);
> +
> +	return tag;
>  }
>  
> -static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
> +static inline int alloc_local_tag(struct percpu_ida *pool)
>  {
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
>  	int tag = -ENOSPC;
>  
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
>  	spin_lock(&tags->lock);
>  	if (tags->nr_free)
>  		tag = tags->freelist[--tags->nr_free];
> -	spin_unlock(&tags->lock);
> +	spin_unlock_irqrestore(&tags->lock, flags);
>  
>  	return tag;
>  }
>  
> +static inline int alloc_global_tag(struct percpu_ida *pool)
> +{
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
> + 	int tag = -ENOSPC;
> + 
> +	spin_lock_irqsave(&pool->lock, flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);

If it makes more sense to make it the way alloc_local_tag() does?

	local_irq_save(flags);
	tags = this_cpu_ptr(pool->tag_cpu);
 	spin_lock(&pool->lock);

> +
> +	if (!tags->nr_free) {
> +		/*
> +		 * Move tags from the global-, onto our percpu-freelist.
> +		 */
> +		move_tags(tags->freelist, &tags->nr_free,
> +			  pool->freelist, &pool->nr_free,
> +			  min(pool->nr_free, pool->percpu_batch_size));

'tags' are accessed lock-less and race with steal_tags().
If double_lock() would help here?

> +	}
> +
> +	spin_unlock(&pool->lock);

It is quite difficult to comment here, since there is no affected code shown,
but I will try nevertheless.

So steal_tags() used to serialized with 'pool->lock', which is removed.
As result, two (or more) concurrent threads could find and unset the very
same bit in this piece of code:

	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
	     cpus_have_tags; cpus_have_tags--) {
		cpu = cpumask_next(cpu, &pool->cpus_have_tags);	// *** FIND

		if (cpu >= nr_cpu_ids) {
			cpu = cpumask_first(&pool->cpus_have_tags);
			if (cpu >= nr_cpu_ids)
				BUG();
		}

		pool->cpu_last_stolen = cpu;
		remote = per_cpu_ptr(pool->tag_cpu, cpu);

		cpumask_clear_cpu(cpu, &pool->cpus_have_tags);	// *** UNSET

		...
	}


The second's thread cpumask_clear_cpu() races with cpumask_set_cpu() in
percpu_ida_free()

        if (nr_free == 1) {
                cpumask_set_cpu(smp_processor_id(),
                                &pool->cpus_have_tags);

		// here the bit is UNSET by the second concurrent thread

               	wake_up(&pool->wait);
        }

Which results in the woken thread would not find the illegitimately unset
bit while looping over the mask in steal_tags(). IOW, the tag might get
"lost".

> +	if (!tags->nr_free)
> +		steal_tags(pool, tags);
> +
> +	if (tags->nr_free) {
> +		spin_lock(&tags->lock);
> +		if (tags->nr_free) {
> +	 		tag = tags->freelist[--tags->nr_free];
> +			if (tags->nr_free) {
> +				cpumask_set_cpu(smp_processor_id(),
> +						&pool->cpus_have_tags);
> +			}
> +		}
> +		spin_unlock(&tags->lock);
> +	}
> +
> +	local_irq_restore(flags);
> + 
> + 	return tag;
> +}
> +
>  /**
>   * percpu_ida_alloc - allocate a tag
>   * @pool: pool to allocate from
> @@ -146,66 +200,26 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
>   */
>  int percpu_ida_alloc(struct percpu_ida *pool, int state)
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
> -
> -		/*
> -		 * prepare_to_wait() must come before steal_tags(), in case
> -		 * percpu_ida_free() on another cpu flips a bit in
> -		 * cpus_have_tags
> -		 *
> -		 * global lock held and irqs disabled, don't need percpu lock
> -		 */
> -		if (state != TASK_RUNNING)
> -			prepare_to_wait(&pool->wait, &wait, state);
> -
> -		if (!tags->nr_free)
> -			alloc_global_tags(pool, tags);
> -		if (!tags->nr_free)
> -			steal_tags(pool, tags);
> -
> -		if (tags->nr_free) {
> -			tag = tags->freelist[--tags->nr_free];
> -			if (tags->nr_free)
> -				cpumask_set_cpu(smp_processor_id(),
> -						&pool->cpus_have_tags);
> -		}
> -
> -		spin_unlock(&pool->lock);
> -		local_irq_restore(flags);
> -
> -		if (tag >= 0 || state == TASK_RUNNING)
> -			break;
> -
> -		if (signal_pending_state(state, current)) {
> -			tag = -ERESTARTSYS;
> -			break;
> -		}
> -
> -		schedule();
> -
> -		local_irq_save(flags);
> -		tags = this_cpu_ptr(pool->tag_cpu);
> -	}
> -	if (state != TASK_RUNNING)
> -		finish_wait(&pool->wait, &wait);
> -
> -	return tag;
> +	int ret;
> +
> +	ret = alloc_local_tag(pool);
> +	if (likely(ret >= 0))
> +		return ret;
> +
> +	if (state != TASK_RUNNING) {
> +		int tag;
> + 
> +		ret = ___wait_event(pool->wait,
> +				    (tag = alloc_global_tag(pool)) >= 0,
> +				    state, 0, 0, schedule());
> + 
> +		if (tag >= 0)
> +			ret = tag;
> +	} else {
> +		ret = alloc_global_tag(pool);
> + 	}
> + 
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(percpu_ida_alloc);
>  
> @@ -239,12 +253,19 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
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
> @@ -344,33 +365,31 @@ EXPORT_SYMBOL_GPL(__percpu_ida_init);
>  int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
>  	void *data)
>  {
> -	unsigned long flags;
>  	struct percpu_ida_cpu *remote;
> -	unsigned cpu, i, err = 0;
> +	unsigned long flags;
> +	int cpu, i, err = 0;
>  
> -	local_irq_save(flags);
>  	for_each_possible_cpu(cpu) {
>  		remote = per_cpu_ptr(pool->tag_cpu, cpu);
> -		spin_lock(&remote->lock);
> +		spin_lock_irqsave(&remote->lock, flags);
>  		for (i = 0; i < remote->nr_free; i++) {
>  			err = fn(remote->freelist[i], data);
>  			if (err)
>  				break;
>  		}
> -		spin_unlock(&remote->lock);
> +		spin_unlock_irqrestore(&remote->lock, flags);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
>  
> -	spin_lock(&pool->lock);
> +	spin_lock_irqsave(&pool->lock, flags);
>  	for (i = 0; i < pool->nr_free; i++) {
>  		err = fn(pool->freelist[i], data);
>  		if (err)
>  			break;
>  	}
> -	spin_unlock(&pool->lock);
> -out:
> -	local_irq_restore(flags);
> +	spin_unlock_irqrestore(&pool->lock, flags);
> +
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(percpu_ida_for_each_free);

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
