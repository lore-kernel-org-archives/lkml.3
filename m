Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaGBQDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaGBQDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:03:08 -0400
Date: Wed, 2 Jul 2014 21:32:23 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jason Cooper <jason@lakedaemon.net>, LKML <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] hwrng: Allow drivers to disable reading during
 probe
Message-ID: <20140702160223.GC12962@grmbl.mre>
References: <cover.1404296679.git.amit.shah@redhat.com>
 <1404306020-24916-1-git-send-email-jason@lakedaemon.net>
 <20140702132635.GD7505@grmbl.mre>
 <20140702134156.GL23978@titan.lakedaemon.net>
 <CAGXu5j+sbiK9zdkwWh_MD1fk4aFs-Na4ZO=3tRosGtqjFvWnDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+sbiK9zdkwWh_MD1fk4aFs-Na4ZO=3tRosGtqjFvWnDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 02 Jul 2014 [08:11:30], Kees Cook wrote:
> On Wed, Jul 2, 2014 at 6:41 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Wed, Jul 02, 2014 at 06:56:35PM +0530, Amit Shah wrote:
> >> Hi Jason,
> >>
> >> On (Wed) 02 Jul 2014 [13:00:19], Jason Cooper wrote:
> >> > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> >> > added a call to rng_get_data() from the hwrng_register() function.
> >> > However, some rng devices need initialization before data can be read
> >> > from them.
> >> >
> >> > Also, the virtio-rng device does not behave properly when this call is
> >> > made in its probe() routine - the virtio core sets the DRIVER_OK status
> >> > bit only on a successful probe, which means the host ignores all
> >> > communication from the guest, and the guest insmod or boot process just
> >> > sits there doing nothing.
> >> >
> >> > [ jac: Modify the API to allow drivers to disable reading at probe, new
> >> > patch, copied Amit's commit message. ]
> >> >
> >> > CC: Kees Cook <keescook@chromium.org>
> >> > CC: Jason Cooper <jason@lakedaemon.net>
> >> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> >> > CC: <stable@vger.kernel.org> # v3.15+
> >> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> >> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> >> > ---
> >> >  drivers/char/hw_random/core.c | 8 +++++---
> >> >  include/linux/hw_random.h     | 4 ++++
> >> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> >> > index 334601cc81cf..b7b6c48ca682 100644
> >> > --- a/drivers/char/hw_random/core.c
> >> > +++ b/drivers/char/hw_random/core.c
> >> > @@ -347,9 +347,11 @@ int hwrng_register(struct hwrng *rng)
> >> >     INIT_LIST_HEAD(&rng->list);
> >> >     list_add_tail(&rng->list, &rng_list);
> >> >
> >> > -   bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> >> > -   if (bytes_read > 0)
> >> > -           add_device_randomness(bytes, bytes_read);
> >> > +   if (!(rng->flags & HWRNG_NO_READ_AT_PROBE)) {
> >> > +           bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> >> > +           if (bytes_read > 0)
> >> > +                   add_device_randomness(bytes, bytes_read);
> >> > +   }
> >>
> >> But this has the inverse problem: if there are two hwrngs in the
> >> system, one will be initialized and probed.  The other will not be
> >> initialized, but still be probed.
> >
> > That's a problem outside the scope of this patch.  You're basically
> > saying the ->init() should be called unconditionally for each hwrng.  If
> > that's what driver authors assumed, that's not what is happening if
> > there is more than one driver in the system.
> 
> My intent with the patch was to get randomness added when a hwrng was
> available. Perhaps instead of skipping this call, it can be done
> either during probe (for devices that support it or lack an init
> function), or done after initialization?

I'll also look at just going ahead with ->init() in the hwrng_register
function itself, that's in line with the spirit of your patch.

However, that may lead to unwelcome problems.  The other approach is
to call rng_get_data() in hwrng_init().

> > I think you should be changing the code a few lines up to make sure
> > hwrng_init() is called once for each driver.
> 
> Is that really how it should work? I'd be for the "always-init"
> approach since it gains us access to the entropy, but I have to play
> devil's advocate: would one expect "probe" to just probe, not
> initialize? That seems more like a function of enabling the device.

There are some other considerations: I found this problem while
looking at other things: especially that the hwrng core doesn't take a
reference on the driver that's the current_rng.  That has to be
fixed.  If we always call ->init(), we'll have to cleanup and possibly
take a reference.  I'll look at this more closely in a bit.

		Amit
