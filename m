Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3HUSfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:35:38 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:21666 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab3HUSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:35:37 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 14:35:36 EDT
Date: Wed, 21 Aug 2013 18:25:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH-v3 1/4] idr: Percpu ida
In-Reply-To: <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
Message-ID: <00000140a2203fca-f2e76962-a285-4e93-b200-bb05d6501f24-000000@email.amazonses.com>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org> <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013, Nicholas A. Bellinger wrote:

> +	spinlock_t			lock;

Remove the spinlock.

> +	unsigned			nr_free;
> +	unsigned			freelist[];
> +};
> +
> +static inline void move_tags(unsigned *dst, unsigned *dst_nr,
> +			     unsigned *src, unsigned *src_nr,
> +			     unsigned nr)
> +{
> +	*src_nr -= nr;
> +	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
> +	*dst_nr += nr;
> +}
> +

> +static inline unsigned alloc_local_tag(struct percpu_ida *pool,
> +				       struct percpu_ida_cpu *tags)

Pass the __percpu offset and not the tags pointer.

> +{
> +	int tag = -ENOSPC;
> +
> +	spin_lock(&tags->lock);

Interupts are already disabled. Drop the spinlock.

> +	if (tags->nr_free)
> +		tag = tags->freelist[--tags->nr_free];

You can keep this or avoid address calculation through segment prefixes.
F.e.

if (__this_cpu_read(tags->nrfree) {
	int n = __this_cpu_dec_return(tags->nr_free);
	tag =  __this_cpu_read(tags->freelist[n]);
}

> +	spin_unlock(&tags->lock);

Drop.

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

You could drop this_cpu_ptr if you pass pool->tag_cpu to alloc_local_tag.

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

No need for spinlocking
> +	tags->freelist[tags->nr_free++] = tag;

nr_free = __this_cpu_inc_return(pool->tag_cpu.nr_free) ?

__this_cpu_write(pool->tag_cpu.freelist[nr_free], tag)


