Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbaCEVva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:51:30 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40386 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbaCEVvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140305211145.GV1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
	<20140304153841.GN1872@titan.lakedaemon.net>
	<CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
	<20140304195356.GS1872@titan.lakedaemon.net>
	<CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
	<1393972797.8344.190.camel@calx>
	<20140305211145.GV1872@titan.lakedaemon.net>
Date: Wed, 5 Mar 2014 13:51:24 -0800
X-Google-Sender-Auth: deStcgDaSGmgtxZboezZVzyZUzQ
Message-ID: <CAGXu5j+=QLE7Rnae8XKCAWji5aXoGm1tufDWRuzDZcsNSkBF5w@mail.gmail.com>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng sources
From: Kees Cook <keescook@chromium.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Matt Mackall <mpm@selenic.com>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 1:11 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> Matt, Kees,
>
> On Tue, Mar 04, 2014 at 04:39:57PM -0600, Matt Mackall wrote:
>> On Tue, 2014-03-04 at 11:59 -0800, Kees Cook wrote:
>> > On Tue, Mar 4, 2014 at 11:53 AM, Jason Cooper <jason@lakedaemon.net> wrote:
>> > > On Tue, Mar 04, 2014 at 11:01:49AM -0800, Kees Cook wrote:
>> > >> On Tue, Mar 4, 2014 at 7:38 AM, Jason Cooper <jason@lakedaemon.net> wrote:
>> > >> > On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
> ...
>> > Well, I think there's confusion here over "the" hwrng and "a" hwrng. I
>> > have devices with multiple entropy sources, and all my hwrngs are
>> > built as modules, so I choose when to load them into my kernel. "The"
>> > arch-specific entropy source (e.g. RDRAND) is very different.
>
> Dynamically loading modules _after_ boot is fine.  Especially with
> Matt's clear explanation.  I'm not concerned about that scenario.
>
>> > > Please understand, my point-of-view is as someone who installs Linux on
>> > > equipment *after* purchase (hobbyist, tinkers).  If I control the part
>> > > selection and sourcing of the board components, of course I have more
>> > > trust in the hwrng.
>> > >
>> > > So my situation is similar to buying an Intel based laptop.  I can't do
>> > > a special order at Bestbuy and ask for a system without the RDRAND
>> > > instruction.  Same with the hobbyist market.  We buy the gear, but we
>> > > have no control over what's inside it.
>> > >
>> > > In that situation, without this patch, I would enable the hwrng for the
>> > > board.  With the patch in it's current form, I would start looking for
>> > > research papers and discussions regarding using the hwrng for input.  If
>> > > the patch provided arch_get_random_long(), I would feel comfortable
>> > > enabling the hwrng.
>> > >
>> > > Perhaps I'm being too conservative, but I'd rather have the discussion
>> > > now and have concerns proven unfounded than have someone say "How the
>> > > hell did this happen?" three releases down the road.
>> >
>> > Sure, and I don't want to be the one weakening the entropy pool.
>>
>> [temporarily coming out of retirement to provide a clue]
>
> Thanks, Matt!
>
>> The pool mixing function is intentionally _reversible_. This is a
>> crucial security property.
>>
>> That means, if I have an initial secret pool state X, and hostile
>> attacker controlled data Y, then we can do:
>>
>> X' = mix(X, Y)
>>
>>  and
>>
>> X = unmix(X', Y)
>>
>> We can see from this that the combination of (X' and Y) still contain
>> the information that was originally in X. Since it's clearly not in Y..
>> it must all remain in X'.
>>
>> In other words, if there are 4096 bits of "unknownness" in X to start
>> with, and I can get those same 4096 bits of "unknownness" back by
>> unmixing X' and Y, then there must still be 4096 bits of "unknownness"
>> in X'. If X' is 4096 bits long, then we've just proven that
>> reversibility means the attacker can know nothing about the contents of
>> X' by his choice of Y.
>
> Well, this reinforces my comfortability with loadable modules.  The pool
> is already initialized by the point at which the driver is loaded.
>
> Unfortunately, any of the drivers in hw_random can be built in.  When
> built in, hwrng_register is going to be called during the kernel
> initialization process.  In that case, the unknownness in X is not 4096
> bits, but far less.  Also, the items that may have seeded X (MAC addr,
> time, etc) are discoverable by a potential attacker.  This is also well
> before random-seed has been fed in.

Would reducing the size of the buffer used for this help your
concerns? Ironically, a non-malicious hwng using this code would
actually improve defense against other early-boot rng badness since
unlike time and MAC, this is much less discoverable by an attacker.

>
> That's the crux of my concern with this patch.  Basically, the user can
> choose 'y' over 'm', say when building a dedicated system w/o loadable
> modules, and not realize how much more trust he has placed in the hwrng.
>
> How does this patch look?  I'm not claiming my change is acceptable for
> mainline, just seeking feedback on the concept.  IS_MODULE() really
> doesn't have many users afaict.

Regardless, making this change to the patch would be fine with me,
yeah. I think the module case is much more common.

-Kees

>
> This builds without warning on ARCH=arm with multi_v7_defconfig when
> HW_RANDOM={y,m,n}
>
> thx,
>
> Jason.
>
> -------->8--------------------------
> commit 0fcc0669ee4bbeae355c0f61f79a6b319a32ba12
> Author: Kees Cook <keescook@chromium.org>
> Date:   Mon Mar 3 15:51:48 2014 -0800
>
>     hwrng: add randomness to system from rng sources
>
>     When bringing a new RNG source online, it seems like it would make sense
>     to use some of its bytes to make the system entropy pool more random,
>     as done with all sorts of other devices that contain per-device or
>     per-boot differences.
>
>     [jac] prevent the code from being called at boot up, before the entropy
>     pool has had time to build and be well initialized.  We do this by
>     making the code conditional on being built as a module.
>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Signed-off-by: Jason Cooper <jason@lakedaemon.net>
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index a0f7724852eb..5c3314cbf671 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -41,6 +41,8 @@
>  #include <linux/miscdevice.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/random.h>
> +#include <linux/kconfig.h>
>  #include <asm/uaccess.h>
>
>
> @@ -305,6 +307,10 @@ int hwrng_register(struct hwrng *rng)
>         int must_register_misc;
>         int err = -EINVAL;
>         struct hwrng *old_rng, *tmp;
> +#if IS_MODULE(CONFIG_HW_RANDOM)
> +       unsigned char bytes[16];
> +       int bytes_read;
> +#endif
>
>         if (rng->name == NULL ||
>             (rng->data_read == NULL && rng->read == NULL))
> @@ -348,6 +354,18 @@ int hwrng_register(struct hwrng *rng)
>         }
>         INIT_LIST_HEAD(&rng->list);
>         list_add_tail(&rng->list, &rng_list);
> +
> +       /*
> +        * Out of an abundance of caution, we should avoid seeding the entropy
> +        * pool when it is first initialized (ie at kernel boot time).
> +        * Therefore, we take advantage of the hwrng when it is built as a
> +        * module, but not when built in.
> +        */
> +#if IS_MODULE(CONFIG_HW_RANDOM)
> +       bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> +       if (bytes_read > 0)
> +               add_device_randomness(bytes, bytes_read);
> +#endif
>  out_unlock:
>         mutex_unlock(&rng_mutex);
>  out:



-- 
Kees Cook
Chrome OS Security
