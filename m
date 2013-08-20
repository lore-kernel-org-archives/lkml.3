Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3HTVcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:32:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3HTVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:31:59 -0400
Date: Tue, 20 Aug 2013 14:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@gentwo.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v3 1/4] idr: Percpu ida
Message-Id: <20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
In-Reply-To: <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
	<1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013 23:09:06 +0000 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Kent Overstreet <kmo@daterainc.com>
> 
> Percpu frontend for allocating ids. With percpu allocation (that works),
> it's impossible to guarantee it will always be possible to allocate all
> nr_tags - typically, some will be stuck on a remote percpu freelist
> where the current job can't get to them.
> 
> We do guarantee that it will always be possible to allocate at least
> (nr_tags / 2) tags - this is done by keeping track of which and how many
> cpus have tags on their percpu freelists. On allocation failure if
> enough cpus have tags that there could potentially be (nr_tags / 2) tags
> stuck on remote percpu freelists, we then pick a remote cpu at random to
> steal from.
> 
> Note that there's no cpu hotplug notifier - we don't care, because
> steal_tags() will eventually get the down cpu's tags. We _could_ satisfy
> more allocations if we had a notifier - but we'll still meet our
> guarantees and it's absolutely not a correctness issue, so I don't think
> it's worth the extra code.
>
> ...
>
>  include/linux/idr.h |   53 +++++++++
>  lib/idr.c           |  316 +++++++++++++++++++++++++++++++++++++++++++++++++--

I don't think this should be in idr.[ch] at all.  It has no
relationship with the existing code.  Apart from duplicating its
functionality :(

> 
> ...
>
> @@ -243,4 +245,55 @@ static inline int ida_get_new(struct ida *ida, int *p_id)
>  
>  void __init idr_init_cache(void);
>  
> +/* Percpu IDA/tag allocator */
> +
> +struct percpu_ida_cpu;
> +
> +struct percpu_ida {
> +	/*
> +	 * number of tags available to be allocated, as passed to
> +	 * percpu_ida_init()
> +	 */
> +	unsigned			nr_tags;
> +
> +	struct percpu_ida_cpu __percpu	*tag_cpu;
> +
> +	/*
> +	 * Bitmap of cpus that (may) have tags on their percpu freelists:
> +	 * steal_tags() uses this to decide when to steal tags, and which cpus
> +	 * to try stealing from.
> +	 *
> +	 * It's ok for a freelist to be empty when its bit is set - steal_tags()
> +	 * will just keep looking - but the bitmap _must_ be set whenever a
> +	 * percpu freelist does have tags.
> +	 */
> +	unsigned long			*cpus_have_tags;

Why not cpumask_t?

> +	struct {
> +		spinlock_t		lock;
> +		/*
> +		 * When we go to steal tags from another cpu (see steal_tags()),
> +		 * we want to pick a cpu at random. Cycling through them every
> +		 * time we steal is a bit easier and more or less equivalent:
> +		 */
> +		unsigned		cpu_last_stolen;
> +
> +		/* For sleeping on allocation failure */
> +		wait_queue_head_t	wait;
> +
> +		/*
> +		 * Global freelist - it's a stack where nr_free points to the
> +		 * top
> +		 */
> +		unsigned		nr_free;
> +		unsigned		*freelist;
> +	} ____cacheline_aligned_in_smp;

Why the ____cacheline_aligned_in_smp?

> +};
> 
> ...
>
> +
> +/* Percpu IDA */
> +
> +/*
> + * Number of tags we move between the percpu freelist and the global freelist at
> + * a time

"between a percpu freelist" would be more accurate?

> + */
> +#define IDA_PCPU_BATCH_MOVE	32U
> +
> +/* Max size of percpu freelist, */
> +#define IDA_PCPU_SIZE		((IDA_PCPU_BATCH_MOVE * 3) / 2)
> +
> +struct percpu_ida_cpu {
> +	spinlock_t			lock;
> +	unsigned			nr_free;
> +	unsigned			freelist[];
> +};

Data structure needs documentation.  There's one of these per cpu.  I
guess nr_free and freelist are clear enough.  The presence of a lock
in a percpu data structure is a surprise.  It's for cross-cpu stealing,
I assume?

> +static inline void move_tags(unsigned *dst, unsigned *dst_nr,
> +			     unsigned *src, unsigned *src_nr,
> +			     unsigned nr)
> +{
> +	*src_nr -= nr;
> +	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
> +	*dst_nr += nr;
> +}
> +
> 
> ...
>
> +static inline void alloc_global_tags(struct percpu_ida *pool,
> +				     struct percpu_ida_cpu *tags)
> +{
> +	move_tags(tags->freelist, &tags->nr_free,
> +		  pool->freelist, &pool->nr_free,
> +		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
> +}

Document this function?

> +static inline unsigned alloc_local_tag(struct percpu_ida *pool,
> +				       struct percpu_ida_cpu *tags)
> +{
> +	int tag = -ENOSPC;
> +
> +	spin_lock(&tags->lock);
> +	if (tags->nr_free)
> +		tag = tags->freelist[--tags->nr_free];
> +	spin_unlock(&tags->lock);
> +
> +	return tag;
> +}

I guess this one's clear enough, if the data structure relationships are
understood.

> +/**
> + * percpu_ida_alloc - allocate a tag
> + * @pool: pool to allocate from
> + * @gfp: gfp flags
> + *
> + * Returns a tag - an integer in the range [0..nr_tags) (passed to
> + * tag_pool_init()), or otherwise -ENOSPC on allocation failure.
> + *
> + * Safe to be called from interrupt context (assuming it isn't passed
> + * __GFP_WAIT, of course).
> + *
> + * Will not fail if passed __GFP_WAIT.
> + */
> +int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
> +{
> +	DEFINE_WAIT(wait);
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
> +	int tag;
> +
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +
> +	/* Fastpath */
> +	tag = alloc_local_tag(pool, tags);
> +	if (likely(tag >= 0)) {
> +		local_irq_restore(flags);
> +		return tag;
> +	}
> +
> +	while (1) {
> +		spin_lock(&pool->lock);
> +
> +		/*
> +		 * prepare_to_wait() must come before steal_tags(), in case
> +		 * percpu_ida_free() on another cpu flips a bit in
> +		 * cpus_have_tags
> +		 *
> +		 * global lock held and irqs disabled, don't need percpu lock
> +		 */
> +		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> +
> +		if (!tags->nr_free)
> +			alloc_global_tags(pool, tags);
> +		if (!tags->nr_free)
> +			steal_tags(pool, tags);
> +
> +		if (tags->nr_free) {
> +			tag = tags->freelist[--tags->nr_free];
> +			if (tags->nr_free)
> +				set_bit(smp_processor_id(),
> +					pool->cpus_have_tags);
> +		}
> +
> +		spin_unlock(&pool->lock);
> +		local_irq_restore(flags);
> +
> +		if (tag >= 0 || !(gfp & __GFP_WAIT))
> +			break;
> +
> +		schedule();
> +
> +		local_irq_save(flags);
> +		tags = this_cpu_ptr(pool->tag_cpu);
> +	}

What guarantees that this wait will terminate?

> +	finish_wait(&pool->wait, &wait);
> +	return tag;
> +}
> +EXPORT_SYMBOL_GPL(percpu_ida_alloc);
> +
> +/**
> + * percpu_ida_free - free a tag
> + * @pool: pool @tag was allocated from
> + * @tag: a tag previously allocated with percpu_ida_alloc()
> + *
> + * Safe to be called from interrupt context.
> + */
> +void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
> +{
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
> +	unsigned nr_free;
> +
> +	BUG_ON(tag >= pool->nr_tags);
> +
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +
> +	spin_lock(&tags->lock);

Why do we need this lock, btw?  It's a cpu-local structure and local
irqs are disabled...

> +	tags->freelist[tags->nr_free++] = tag;
> +
> +	nr_free = tags->nr_free;
> +	spin_unlock(&tags->lock);
> +
> +	if (nr_free == 1) {
> +		set_bit(smp_processor_id(),
> +			pool->cpus_have_tags);
> +		wake_up(&pool->wait);
> +	}
> +
> +	if (nr_free == IDA_PCPU_SIZE) {
> +		spin_lock(&pool->lock);
> +
> +		/*
> +		 * Global lock held and irqs disabled, don't need percpu
> +		 * lock
> +		 */
> +		if (tags->nr_free == IDA_PCPU_SIZE) {
> +			move_tags(pool->freelist, &pool->nr_free,
> +				  tags->freelist, &tags->nr_free,
> +				  IDA_PCPU_BATCH_MOVE);
> +
> +			wake_up(&pool->wait);
> +		}
> +		spin_unlock(&pool->lock);
> +	}
> +
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(percpu_ida_free);
> 
> ...
>
> +int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
> +{
> +	unsigned i, cpu, order;
> +
> +	memset(pool, 0, sizeof(*pool));
> +
> +	init_waitqueue_head(&pool->wait);
> +	spin_lock_init(&pool->lock);
> +	pool->nr_tags = nr_tags;
> +
> +	/* Guard against overflow */
> +	if (nr_tags > (unsigned) INT_MAX + 1) {
> +		pr_err("tags.c: nr_tags too large\n");

"tags.c"?

> +		return -EINVAL;
> +	}
> +
> +	order = get_order(nr_tags * sizeof(unsigned));
> +	pool->freelist = (void *) __get_free_pages(GFP_KERNEL, order);
> +	if (!pool->freelist)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_tags; i++)
> +		pool->freelist[i] = i;
> +
> +	pool->nr_free = nr_tags;
> +
> +	pool->cpus_have_tags = kzalloc(BITS_TO_LONGS(nr_cpu_ids) *
> +				       sizeof(unsigned long), GFP_KERNEL);
> +	if (!pool->cpus_have_tags)
> +		goto err;
> +
> +	pool->tag_cpu = __alloc_percpu(sizeof(struct percpu_ida_cpu) +
> +				       IDA_PCPU_SIZE * sizeof(unsigned),
> +				       sizeof(unsigned));
> +	if (!pool->tag_cpu)
> +		goto err;
> +
> +	for_each_possible_cpu(cpu)
> +		spin_lock_init(&per_cpu_ptr(pool->tag_cpu, cpu)->lock);
> +
> +	return 0;
> +err:
> +	percpu_ida_destroy(pool);
> +	return -ENOMEM;
> +}
> +EXPORT_SYMBOL_GPL(percpu_ida_init);
