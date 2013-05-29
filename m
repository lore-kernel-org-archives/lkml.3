Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3E2FHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:07:49 -0400
Received: from ozlabs.org ([203.10.76.45]:44257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab3E2FHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:07:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
In-Reply-To: <20130528234728.GB2291@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-5-git-send-email-koverstreet@google.com> <20130514145932.GA6607@mtj.dyndns.org> <20130515085856.GB16164@moria.home.lan> <20130515173720.GA26222@htj.dyndns.org> <20130528234728.GB2291@google.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 29 May 2013 14:29:56 +0930
Message-ID: <87hahmmldf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:
> On Wed, May 15, 2013 at 10:37:20AM -0700, Tejun Heo wrote:
>> Can you please expand it on a bit and, more importantly, describe in
>> what limits, it's safe?  This should be safe as long as the actual sum
>> of refcnts given out doesn't overflow the original type, right? 
>
> Precisely.
>
>> It'd be great if that is explained clearly in more intuitive way.  The
>> only actual explanation above is "modular arithmatic is commutative"
>> which is a very compact way to put it and I really think it deserves
>> an easier explanation.
>
> I'm not sure I know of any good way of explaining it intuitively, but
> here's this at least...
>
>  * (More precisely: because moduler arithmatic is commutative the sum of all the
>  * pcpu_count vars will be equal to what it would have been if all the gets and
>  * puts were done to a single integer, even if some of the percpu integers
>  * overflow or underflow).

This seems intuitively obvious, so I wouldn't sweat it too much.  What
goes up, has to come down somewhere.

>> > > Are we sure this is enough?  1<<31 is a fairly large number but it's
>> > > just easy enough to breach from time to time and it's gonna be hellish
>> > > to reproduce / debug when it actually overflows.  Maybe we want
>> > > atomic64_t w/ 1LLU << 63 bias?  Or is there something else which
>> > > guarantees that the bias can't over/underflow?
>> > 
>> > Well, it has the effect of halving the usable range of the refcount,
>> > which I think is probably ok - the thing is, the range of an atomic_t
>> > doesn't really correspond to anything useful on 64 bit machines so if
>> > you're concerned about overflow you probably need to be using an
>> > atomic_long_t. That is, if 32 bits is big enough 31 bits probably is
>> > too.
>> 
>> I'm not worrying about the total refcnt overflowing 31 bits, that's
>> fine.  What I'm worried about is the percpu refs having systmetic
>> drift (got on certain cpus and put on others), and the total counter
>> being overflowed while percpu draining is in progress.  To me, the
>> problem is that the bias which tags that draining in progress can be
>> overflown by percpu refs.  The summing can be the same but the tagging
>> should be put where summing can't overflow it.  It'd be great if you
>> can explain in the comment in what range it's safe and why, because
>> that'd make the limits clear to both you and other people reading the
>> code and would help a lot in deciding whether it's safe enough.
>
> (This is why I initially didn't (don't) like the bias method, it makes
> things harder to reason about).
>
> The fact that the counter is percpu is irrelevant w.r.t. the bias; we
> sum all the percpu counters up before adding them to the atomic counter
> and subtracting the bias, so when we go to add the percpu counters it's
> no different from if the percpu counter was a single integer all along.
>
> So there's only two counters we're adding together; there's the percpu
> counter (just think of it as a single integer) that we started out
> using, but then at some point in time we start applying the gets and
> puts to the atomic counter.
>
> Note that there's no systemic drift here; at time t all the gets and
> puts were happening to one counter, and then at time t+1 they switch to
> a different counter.
>
> We know the sum of the counters will be positive (again, because modular
> arithmatic is still commutative; when we sum the counters it's as if
> there was a single counter all along) but that doesn't mean either of
> the individual counters can't be negative.
>
> (Actually, unless I'm mistaken in this version the percpu counter can
> never go negative - it definitely could with dynamic percpu allocation,
> as you need a atomic_t -> percpu transition when the atomic_t was > 0
> for the percpu counter to go negative; but in this version we start out
> using the percpu counters and the atomic_t 0 (ignoring for the moment
> the bias and the initial ref).
>
> So, the sum must be positive but the atomic_t could be negative. How
> negative?
>
> We can't do a get() to the percpu counters after we've seen that the ref
> is no longer in percpu mode - so after we've done one put to the
> atomic_t we can do more puts to atomic_t (or gets to the atomic_t) but
> we can't do a get to the percpu counter.
>
> And we can't do more puts than there have been gets - because the sum
> can't be negative. So the most puts() we can do at any given time is the
> real count, or sum of the percpu ref and atomic_t.
>
> Therefore, the amount the atomic_t can go negative is bounded by the
> maximum value of the refcount.
>
> So if we say arbitrarily that the maximum legal value of the refcount is
> - say - 1U << 31, then the atomic_t will always be greater than
> -((int) (1U << 31)).
>
> So as long as the total number of outstanding refs never exceeds the
> bias we're fine.

Yes.  We should note the 31 bit limit somewhere.  We could WARN_ON() if
count is >= BIAS in percpu_ref_kill(), perhaps.

>> I probably should have made it clearer.  Sorry about that.  tryget()
>> is fine.  I was curious about count() as it's always a bit dangerous a
>> query interface which is racy and can return something unexpected like
>> false zero or underflowed refcnt.
>
> Yeah, it is, it was intended just for the module code where it's only
> used for the value lsmod shows.

Open code it there?

>> Let's just have percpu_ref_kill(ref, release) which puts the base ref
>> and invokes release whenever it's done.
>
> Release has to be stored in struct percpu_ref() so it can be invoked
> after a call_rcu() (percpu_ref_kill -> call_rcu() ->
> percpu_ref_kill_rcu() -> percpu_ref_put()) so I'm passing it to
> percpu_ref_init(), but yeah.

Or hand it to percpu_ref_put(), too, as per kref_put().  I hate indirect
magic.

Cheers,
Rusty.
