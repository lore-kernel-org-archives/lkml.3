Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3AONGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:06:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52511 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3AONGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:06:33 -0500
Date: Tue, 15 Jan 2013 14:06:23 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130115130623.GC2625@pengutronix.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
 <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
 <20130109091939.GA4369@core.coreip.homeip.net>
 <20130109092352.GA28037@avionic-0098.adnet.avionic-design.de>
 <20130114154959.GA25049@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <20130114154959.GA25049@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> > > > > I am sorry, but I do not consider a function that was added a lit=
tle
> > > > > over a year ago as a canon. If you look at the uses of EADDRNOTAV=
AIL it
> > > > > is used predominantly in networking code to indicate that attempt=
ed
> > > > > _network_ address is not available.
> > > >=20
> > > > EBUSY might be misleading, though. devm_request_and_ioremap() can f=
ail
> > > > in both the request_mem_region() and ioremap() calls. Furthermore i=
t'd
> > > > be good to settle on a consistent error-code instead of doing it
> > > > differently depending on subsystem and/or driver. Currently the var=
ious
> > > > error codes used are:
> > > >=20
> > > > 	EBUSY, EADDRNOTAVAIL, ENXIO, ENOMEM, ENODEV, ENOENT, EINVAL,
> > > > 	EIO, EFAULT, EADDRINUSE
> > > >=20
> > > > Also if we can settle on one error code we should follow up with a =
patch
> > > > to make it consistent across the tree and also update that kerneldoc
> > > > comment. I volunteer to do that if nobody else steps up. I'm also C=
c'ing
> > > > Wolfram (the original author), maybe he has some thoughts on this.

Handling the error case was the biggest discussion back then. I
initially did not want to use ERR_PTR, because I see already enough
patches adding a forgotten ERR_PTR to drivers. My initial idea was to
return a simple errno and have the pointer a function argument. I was
convinced [1], however, that the dev_err printout is enough to make
visible what actually went wrong and return a NULL pointer instead. So
much for why the function does NOT return a PTR_ERR, and I still prefer
that.

Then, I added the example code in the documentation using EADDRNOTAVAIL.
Yes, I was brave with this one. Yet, EINVAL, EBUSY, ENOENT, did not
really cut it and are so heavily used in drivers that they turned into a
generic "something is wrong" error. I tried here to use a not overloaded
error code in order to be specific again. Since the patches were
accepted, I assumed it wasn't seen as a namespace violation. (Then
again, it probably would have been if that error code would go out to
userspace) Naturally, I didn't have the resources to check all patches
for a consistent error code.

> > > If you going to change all drivers make devm_request_and_ioremap()
> > > return ERR_PTR()-encoded errors and then we can differentiate what
> > > part of it failed.
> >=20
> > Yeah, that thought also crossed my mind. I'll give other people some
> > time to comment before hurling myself into preparing patches.

As said above, that was argued away when committing the patches.

But there is more to that:

When working with this function, there was also the idea to abstract
getting the resource away. Which then gave Sascha Hauer and me the
question, if drivers really have to do this or if this couldn't be done
by the kernel somehow, i.e. giving the drivers already the resources
they need, completely prepared.

Of course, then we would need a similar function for interrupt
resources. Which has much bigger problem with return codes, since we
then step into the area of the "0 is no interrupt" topic (while
platform_get_irq returns an error code).

As a result, I got the impression that the whole topic needs ONE
concentrated, major rehaul or at least a master plan. Adding an idea
here and there doesn't seem to cut it, at least not in the way
devm_request_and_ioremap() was done. I would be interested in doing that
but my resources don't allow me to even think about it at the moment,
sadly.

Regards,

   Wolfram

[1] http://lkml.org/lkml/2011/10/24/278

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD1VE8ACgkQD27XaX1/VRuU/wCeKk2fiXMlUbT7bXIrkVR0LMPi
yF4AoMM7ohK1kf9R4sJSIfMGkGAOKKvT
=fj7L
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
