Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3EaUNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:13:13 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35202 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3EaUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:13:03 -0400
Date: Fri, 31 May 2013 13:12:59 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
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
Message-ID: <20130531201259.GH2291@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514145932.GA6607@mtj.dyndns.org>
 <20130515085856.GB16164@moria.home.lan>
 <20130515173720.GA26222@htj.dyndns.org>
 <20130528234728.GB2291@google.com>
 <87hahmmldf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hahmmldf.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 02:29:56PM +0930, Rusty Russell wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> > I'm not sure I know of any good way of explaining it intuitively, but
> > here's this at least...
> >
> >  * (More precisely: because moduler arithmatic is commutative the sum of all the
> >  * pcpu_count vars will be equal to what it would have been if all the gets and
> >  * puts were done to a single integer, even if some of the percpu integers
> >  * overflow or underflow).
> 
> This seems intuitively obvious, so I wouldn't sweat it too much.  What
> goes up, has to come down somewhere.

I agree, but it seems there's a fair amount of disagreement over what's
intuitive :)

> Yes.  We should note the 31 bit limit somewhere.  We could WARN_ON() if
> count is >= BIAS in percpu_ref_kill(), perhaps.

I'd be hesitant about that - that WARN_ON() would work for this version
(I think) but it'd be incorrect for dynamic percpu refcounting, for
reasons that are almost accidental. And that WARN_ON() isn't going to
fire in anything but the most retarded torture testing.

Besides that, it's hard to imagine a situation where a range of 1 << 32
would be ok but a range of 1 << 31 wouldn't... if we need a WARN_ON()
here we need one for regular atomic_t too, but I don't see either buying
us much.

Also, if/when this is used for something where the range does matter
I'll just switch it to unsigned long (been debating doing that now, but
the aio code was using at atomic_t so I don't really care yet).

It should be documented though - I'll do that.

> >> I probably should have made it clearer.  Sorry about that.  tryget()
> >> is fine.  I was curious about count() as it's always a bit dangerous a
> >> query interface which is racy and can return something unexpected like
> >> false zero or underflowed refcnt.
> >
> > Yeah, it is, it was intended just for the module code where it's only
> > used for the value lsmod shows.
> 
> Open code it there?

Maybe justified for this, but I'm not a fan of open coding anything that
could be considered library/utility code... better to just document it
with ALL CAPS WARNINGS about being dangerous if used incorrectly.

But we can revisit that if/when the module refcount conversion is done.

> >> Let's just have percpu_ref_kill(ref, release) which puts the base ref
> >> and invokes release whenever it's done.
> >
> > Release has to be stored in struct percpu_ref() so it can be invoked
> > after a call_rcu() (percpu_ref_kill -> call_rcu() ->
> > percpu_ref_kill_rcu() -> percpu_ref_put()) so I'm passing it to
> > percpu_ref_init(), but yeah.
> 
> Or hand it to percpu_ref_put(), too, as per kref_put().  I hate indirect
> magic.

The indirect magic is unfortunately necessary because percpu_ref_kill()
has to do a put after a call_rcu().

If the indirect magic wasn't needed I'd prefer to not pass a release
function to anything and just have percpu_ref_put() return bool, but
Tejun disagrees and it's a moot point anyways.
