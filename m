Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaGGGeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaGGGem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:34:42 -0400
Date: Mon, 7 Jul 2014 12:04:09 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Cooper <jason@lakedaemon.net>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] virtio: rng: ensure reads happen after successful
 probe
Message-ID: <20140707063409.GD27024@grmbl.mre>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
 <CAGXu5jK1wL9DCnH0RcqhantcCvyJhwZfkw+_L7VQi8wfY2Nt_g@mail.gmail.com>
 <20140707055049.GA27024@grmbl.mre>
 <CAGXu5jJ9-b-NycB4ESvVnVgiBXpeQvKAT_hDPoAzhWSpQQKreg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ9-b-NycB4ESvVnVgiBXpeQvKAT_hDPoAzhWSpQQKreg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Sun) 06 Jul 2014 [23:09:49], Kees Cook wrote:
> On Sun, Jul 6, 2014 at 10:51 PM, Amit Shah <amit.shah@redhat.com> wrote:
> > On (Sun) 06 Jul 2014 [21:38:36], Kees Cook wrote:
> >> On Fri, Jul 4, 2014 at 10:34 PM, Amit Shah <amit.shah@redhat.com> wrote:
> >> > The hwrng core asks for random data in the hwrng_register() call itself
> >> > from commit d9e7972619.  This doesn't play well with virtio -- the
> >> > DRIVER_OK bit is only set by virtio core on a successful probe, and
> >> > we're not yet out of our probe routine when this call is made.  This
> >> > causes the host to not acknowledge any requests we put in the virtqueue,
> >> > and the insmod or kernel boot process just waits for data to arrive from
> >> > the host, which never happens.
> >>
> >> Doesn't this mean that virtio-rng won't ever contribute entropy to the system?
> >
> > The initial randomness?  Yes.  But it'll start contributing entropy as
> > soon as it's used as the current source.
> 
> How does that happen? I don't see an init function defined for it?

I mean the regular usage; not the initial randomness patch that you
added.

Initial randomness from virtio-rng currently won't be sourced.  That's
no different from the way things were before your patch; and I can't
think of a way to make that happen for now.

virtio's probe() has to finish before communication with the host can
start.  If a virtio-rng device is the only hwrng in the system (very
likely in a guest), it's almost guaranteed that hwrng_init() won't be
called after hwrng_register() completes (as it would have already been
called and the virtio-rng device will have become the current_rng).

If the VM admin configured two virtio-rng sources, though, or
hotplugged one later, the early randomness will be obtained for the
second virtio-rng device.  But this is a scenario I don't expect to
ever arise -- it's just a theoretical possibility.


		Amit
