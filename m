Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3ENO7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:59:44 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:48139 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3ENO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:59:40 -0400
Date: Tue, 14 May 2013 07:59:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130514145932.GA6607@mtj.dyndns.org>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368494338-7069-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 13, 2013 at 06:18:41PM -0700, Kent Overstreet wrote:
> +/**
> + * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
> + *
> + * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.

Explanation on synchronization and use cases would be nice.  People
tend to develop massive mis-uses for interfaces like this.

> + */
> +static inline int percpu_ref_dead(struct percpu_ref *ref)
> +{
> +	return ref->pcpu_count == NULL;
> +}
...
> +/*
> + * The trick to implementing percpu refcounts is shutdown. We can't detect the
> + * ref hitting 0 on every put - this would require global synchronization and
> + * defeat the whole purpose of using percpu refs.
> + *
> + * What we do is require the user to keep track of the initial refcount; we know
> + * the ref can't hit 0 before the user drops the initial ref, so as long as we
> + * convert to non percpu mode before the initial ref is dropped everything
> + * works.

Can you please also explain why per-cpu wrapping is safe somewhere?

> + * Converting to non percpu mode is done with some RCUish stuff in
> + * percpu_ref_kill. Additionally, we need a bias value so that the atomic_t
> + * can't hit 0 before we've added up all the percpu refs.
> + */
> +
> +#define PCPU_COUNT_BIAS		(1ULL << 31)

Are we sure this is enough?  1<<31 is a fairly large number but it's
just easy enough to breach from time to time and it's gonna be hellish
to reproduce / debug when it actually overflows.  Maybe we want
atomic64_t w/ 1LLU << 63 bias?  Or is there something else which
guarantees that the bias can't over/underflow?

> +int percpu_ref_tryget(struct percpu_ref *ref)
> +{
> +	int ret = 1;
> +
> +	preempt_disable();
> +
> +	if (!percpu_ref_dead(ref))
> +		percpu_ref_get(ref);
> +	else
> +		ret = 0;
> +
> +	preempt_enable();
> +
> +	return ret;
> +}

Why isn't the above one inline?

Why no /** comment on public functions?  It'd be great if you can
explicitly warn about the racy nature of the function - especially,
the function may return overflowed or zero refcnt.  BTW, why is this
function necessary?  What's the use case?

> +unsigned percpu_ref_count(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +	unsigned count = 0;
> +	int cpu;
> +
> +	preempt_disable();
> +
> +	count = atomic_read(&ref->count);
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (pcpu_count)
> +		for_each_possible_cpu(cpu)
> +			count += *per_cpu_ptr(pcpu_count, cpu);
> +
> +	preempt_enable();
> +
> +	return count;
> +}
...
> +/**
> + * percpu_ref_kill - prepare a dynamic percpu refcount for teardown
> + *
> + * Must be called before dropping the initial ref, so that percpu_ref_put()
> + * knows to check for the refcount hitting 0. If the refcount was in percpu
> + * mode, converts it back to single atomic counter mode.
> + *
> + * The caller must issue a synchronize_rcu()/call_rcu() before calling
> + * percpu_ref_put() to drop the initial ref.
> + *
> + * Returns true the first time called on @ref and false if @ref is already
> + * shutting down, so it may be used by the caller for synchronizing other parts
> + * of a two stage shutdown.
> + */

I'm not sure I like this interface.  Why does it allow being called
multiple times?  Why is that necessary?  Wouldn't just making it
return void and trigger WARN_ON() if it detects that it's being called
multiple times better?  Also, why not bool if the return value is
true/false?

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
> +
> +	synchronize_sched();

And this makes the whole function blocking.  Why not use call_rcu() so
that the ref can be called w/o sleepable context too?

> +
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

Can we just roll the above into percpu_ref_kill()?  It's much harder
to misuse if kill puts the base ref.

Thanks.

-- 
tejun
