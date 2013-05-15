Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab3EORh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:37:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52245 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759816Ab3EORhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:37:24 -0400
Date: Wed, 15 May 2013 10:37:20 -0700
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
Message-ID: <20130515173720.GA26222@htj.dyndns.org>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514145932.GA6607@mtj.dyndns.org>
 <20130515085856.GB16164@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515085856.GB16164@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Wed, May 15, 2013 at 01:58:56AM -0700, Kent Overstreet wrote:
> > Explanation on synchronization and use cases would be nice.  People
> > tend to develop massive mis-uses for interfaces like this.
> 
> hrm, kind of hard to know exactly what to say without seeing how people
> misuse it first. How about this?
> 
>  * Returns true the first time called on @ref and false percpu_ref_kill() has
>  * already been called on @ref.
>  *
>  * The return value can optionally be used to synchronize shutdown, when
>  * multiple threads could try to destroy an object at the same time - if
>  * percpu_ref_kill() returns true, then this thread should release the initial
>  * refcount - see percpu_ref_put_initial_ref().

Ooh, I was referring to percpu_ref_dead() not percpu_ref_kill().
percpu_ref_dead() reminds me of some of the work state query functions
in workqueue which ended up being misused in ways that were subtly
racy, so I'm curious why it's necessary and how it's supposed to be
used.

> > > + * What we do is require the user to keep track of the initial refcount; we know
> > > + * the ref can't hit 0 before the user drops the initial ref, so as long as we
> > > + * convert to non percpu mode before the initial ref is dropped everything
> > > + * works.
> > 
> > Can you please also explain why per-cpu wrapping is safe somewhere?
> 
> I feel like we had this exact discussion before and I came up with some

Yeap, we did.

> sort of explanation but I can't remember what I came up with. Here's
> what I've got now...
> 
>  * Initially, a percpu refcount is just a set of percpu counters. Initially, we
>  * don't try to detect the ref hitting 0 - which means that get/put can just
>  * increment or decrement the local counter. Note that the counter on a
>  * particular cpu can (and will) wrap - this is fine, when we go to shutdown the
>  * percpu counters will all sum to the correct value (because moduler arithmatic
>  * is commutative).

Can you please expand it on a bit and, more importantly, describe in
what limits, it's safe?  This should be safe as long as the actual sum
of refcnts given out doesn't overflow the original type, right?  It'd
be great if that is explained clearly in more intuitive way.  The only
actual explanation above is "modular arithmatic is commutative" which
is a very compact way to put it and I really think it deserves an
easier explanation.

> > Are we sure this is enough?  1<<31 is a fairly large number but it's
> > just easy enough to breach from time to time and it's gonna be hellish
> > to reproduce / debug when it actually overflows.  Maybe we want
> > atomic64_t w/ 1LLU << 63 bias?  Or is there something else which
> > guarantees that the bias can't over/underflow?
> 
> Well, it has the effect of halving the usable range of the refcount,
> which I think is probably ok - the thing is, the range of an atomic_t
> doesn't really correspond to anything useful on 64 bit machines so if
> you're concerned about overflow you probably need to be using an
> atomic_long_t. That is, if 32 bits is big enough 31 bits probably is
> too.

I'm not worrying about the total refcnt overflowing 31 bits, that's
fine.  What I'm worried about is the percpu refs having systmetic
drift (got on certain cpus and put on others), and the total counter
being overflowed while percpu draining is in progress.  To me, the
problem is that the bias which tags that draining in progress can be
overflown by percpu refs.  The summing can be the same but the tagging
should be put where summing can't overflow it.  It'd be great if you
can explain in the comment in what range it's safe and why, because
that'd make the limits clear to both you and other people reading the
code and would help a lot in deciding whether it's safe enough.

> > Why no /** comment on public functions?  It'd be great if you can
> > explicitly warn about the racy nature of the function - especially,
> > the function may return overflowed or zero refcnt.  BTW, why is this
> > function necessary?  What's the use case?
> 
> Module code - I should probably leave count() and tryget() out until the
> module conversion is done. tryget() in particular is just trying to
> match the existing module_tryget() and it could certainly be implemented
> differently.

I probably should have made it clearer.  Sorry about that.  tryget()
is fine.  I was curious about count() as it's always a bit dangerous a
query interface which is racy and can return something unexpected like
false zero or underflowed refcnt.

> > I'm not sure I like this interface.  Why does it allow being called
> > multiple times?  Why is that necessary?  Wouldn't just making it
> > return void and trigger WARN_ON() if it detects that it's being called
> > multiple times better?  Also, why not bool if the return value is
> > true/false?
> 
> bool just feels a bit strange in the kernel because it's not used that
> much, but yeah bool is correct here.

Well, it's added later on and we're still in the process of converting
to bool.  New things are supposed to use it and they do most of the
time, so let's please stick to it.

> Whether it should return bool, or void like you said and WARN_ON() is
> definitely debatable. I don't have a strong opinion on it - I did it
> this way because it's commonly needed functionality and a convenient
> place implement it, but if we see people misusing it in the future I
> would definitely rip it out.

It's superflous and kinda reminds me of get(ptr) returning ptr, which
people though would be neat as it allows chaining calls on top of it.
It hides the fact the ptr can't change from the compiler and much more
importantly in not so few cases it led people to check the return
value for NULL believing it somehow would take care of the last put
synchronization.  I think we still have such bugs lurking around
kobject.

And I think this one also provides ample opportunities for misuses.
It's an interface which kills a refcnt but doesn't require a reference
as it doesn't put one and people would be tempted to write the
following in racy paths.

	if (ref_kill(ref))
		ref_put(ref);

which seems innocent enough, except that it almost invites
use-after-free on the ref_kill() call.  Why is it calling a function
which kills the ref if it doesn't hold a ref?

Again, let's *please* stick to the known patterns unless deviation is
explicitly justified.  There are very good reasons why people want
justifications when something deviates from the established
conventions / what's neceassary for a given interface.  It's very easy
to introduce something which is broken in subtle yet fundamental ways
and it's just a fact that the author or reviewers are gonna miss some
eventually.

I think I've repeated this multiple times over the past year but here
it is again - deviation or complexity require justification.  We
absolutely shouldn't be doing something unnecessarily unusual and then
try to see what happens.  The risk is higher than immediately visible
and totally unnecessary.

> > > +
> > > +	synchronize_sched();
> > 
> > And this makes the whole function blocking.  Why not use call_rcu() so
> > that the ref can be called w/o sleepable context too?
> 
> Because you need to know when percpu_ref_kill() finishes so you know
> when it's safe to drop the initial ref - if percpu_ref_kill() used
> call_rcu() itself, it would then have to be doing the put itself...
> which means we'd have to stick a pointer to the release function in
> struct percpu_ref.

Hmmm... okay.

> But this is definitely going to be an issue... I was thinking about
> using the low bit of the pointer to indicate that the ref is dead so
> that the caller could use call_rcu() and then call another function to
> gather up the percpu counters, but that's pretty ugly.
> 
> I may just stick the release function in struct percpu_ref and have
> percpu_ref_kill() use call_rcu() after all...

That seems like a better option.  It definitely is hell lot more
intuitive.

> > Can we just roll the above into percpu_ref_kill()?  It's much harder
> > to misuse if kill puts the base ref.
> 
> Possibly... if we did that we'd also be getting rid of percpu_ref_kill's
> synchronization functionality.
> 
> I want to wait until after the call_rcu() thing is decided before
> futzing with this part, there's some dependancies.

Let's just have percpu_ref_kill(ref, release) which puts the base ref
and invokes release whenever it's done.

Thanks.

-- 
tejun
