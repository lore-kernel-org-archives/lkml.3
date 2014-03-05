Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaCEVMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:12:01 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29732 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751879AbaCEVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:11:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rUT2nGXkHLlQSckj8jU5FDKgIT2r+f1A=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0F5C853B092
Date: Wed, 5 Mar 2014 16:11:45 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
Message-ID: <20140305211145.GV1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
 <20140304153841.GN1872@titan.lakedaemon.net>
 <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
 <20140304195356.GS1872@titan.lakedaemon.net>
 <CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
 <1393972797.8344.190.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393972797.8344.190.camel@calx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt, Kees,

On Tue, Mar 04, 2014 at 04:39:57PM -0600, Matt Mackall wrote:
> On Tue, 2014-03-04 at 11:59 -0800, Kees Cook wrote:
> > On Tue, Mar 4, 2014 at 11:53 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > > On Tue, Mar 04, 2014 at 11:01:49AM -0800, Kees Cook wrote:
> > >> On Tue, Mar 4, 2014 at 7:38 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > >> > On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
...
> > Well, I think there's confusion here over "the" hwrng and "a" hwrng. I
> > have devices with multiple entropy sources, and all my hwrngs are
> > built as modules, so I choose when to load them into my kernel. "The"
> > arch-specific entropy source (e.g. RDRAND) is very different.

Dynamically loading modules _after_ boot is fine.  Especially with
Matt's clear explanation.  I'm not concerned about that scenario.

> > > Please understand, my point-of-view is as someone who installs Linux on
> > > equipment *after* purchase (hobbyist, tinkers).  If I control the part
> > > selection and sourcing of the board components, of course I have more
> > > trust in the hwrng.
> > >
> > > So my situation is similar to buying an Intel based laptop.  I can't do
> > > a special order at Bestbuy and ask for a system without the RDRAND
> > > instruction.  Same with the hobbyist market.  We buy the gear, but we
> > > have no control over what's inside it.
> > >
> > > In that situation, without this patch, I would enable the hwrng for the
> > > board.  With the patch in it's current form, I would start looking for
> > > research papers and discussions regarding using the hwrng for input.  If
> > > the patch provided arch_get_random_long(), I would feel comfortable
> > > enabling the hwrng.
> > >
> > > Perhaps I'm being too conservative, but I'd rather have the discussion
> > > now and have concerns proven unfounded than have someone say "How the
> > > hell did this happen?" three releases down the road.
> > 
> > Sure, and I don't want to be the one weakening the entropy pool.
> 
> [temporarily coming out of retirement to provide a clue]

Thanks, Matt!

> The pool mixing function is intentionally _reversible_. This is a
> crucial security property.
> 
> That means, if I have an initial secret pool state X, and hostile
> attacker controlled data Y, then we can do:
> 
> X' = mix(X, Y)
> 
>  and 
> 
> X = unmix(X', Y)
> 
> We can see from this that the combination of (X' and Y) still contain
> the information that was originally in X. Since it's clearly not in Y..
> it must all remain in X'.
> 
> In other words, if there are 4096 bits of "unknownness" in X to start
> with, and I can get those same 4096 bits of "unknownness" back by
> unmixing X' and Y, then there must still be 4096 bits of "unknownness"
> in X'. If X' is 4096 bits long, then we've just proven that
> reversibility means the attacker can know nothing about the contents of
> X' by his choice of Y.

Well, this reinforces my comfortability with loadable modules.  The pool
is already initialized by the point at which the driver is loaded.

Unfortunately, any of the drivers in hw_random can be built in.  When
built in, hwrng_register is going to be called during the kernel
initialization process.  In that case, the unknownness in X is not 4096
bits, but far less.  Also, the items that may have seeded X (MAC addr,
time, etc) are discoverable by a potential attacker.  This is also well
before random-seed has been fed in.

That's the crux of my concern with this patch.  Basically, the user can
choose 'y' over 'm', say when building a dedicated system w/o loadable
modules, and not realize how much more trust he has placed in the hwrng.

How does this patch look?  I'm not claiming my change is acceptable for
mainline, just seeking feedback on the concept.  IS_MODULE() really
doesn't have many users afaict.

This builds without warning on ARCH=arm with multi_v7_defconfig when
HW_RANDOM={y,m,n}

thx,

Jason.

-------->8--------------------------
commit 0fcc0669ee4bbeae355c0f61f79a6b319a32ba12
Author: Kees Cook <keescook@chromium.org>
Date:   Mon Mar 3 15:51:48 2014 -0800

    hwrng: add randomness to system from rng sources
    
    When bringing a new RNG source online, it seems like it would make sense
    to use some of its bytes to make the system entropy pool more random,
    as done with all sorts of other devices that contain per-device or
    per-boot differences.
    
    [jac] prevent the code from being called at boot up, before the entropy
    pool has had time to build and be well initialized.  We do this by
    making the code conditional on being built as a module.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a0f7724852eb..5c3314cbf671 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -41,6 +41,8 @@
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/kconfig.h>
 #include <asm/uaccess.h>
 
 
@@ -305,6 +307,10 @@ int hwrng_register(struct hwrng *rng)
 	int must_register_misc;
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
+#if IS_MODULE(CONFIG_HW_RANDOM)
+	unsigned char bytes[16];
+	int bytes_read;
+#endif
 
 	if (rng->name == NULL ||
 	    (rng->data_read == NULL && rng->read == NULL))
@@ -348,6 +354,18 @@ int hwrng_register(struct hwrng *rng)
 	}
 	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
+
+	/*
+	 * Out of an abundance of caution, we should avoid seeding the entropy
+	 * pool when it is first initialized (ie at kernel boot time).
+	 * Therefore, we take advantage of the hwrng when it is built as a
+	 * module, but not when built in.
+	 */
+#if IS_MODULE(CONFIG_HW_RANDOM)
+	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
+	if (bytes_read > 0)
+		add_device_randomness(bytes, bytes_read);
+#endif
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
