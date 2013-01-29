Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3A2T3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:29:14 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:52597 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3A2T3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:29:11 -0500
Date: Tue, 29 Jan 2013 11:29:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130129192904.GA6824@mtj.dyndns.org>
References: <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128214506.GG26407@google.com>
 <20130128215042.GN22465@mtj.dyndns.org>
 <20130129163942.GI26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129163942.GI26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Tue, Jan 29, 2013 at 08:39:42AM -0800, Kent Overstreet wrote:
> Oh, if this is going to be widely used I should probably have a
> different implementation for archs that don't have atomic64_t in
> hardware. Don't suppose you know the CONFIG_ macro to test against? I
> couldn't find it when I was looking recently.

!CONFIG_GENERIC_ATOMIC64, I think.  I don't think it's worthwhile to
worry about tho.  Reverting to simple atomic_t ops on !CONFIG_SMP
should cover most relevant cases.

Very tentative review follows.

> +#define PCPU_REF_PTR		0
> +#define PCPU_REF_NONE		1
> +#define PCPU_REF_DEAD		2

Do we still need to distinguish between NONE and DEAD?  It would be
nice if we can just test against NULL.

> +/**
> + * percpu_ref_get - increment a dynamic percpu refcount
> + *
> + * Analagous to atomic_inc().
> +  */
> +static inline void percpu_ref_get(struct percpu_ref *ref)
> +{
> +	unsigned long pcpu_count;
> +
> +	preempt_disable();
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
> +		/* for rcu - we're not using rcu_dereference() */
> +		smp_read_barrier_depends();

Let's explain more. :)

> +		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));

What about overflow?  Note that we can have systemetic cases where ref
is gotten on one cpu and put on another transferring counts in a
specific direction.

> +#define PCPU_COUNT_BITS		50
> +#define PCPU_COUNT_MASK		((1LL << PCPU_COUNT_BITS) - 1)
> +
> +#define PCPU_COUNT_BIAS		(1ULL << 32)

I really don't get this.  Why use 1<<32 for bias which isn't too
difficult to overflow especially if you have many cpu threads and some
systemetic drift in percpu refs?  What's the point of not using the
higher bits?  Is it to encode count usage statistics into the same
counter?  If so, just add another field.  24bytes is fine.

I'd really like to see just basic percpu refcnt with async and sync
interfaces w/o dynamic allocation.  At this point, we aren't really
sure if there are gonna be enough benefits or use cases from dynamic
allocation, so I don't really see the point in the added complexity.
Let's start with basic stuff and add on dynamic alloc if it actually
is necessary.

Thanks.

-- 
tejun
