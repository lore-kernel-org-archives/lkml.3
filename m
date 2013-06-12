Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab3FLRND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:13:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679Ab3FLRM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:12:59 -0400
Date: Wed, 12 Jun 2013 19:08:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130612170835.GA4682@redhat.com>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371009804-11596-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Kent Overstreet wrote:
>
> + * This is done by keeping track of which cpus have tags on their percpu
> + * freelists in a bitmap, and then on allocation failure if too many cpus have
> + * tags on their freelists - i.e. if cpus_have_tags * TAG_CPU_SIZE (64) >
> + * nr_tags / 2 - then we steal one remote cpu's freelist (effectively picked at
> + * random).

Interesting... I'll try to read the patch later.

I have to admit, I do not really understand what this bitmap can actually
buy after a quick glance. It is only a hint afaics, and obviously it is
not accurate. alloc_local_tag() never clears the bit, tag_free()->set_bit()
is racy, etc. I guess this is fine, just this doesn't look clear.

But the code looks correct, just a couple of minor nits, feel freee to
ignore.

> +enum {
> +	TAG_FAIL	= -1U,
> +	TAG_MAX		= TAG_FAIL - 1,
> +};

This can probably go to .c, and it seems that TAG_MAX is not needed.
tag_init() can check "nr_tags >= TAG_FAIL" instead.

> +static bool steal_tags(struct percpu_tag_pool *pool,
> +		       struct percpu_tag_cpu_freelist *tags)
> +{
> +	unsigned i, nr_free, cpus_have_tags = 0, cpu = pool->cpu_last_stolen;
> +	struct percpu_tag_cpu_freelist *remote;
> +
> +	for (i = 0; i < DIV_ROUND_UP(nr_cpu_ids, BITS_PER_LONG); i++)
> +		cpus_have_tags += hweight_long(pool->cpus_have_tags[i]);

bitmap_weight(pool->cpus_have_tags, pool->nr_tags).

> +
> +	while (cpus_have_tags-- * TAG_CPU_SIZE > pool->nr_tags / 2) {
> +		cpu = find_next_bit(pool->cpus_have_tags, nr_cpu_ids, cpu);
> +
> +		if (cpu == nr_cpu_ids)
> +			cpu = find_first_bit(pool->cpus_have_tags, nr_cpu_ids);
> +
> +		if (cpu == nr_cpu_ids)
> +			BUG();
> +
> +		pool->cpu_last_stolen = cpu;
> +		remote = per_cpu_ptr(pool->tag_cpu, cpu);
> +
> +		if (remote == tags)
> +			continue;
> +
> +		clear_bit(cpu, pool->cpus_have_tags);
> +
> +		nr_free = xchg(&remote->nr_free, TAG_CPU_STEALING);
> +
> +		if (nr_free) {
> +			memcpy(tags->freelist,
> +			       remote->freelist,
> +			       sizeof(unsigned) * nr_free);
> +			smp_mb();
> +			remote->nr_free = 0;
> +			tags->nr_free = nr_free;
> +			return true;
> +		} else {
> +			remote->nr_free = 0;
> +		}

Both branches clear remote->nr_free.

> +int percpu_tag_pool_init(struct percpu_tag_pool *pool, unsigned long nr_tags)
> +{
> +	unsigned i, order;
> +
> +	memset(pool, 0, sizeof(*pool));
> +
> +	spin_lock_init(&pool->lock);
> +	init_waitqueue_head(&pool->wait);
> +	pool->nr_tags = nr_tags;
> +
> +	/* Guard against overflow */
> +	if (nr_tags > TAG_MAX) {
> +		pr_err("tags.c: nr_tags too large\n");
> +		return -EINVAL;
> +	}
> +
> +	order = get_order(nr_tags * sizeof(unsigned));
> +	pool->freelist = (void *) __get_free_pages(GFP_KERNEL, order);
> +	if (!pool->freelist)
> +		goto err;
> +
> +	for (i = 0; i < nr_tags; i++)
> +		pool->freelist[i] = i;
> +
> +	pool->nr_free = nr_tags;
> +
> +	pool->cpus_have_tags = kzalloc(DIV_ROUND_UP(nr_cpu_ids, BITS_PER_LONG) *
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
BITS_TO_LONGS(nr_cpu_ids)

Oleg.

