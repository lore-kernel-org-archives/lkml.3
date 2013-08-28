Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3H1TxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:53:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36707 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3H1TxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:53:12 -0400
Date: Wed, 28 Aug 2013 12:53:17 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v3 1/4] idr: Percpu ida
Message-ID: <20130828195317.GE8032@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
 <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
 <20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:31:57PM -0700, Andrew Morton wrote:
> On Fri, 16 Aug 2013 23:09:06 +0000 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > +	/*
> > +	 * Bitmap of cpus that (may) have tags on their percpu freelists:
> > +	 * steal_tags() uses this to decide when to steal tags, and which cpus
> > +	 * to try stealing from.
> > +	 *
> > +	 * It's ok for a freelist to be empty when its bit is set - steal_tags()
> > +	 * will just keep looking - but the bitmap _must_ be set whenever a
> > +	 * percpu freelist does have tags.
> > +	 */
> > +	unsigned long			*cpus_have_tags;
> 
> Why not cpumask_t?

I hadn't encountered it before - looks like it's probably what I want.

I don't see any explanation for the parallel set of operations for
working on cpumasks - e.g. next_cpu()/cpumask_next(). For now I'm going
with the cpumask_* versions, is that what I want?o

If you can have a look at the fixup patch that'll be most appreciated.

> > +	struct {
> > +		spinlock_t		lock;
> > +		/*
> > +		 * When we go to steal tags from another cpu (see steal_tags()),
> > +		 * we want to pick a cpu at random. Cycling through them every
> > +		 * time we steal is a bit easier and more or less equivalent:
> > +		 */
> > +		unsigned		cpu_last_stolen;
> > +
> > +		/* For sleeping on allocation failure */
> > +		wait_queue_head_t	wait;
> > +
> > +		/*
> > +		 * Global freelist - it's a stack where nr_free points to the
> > +		 * top
> > +		 */
> > +		unsigned		nr_free;
> > +		unsigned		*freelist;
> > +	} ____cacheline_aligned_in_smp;
> 
> Why the ____cacheline_aligned_in_smp?

It's separating the RW stuff that isn't always touched from the RO stuff
that's used on every allocation.

> 
> > +};
> > 
> > ...
> >
> > +
> > +/* Percpu IDA */
> > +
> > +/*
> > + * Number of tags we move between the percpu freelist and the global freelist at
> > + * a time
> 
> "between a percpu freelist" would be more accurate?

No, because when we're stealing tags we always grab all of the remote
percpu freelist's tags - IDA_PCPU_BATCH_MOVE is only used when moving
to/from the global freelist.

> 
> > + */
> > +#define IDA_PCPU_BATCH_MOVE	32U
> > +
> > +/* Max size of percpu freelist, */
> > +#define IDA_PCPU_SIZE		((IDA_PCPU_BATCH_MOVE * 3) / 2)
> > +
> > +struct percpu_ida_cpu {
> > +	spinlock_t			lock;
> > +	unsigned			nr_free;
> > +	unsigned			freelist[];
> > +};
> 
> Data structure needs documentation.  There's one of these per cpu.  I
> guess nr_free and freelist are clear enough.  The presence of a lock
> in a percpu data structure is a surprise.  It's for cross-cpu stealing,
> I assume?

Yeah, I'll add some comments.

> > +static inline void alloc_global_tags(struct percpu_ida *pool,
> > +				     struct percpu_ida_cpu *tags)
> > +{
> > +	move_tags(tags->freelist, &tags->nr_free,
> > +		  pool->freelist, &pool->nr_free,
> > +		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
> > +}
> 
> Document this function?

Will do

> > +	while (1) {
> > +		spin_lock(&pool->lock);
> > +
> > +		/*
> > +		 * prepare_to_wait() must come before steal_tags(), in case
> > +		 * percpu_ida_free() on another cpu flips a bit in
> > +		 * cpus_have_tags
> > +		 *
> > +		 * global lock held and irqs disabled, don't need percpu lock
> > +		 */
> > +		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> > +
> > +		if (!tags->nr_free)
> > +			alloc_global_tags(pool, tags);
> > +		if (!tags->nr_free)
> > +			steal_tags(pool, tags);
> > +
> > +		if (tags->nr_free) {
> > +			tag = tags->freelist[--tags->nr_free];
> > +			if (tags->nr_free)
> > +				set_bit(smp_processor_id(),
> > +					pool->cpus_have_tags);
> > +		}
> > +
> > +		spin_unlock(&pool->lock);
> > +		local_irq_restore(flags);
> > +
> > +		if (tag >= 0 || !(gfp & __GFP_WAIT))
> > +			break;
> > +
> > +		schedule();
> > +
> > +		local_irq_save(flags);
> > +		tags = this_cpu_ptr(pool->tag_cpu);
> > +	}
> 
> What guarantees that this wait will terminate?

It seems fairly clear to me from the break statement a couple lines up;
if we were passed __GFP_WAIT we terminate iff we succesfully allocated a
tag. If we weren't passed __GFP_WAIT we never actually sleep.

I can add a comment if you think it needs one.

> > +	finish_wait(&pool->wait, &wait);
> > +	return tag;
> > +}
> > +EXPORT_SYMBOL_GPL(percpu_ida_alloc);
> > +
> > +/**
> > + * percpu_ida_free - free a tag
> > + * @pool: pool @tag was allocated from
> > + * @tag: a tag previously allocated with percpu_ida_alloc()
> > + *
> > + * Safe to be called from interrupt context.
> > + */
> > +void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
> > +{
> > +	struct percpu_ida_cpu *tags;
> > +	unsigned long flags;
> > +	unsigned nr_free;
> > +
> > +	BUG_ON(tag >= pool->nr_tags);
> > +
> > +	local_irq_save(flags);
> > +	tags = this_cpu_ptr(pool->tag_cpu);
> > +
> > +	spin_lock(&tags->lock);
> 
> Why do we need this lock, btw?  It's a cpu-local structure and local
> irqs are disabled...

Tag stealing. I added a comment for the data structure explaining the
lock, do you think that suffices?

> > +	/* Guard against overflow */
> > +	if (nr_tags > (unsigned) INT_MAX + 1) {
> > +		pr_err("tags.c: nr_tags too large\n");
> 
> "tags.c"?

Whoops, out of date.
