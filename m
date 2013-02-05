Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3BEHnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:43:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3BEHnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:43:07 -0500
Date: Tue, 5 Feb 2013 08:43:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 1/8] gpu: host1x: Add host1x driver
Message-ID: <20130205074301.GA20437@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-2-git-send-email-tbergstrom@nvidia.com>
 <20130204090941.GA27443@avionic-0098.mockup.avionic-design.de>
 <51107CC0.9060900@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <51107CC0.9060900@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:0WTQ9MubkZMtaOMTnU8MWdFzKL5X+kO9VCJV2mlXyfY
 NT7d1HQtKNOW1c1dCnto4lPmmBItUTWvVHq3fh5Ly6bzHe8iey
 /j3H1QqpEGH0Nxz5ESd+by2BPfjzzfm7jF7gdhtlEptVMZ3qUD
 luUHFkGkVUwm1uJbpI1rXMvAGOHhnibA0dOR0w1DYj49Kkj9DU
 iwFsZNOXwGEms3Kc/8AWq8fubO41huIMoRtqQPMugnaU28nSCY
 VrYKYs0JCqne/isIbIXCdDODsZz+jdb+/2Y5e4pxf6a4CmRUZv
 icnvZi/iT1ae2W6Fj1uyejxZHjuo1ZgOCEphOw00/FcxYQFZqc
 RswivHaXslwd3AF2NESZgm7ek9bHJUlFIPqR0QZpOLlKod1fTc
 8Lwrl9aDHD90kfK24bU5bipvcAhKpti4ily1LIFYB6IigvxBAC
 biPja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 07:30:08PM -0800, Terje Bergstr=C3=B6m wrote:
> On 04.02.2013 01:09, Thierry Reding wrote:
> > On Tue, Jan 15, 2013 at 01:43:57PM +0200, Terje Bergstrom wrote:
> >> Add host1x, the driver for host1x and its client unit 2D.
> >=20
> > Maybe this could be a bit more verbose. Perhaps describe what host1x is.
>=20
> Sure. I could just steal the paragraph from Stephen:
>=20
> The Tegra host1x module is the DMA engine for register access to Tegra's
> graphics- and multimedia-related modules. The modules served by host1x
> are referred to as clients. host1x includes some other  functionality,
> such as synchronization.

Yes, that sound good.

> >> +     err =3D host1x_syncpt_init(host);
> >> +     if (err)
> >> +             return err;
> > [...]
> >> +     host1x_syncpt_reset(host);
> >=20
> > Why separate host1x_syncpt_reset() from host1x_syncpt_init()? I see why
> > it might be useful to have host1x_syncpt_reset() as a separate function
> > but couldn't it be called as part of host1x_syncpt_init()?
>=20
> host1x_syncpt_init() is used for initializing the syncpt structures, and
> is called in probe. host1x_syncpt_reset() should be called whenever we
> think hardware state is lost, for example if VDD_CORE was rail gated due
> to system suspend.

My point was that you could include the call to host1x_syncpt_reset()
within host1x_syncpt_init(). That will keep unneeded code out of the
host1x_probe() function. Also you don't want to use the syncpoints
uninitialized, right?

> >> +#include "hw/syncpt_hw.c"
> >=20
> > Why include the source file here? Can't you compile it separately
> > instead?
>=20
> It's because we need to compile with the hardware headers of that host1x
> version, because we haven't been good at keeping compatibility. So
> host1x01.c #includes version 01 headers, and syncpt_hw.c in this
> compilation unit gets compiled with that. 02 would include 02 headers,
> and syncpt_hw.c would get compiled with its register definitions etc.

Okay, fair enough.

> >> + */
> >> +static u32 syncpt_load_min(struct host1x_syncpt *sp)
> >> +{
> >> +     struct host1x *dev =3D sp->dev;
> >> +     u32 old, live;
> >> +
> >> +     do {
> >> +             old =3D host1x_syncpt_read_min(sp);
> >> +             live =3D host1x_sync_readl(dev,
> >> +                             HOST1X_SYNC_SYNCPT_0 + sp->id * 4);
> >> +     } while ((u32)atomic_cmpxchg(&sp->min_val, old, live) !=3D old);
> >=20
> > I think this warrants a comment.
>=20
> Sure. It just loops in case there's a race writing to min_val.

Oh, I see. That'd make a good comment. Is the cast to (u32) really
necessary?

> >> +/*
> >> + * Resets syncpoint and waitbase values to sw shadows
> >> + */
> >> +void host1x_syncpt_reset(struct host1x *dev)
> >=20
> > Maybe host1x_syncpt_flush() would be a better name given the above
> > description? Reset does have this hardware reset connotation so my first
> > intuition had been that this would reset the syncpt value to 0.
>=20
> Right, it actually reloads values stored in shadow registers back to
> host1x. Flush doesn't feel like it's conveying the meaning. Would
> host1x_syncpt_restore() work? That'd match with host1x_syncpt_save(),
> which just updates all shadow registers from hardware and is used just
> before host1x loses power.

Save/restore has the disadvantage of the direction not being implicit.
Save could mean save to hardware or save to software. The same is true
for restore. However if the direction is clearly defined, save and
restore work for me.

Maybe the comment could be changed to be more explicit. Something like:

	/*
	 * Write cached syncpoint and waitbase values to hardware.
	 */

And for host1x_syncpt_save():

	/*
	 * For client-managed registers, update the cached syncpoint and
	 * waitbase values by reading from the registers.
	 */

> >> +/*
> >> + * Updates the last value read from hardware.
> >> + */
> >> +u32 host1x_syncpt_load_min(struct host1x_syncpt *sp)
> >> +{
> >> +     u32 val;
> >> +     val =3D sp->dev->syncpt_op.load_min(sp);
> >> +     trace_host1x_syncpt_load_min(sp->id, val);
> >> +
> >> +     return val;
> >> +}
> >=20
> > I don't know I understand what this means exactly. Does it read the
> > value that hardware last incremented? Perhaps this will become clearer
> > when you add a comment to the syncpt_load_min() implementation.
>=20
> It just loads the current syncpt value to shadow register. The shadow
> register is called min, because host1x tracks the range of sync point
> increments that hardware is still going to do, so min is the lower
> boundary of the range.
>=20
> max tells what the sync point is expected to reach for hardware to be
> considered idle.
>=20
> host1x will f.ex. nop out waits for sync point values outside the range,
> because hardware isn't good at handling syncpt value wrapping.

Maybe the function should be called host1x_syncpt_load() if there is no
equivalent way to load the maximum value (since there is no register to
read from).

> > Also the syncpoint is not actually allocated here, so maybe
> > host1x_syncpt_request() would be a better name. As a nice side-effect it
> > makes the naming more similar to the IRQ API and might be easier to work
> > with.
>=20
> I'm not entirely sure about the difference, but isn't the number to be
> allocated usually passed to a function ending in _request? Allocate
> would just allocate the next available - as host1x_syncpt_allocate does.

That's certainly true for interrupts. However, if you look at the DMA
subsystem for example, you can also request an unnamed resource.

The difference is sufficiently subtle that host1x_syncpt_allocate()
would work for me too, though. I just have a slight preference for
host1x_syncpt_request().

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRELgEAAoJEN0jrNd/PrOhfOkP/1TkBKcgMQUPNb713lY3QdcS
1PcQlUOBg0ZSOJVwrnkUYGnmak5okpEsuHMRvcQWDyG8xorGG91Bs8Mjg9GbB7lL
d479Xz72AgpSTW2itTizKgBzmXTuIkEjaIAVM/DwC1JgntDuO+0iVlZQQIcToUkk
a7u41Apr3TdFXS7flHDtzrsIYhEAQITPxed6pec13+3Q2fh2mdnkYD204ZKcrirr
a8RQIFIaFTcR+pdu76wiTcKGOJa1GOKyg2traPp01fvFFJLBWnQrGRQRAecOIomh
80+NuVlbUBBmP8+gQArMaYCgV164SYLIPuvFOrH2M0dB5qiKuTUNR/EprFu8CVuU
HOM4Tdf0RrSYXrWzk2GC0jY7PPcAiln+ltQzE9pOh8iXo83VcSkcvltR3nW8Ls4w
dOk8EhdQkjmsPuqczUxrAQRZtkNLaHwbmS9p+BQPYwuahNTIcRTGJtAAzw9xlCm8
PILRwiDKH7vRIVHZ4bfpurJNtaBByX3mn8VWdl7Ajajeo5c5OJoeWls7R0bxJIDe
vOQaPW+Ss96wEgBIAeq/XsDMFcnxUrGPnFzuEiKthiJ8H8UfqbRVq3z1l1eqOY15
vEj2XtfqHJGN3Ql5Bw2RhXXZ1h99+GPlLZsthabORorBnhdOtQ2+gzIWP1CgYql+
5Y2Sm+rWk5wMwqUJE4Vt
=HaOX
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
