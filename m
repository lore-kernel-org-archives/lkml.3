Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3EOI7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:59:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39047 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab3EOI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:59:32 -0400
Date: Wed, 15 May 2013 01:58:56 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20130515085856.GB16164@moria.home.lan>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514145932.GA6607@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514145932.GA6607@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:59:32AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, May 13, 2013 at 06:18:41PM -0700, Kent Overstreet wrote:
> > +/**
> > + * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
> > + *
> > + * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
> 
> Explanation on synchronization and use cases would be nice.  People
> tend to develop massive mis-uses for interfaces like this.

hrm, kind of hard to know exactly what to say without seeing how people
misuse it first. How about this?

 * Returns true the first time called on @ref and false percpu_ref_kill() has
 * already been called on @ref.
 *
 * The return value can optionally be used to synchronize shutdown, when
 * multiple threads could try to destroy an object at the same time - if
 * percpu_ref_kill() returns true, then this thread should release the initial
 * refcount - see percpu_ref_put_initial_ref().



> > + */
> > +static inline int percpu_ref_dead(struct percpu_ref *ref)
> > +{
> > +	return ref->pcpu_count == NULL;
> > +}
> ...
> > +/*
> > + * The trick to implementing percpu refcounts is shutdown. We can't detect the
> > + * ref hitting 0 on every put - this would require global synchronization and
> > + * defeat the whole purpose of using percpu refs.
> > + *
> > + * What we do is require the user to keep track of the initial refcount; we know
> > + * the ref can't hit 0 before the user drops the initial ref, so as long as we
> > + * convert to non percpu mode before the initial ref is dropped everything
> > + * works.
> 
> Can you please also explain why per-cpu wrapping is safe somewhere?

I feel like we had this exact discussion before and I came up with some
sort of explanation but I can't remember what I came up with. Here's
what I've got now...

 * Initially, a percpu refcount is just a set of percpu counters. Initially, we
 * don't try to detect the ref hitting 0 - which means that get/put can just
 * increment or decrement the local counter. Note that the counter on a
 * particular cpu can (and will) wrap - this is fine, when we go to shutdown the
 * percpu counters will all sum to the correct value (because moduler arithmatic
 * is commutative).

> > + * Converting to non percpu mode is done with some RCUish stuff in
> > + * percpu_ref_kill. Additionally, we need a bias value so that the atomic_t
> > + * can't hit 0 before we've added up all the percpu refs.
> > + */
> > +
> > +#define PCPU_COUNT_BIAS		(1ULL << 31)
> 
> Are we sure this is enough?  1<<31 is a fairly large number but it's
> just easy enough to breach from time to time and it's gonna be hellish
> to reproduce / debug when it actually overflows.  Maybe we want
> atomic64_t w/ 1LLU << 63 bias?  Or is there something else which
> guarantees that the bias can't over/underflow?

Well, it has the effect of halving the usable range of the refcount,
which I think is probably ok - the thing is, the range of an atomic_t
doesn't really correspond to anything useful on 64 bit machines so if
you're concerned about overflow you probably need to be using an
atomic_long_t. That is, if 32 bits is big enough 31 bits probably is
too.

If we need a 64-ish bit refcount in the future (I don't think it matters
for AIO) I'll probably just make a percpu_ref64 - that uses u64s for the
percpu counters too.

Or... maybe just make this version use unsigned longs/atomic_long_ts
instead of 32 bit integers. I dunno, I'll think about it a bit.

I don't think it's urgent, it's easy to change the types if and when a
new user comes along for which it matters. IIRC the module code uses 32
bit ints for its refcounts and that's the next thing I was trying to
convert at one point.

> > +int percpu_ref_tryget(struct percpu_ref *ref)
> > +{
> > +	int ret = 1;
> > +
> > +	preempt_disable();
> > +
> > +	if (!percpu_ref_dead(ref))
> > +		percpu_ref_get(ref);
> > +	else
> > +		ret = 0;
> > +
> > +	preempt_enable();
> > +
> > +	return ret;
> > +}
> 
> Why isn't the above one inline?

hmm, I suppose that's like two or three more instructions than normal
get, I'll make it inline.

> Why no /** comment on public functions?  It'd be great if you can
> explicitly warn about the racy nature of the function - especially,
> the function may return overflowed or zero refcnt.  BTW, why is this
> function necessary?  What's the use case?

Module code - I should probably leave count() and tryget() out until the
module conversion is done. tryget() in particular is just trying to
match the existing module_tryget() and it could certainly be implemented
differently.

> > +/**
> > + * percpu_ref_kill - prepare a dynamic percpu refcount for teardown
> > + *
> > + * Must be called before dropping the initial ref, so that percpu_ref_put()
> > + * knows to check for the refcount hitting 0. If the refcount was in percpu
> > + * mode, converts it back to single atomic counter mode.
> > + *
> > + * The caller must issue a synchronize_rcu()/call_rcu() before calling
> > + * percpu_ref_put() to drop the initial ref.
> > + *
> > + * Returns true the first time called on @ref and false if @ref is already
> > + * shutting down, so it may be used by the caller for synchronizing other parts
> > + * of a two stage shutdown.
> > + */
> 
> I'm not sure I like this interface.  Why does it allow being called
> multiple times?  Why is that necessary?  Wouldn't just making it
> return void and trigger WARN_ON() if it detects that it's being called
> multiple times better?  Also, why not bool if the return value is
> true/false?

bool just feels a bit strange in the kernel because it's not used that
much, but yeah bool is correct here.

Whether it should return bool, or void like you said and WARN_ON() is
definitely debatable. I don't have a strong opinion on it - I did it
this way because it's commonly needed functionality and a convenient
place implement it, but if we see people misusing it in the future I
would definitely rip it out.

> > +int percpu_ref_kill(struct percpu_ref *ref)
> > +{
> > +	unsigned __percpu *pcpu_count;
> > +	unsigned __percpu *old;
> > +	unsigned count = 0;
> > +	int cpu;
> > +
> > +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> > +
> > +	do {
> > +		if (!pcpu_count)
> > +			return 0;
> > +
> > +		old = pcpu_count;
> > +		pcpu_count = cmpxchg(&ref->pcpu_count, old, NULL);
> > +	} while (pcpu_count != old);
> > +
> > +	synchronize_sched();
> 
> And this makes the whole function blocking.  Why not use call_rcu() so
> that the ref can be called w/o sleepable context too?

Because you need to know when percpu_ref_kill() finishes so you know
when it's safe to drop the initial ref - if percpu_ref_kill() used
call_rcu() itself, it would then have to be doing the put itself...
which means we'd have to stick a pointer to the release function in
struct percpu_ref.

But this is definitely going to be an issue... I was thinking about
using the low bit of the pointer to indicate that the ref is dead so
that the caller could use call_rcu() and then call another function to
gather up the percpu counters, but that's pretty ugly.

I may just stick the release function in struct percpu_ref and have
percpu_ref_kill() use call_rcu() after all...

> > +/**
> > + * percpu_ref_put_initial_ref - safely drop the initial ref
> > + *
> > + * A percpu refcount needs a shutdown sequence before dropping the initial ref,
> > + * to put it back into single atomic_t mode with the appropriate barriers so
> > + * that percpu_ref_put() can safely check for it hitting 0 - this does so.
> > + *
> > + * Returns true if @ref hit 0.
> > + */
> > +int percpu_ref_put_initial_ref(struct percpu_ref *ref)
> > +{
> > +	if (percpu_ref_kill(ref)) {
> > +		return percpu_ref_put(ref);
> > +	} else {
> > +		WARN_ON(1);
> > +		return 0;
> > +	}
> > +}
> 
> Can we just roll the above into percpu_ref_kill()?  It's much harder
> to misuse if kill puts the base ref.

Possibly... if we did that we'd also be getting rid of percpu_ref_kill's
synchronization functionality.

I want to wait until after the call_rcu() thing is decided before
futzing with this part, there's some dependancies.
