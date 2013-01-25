Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3AYSKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:10:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3AYSKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:10:33 -0500
Date: Fri, 25 Jan 2013 19:09:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: tj@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130125180941.GA16896@redhat.com>
References: <20130124232024.GA584@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124232024.GA584@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add lkml)

On 01/24, Kent Overstreet wrote:
>
> This has already been on lkml and is in Andrew's tree, Tejun just asked
> me to send it out again:

I'll try to read this code later, just a couple of questions after a quick
glance. Sorry this was already discussed...

> +struct percpu_ref {
> +	atomic64_t		count;
> +	unsigned long		pcpu_count;
> +};

The code looks a bit tricky mostly because you pack state/pointer/jiffies
into ->pcpu_count. The same for ->count.

I assume that you have a good reason to shrink the sizeof(percpu_ref), but
I am curious: who is the user of this thing?

> + * percpu_ref_get - increment a dynamic percpu refcount
> + *
> + * Increments @ref and possibly converts it to percpu counters. Must be called
> + * with rcu_read_lock() held, and may potentially drop/reacquire rcu_read_lock()
> + * to allocate percpu counters - if sleeping/allocation isn't safe for some
> + * other reason (e.g. a spinlock), see percpu_ref_get_noalloc().

And this looks strange. It must be called under rcu_read_lock(), but
->rcu_read_lock_nesting must be == 1. Otherwise rcu_read_unlock() in
percpu_ref_alloc() won't work.

Again, I think you have a reason, but could you explain? IOW, why we
can't make it might_sleep() instead? The fast path can do rcu_read_lock()
itself.

> +static inline void percpu_ref_get_noalloc(struct percpu_ref *ref)
> +{
> +	__percpu_ref_get(ref, false);
> +}

and this could be percpu_ref_get_atomic().

Once again, I am not arguing, just can't understand.

> +void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
> +{
> +	unsigned long pcpu_count;
> +	uint64_t v;
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
> +		/* for rcu - we're not using rcu_dereference() */
> +		smp_read_barrier_depends();
> +		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));

The comment looks confusing a bit... smp_read_barrier_depends() is not
for rcu, we obviously need it to access (unsigned __percpu *) pcpu_count.
But yes, since we didn't use rcu_dereference() we have to add it by hand.

> +int percpu_ref_kill(struct percpu_ref *ref)
> +{
> ...
> +	if (status == PCPU_REF_PTR) {
> +		unsigned count = 0, cpu;
> +
> +		synchronize_rcu();
> +
> +		for_each_possible_cpu(cpu)
> +			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
> +
> +		pr_debug("global %lli pcpu %i",
> +			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
> +			 (int) count);
> +
> +		atomic64_add((int) count, &ref->count);
> +		smp_wmb();
> +		/* Between setting global count and setting PCPU_REF_DEAD */
> +		ref->pcpu_count = PCPU_REF_DEAD;

The coment explains what the code does, but not why ;)

I guess this is for percpu_ref_put(), and this wmb() pairs with implicit
mb() implied by atomic64_dec_return().

> +		free_percpu((unsigned __percpu *) pcpu_count);

I guess it could be freed right after for_each_possible_cpu() above, but
this doesn't matter.

Oleg.

