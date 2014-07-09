Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaGINQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbaGINQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:16:35 -0400
Date: Wed, 9 Jul 2014 18:45:59 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] virtio: rng: ensure reads happen after successful
 probe
Message-ID: <20140709131559.GB4553@grmbl.mre>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
 <CAGXu5jK1wL9DCnH0RcqhantcCvyJhwZfkw+_L7VQi8wfY2Nt_g@mail.gmail.com>
 <20140707055049.GA27024@grmbl.mre>
 <CAGXu5jJ9-b-NycB4ESvVnVgiBXpeQvKAT_hDPoAzhWSpQQKreg@mail.gmail.com>
 <20140707063409.GD27024@grmbl.mre>
 <20140709120823.GN13433@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709120823.GN13433@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 09 Jul 2014 [08:08:23], Jason Cooper wrote:
> On Mon, Jul 07, 2014 at 12:04:09PM +0530, Amit Shah wrote:
> > On (Sun) 06 Jul 2014 [23:09:49], Kees Cook wrote:
> > > On Sun, Jul 6, 2014 at 10:51 PM, Amit Shah <amit.shah@redhat.com> wrote:
> > > > On (Sun) 06 Jul 2014 [21:38:36], Kees Cook wrote:
> > > >> On Fri, Jul 4, 2014 at 10:34 PM, Amit Shah <amit.shah@redhat.com> wrote:
> > > >> > The hwrng core asks for random data in the hwrng_register() call itself
> > > >> > from commit d9e7972619.  This doesn't play well with virtio -- the
> > > >> > DRIVER_OK bit is only set by virtio core on a successful probe, and
> > > >> > we're not yet out of our probe routine when this call is made.  This
> > > >> > causes the host to not acknowledge any requests we put in the virtqueue,
> > > >> > and the insmod or kernel boot process just waits for data to arrive from
> > > >> > the host, which never happens.
> > > >>
> > > >> Doesn't this mean that virtio-rng won't ever contribute entropy to the system?
> > > >
> > > > The initial randomness?  Yes.  But it'll start contributing entropy as
> > > > soon as it's used as the current source.
> > > 
> > > How does that happen? I don't see an init function defined for it?
> > 
> > I mean the regular usage; not the initial randomness patch that you
> > added.
> > 
> > Initial randomness from virtio-rng currently won't be sourced.  That's
> > no different from the way things were before your patch; and I can't
> > think of a way to make that happen for now.
> 
> Yes, but this is a critical case.  There are three common scenarios
> where long term keys are generated in entropy-deprived states:
> 
>   - boot to a Linux Install CD, encrypt system during install
>   - first boot of a Linux-based embedded router, need SSL keys
>   - first boot of a Linux VM, need SSH host keys
> 
> We have the opportunity to make the third option suck less if we can get
> this right.
> 
> > virtio's probe() has to finish before communication with the host can
> > start.  If a virtio-rng device is the only hwrng in the system (very
> > likely in a guest), it's almost guaranteed that hwrng_init() won't be
> > called after hwrng_register() completes (as it would have already been
> > called and the virtio-rng device will have become the current_rng).
> 
> Well, I'm confused.  virtio-rng has no init function defined.  So
> hwrng_init() will just return zero.

This isn't really tied to hwrng_init() anymore, is it?

The problem with virtio-rng is that on a system with virtio-rng,
i.e. a kvm guest, it's most likely that there's only one hwrng device,
namely the virtio-rng, and when hwrng_register() is called in its
probe routine, hwrng_register doesn't have an old_rng, and will
proceed to call hwrng_init() and start using it.

So there's no second chance for the virtio-rng driver to finish its
probe and give the hwrng core an initial set of randomness.

> I think the basic question is: Where in the virtio-rng driver does it
> execute init-style code?  And why isn't that in an init function?

As mentioned above, putting it inside init won't help, as that init
function will be called during probe itself by hwrng_register due to
no current_rng registered at that point.

> Should we create a small init function that simply checks this DRIVER_OK
> bit?

I can't think of a solution that doesn't involve a layering violation
in the virtio code (i.e. set the DRIVER_OK bit in the probe routine;
the host is happy to service requests from such a driver and passes on
some randomness; and then reset that bit before probe() finishes).

Perhaps a re-work in hw_random/core.c could achieve this result for
virtio-rng, but that approach can't be valid for a -stable patch.
Perhaps a workqueue item that fires off the get_initial_randomness
function, which then sleeps till it receives a reply.  Then, the
'wait' param for hwrng_read() can be 0.

Thoughts?
		Amit
