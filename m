Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaCDWsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:48:32 -0500
Received: from waste.org ([173.11.57.241]:47133 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaCDWs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:48:28 -0500
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 17:48:28 EST
Message-ID: <1393972797.8344.190.camel@calx>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
From: Matt Mackall <mpm@selenic.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jason Cooper <jason@lakedaemon.net>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 04 Mar 2014 16:39:57 -0600
In-Reply-To: <CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
References: <20140303235148.GA7601@www.outflux.net>
	 <20140304153841.GN1872@titan.lakedaemon.net>
	 <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
	 <20140304195356.GS1872@titan.lakedaemon.net>
	 <CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 11:59 -0800, Kees Cook wrote:
> On Tue, Mar 4, 2014 at 11:53 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Tue, Mar 04, 2014 at 11:01:49AM -0800, Kees Cook wrote:
> >> On Tue, Mar 4, 2014 at 7:38 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> > Kees, Ted,
> >> >
> >> > On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
> >> >> When bringing a new RNG source online, it seems like it would make sense
> >> >> to use some of its bytes to make the system entropy pool more random,
> >> >> as done with all sorts of other devices that contain per-device or
> >> >> per-boot differences.
> >> >
> >> > Why is this necessary?  init_std_data() already calls
> >> > arch_get_random_long() while stirring each of the pools.
> >>
> >> I may be misunderstanding something here, but hwrng isn't going to get
> >> hit by a arch_get_random_long().
> >
> > ahh, you are correct.  It appears it's only used on x86 and powerpc.
> > Bad assumption on my part.
> >
> >> That's just for arch-specific RNGs (e.g. RDRAND), where as hwrng is
> >> for, effectively, add-on devices (e.g. TPMs).
> >>
> >> > I'm a little concerned here because this gives potentially untrusted
> >> > hwrngs more influence over the entropy pools initial state than most
> >> > users of random.c expect.  Many of the drivers in hw_random/ are
> >> > platform drivers and are initialized before random.c.
> >> >
> >> > I'm comfortable with the design decisions Ted has made wrt random.c and
> >> > hwrngs.  However, I think that this changes that trust relationship in a
> >> > fundamental way.  I'm ok with building support into my kernels for
> >> > hwrngs as long as random.c's internal use of them is limited to the
> >> > mixing in extract_buf() and init_std_data().
> >> >
> >> > By adding this patch, even without crediting entropy to the pool, a
> >> > rogue hwrng now has significantly more influence over the initial state
> >> > of the entropy pools.  Or, am I missing something?
> >>
> >> I wasn't viewing this as dealing with rouge hwrngs (though shouldn't
> >> that state still be covered due to the existing mixing), but more as a
> >> "hey this thing has some randomness associated with it", similar to
> >> the mixing done for things like NIC MAC, etc. (Better, actually, since
> >> NIC MAC is going to be the same every boot.) It seemed silly to ignore
> >> an actual entropy source when seeding.
> >
> > Agreed, but I think we need to be careful about how random.c interacts
> > with any hwrng.  Ideally, the drivers in hw_random/ could provide
> > arch_get_random_long().  This way, random.c still determines when and
> > how to use the hwrng.
> >
> > Ultimately, the user (person compiling the kernel) will decide to trust
> > or not trust the hwrng by enabling support for it or not.  My concern
> > with this patch is that it changes the magnitude of that trust decision.
> > And only the most diligent user would discover the change.
> >
> > To date, all discussion wrt random.c and hwrngs are that the output of
> > the hwrng (in particular, RDRAND) is XORd with the output of the mixer.
> > Now, we're saying it can provide input as well.
> 
> Well, I think there's confusion here over "the" hwrng and "a" hwrng. I
> have devices with multiple entropy sources, and all my hwrngs are
> built as modules, so I choose when to load them into my kernel. "The"
> arch-specific entropy source (e.g. RDRAND) is very different.
> 
> >
> > Please understand, my point-of-view is as someone who installs Linux on
> > equipment *after* purchase (hobbyist, tinkers).  If I control the part
> > selection and sourcing of the board components, of course I have more
> > trust in the hwrng.
> >
> > So my situation is similar to buying an Intel based laptop.  I can't do
> > a special order at Bestbuy and ask for a system without the RDRAND
> > instruction.  Same with the hobbyist market.  We buy the gear, but we
> > have no control over what's inside it.
> >
> > In that situation, without this patch, I would enable the hwrng for the
> > board.  With the patch in it's current form, I would start looking for
> > research papers and discussions regarding using the hwrng for input.  If
> > the patch provided arch_get_random_long(), I would feel comfortable
> > enabling the hwrng.
> >
> > Perhaps I'm being too conservative, but I'd rather have the discussion
> > now and have concerns proven unfounded than have someone say "How the
> > hell did this happen?" three releases down the road.
> 
> Sure, and I don't want to be the one weakening the entropy pool.

[temporarily coming out of retirement to provide a clue]

The pool mixing function is intentionally _reversible_. This is a
crucial security property.

That means, if I have an initial secret pool state X, and hostile
attacker controlled data Y, then we can do:

X' = mix(X, Y)

 and 

X = unmix(X', Y)

We can see from this that the combination of (X' and Y) still contain
the information that was originally in X. Since it's clearly not in Y..
it must all remain in X'.

In other words, if there are 4096 bits of "unknownness" in X to start
with, and I can get those same 4096 bits of "unknownness" back by
unmixing X' and Y, then there must still be 4096 bits of "unknownness"
in X'. If X' is 4096 bits long, then we've just proven that
reversibility means the attacker can know nothing about the contents of
X' by his choice of Y.

Consider the case of a single bit: the quarter in my pocket. I let you
tell me how many times to flip it, but this reversible function gives
you no way to force it to be heads when I reveal it.

So as long as the mixing function remains reversible, it is perfectly
safe to mix in arbitrary amounts of potentially attacker-controlled
data. In fact:

$ ls -l /dev/random
crw-rw-rw- 1 root root 1, 8 Feb 15 16:24 /dev/random

..that's exactly what the 'w' bits here lets you do.

On the other hand, you should continue to be vigilant against anything
that bypasses the pool mixing.

-- 
Mathematics is the supreme nostalgia of our time.


