Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3EPBHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:07:25 -0400
Received: from ozlabs.org ([203.10.76.45]:49074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab3EPBGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:06:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
In-Reply-To: <1368494338-7069-5-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-5-git-send-email-koverstreet@google.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 16 May 2013 09:56:19 +0930
Message-ID: <87y5bfzs5w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:
> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test() - but percpu.

Ah!  This is why I was CC'd... Now I understand.  Thanks :)

Delighted to see someone chasing this.  I had an implementation of such
a thing last decade, but the slowmode pattern didn't make for trivial
kref conversions, so I dropped it.

Note: I haven't read the other feedback yet, so ignore if dups.

> +int percpu_ref_init(struct percpu_ref *ref);

Why not just run is slow mode when allocation fails?  Things which can't
fail make for simpler use.

> +int percpu_ref_tryget(struct percpu_ref *ref);
> +int percpu_ref_put_initial_ref(struct percpu_ref *ref);

This is part of a slightly different pattern: the owned refcount.

In fact, I think that's the most sane pattern to use (but I could be
wrong; does the AIO stuff fit?). If so, promote this to the first class
citizen, and if necessary expose kill as __percpu_ref_kill()?

(I might suggest percpu_ref_owner_put() as a name, in fact).

> +/**
> + * percpu_ref_get - increment a dynamic percpu refcount
> + *
> + * Analagous to atomic_inc().
> +  */
> +static inline void percpu_ref_get(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +
> +	preempt_disable();
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (pcpu_count)
> +		__this_cpu_inc(*pcpu_count);
> +	else
> +		atomic_inc(&ref->count);
> +
> +	preempt_enable();
> +}

s/preempt_disable()/rcu_read_lock()/ ?

> +/**
> + * percpu_ref_put - decrement a dynamic percpu refcount
> + *
> + * Returns true if the result is 0, otherwise false; only checks for the ref
> + * hitting 0 after percpu_ref_kill() has been called. Analagous to
> + * atomic_dec_and_test().
> + */
> +static inline int percpu_ref_put(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +	int ret = 0;
> +
> +	preempt_disable();
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (pcpu_count)
> +		__this_cpu_dec(*pcpu_count);
> +	else
> +		ret = atomic_dec_and_test(&ref->count);
> +
> +	preempt_enable();
> +
> +	return ret;
> +}

Here too.  And if you don't put unlikely() in this code, you lose kernel
hacker points :)

And int/true/false is for old-timers.

> +
> +unsigned percpu_ref_count(struct percpu_ref *ref);
> +int percpu_ref_kill(struct percpu_ref *ref);
> +
> +/**
> + * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
> + *
> + * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
> + */
> +static inline int percpu_ref_dead(struct percpu_ref *ref)
> +{
> +	return ref->pcpu_count == NULL;
> +}

Can you unexpose these?  I think percpu_ref_init(), ...get(), ...put()
and ...put_initial() are a nicer API.

> +int percpu_ref_kill(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +	unsigned __percpu *old;
> +	unsigned count = 0;
> +	int cpu;
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	do {
> +		if (!pcpu_count)
> +			return 0;
> +
> +		old = pcpu_count;
> +		pcpu_count = cmpxchg(&ref->pcpu_count, old, NULL);
> +	} while (pcpu_count != old);

This is more complex than it needs to be, no?


        pcpu_count = ACCESS_ONCE(ref->pcpu_count);
        if (!pcpu_count)
                return 0;
        if (cmpxchg(&ref->pcpu_count, pcpu_count, NULL) == NULL)
                return 0;

Of course, if all callers use the owner pattern, this is simply:

        pcpu_count = ACCESS_ONCE(ref->pcpu_count);
        BUG_ON(!pcpu_count);

> +	synchronize_sched();

synchronize_rcu() ?

> +	for_each_possible_cpu(cpu)
> +		count += *per_cpu_ptr(pcpu_count, cpu);
> +
> +	free_percpu(pcpu_count);
> +
> +	pr_debug("global %lli pcpu %i",
> +		 (int64_t) atomic_read(&ref->count), (int) count);
> +
> +	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
> +
> +	return 1;
> +}
> +
> +/**
> + * percpu_ref_put_initial_ref - safely drop the initial ref
> + *
> + * A percpu refcount needs a shutdown sequence before dropping the initial ref,
> + * to put it back into single atomic_t mode with the appropriate barriers so
> + * that percpu_ref_put() can safely check for it hitting 0 - this does so.
> + *
> + * Returns true if @ref hit 0.
> + */
> +int percpu_ref_put_initial_ref(struct percpu_ref *ref)
> +{
> +	if (percpu_ref_kill(ref)) {
> +		return percpu_ref_put(ref);
> +	} else {
> +		WARN_ON(1);
> +		return 0;
> +	}
> +}

Note that percpu_ref_restore_initial_ref() is also possible, and may be
useful for the module code... (or percpu_ref_owner_get).

Great stuff!
Rusty.
