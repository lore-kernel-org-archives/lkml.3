Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaCDTyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:54:07 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60270 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754228AbaCDTyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:54:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hToW7Rxd02/3hRrDwm3zsgdS7nrKqG9s=
X-DKIM: OpenDKIM Filter v2.0.1 titan 36A4D539E74
Date: Tue, 4 Mar 2014 14:53:56 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
Message-ID: <20140304195356.GS1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
 <20140304153841.GN1872@titan.lakedaemon.net>
 <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:01:49AM -0800, Kees Cook wrote:
> On Tue, Mar 4, 2014 at 7:38 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > Kees, Ted,
> >
> > On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
> >> When bringing a new RNG source online, it seems like it would make sense
> >> to use some of its bytes to make the system entropy pool more random,
> >> as done with all sorts of other devices that contain per-device or
> >> per-boot differences.
> >
> > Why is this necessary?  init_std_data() already calls
> > arch_get_random_long() while stirring each of the pools.
> 
> I may be misunderstanding something here, but hwrng isn't going to get
> hit by a arch_get_random_long(). 

ahh, you are correct.  It appears it's only used on x86 and powerpc.
Bad assumption on my part.

> That's just for arch-specific RNGs (e.g. RDRAND), where as hwrng is
> for, effectively, add-on devices (e.g. TPMs).
> 
> > I'm a little concerned here because this gives potentially untrusted
> > hwrngs more influence over the entropy pools initial state than most
> > users of random.c expect.  Many of the drivers in hw_random/ are
> > platform drivers and are initialized before random.c.
> >
> > I'm comfortable with the design decisions Ted has made wrt random.c and
> > hwrngs.  However, I think that this changes that trust relationship in a
> > fundamental way.  I'm ok with building support into my kernels for
> > hwrngs as long as random.c's internal use of them is limited to the
> > mixing in extract_buf() and init_std_data().
> >
> > By adding this patch, even without crediting entropy to the pool, a
> > rogue hwrng now has significantly more influence over the initial state
> > of the entropy pools.  Or, am I missing something?
> 
> I wasn't viewing this as dealing with rouge hwrngs (though shouldn't
> that state still be covered due to the existing mixing), but more as a
> "hey this thing has some randomness associated with it", similar to
> the mixing done for things like NIC MAC, etc. (Better, actually, since
> NIC MAC is going to be the same every boot.) It seemed silly to ignore
> an actual entropy source when seeding.

Agreed, but I think we need to be careful about how random.c interacts
with any hwrng.  Ideally, the drivers in hw_random/ could provide
arch_get_random_long().  This way, random.c still determines when and
how to use the hwrng.

Ultimately, the user (person compiling the kernel) will decide to trust
or not trust the hwrng by enabling support for it or not.  My concern
with this patch is that it changes the magnitude of that trust decision.
And only the most diligent user would discover the change.

To date, all discussion wrt random.c and hwrngs are that the output of
the hwrng (in particular, RDRAND) is XORd with the output of the mixer.
Now, we're saying it can provide input as well.  

Please understand, my point-of-view is as someone who installs Linux on
equipment *after* purchase (hobbyist, tinkers).  If I control the part
selection and sourcing of the board components, of course I have more
trust in the hwrng.

So my situation is similar to buying an Intel based laptop.  I can't do
a special order at Bestbuy and ask for a system without the RDRAND
instruction.  Same with the hobbyist market.  We buy the gear, but we
have no control over what's inside it.

In that situation, without this patch, I would enable the hwrng for the
board.  With the patch in it's current form, I would start looking for
research papers and discussions regarding using the hwrng for input.  If
the patch provided arch_get_random_long(), I would feel comfortable
enabling the hwrng.

Perhaps I'm being too conservative, but I'd rather have the discussion
now and have concerns proven unfounded than have someone say "How the
hell did this happen?" three releases down the road.

thx,

Jason.


> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  drivers/char/hw_random/core.c |    7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> >> index a0f7724852eb..6e5bb68a708c 100644
> >> --- a/drivers/char/hw_random/core.c
> >> +++ b/drivers/char/hw_random/core.c
> >> @@ -41,6 +41,7 @@
> >>  #include <linux/miscdevice.h>
> >>  #include <linux/delay.h>
> >>  #include <linux/slab.h>
> >> +#include <linux/random.h>
> >>  #include <asm/uaccess.h>
> >>
> >>
> >> @@ -305,6 +306,8 @@ int hwrng_register(struct hwrng *rng)
> >>       int must_register_misc;
> >>       int err = -EINVAL;
> >>       struct hwrng *old_rng, *tmp;
> >> +     unsigned char bytes[16];
> >> +     int bytes_read;
> >>
> >>       if (rng->name == NULL ||
> >>           (rng->data_read == NULL && rng->read == NULL))
> >> @@ -348,6 +351,10 @@ int hwrng_register(struct hwrng *rng)
> >>       }
> >>       INIT_LIST_HEAD(&rng->list);
> >>       list_add_tail(&rng->list, &rng_list);
> >> +
> >> +     bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> >> +     if (bytes_read > 0)
> >> +             add_device_randomness(bytes, bytes_read);
> >>  out_unlock:
> >>       mutex_unlock(&rng_mutex);
> >>  out:
> >> --
> >> 1.7.9.5
> >>
> >>
> >> --
> >> Kees Cook
> >> Chrome OS Security
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
